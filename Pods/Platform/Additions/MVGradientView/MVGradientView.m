//
//  MVGradientView.m
//
//  Created by Cory Imdieke on 9/26/12.
//  Copyright (c) 2012 Bitsuites, LLC. All rights reserved.
//

#import "MVGradientView.h"
#import "KGNoise.h"


@implementation MVGradientView

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if(self){
		// Initialization code
		_gradientDirection = MVGradientDirectionHorizontal;
		_noiseOpacity = 0.0;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		// Initialization code
		_gradientDirection = MVGradientDirectionHorizontal;
		_noiseOpacity = 0.0;
	}
	return self;
}

- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClipToRect(context, rect);

	NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:[self.colors count]];
	for(UIColor *color in self.colors){
		[cgColors addObject:(id)[color CGColor]];
	}

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradientToDraw = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(cgColors), NULL);

	CGPoint start = CGPointMake(0.0f, 0.0f);
	CGPoint end = (self.gradientDirection == MVGradientDirectionVertical) ? CGPointMake(0.0f, rect.size.height) : CGPointMake(rect.size.width, 0.0f);
	CGContextDrawLinearGradient(context, gradientToDraw, start, end, 0);

	if(self.noiseOpacity > 0.0)
		[KGNoise drawNoiseWithOpacity:self.noiseOpacity];

	CGGradientRelease(gradientToDraw);
	CGColorSpaceRelease(colorSpace);
}

#pragma mark Accessors

- (void)setGradientDirection:(MVGradientDirection)gradientDirection{
	_gradientDirection = gradientDirection;

	[self setNeedsDisplay];
}

- (void)setColors:(NSArray *)colors{
	_colors = colors;

	[self setNeedsDisplay];
}

- (void)setNoiseOpacity:(CGFloat)noiseOpacity{
	_noiseOpacity = noiseOpacity;

	[self setNeedsDisplay];
}

@end
