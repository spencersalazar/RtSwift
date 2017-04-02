//
//  RtSwiftBridge.m
//  RtSwift
//
//  Created by Spencer Salazar on 2/6/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#import "RtSwiftBridge.h"
#import "TheAmazingAudioEngine/TheAmazingAudioEngine.h"
#import "FastCircularBuffer.h"

#define INPUT_BUFFER_FACTOR (4) // padding of input buffer (times nominal buffer size)

@interface RtSwiftBridge ()
{
    AEAudioController *_audioController;
    
    AEBlockChannel *_outputChannel;
    AEBlockFilter *_inputOutputChannel;
    AEBlockAudioReceiver *_inputReceiver;
    
    FastCircularBuffer _inputBuffer;
}

@property NSUInteger numChannels;
@property NSUInteger bufferSize;

@end

@implementation RtSwiftBridge

- (void)start:(void (^)(AudioBuffer, AudioBuffer, int))process {

    self.numChannels = 2;
    self.bufferSize = 128;
    
    AudioStreamBasicDescription audioDescription;
    memset(&audioDescription, 0, sizeof(audioDescription));
    audioDescription.mFormatID          = kAudioFormatLinearPCM;
    audioDescription.mFormatFlags       = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    audioDescription.mChannelsPerFrame  = (UInt32) self.numChannels;
    audioDescription.mBytesPerPacket    = sizeof(float);
    audioDescription.mFramesPerPacket   = 1;
    audioDescription.mBytesPerFrame     = sizeof(float);
    audioDescription.mBitsPerChannel    = 8 * sizeof(float);
    audioDescription.mSampleRate        = self.sampleRate;
    
    if(self.enableInput)
        _inputBuffer.initialize((unsigned int)(self.bufferSize*self.numChannels*INPUT_BUFFER_FACTOR)+1, sizeof(float));
    
    _audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription inputEnabled:self.enableInput];
    _audioController.preferredBufferDuration = 128.0/self.sampleRate;
    [_audioController start:NULL];
    
    if(self.enableInput)
    {
        [_audioController addInputReceiver:[AEBlockAudioReceiver audioReceiverWithBlock:^(void *source,
                                                                                          const AudioTimeStamp *time,
                                                                                          UInt32 frames,
                                                                                          AudioBufferList *audio) {
            assert(audio->mNumberBuffers > 0);
            
            if(_inputBuffer.canWrite() >= frames)
                _inputBuffer.put(audio->mBuffers[0].mData, frames);
            else
                NSLog(@"warning: dropping %u input frames", frames);
        }]];
    }
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock:^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
//        if(_bufferSize != frames)
//        {
//            NSLog(@"resizing audio buffer to %i", frames);
//            if(_bufferLeft) free(_bufferLeft);
//            if(_bufferRight) free(_bufferRight);
//            _bufferLeft = (float *) calloc(frames, sizeof(float));
//            _bufferRight = (float *) calloc(frames, sizeof(float));
//            _bufferSize = frames;
//        }
        
        if(_enableInput)
        {
            while(_inputBuffer.canRead() < frames)
                usleep(100);
            _inputBuffer.get(audio->mBuffers[0].mData, frames);
        }
        
        process(audio->mBuffers[0], audio->mBuffers[1], frames);
        
        // deinterleave
//        for(int i = 0; i < frames; i++)
//        {
//            ((float*)(audio->mBuffers[0].mData))[i] = sinf(phase*2*M_PI);
//            ((float*)(audio->mBuffers[1].mData))[i] = 0;
//            phase += 220.0f/48000.0f;
//            if(phase > 1)
//                phase -=1 ;
//        }
    }]]];
}

@end
