//
//  UIImage+Border.m
//
//  Created by Justin Carstens on 2/11/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import "UIImage+Border.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Border)

- (UIImage*)imageWithRoundedCorners:(float)radius andBorderWidth:(float)width andBorderColor:(UIColor *)color{
	CALayer *imageLayer = [CALayer layer];
	imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
	imageLayer.contents = (id) self.CGImage;
	
	imageLayer.borderColor = [color CGColor];
	imageLayer.borderWidth = width;
	imageLayer.masksToBounds = YES;
	imageLayer.cornerRadius = radius;
	
	UIGraphicsBeginImageContext(self.size);
	[imageLayer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return roundedImage;
}

@end
