//
//  NSDateFormatter+Extensions.m
//
//  Created by Cory Imdieke on 5/13/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import "NSDateFormatter+Extensions.h"

@implementation NSDateFormatter (Extensions)

+ (NSString *)timeFormatStringForCurrentLocaleWithAMPMOr24Hour{
	return [NSDateFormatter dateFormatFromTemplate:@"j:mm a" options:0 locale:[NSLocale currentLocale]];
}

@end
