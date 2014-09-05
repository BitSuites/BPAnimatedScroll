//
//  MVGradientView.h
//
//  Created by Cory Imdieke on 9/26/12.
//  Copyright (c) 2012 Bitsuites, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
	MVGradientDirectionHorizontal,
	MVGradientDirectionVertical
} MVGradientDirection;

@interface MVGradientView : UIView

@property (nonatomic) MVGradientDirection gradientDirection;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) CGFloat noiseOpacity;

@end
