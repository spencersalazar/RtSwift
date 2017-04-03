//
//  RtSwiftBridge.h
//  RtSwift
//
//  Created by Spencer Salazar on 2/6/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RtSwiftBridge : NSObject

@property NSInteger sampleRate;
@property BOOL enableInput;

- (void)start:(void (^)(AudioBuffer, AudioBuffer, int))process;
- (void)startFullDuplex:(void (^)(AudioBuffer, AudioBuffer, AudioBuffer, int))process;

@end
