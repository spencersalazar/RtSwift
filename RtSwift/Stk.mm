//
//  Stk.m
//  RtSwift
//
//  Created by Spencer Salazar on 3/20/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#import "Stk.h"
#import "stk/Stk.h"

@implementation Stk

+ (StkFloat)sampleRate
{
    return stk::Stk::sampleRate();
}

+ (void)setSampleRate:(StkFloat)srate
{
    stk::Stk::setSampleRate(srate);
}

@end
