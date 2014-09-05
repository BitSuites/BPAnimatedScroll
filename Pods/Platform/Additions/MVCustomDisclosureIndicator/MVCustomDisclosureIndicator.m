//
//  MVCustomDisclosureIndicator.m
//
//  Created by Cory Imdieke on 12/6/11.
//  Copyright (c) 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "MVCustomDisclosureIndicator.h"

@implementation MVCustomDisclosureIndicator

@synthesize accessoryColor, highlightedColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

+ (id)accessoryWithColor:(UIColor *)color{
	id ret = [[self alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
	[ret setAccessoryColor:color];
	
	return ret;
}

- (void)drawRect:(CGRect)rect{
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0;
	CGFloat y = CGRectGetMidY(self.bounds);
	const CGFloat R = 4.5;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
	
	if (self.highlighted){
		[self.highlightedColor setStroke];
	}
	else{
		[self.accessoryColor setStroke];
	}
	
	CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted{
	[super setHighlighted:highlighted];
	
	[self setNeedsDisplay];
}

- (UIColor *)accessoryColor{
	if (!accessoryColor){
		return [UIColor lightGrayColor];
	}
	
	return accessoryColor;
}

- (UIColor *)highlightedColor{
	if (!highlightedColor){
		return [UIColor whiteColor];
	}
	
	return highlightedColor;
}

@end
