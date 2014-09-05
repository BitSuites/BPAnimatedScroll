//
//  MVBarTender.h
//
//  Created by Cory Imdieke on 10/10/12.
//  Copyright (c) 2012 Bitsuites, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MVBarTender.h"
#import "MVGradientView.h"
#import "UIColor+Extensions.h"
#import "UIView+Extensions.h"


@implementation MVBarTender

+ (void)customizeNavBarWithDefaults:(UINavigationBar *)navBar{
	UIColor *defaultColor = [UIColor colorWithWhite:0.25 alpha:1.0];
	
	[self customizeNavBar:navBar withTintColor:defaultColor];
}

+ (void)customizeNavBar:(UINavigationBar *)navBar withTintColor:(UIColor *)tintColor{
	// nil nav bar means customize appearance proxy
	if(!navBar){
		navBar = [UINavigationBar appearance];
	}
	
	UIColor *darkerColor = [tintColor darkerColor];
	
	UIImage *background = [self backgroundImageForTintColor:tintColor darkerColor:darkerColor barPosition:UIToolbarPositionTop barHeight:44.0];
	
	[navBar setBackgroundImage:background forBarMetrics:UIBarMetricsDefault];
	[navBar setTintColor:tintColor];
}

+ (void)customizeToolBarWithDefaults:(UIToolbar *)toolBar{
	UIColor *defaultColor = [UIColor colorWithWhite:0.25 alpha:1.0];
	
	[self customizeToolBar:toolBar withTintColor:defaultColor];
}

+ (void)customizeToolBar:(UIToolbar *)toolBar withTintColor:(UIColor *)tintColor{
	// nil tool bar means customize appearance proxy
	if(!toolBar){
		toolBar = [UIToolbar appearance];
	}
	
	UIColor *darkerColor = [tintColor darkerColor];
	
	UIImage *topBackground = [self backgroundImageForTintColor:tintColor darkerColor:darkerColor barPosition:UIToolbarPositionTop barHeight:44.0];
	UIImage *bottomBackground = [self backgroundImageForTintColor:tintColor darkerColor:darkerColor barPosition:UIToolbarPositionBottom barHeight:44.0];
	
	[toolBar setBackgroundImage:topBackground forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
	[toolBar setBackgroundImage:bottomBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	[toolBar setTintColor:tintColor];
}

+ (void)customizeTabBarWithDefaults:(UITabBar *)tabBar forNumberOfTabs:(NSUInteger)numTabs{
	UIColor *defaultColor = [UIColor colorWithWhite:0.25 alpha:1.0];
	
	[self customizeTabBar:tabBar withTintColor:defaultColor forNumberOfTabs:numTabs];
}

+ (void)customizeTabBar:(UITabBar *)tabBar withTintColor:(UIColor *)tintColor forNumberOfTabs:(NSUInteger)numTabs{
	// nil tab bar means customize appearance proxy
	if(!tabBar){
		tabBar = [UITabBar appearance];
	}
	
	UIColor *darkerColor = [tintColor darkerColor];
	
	UIImage *background = [self backgroundImageForTintColor:tintColor darkerColor:darkerColor barPosition:UIToolbarPositionBottom barHeight:49.0];
	UIImage *selected = [self selectedImageForNumberOfTabs:numTabs];
	
	[tabBar setBackgroundImage:background];
	[tabBar setSelectionIndicatorImage:selected];
}

+ (UIImage *)backgroundImageForTintColor:(UIColor *)tintColor darkerColor:(UIColor *)darkColor barPosition:(UIToolbarPosition)position barHeight:(CGFloat)height{
	CGFloat whitePosition = 0.0, blackPosition = 0.0;
	switch (position) {
		case UIToolbarPositionTop:
			whitePosition = height - 2.0;
			blackPosition = height - 1.0;
			break;
			
		case UIToolbarPositionBottom:
			whitePosition = 1.0;
			blackPosition = 0.0;
			break;
			
		default:
			NSAssert(NO, @"Toolbar position must not be UIToolbarPositionAny.");
			break;
	}
	
	UIView *tabBarCustom = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, height)];
	MVGradientView *gradient = [[MVGradientView alloc] initWithFrame:tabBarCustom.frame];
	[gradient setGradientDirection:MVGradientDirectionVertical];
	[gradient setColors:@[tintColor, darkColor]];
	[gradient setNoiseOpacity:0.05];
	[gradient setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	[tabBarCustom addSubview:gradient];
	UIView *blackLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, blackPosition, 320.0, 1.0)];
	[blackLine setBackgroundColor:[UIColor blackColor]];
	[blackLine setAlpha:0.4];
	[blackLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, whitePosition, 320.0, 1.0)];
	[whiteLine setBackgroundColor:[UIColor whiteColor]];
	[whiteLine setAlpha:0.1];
	[whiteLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[tabBarCustom addSubview:blackLine];
	[tabBarCustom addSubview:whiteLine];
	
	return [self renderViewToImage:tabBarCustom];
}

+ (UIImage *)selectedImageForNumberOfTabs:(NSUInteger)numTabs{
	CGFloat tabWidth = 0.0;
	switch(numTabs){
		case 1:
			tabWidth = 320.0;
			break;
		case 2:
			tabWidth = 160.0;
			break;
		case 3:
			tabWidth = 107.0;
			break;
		case 4:
			tabWidth = 80.0;
			break;
		case 5:
			tabWidth = 64.0;
			break;
			
		default:
			NSAssert(NO, @"Invalid number of tabs: %lu. Must be between 1 and 5.", (unsigned long)numTabs);
			break;
	}
	
	UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tabWidth, 49.0)];
	[selectedView setBackgroundColor:[UIColor blackColor]];
	[selectedView setAlpha:0.4];
	
	return [self renderViewToImage:selectedView];
}

+ (UIImage *)renderViewToImage:(UIView *)view{
	int pixelsWide = view.bounds.size.width;
	int pixelsHigh = view.bounds.size.height;
	CGFloat drawScale = [[UIScreen mainScreen] scale];
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixelsWide, pixelsHigh), NO, drawScale);
	CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
	
	if([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
		[view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
	else
		[view.layer renderInContext:bitmapContext];
	
	CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
	UIImage *newImage = [[UIImage alloc] initWithCGImage:image scale:drawScale orientation:UIImageOrientationUp];
	CGImageRelease(image);
	UIGraphicsPopContext();
	
	return newImage;
}

@end