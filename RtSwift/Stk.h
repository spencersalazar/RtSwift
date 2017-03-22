//
//  Stk.h
//  RtSwift
//
//  Created by Spencer Salazar on 3/20/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

typedef float StkFloat;

@interface Stk : NSObject

+ (StkFloat)sampleRate;
+ (void)setSampleRate:(StkFloat)sampleRate;

@end
