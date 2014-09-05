//
//  MVTimeFormatter.h
//
//  Created by Cory Imdieke on 2/21/12.
//  Copyright (c) 2012 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Class which converts an `NSTimeInterval` in seconds into a human-readable string.
 
 If the input is longer than an hour, the string output is HH:MM:SS. If less than an hour, the output is only MM:SS.
 */
@interface MVTimeFormatter : NSObject

/** Converts the duration to a human-readable string.
 
 @param duration Duration in seconds.
 @return Returns a string in HH:MM:SS or MM:SS as appropriate.
 */
+ (NSString *)stringForDuration:(NSTimeInterval)duration;

/** Converts the duration to a human-readable string.
 
 @param duration Duration in miliseconds.
 @return Returns a string in HH:MM:SS:mm or MM:SS:mm as appropriate.
 */
+ (NSString *)stringForDurationMilliseconds:(NSTimeInterval)duration;

/** Converts the duration to a human-readable string.
 
 @param duration Duration in miliseconds.
 @return Returns a string in HH:MM:SS.mm or MM:SS.mm as appropriate.
 */
+ (NSString *)stringForDurationMillisecondsDecimal:(NSTimeInterval)duration leadingZeroInHour:(BOOL)zeroInHour;

@end
