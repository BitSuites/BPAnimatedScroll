//
//  UIImage+Blur.h
//  Platform
//
//  Created by Cory Imdieke on 6/17/13.
//  Copyright (c) 2013 BitSuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>


@interface UIImage (Blur)

- (UIImage *)applyLightBlurEffect;
- (UIImage *)applyExtraLightBlurEffect;
- (UIImage *)applyDarkBlurEffect;
- (UIImage *)applyTintBlurEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
