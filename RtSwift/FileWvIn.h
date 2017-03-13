//
//  FileWvIn-wrapper.h
//  RtSwift
//  C wrapper around stk::WvFileIn
//
//  Created by Spencer Salazar on 2/25/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

typedef float StkFloat;

@interface FileWvIn : NSObject

- (id) init;

//! Open the specified file and load its data.
/*!
 Data from a previously opened file will be overwritten by this
 function.  An StkError will be thrown if the file is not found,
 its format is unknown, or a read error occurs.  If the file data
 is to be loaded incrementally from disk and normalization is
 specified, a scaling will be applied with respect to fixed-point
 limits.  If the data format is floating-point, no scaling is
 performed.
 */
- (void) openFile: (NSString *) file;

//! Close a file if one is open.
- (void) closeFile;

//! Clear outputs and reset time (file) pointer to zero.
- (void) reset;

//! Normalize data to a maximum of +-1.0.
/*!
 This function has no effect when data is incrementally loaded
 from disk.
 */
- (void) normalize;

//! Return the file size in sample frames.
- (unsigned long) size;

//! Return the input file sample rate in Hz (not the data read rate).
/*!
 WAV, SND, and AIF formatted files specify a sample rate in
 their headers.  STK RAW files have a sample rate of 22050 Hz
 by definition.  MAT-files are assumed to have a rate of 44100 Hz.
 */
- (StkFloat) fileRate;

//! Query whether a file is open.
- (BOOL) isOpen;

//! Query whether reading is complete.
- (BOOL) isFinished;

//! Set the data read rate in samples.  The rate can be negative.
/*!
 If the rate value is negative, the data is read in reverse order.
 */
- (void) setRate: (StkFloat) rate;

//! Increment the read pointer by \e time samples.
/*!
 Note that this function will not modify the interpolation flag status.
 */
- (void) addTime: (StkFloat) rate;

//! Return the specified channel value of the last computed frame.
/*!
 If no file is loaded, the returned value is 0.0.  The \c
 channel argument must be less than the number of output channels,
 which can be determined with the channelsOut() function (the first
 channel is specified by 0).  However, range checking is only
 performed if _STK_DEBUG_ is defined during compilation, in which
 case an out-of-range value will trigger an StkError exception. \sa
 lastFrame()
 */
- (StkFloat) lastOut;

- (StkFloat) lastOutFromChannel: (unsigned int) channel;

//! Compute a sample frame and return the specified \c channel value.
/*!
 For multi-channel files, use the lastFrame() function to get
 all values from the computed frame.  If no file data is loaded,
 the returned value is 0.0.  The \c channel argument must be less
 than the number of channels in the file data (the first channel is
 specified by 0).  However, range checking is only performed if
 _STK_DEBUG_ is defined during compilation, in which case an
 out-of-range value will trigger an StkError exception.
 */
- (StkFloat) tick;

@end

