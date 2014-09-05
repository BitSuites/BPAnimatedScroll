//
//  MVTimeFormatter.m
//
//  Created by Cory Imdieke on 2/21/12.
//  Copyright (c) 2012 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "MVTimeFormatter.h"

@implementation MVTimeFormatter

+ (NSString *)stringForDuration:(NSTimeInterval)duration{
	int hours = 0;
	int minutes = 0;
	int seconds = 0;
	
	NSTimeInterval tempDuration = duration;
	
	while(tempDuration >= 3600){
		hours++;
		tempDuration = tempDuration - 3600;
	}
	while(tempDuration >= 60){
		minutes++;
		tempDuration = tempDuration - 60;
	}
	seconds = tempDuration;
	
	if(hours > 0){
		return [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
	} else {
		return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
	}
}

+ (NSString *)stringForDurationMilliseconds:(NSTimeInterval)duration{
	int hours = 0;
	int minutes = 0;
	int seconds = 0;
	int milliseconds = 0;
	
	NSTimeInterval tempDuration = duration*1000;
	
	while(tempDuration >= 3600000){
		hours++;
		tempDuration = tempDuration - 3600000;
	}
	while(tempDuration >= 60000){
		minutes++;
		tempDuration = tempDuration - 60000;
	}
	while(tempDuration >= 1000){
		seconds++;
		tempDuration = tempDuration - 1000;
	}
	milliseconds = tempDuration;
	NSString *millString = [NSString stringWithFormat:@"%03d", milliseconds];
	
	if(hours > 0){
		return [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", hours, minutes, seconds, milliseconds];
	} else {
		return [NSString stringWithFormat:@"%02d:%02d:%@", minutes, seconds, [millString substringToIndex:2]];
	}
}

+ (NSString *)stringForDurationMillisecondsDecimal:(NSTimeInterval)duration leadingZeroInHour:(BOOL)zeroInHour{
	int hours = 0;
	int minutes = 0;
	int seconds = 0;
	int milliseconds = 0;
	
	NSTimeInterval tempDuration = duration*1000;
	
	while(tempDuration >= 3600000){
		hours++;
		tempDuration = tempDuration - 3600000;
	}
	while(tempDuration >= 60000){
		minutes++;
		tempDuration = tempDuration - 60000;
	}
	while(tempDuration >= 1000){
		seconds++;
		tempDuration = tempDuration - 1000;
	}
	milliseconds = tempDuration;
	
	if(zeroInHour)
		return [NSString stringWithFormat:@"%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds];
	else
		return [NSString stringWithFormat:@"%d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds];
}

@end
