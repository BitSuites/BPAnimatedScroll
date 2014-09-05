//
//  UIImage+ImageManipulation.h
//
//  Created by Cory Imdieke on 12/2/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (ImageManipulation)

- (UIImage *)convertToGrayscale;

// Around 30 works well for intensity
- (UIImage *)convertToSepiaWithIntensity:(int)sepiaIntensity;

// Between 0 and 3 (0 is normal)
- (UIImage *)adjustedSaturationImage:(CGFloat)saturation;

// Between 0 and 2 (1.0 is normal)
- (UIImage *)adjustedContrastImage:(CGFloat)contrast;

- (UIImage *)vintageImage;

- (UIImage *)sharpenedImage;

// Uses a box blur http://www.jhlabs.com/ip/blurring.html
// 0 is no blur, 5 for minor blur, 20 for huge blur
- (UIImage *)blurredImage:(int)intensity;

@end
