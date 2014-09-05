//
//  UIImage+Border.h
//
//  Created by Justin Carstens on 2/11/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Border)
- (UIImage*)imageWithRoundedCorners:(float)radius andBorderWidth:(float)width andBorderColor:(UIColor *)color;
@end
