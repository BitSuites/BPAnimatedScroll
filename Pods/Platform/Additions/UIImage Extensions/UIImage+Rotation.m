//
//  UIImage+Rotation.m
//  Pathways
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

#import "UIImage+Rotation.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (Rotation)

#pragma mark Rotating

- (UIImage *)rotatedImageByRadians:(CGFloat)radians{
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(radians);
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	// Rotate the image context
	CGContextRotateCTM(bitmap, radians);
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *)rotatedImageByDegrees:(CGFloat)degrees{   
	return [self rotatedImageByRadians:DegreesToRadians(degrees)];
}

#pragma mark Flipping

- (UIImage *)flippedImageByAxis:(MVImageFlip)axis{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	if(axis == MVImageFlipXAxis){
		// Do nothing, X is flipped normally in a Core Graphics Context
	} else if(axis == MVImageFlipYAxis){
		// fix X axis
		CGContextTranslateCTM(context, 0, self.size.height);
		CGContextScaleCTM(context, 1.0f, -1.0f);
		
		// then flip Y axis
		CGContextTranslateCTM(context, self.size.width, 0);
		CGContextScaleCTM(context, -1.0f, 1.0f);
	} else if(axis == MVImageFlipXAxisAndYAxis){
		// just flip Y
		CGContextTranslateCTM(context, self.size.width, 0);
		CGContextScaleCTM(context, -1.0f, 1.0f);
	}
	
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, self.size.width, self.size.height), [self CGImage]);
	
    UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return flipedImage;
}

#pragma mark Normalizing

+ (UIImage *)imageByNormalizingImageDataForSetOrientation:(UIImage *)image{
	if (image.imageOrientation == UIImageOrientationUp)
		return image;
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	switch (image.imageOrientation) {
		case UIImageOrientationDown:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.width, 0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
			
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, 0, image.size.height);
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			break;
		case UIImageOrientationUp:
		case UIImageOrientationUpMirrored:
			break;
	}
	
	switch (image.imageOrientation) {
		case UIImageOrientationUpMirrored:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.width, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
			
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.height, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
		case UIImageOrientationUp:
		case UIImageOrientationDown:
		case UIImageOrientationLeft:
		case UIImageOrientationRight:
			break;
	}
	
	// Now we draw the underlying CGImage into a new context, applying the transform
	// calculated above.
	CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
											 CGImageGetBitsPerComponent(image.CGImage), 0,
											 CGImageGetColorSpace(image.CGImage),
											 CGImageGetBitmapInfo(image.CGImage));
	CGContextConcatCTM(ctx, transform);
	switch (image.imageOrientation) {
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			// Grr...
			CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
			break;
			
		default:
			CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
			break;
	}
	
	// And now we just create a new UIImage from the drawing context
	CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
	UIImage *img = [UIImage imageWithCGImage:cgimg];
	CGContextRelease(ctx);
	CGImageRelease(cgimg);
	return img;
}

@end
