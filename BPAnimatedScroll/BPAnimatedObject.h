//
//  BPAnimatedObject.h
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BPLayoutConstraintWidth, // Width of object (negative number is screen width minus value) (CGFLoat)
    BPLayoutConstraintHeight, // Height of object (negative number is screen width minus value) (CGFLoat)
    BPLayoutConstraintTopToTopLayout, // Top of Object to Top of Scroll View (CGFLoat)
    BPLayoutConstraintTopToBottomLayout, // Top of Object to Bottom of Scroll View (View will be off screen) (CGFLoat)
    BPLayoutConstraintBottomToBottomLayout, // Bottom of Object to Bottom of Scroll View (CGFLoat)
    BPLayoutConstraintBottomToTopLayout, // Bottom of Object to Top of Scroll View (View will be off screen) (CGFLoat)
    BPLayoutConstraintLeftToLeading, // Left of Object to Left of Scroll View (CGFLoat)
    BPLayoutConstraintLeftToTrailing, // Left of Object to Right of Scroll View (View will be off screen) (CGFLoat)
    BPLayoutConstraintRightToTrailing, // Right of Object to Right of Scroll View (CGFLoat)
    BPLayoutConstraintRightToLeading, // Right of Object to Left of Scroll View (View will be off screen) (CGFLoat)
    BPLayoutConstraintCenterVertical, // Centers Object vertically in scroll view (YES)
    BPLayoutConstraintCenterHorizontal, // Centers Object horizonally in scroll view (YES)
    BPLayoutConstraintKeepRatio // Keeps the ratio of the original frame (YES)
} BPLayoutConstraint;

@interface BPAnimatedObject : NSObject

@property (nonatomic, strong) UIView *animatedObject;
@property (nonatomic) CGRect startPosition; // Off Screen Left
@property (nonatomic) CGRect centerPosition; // Center Screen
@property (nonatomic) CGRect endPosition; // Off Screen Right
@property (nonatomic, strong) NSDictionary *startConstraints; // Off Screen Left
@property (nonatomic, strong) NSDictionary *centerConstraints; // Center Screen
@property (nonatomic, strong) NSDictionary *endConstraints; // Off Screen Right
@property (nonatomic) CGFloat startAlpha; // Off Screen Left
@property (nonatomic) CGFloat centerAlpha; // Center Left
@property (nonatomic) CGFloat endAlpha; // Off Screen Right

@property (nonatomic) CGRect landscapeStartPosition; // Off Screen Left
@property (nonatomic) CGRect landscapeCenterPosition; // Center Screen
@property (nonatomic) CGRect landscapeEndPosition; // Off Screen Right
@property (nonatomic, strong) NSDictionary *landscapeStartConstraints; // Off Screen Left
@property (nonatomic, strong) NSDictionary *landscapeCenterConstraints; // Center Screen
@property (nonatomic, strong) NSDictionary *landscapeEndConstraints; // Off Screen Right
@property (nonatomic) CGFloat landscapeStartAlpha; // Off Screen Left
@property (nonatomic) CGFloat landscapeCenterAlpha; // Center Left
@property (nonatomic) CGFloat landscapeEndAlpha; // Off Screen Right

@property (nonatomic) BOOL differentLandscapeConstraints; // Default NO
@property (nonatomic) NSInteger zOrder; // Default is 10;

// Local Use only need to make private
- (void)addToSuperview:(UIView *)superview;
- (void)removeFromSuperview;
- (void)animateToPercent:(CGFloat)percent leftSide:(BOOL)leftSide;

@end
