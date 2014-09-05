//
//  UIView+Extensions.m
//
//  Created by Cory Imdieke on 1/22/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import "UIView+Extensions.h"

#if __has_feature(objc_arc) != 1
#error This code requires ARC
#endif

@implementation UIView (Extensions)

#pragma mark Searching
- (id)descendantOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls])
		return self;
	
	for (UIView* child in self.subviews) {
		UIView* it = [child descendantOrSelfWithClass:cls];
		if (it)
			return it;
	}
	
	return nil;
}

- (id)ancestorOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	} else if (self.superview) {
		return [self.superview ancestorOrSelfWithClass:cls];
	} else {
		return nil;
	}
}

- (id)findFirstResponder {
	if ([self isFirstResponder]) {
		return self;
	}
	
	for (UIView* subView in self.subviews) {
		if ([subView isFirstResponder]) {
			return subView;
		}
		
		UIView* firstResponderCheck = [subView findFirstResponder];
		if (nil != firstResponderCheck) {
			return firstResponderCheck;
		}
	}
	return nil;
}

#pragma mark - Positioning
- (CGFloat)x{
	return self.frame.origin.x;
}
- (CGFloat)y{
	return self.frame.origin.y;
}
- (CGPoint)origin{
	return self.frame.origin;
}
- (CGFloat)width{
	return self.frame.size.width;
}
- (CGFloat)height{
	return self.frame.size.height;
}
- (CGSize)size{
	return self.frame.size;
}

- (void)setX:(CGFloat)newX{
	[self setFrame:CGRectMake(newX, self.y, self.width, self.height)];
}
- (void)setY:(CGFloat)newY{
	[self setFrame:CGRectMake(self.x, newY, self.width, self.height)];
}
- (void)setOrigin:(CGPoint)newOrigin{
	[self setFrame:CGRectMake(newOrigin.x, newOrigin.y, self.width, self.height)];
}
- (void)setWidth:(CGFloat)newWidth{
	[self setFrame:CGRectMake(self.x, self.y, newWidth, self.height)];
}
- (void)setHeight:(CGFloat)newHeight{
	[self setFrame:CGRectMake(self.x, self.y, self.width, newHeight)];
}
- (void)setSize:(CGSize)newSize{
	[self setFrame:CGRectMake(self.x, self.y, newSize.width, newSize.height)];
}

#pragma mark - Shadows
- (void)setViewShadowWithOffset:(CGSize)offset{
	self.layer.masksToBounds = NO;
	self.layer.shadowOffset = offset;
	self.layer.shadowRadius = 5.0;
	self.layer.shadowOpacity = 0.5;
	CGPathRef shadowPath = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
	self.layer.shadowPath = shadowPath;
}

#pragma mark - Rounded Corners
- (void)setRoundedCornersWithRadius:(CGFloat)rad{
	self.layer.cornerRadius = rad;
	self.layer.masksToBounds = YES;
}

- (void)setRoundedCorners:(CGFloat)roundedCorners{
	[self setRoundedCornersWithRadius:roundedCorners];
}

- (CGFloat)roundedCorners{
	return self.layer.cornerRadius;
}

#pragma mark - Borders
- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width{
	self.layer.borderColor = [color CGColor];
	self.layer.borderWidth = width;
}

#pragma mark - PDF

- (NSData *)renderInPDFData{
    CGRect mediaBox = self.bounds;
	NSMutableData *pdfData = [[NSMutableData alloc] init];
	CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfData);
	CGContextRef ctx = CGPDFContextCreate(consumer, &mediaBox, NULL);
	
    CGPDFContextBeginPage(ctx, NULL);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -mediaBox.size.height);
	
	if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
	else
		[self.layer renderInContext:ctx];
	
    CGPDFContextEndPage(ctx);
    CGContextRelease(ctx);
	CFRelease(consumer);
	
	return [NSData dataWithData:pdfData];
}

#pragma mark - Image

- (UIImage *)renderSizeToImage:(CGSize)renderSize{
	CGRect tempFrame = self.frame;
	CGSize oldSize = self.frame.size;
	tempFrame.size = renderSize;
	self.frame = tempFrame;
	
	UIImage *returnImage = [self renderVisibleToImage];
	
	tempFrame.size = oldSize;
	self.frame = tempFrame;
	
	return returnImage;
}

- (UIImage *)renderVisibleToImage{
	int pixelsWide = self.bounds.size.width;
	int pixelsHigh = self.bounds.size.height;
    CGContextRef bitmapContext = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
	
    bitmapBytesPerRow = (pixelsWide * 4);// 1
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
	
    colorSpace = CGColorSpaceCreateDeviceRGB();  // modification from sample
    bitmapData = malloc(bitmapByteCount);
	
	memset(bitmapData, 255, bitmapByteCount);  // wipe with 100% white
    if (bitmapData == NULL){
        fprintf(stderr, "Memory not allocated!");
		CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    bitmapContext = CGBitmapContextCreate (bitmapData,
										   pixelsWide,
										   pixelsHigh,
										   8,      // bits per component
										   bitmapBytesPerRow,
										   colorSpace,
										   (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (bitmapContext == NULL){
        free(bitmapData);
        fprintf(stderr, "Context not created!");
		CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    CGColorSpaceRelease(colorSpace);
	
	CGContextScaleCTM(bitmapContext, 1, -1);
	CGContextTranslateCTM(bitmapContext, 0, -self.bounds.size.height);
	
	if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
		UIGraphicsPushContext(bitmapContext);
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
		UIGraphicsPopContext();
	} else {
		[self.layer renderInContext:bitmapContext];
	}
	
	CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
	UIImage *newImage = [UIImage imageWithCGImage:image];
	CGContextRelease(bitmapContext);
	CGImageRelease(image);
	free(bitmapData);
	
	return newImage;
}

#pragma mark - View Controller

- (UIViewController *)firstAvailableUIViewController{
	// convenience function for casting and to "mask" the recursive function
	return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController{
	id nextResponder = [self nextResponder];
	if([nextResponder isKindOfClass:[UIViewController class]]){
		return nextResponder;
	} else if([nextResponder isKindOfClass:[UIView class]]){
		return [nextResponder traverseResponderChainForUIViewController];
	} else {
		return nil;
	}
}

@end
