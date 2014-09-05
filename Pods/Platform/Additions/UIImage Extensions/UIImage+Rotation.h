//
//  UIImage+Rotation.h
//  Pathways
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	MVImageFlipXAxis,
	MVImageFlipYAxis,
	MVImageFlipXAxisAndYAxis
} MVImageFlip;

@interface UIImage (Rotation)

// Rotating
- (UIImage *)rotatedImageByRadians:(CGFloat)radians;
- (UIImage *)rotatedImageByDegrees:(CGFloat)degrees;

// Flipping
- (UIImage *)flippedImageByAxis:(MVImageFlip)axis;

// Normalizing Image
+ (UIImage *)imageByNormalizingImageDataForSetOrientation:(UIImage *)image;

@end
