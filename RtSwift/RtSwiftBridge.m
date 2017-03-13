//
//  RtSwiftBridge.m
//  RtSwift
//
//  Created by Spencer Salazar on 2/6/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#import "RtSwiftBridge.h"
#import "TheAmazingAudioEngine/TheAmazingAudioEngine.h"

@interface RtSwiftBridge ()
{
    AEAudioController *_audioController;
    float *_bufferLeft;
    float *_bufferRight;
    int _bufferSize;
}

@end

@implementation RtSwiftBridge

- (void)start:(void (^)(AudioBuffer, AudioBuffer, int))process {

    int numChannels = 2;
    
    AudioStreamBasicDescription audioDescription;
    memset(&audioDescription, 0, sizeof(audioDescription));
    audioDescription.mFormatID          = kAudioFormatLinearPCM;
    audioDescription.mFormatFlags       = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    audioDescription.mChannelsPerFrame  = numChannels;
    audioDescription.mBytesPerPacket    = sizeof(float);
    audioDescription.mFramesPerPacket   = 1;
    audioDescription.mBytesPerFrame     = sizeof(float);
    audioDescription.mBitsPerChannel    = 8 * sizeof(float);
    audioDescription.mSampleRate        = self.sampleRate;
    
    _audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription inputEnabled:NO];
    _audioController.preferredBufferDuration = 128.0/self.sampleRate;
    [_audioController start:NULL];
    
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
