//
//  UIImage+ImageManipulation.m
//
//  Created by Cory Imdieke on 12/2/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import "UIImage+ImageManipulation.h"

CGFloat normalize(CGFloat pixel){
	if(pixel > 255) return 255;
	else if(pixel < 0) return 0;
	return pixel;
}

@implementation UIImage (ImageManipulation)

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (UIImage *)convertToGrayscale {
    CGSize size = [self size];
	// (Modified to take scale into account)
    int width = size.width * [self scale];
    int height = size.height * [self scale];
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return (modified to keep scale and orientation
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}

- (UIImage *)convertToSepiaWithIntensity:(int)sepiaIntensity {
	int sepiaDepth = 20;
	
    CGSize size = [self size];
	// (Modified to take scale into account)
    int width = size.width * [self scale];
    int height = size.height * [self scale];
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
			// set the pixels to gray (we use temp ints in case the pixels go above or below bounds
			int r = gray;
			int g = gray;
			int b = gray;
			
			// add sepia depth
			r = r + (sepiaDepth * 2);
			g = g + sepiaDepth;
			
			// check for bounds
			if(r > 255) r = 255;
			if(g > 255) g = 255;
			
			// darken blue to intensify sepia
			b = b - sepiaIntensity;
			
			// normalize if out of bounds 
			b = normalize(b);
			
			// Write back to pixels
			rgbaPixel[RED] = r;
			rgbaPixel[GREEN] = g;
			rgbaPixel[BLUE] = b;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return (modified to keep scale and orientation
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}
 
- (UIImage *)adjustedSaturationImage:(CGFloat)saturation{
	CGSize size = [self size];
	// (Modified to take scale into account)
    int width = size.width * [self scale];
    int height = size.height * [self scale];
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
			// Get each color component
			int r = rgbaPixel[RED];
			int g = rgbaPixel[GREEN];
			int b = rgbaPixel[BLUE];
			
			// Saturate
			CGFloat avg = (r + g + b) / 3.0;
			r = normalize((r - avg) * saturation + avg);
			g = normalize((g - avg) * saturation + avg);
			b = normalize((b - avg) * saturation + avg);
			
			// Write back to pixels
			rgbaPixel[RED] = r;
			rgbaPixel[GREEN] = g;
			rgbaPixel[BLUE] = b;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return (modified to keep scale and orientation
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}

- (UIImage *)adjustedContrastImage:(CGFloat)contrast{
	CGSize size = [self size];
	// (Modified to take scale into account)
    int width = size.width * [self scale];
    int height = size.height * [self scale];
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
			
			// Get each color component
			int r = rgbaPixel[RED];
			int g = rgbaPixel[GREEN];
			int b = rgbaPixel[BLUE];
			
			// Adjust Contrast
			r = normalize((((r-128) * contrast)) + 128);
			g = normalize((((g-128) * contrast)) + 128);
			b = normalize((((b-128) * contrast)) + 128);
			
			// Write back to pixels
			rgbaPixel[RED] = r;
			rgbaPixel[GREEN] = g;
			rgbaPixel[BLUE] = b;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return (modified to keep scale and orientation
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}

- (UIImage *)vintageImage{
	@autoreleasepool {
		UIImage *editingImage = [self adjustedSaturationImage:1.6];
		editingImage = [editingImage adjustedContrastImage:1.2];
		UIImage *sepiaImage = [editingImage convertToSepiaWithIntensity:25];
		
		CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
		
		UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextTranslateCTM(context, 0.0, self.size.height); // flip image right side up
		CGContextScaleCTM(context, 1.0, -1.0);
		
		CGContextDrawImage(context, rect, editingImage.CGImage);
		CGContextSetAlpha(context, 0.7);
		CGContextDrawImage(context, rect, sepiaImage.CGImage);
		
		UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		return retImage;
	}
}

- (UIImage *)sharpenedImage{
	CGSize size = [self size];
	// (Modified to take scale into account)
    int width = size.width * [self scale];
    int height = size.height * [self scale];
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
	int filter[3][3] = {{-1,-1,-1},
						{-1,17,-1},
						{-1,-1,-1}}; // The sharpen filter
	
	int rsum = 0;
	int gsum = 0;
	int bsum = 0;
	int ksum = 0;
	
	// Step through image
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
			// Modifying the matrix's center pixel
			uint8_t *centerPixel = (uint8_t *) &pixels[y * width + x];
			
			// Step through matrix and add to total sum for each component
			for(int row = -1; row <= 1; row++){
				for(int col = -1; col <= 1; col++){
					// Make sure we're not out of image bounds
					if(y + row >= 0 && y + row <= height){
						if(x + col >= 0 && x + col <= width){
							uint8_t *matrixPixel = (uint8_t *) &pixels[((y + row) * width) + (x + col)];
							
							// Get each color component
							int r = matrixPixel[RED];
							int g = matrixPixel[GREEN];
							int b = matrixPixel[BLUE];
							
							// Add sums from matrix
							rsum = rsum + filter[row + 1][col + 1] * r; // Red
							gsum = gsum + filter[row + 1][col + 1] * g; // Green
							bsum = bsum + filter[row + 1][col + 1] * b; // Blue
							ksum = ksum + filter[row + 1][col + 1];	    // Kernel Sum
							
						}
					}
				}
			}
			
			int newR = rsum;
			int newG = gsum;
			int newB = bsum;
			
			if(ksum != 0){
				newR = rsum / ksum;
				newG = gsum / ksum;
				newB = bsum / ksum;
			}
			
			// Write back to center pixel
			centerPixel[RED] = normalize(newR);
			centerPixel[GREEN] = normalize(newG);
			centerPixel[BLUE] = normalize(newB);
			
			// Reset values
			rsum = 0;
			gsum = 0;
			bsum = 0;
			ksum = 0;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return (modified to keep scale and orientation
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}

- (UIImage *)blurredImage:(int)intensity{
	if(intensity < 2) return nil;
	
	CGSize size = [self size];
	// (Modified to take scale into account)
    int width = size.width * [self scale];
    int height = size.height * [self scale];
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
	// Make sure intensity is odd number
	if(intensity % 2 == 0)
		intensity++;
	
	// Kernel center value
	int kCenter = intensity / 2 + 1;
	int startPoint = -(intensity - kCenter);
	int endPoint = (intensity - kCenter);
	
	// Generate blur filter depending on intensity
	float filter[intensity][intensity];
	for(int fr = 0; fr < intensity; fr++){
		for(int fc = 0; fc < intensity; fc++){
			filter[fr][fc] = 1.0 / ((float)intensity * (float)intensity);
		}
	}
	
	float rsum = 0.0;
	float gsum = 0.0;
	float bsum = 0.0;
	float ksum = 0.0;
	
	// Step through image
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
			// Modifying the matrix's center pixel
			uint8_t *centerPixel = (uint8_t *) &pixels[y * width + x];
			
			// Step through matrix and add to total sum for each component
			for(int row = startPoint; row <= endPoint; row++){
				for(int col = startPoint; col <= endPoint; col++){
					// Make sure we're not out of image bounds
					if(y + row >= 0 && y + row <= height){
						if(x + col >= 0 && x + col <= width){
							uint8_t *matrixPixel = (uint8_t *) &pixels[((y + row) * width) + (x + col)];
							
							// Get each color component
							int r = matrixPixel[RED];
							int g = matrixPixel[GREEN];
							int b = matrixPixel[BLUE];
							
							// Add sums from matrix
							rsum = rsum + filter[row + endPoint][col + endPoint] * r; // Red
							gsum = gsum + filter[row + endPoint][col + endPoint] * g; // Green
							bsum = bsum + filter[row + endPoint][col + endPoint] * b; // Blue
							ksum = ksum + filter[row + endPoint][col + endPoint];	  // Kernel Sum
							
						}
					}
				}
			}
			
			rsum = roundf(rsum);
			gsum = roundf(gsum);
			bsum = roundf(bsum);
			
			int newR = (int)rsum;
			int newG = (int)gsum;
			int newB = (int)bsum;
			
			if(ksum != 0.0){
				newR = (int)(rsum / ksum);
				newG = (int)(gsum / ksum);
				newB = (int)(bsum / ksum);
			}
			
			// Write back to center pixel
			centerPixel[RED] = normalize(newR);
			centerPixel[GREEN] = normalize(newG);
			centerPixel[BLUE] = normalize(newB);
			
			// Reset values
			rsum = 0.0;
			gsum = 0.0;
			bsum = 0.0;
			ksum = 0.0;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return (modified to keep scale and orientation
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}

@end