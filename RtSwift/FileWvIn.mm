//
//  FileWvIn-wrapper.c
//  RtSwift
//
//  Created by Spencer Salazar on 2/25/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#include "FileWvIn.h"
#include "stk/FileWvIn.h"

@interface FileWvIn ()
{
    stk::FileWvIn _fileWvIn;
}

@end

@implementation FileWvIn

- (id) init
{
    if(self = [super init]) { }
    return self;
}

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
- (void) openFile: (NSString *) file
{
    _fileWvIn.openFile(std::string([file UTF8String]));
}

//! Close a file if one is open.
- (void) closeFile
{
    _fileWvIn.closeFile();
}

//! Clear outputs and reset time (file) pointer to zero.
- (void) reset
{
    _fileWvIn.reset();
}

//! Normalize data to a maximum of +-1.0.
/*!
 This function has no effect when data is incrementally loaded
 from disk.
 */
- (void) normalize
{
    _fileWvIn.normalize();
}

//! Return the file size in sample frames.
- (unsigned long) size
{
    return _fileWvIn.getSize();
}

//! Return the input file sample rate in Hz (not the data read rate).
/*!
 WAV, SND, and AIF formatted files specify a sample rate in
 their headers.  STK RAW files have a sample rate of 22050 Hz
 by definition.  MAT-files are assumed to have a rate of 44100 Hz.
 */
- (StkFloat) fileRate
{
    return _fileWvIn.getFileRate();
}

//! Query whether a file is open.
- (BOOL) isOpen
{
    return _fileWvIn.isOpen();
}

//! Query whether reading is complete.
- (BOOL) isFinished
{
    return _fileWvIn.isFinished();
}

//! Set the data read rate in samples.  The rate can be negative.
/*!
 If the rate value is negative, the data is read in reverse order.
 */
- (void) setRate: (StkFloat) rate
{
    _fileWvIn.setRate(rate);
}

//! Increment the read pointer by \e time samples.
/*!
 Note that this function will not modify the interpolation flag status.
 */
- (void) addTime: (StkFloat) time
{
    _fileWvIn.addTime(time);
}

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
- (StkFloat) lastOut
{
    return _fileWvIn.lastOut();
}

- (StkFloat) lastOutFromChannel: (unsigned int) channel
{
    return _fileWvIn.lastOut(channel);
}

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
- (StkFloat) tick
{
    return _fileWvIn.tick();
}

@end
