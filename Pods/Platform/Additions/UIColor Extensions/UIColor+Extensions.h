//
//  UIColor+Extensions.h
//
//  Created by Cory Imdieke on 7/6/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Convenience methods for `UIColor`
@interface UIColor (Extensions)

/** Generates a `UIColor` given a web-style hex string.
 
 @param str Hex string. Example: #123456
 */
+ (UIColor *)colorWithHexString:(NSString *)str;

/** Generates a `UIColor` given a hex number.
 
 @param col Hex integer. Example: 0x123456
 */
+ (UIColor *)colorWithHex:(UInt32)col;

/** Generates a `UIColor` that is slightly darker from the base color.
 */
- (UIColor *)darkerColor;

/** Generates a `UIColor` that is slightly lighter from the base color.
 */
- (UIColor *)lighterColor;

@end
