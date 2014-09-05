//
//  UIColor+Extensions.m
//
//  Created by Cory Imdieke on 7/6/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "UIColor+Extensions.h"


@implementation UIColor (Extensions)

// takes @"#123456"
+ (UIColor *)colorWithHexString:(NSString *)str{
	if(!str) return nil;
    
    // Check validity
    if(![str hasPrefix:@"#"]){
        str = [@"#" stringByAppendingString:str];
    }
    if([str length] != 7)
        return nil;
    
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:(UInt32)x];
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col{
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

- (UIColor *)darkerColor{
	CGFloat h, s, b, a, r, g, w;
    if([self getHue:&h saturation:&s brightness:&b alpha:&a]){
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.65
                               alpha:a];
	} else if([self getRed:&r green:&g blue:&b alpha:&a]){
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
	} else if([self getWhite:&w alpha:&a]){
		return [UIColor colorWithWhite:MAX(w - 0.15, 0.0)
								 alpha:a];
	}
	
    return nil;
}

- (UIColor *)lighterColor{
	CGFloat h, s, b, a, r, g, w;
    if([self getHue:&h saturation:&s brightness:&b alpha:&a]){
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
							   alpha:a];
	} else if([self getRed:&r green:&g blue:&b alpha:&a]){
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
	} else if([self getWhite:&w alpha:&a]){
		return [UIColor colorWithWhite:MAX(w + 0.15, 0.0)
								 alpha:a];
	}
    return nil;
}

@end
