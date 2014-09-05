//
//  MVFormatter.h
//  Platform
//
//  Created by Justin Carstens on 3/19/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MVFormatter<NSObject>
/** Formats the given string with with formatting
 
 @param string that is to be formatted
 @return Returns an `NSString` of the string with formatting
 */
+ (NSString *)formattedStringFromUnformattedString:(NSString *)string;

@optional

/** Seperates a formatted string into its seprerate pieces
 
 @param string that is to be formatted and seperated
 @return Returns an `NSArray` of the string that was formatted and seperated
 */
+ (NSArray *)seperatedStringsFromFromattedString:(NSString *)string;

@end
