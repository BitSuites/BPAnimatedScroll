//
//  BPAnimatedObject.m
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import "BPAnimatedObject.h"

typedef enum {
    BPAnimatedObjectSetWidth,
    BPAnimatedObjectSetHeight,
    BPAnimatedObjectSetX,
    BPAnimatedObjectSetY,
    BPAnimatedObjectSetFrame
} BPAnimatedObjectSet;

@interface BPAnimatedObject () {
    BOOL startSet;
    BOOL centerSet;
    BOOL endSet;
}

@end

@implementation BPAnimatedObject
@synthesize startPosition, centerPosition, endPosition, sharedConstraints, startConstraints, centerConstraints, endConstraints, startAlpha, centerAlpha, endAlpha, animatedObject, landscapeCenterAlpha, landscapeCenterConstraints, landscapeCenterPosition, landscapeEndAlpha, landscapeEndConstraints, landscapeEndPosition, landscapeStartAlpha, landscapeSharedConstraints, landscapeStartConstraints, landscapeStartPosition, zOrder, differentLandscapeConstraints;

- (instancetype)init {
    self = [super init];
    if (self) {
        zOrder = 10;
        differentLandscapeConstraints = NO;
    }
    return self;
}

#pragma mark - Setters

- (void)setAnimatedObject:(UIView *)newObject {
    if (!startSet) {
        startPosition = newObject.frame;
        landscapeStartPosition = newObject.frame;
    }
    if (!centerSet) {
        centerPosition = newObject.frame;
        landscapeCenterPosition = newObject.frame;
    }
    if (!endSet) {
        endPosition = newObject.frame;
        landscapeEndPosition = newObject.frame;
    }
    animatedObject = newObject;
}

- (void)setStartPosition:(CGRect)position {
    startPosition = position;
    startSet = YES;
}

- (void)setCenterPosition:(CGRect)position {
    centerPosition = position;
    centerSet = YES;
}

- (void)setEndPosition:(CGRect)position {
    endPosition = position;
    endSet = YES;
}

#pragma mark - Custom

- (void)addToSuperview:(UIView *)superview {
    if (animatedObject && animatedObject.superview != superview) {
        [animatedObject setFrame:[self startFrame]];
        [animatedObject setAlpha:([self isLandscape] ? landscapeStartAlpha : landscapeEndAlpha)];
        [animatedObject setHidden:YES];
        [superview addSubview:animatedObject];
        [animatedObject.layer setZPosition:zOrder];
    }
}

- (void)removeFromSuperview {
    if (animatedObject) {
        [animatedObject removeFromSuperview];
    }
}

- (void)animateToPercent:(CGFloat)percent leftSide:(BOOL)leftSide {
    if (!animatedObject)
        return;
    if (percent <= 0) {
        [animatedObject setHidden:YES];
        return;
    } else {
        [animatedObject setHidden:NO];
    }
    
    CGFloat beginningAlpha = ([self isLandscape] ? landscapeCenterAlpha : centerAlpha);
    CGFloat finishingAlpha = 0.0;
    if ([self isLandscape])
        finishingAlpha = (leftSide ? landscapeEndAlpha : landscapeStartAlpha);
    else
        finishingAlpha = (leftSide ? endAlpha : startAlpha);
    CGFloat alphaDiff = (beginningAlpha - finishingAlpha) * (1 - percent);
    [animatedObject setAlpha:(beginningAlpha - alphaDiff)];
    
    CGRect startRect = [self centerFrame];
    CGRect endRect = (leftSide ? [self endFrame] : [self startFrame]);
    CGFloat xOriginDiff = (startRect.origin.x - endRect.origin.x) * (1 - percent);
    CGFloat yOriginDiff = (startRect.origin.y - endRect.origin.y) * (1 - percent);
    CGFloat widthDiff = (startRect.size.width - endRect.size.width) * (1 - percent);
    CGFloat heightDiff = (startRect.size.height - endRect.size.height) * (1 - percent);
    [animatedObject setFrame:CGRectMake(startRect.origin.x - xOriginDiff, startRect.origin.y - yOriginDiff, startRect.size.width - widthDiff, startRect.size.height - heightDiff)];
}

- (BOOL)isLandscape {
    UIViewController *foundController = [self firstAvailableUIViewController:animatedObject];
    if (differentLandscapeConstraints && foundController && UIInterfaceOrientationIsLandscape([foundController interfaceOrientation])) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController *)firstAvailableUIViewController:(UIView *)view {
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self firstAvailableUIViewController:nextResponder];
    } else {
        return nil;
    }
}

- (CGRect)frameForPosition:(BPAnimatedObjectPosition)position {
    if (position == BPAnimatedObjectPositionStart) {
        return [self startFrame];
    } else if (position == BPAnimatedObjectPositionCenter) {
        return [self centerFrame];
    } else if (position == BPAnimatedObjectPositionEnd) {
        return [self endFrame];
    } else {
        return animatedObject.frame;
    }
}

- (CGRect)startFrame {
    if ([self isLandscape]) {
        return [self frameFromConstraints:landscapeStartConstraints withFallbackFrame:landscapeStartPosition position:BPAnimatedObjectPositionStart];
    } else {
        return [self frameFromConstraints:startConstraints withFallbackFrame:startPosition position:BPAnimatedObjectPositionStart];
    }
}

- (CGRect)centerFrame {
    if ([self isLandscape]) {
        return [self frameFromConstraints:landscapeCenterConstraints withFallbackFrame:landscapeCenterPosition position:BPAnimatedObjectPositionCenter];
    } else {
        return [self frameFromConstraints:centerConstraints withFallbackFrame:centerPosition position:BPAnimatedObjectPositionCenter];
    }
}

- (CGRect)endFrame {
    if ([self isLandscape]) {
        return [self frameFromConstraints:landscapeEndConstraints withFallbackFrame:landscapeEndPosition position:BPAnimatedObjectPositionEnd];
    } else {
        return [self frameFromConstraints:endConstraints withFallbackFrame:endPosition position:BPAnimatedObjectPositionEnd];
    }
}

- (CGRect)frameFromConstraints:(NSDictionary *)constraints withFallbackFrame:(CGRect)frame position:(BPAnimatedObjectPosition)position {
    NSMutableDictionary *allConstraints;
    if (constraints) {
        allConstraints = [constraints mutableCopy];
    } else {
        allConstraints = [[NSMutableDictionary alloc] init];
    }
    if ([self isLandscape]) {
        if (landscapeSharedConstraints) {
            [allConstraints addEntriesFromDictionary:landscapeSharedConstraints];
        }
    } else {
        if (sharedConstraints) {
            [allConstraints addEntriesFromDictionary:sharedConstraints];
        }
    }
	CGRect fallbackFrame = frame;
    if ([[allConstraints allKeys] count] <= 0)
        return frame;
    CGRect superviewFrame = CGRectMake(0, 0, 0, 0);
    if (animatedObject.superview) {
        superviewFrame = animatedObject.superview.frame;
    }
    BOOL widthSet = NO;
    BOOL heightSet = NO;
    BOOL xOriginSet = NO;
    BOOL yOriginSet = NO;
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintRelatedToObjects)]) {
        NSArray *relationships = [allConstraints objectForKey:@(BPLayoutConstraintRelatedToObjects)];
        for (NSDictionary *nextRelationship in relationships) {
            BPAnimatedObject *object = [nextRelationship objectForKey:@(BPLayoutConstraintObject)];
            NSDictionary *currentSetItems = @{@(BPAnimatedObjectSetHeight) : @(heightSet), @(BPAnimatedObjectSetWidth) : @(widthSet), @(BPAnimatedObjectSetX) : @(xOriginSet), @(BPAnimatedObjectSetY) : @(yOriginSet)};
            NSDictionary *result = [self relatedFrameFromConstraints:[nextRelationship objectForKey:@(BPLayoutConstraintConstraints)] currentFrame:frame withObjectFrame:[object frameForPosition:position] setValues:currentSetItems];
            if (result != nil) {
                frame = [[result objectForKey:@(BPAnimatedObjectSetFrame)] CGRectValue];
                if ([[result objectForKey:@(BPAnimatedObjectSetHeight)] boolValue]) {
                    heightSet = YES;
                }
                if ([[result objectForKey:@(BPAnimatedObjectSetWidth)] boolValue]) {
                    widthSet = YES;
                }
                if ([[result objectForKey:@(BPAnimatedObjectSetX)] boolValue]) {
                    xOriginSet = YES;
                }
                if ([[result objectForKey:@(BPAnimatedObjectSetY)] boolValue]) {
                    yOriginSet = YES;
                }
            }
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintWidth)]) {
        float widthValue = [[allConstraints objectForKey:@(BPLayoutConstraintWidth)] floatValue];
        if (widthValue < 0) {
            frame.size.width = (superviewFrame.size.width + widthValue);
        } else {
            frame.size.width = widthValue;
        }
        widthSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintHeight)]) {
        float heightValue = [[allConstraints objectForKey:@(BPLayoutConstraintHeight)] floatValue];
        if (heightValue < 0) {
            frame.size.height = (superviewFrame.size.height + heightValue);
        } else {
            frame.size.height = heightValue;
        }
        heightSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintSizeFitHeight)]) {
        if ([animatedObject isKindOfClass:[UILabel class]]) {
            CGFloat newHeight = [((UILabel *)animatedObject) sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)].height;
            if (!heightSet || newHeight < frame.size.height) {
                frame.size.height = newHeight;
                heightSet = YES;
            }
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintTopToTopLayout)]) {
        frame.origin.y = [[allConstraints objectForKey:@(BPLayoutConstraintTopToTopLayout)] floatValue];
        yOriginSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintTopToBottomLayout)]) {
        if (!yOriginSet) {
            frame.origin.y = (superviewFrame.size.height + [[allConstraints objectForKey:@(BPLayoutConstraintTopToBottomLayout)] floatValue]);
            yOriginSet = YES;
        } else if (superviewFrame.size.height > 0) {
            NSLog(@"Breaking BPLayoutConstraintTopToBottomLayout");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintBottomToBottomLayout)]) {
        if (!heightSet && yOriginSet) {
            CGFloat height = (superviewFrame.size.height - frame.origin.y - [[allConstraints objectForKey:@(BPLayoutConstraintBottomToBottomLayout)] floatValue]);
            if (height > 0.0) {
                frame.size.height = height;
                heightSet = YES;
            } else if (superviewFrame.size.height > 0) {
                NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
            }
        } else if (!yOriginSet) {
            frame.origin.y = (superviewFrame.size.height - frame.size.height - [[allConstraints objectForKey:@(BPLayoutConstraintBottomToBottomLayout)] floatValue]);
            yOriginSet = YES;
        } else if (superviewFrame.size.height > 0) {
            NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintBottomToTopLayout)]) {
        if (!heightSet && yOriginSet) {
            CGFloat height = ((-[[allConstraints objectForKey:@(BPLayoutConstraintBottomToTopLayout)] floatValue]) - frame.origin.y);
            if (height > 0.0) {
                frame.size.height = height;
                heightSet = YES;
            } else {
                NSLog(@"Breaking BPLayoutConstraintBottomToTopLayout");
            }
        } else if (!yOriginSet) {
            frame.origin.y = (-([[allConstraints objectForKey:@(BPLayoutConstraintBottomToTopLayout)] floatValue] + frame.size.height));
            yOriginSet = YES;
        } else {
            NSLog(@"Breaking BPLayoutConstraintBottomToTopLayout");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintLeftToLeading)]) {
        frame.origin.x = [[allConstraints objectForKey:@(BPLayoutConstraintLeftToLeading)] floatValue];
        xOriginSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintLeftToTrailing)]) {
        if (!xOriginSet) {
            frame.origin.x = (superviewFrame.size.width + [[allConstraints objectForKey:@(BPLayoutConstraintLeftToTrailing)] floatValue]);
            xOriginSet = YES;
        } else if (superviewFrame.size.width > 0) {
            NSLog(@"Breaking BPLayoutConstraintLeftToTrailing");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintRightToTrailing)]) {
        if (!widthSet && xOriginSet) {
            CGFloat width = (superviewFrame.size.width - frame.origin.x - [[allConstraints objectForKey:@(BPLayoutConstraintRightToTrailing)] floatValue]);
            if (width > 0.0) {
                frame.size.width = width;
                widthSet = YES;
            } else if (superviewFrame.size.width > 0) {
                NSLog(@"Breaking BPLayoutConstraintRightToTrailing");
            }
        } else if (!xOriginSet) {
            frame.origin.x = (superviewFrame.size.width - frame.size.width - [[allConstraints objectForKey:@(BPLayoutConstraintRightToTrailing)] floatValue]);
            xOriginSet = YES;
        } else if (superviewFrame.size.width > 0) {
            NSLog(@"Breaking BPLayoutConstraintRightToTrailing");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintRightToLeading)]) {
        if (!widthSet && xOriginSet) {
            CGFloat width = ((-[[allConstraints objectForKey:@(BPLayoutConstraintRightToLeading)] floatValue]) - frame.origin.x);
            if (width > 0.0) {
                frame.size.width = width;
                widthSet = YES;
            } else {
                NSLog(@"Breaking BPLayoutConstraintRightToLeading");
            }
        } else if (!xOriginSet) {
            frame.origin.x = (-([[allConstraints objectForKey:@(BPLayoutConstraintRightToLeading)] floatValue] + frame.size.width));
            xOriginSet = YES;
        } else {
            NSLog(@"Breaking BPLayoutConstraintRightToLeading");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintCenterVertical)]) {
        if (!yOriginSet) {
            frame.origin.y = (superviewFrame.size.height / 2) - (frame.size.height / 2) + [[allConstraints objectForKey:@(BPLayoutConstraintCenterVertical)] floatValue];
            yOriginSet = YES;
        } else if (superviewFrame.size.height > 0) {
            NSLog(@"Breaking BPLayoutConstraintCenterVertical");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintCenterHorizontal)]) {
        if (!xOriginSet) {
            frame.origin.x = (superviewFrame.size.width / 2) - (frame.size.width / 2) + [[allConstraints objectForKey:@(BPLayoutConstraintCenterHorizontal)] floatValue];
            xOriginSet = YES;
        } else if (superviewFrame.size.width > 0) {
            NSLog(@"Breaking BPLayoutConstraintCenterHorizontal");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintKeepRatio)]) {
		if (!heightSet || !widthSet) {
			if (heightSet) {
				CGFloat newWidth = (fallbackFrame.size.width * frame.size.height) / fallbackFrame.size.height;
				if (newWidth > 0)
					frame.size.width = newWidth;
			} else {
				CGFloat newHeight = (fallbackFrame.size.height * frame.size.width) / fallbackFrame.size.width;
				if (newHeight > 0)
					frame.size.height = newHeight;
			}
		}
    }
    return frame;
}

- (NSDictionary *)relatedFrameFromConstraints:(NSDictionary *)constraints currentFrame:(CGRect)frame withObjectFrame:(CGRect)objectFrame setValues:(NSDictionary *)setValues {
    NSMutableDictionary *allConstraints;
    if (constraints) {
        allConstraints = [constraints mutableCopy];
    } else {
        allConstraints = [[NSMutableDictionary alloc] init];
    }
    if ([[allConstraints allKeys] count] <= 0)
        return nil;
    BOOL widthSet = [[setValues objectForKey:@(BPAnimatedObjectSetWidth)] boolValue];
    BOOL heightSet = [[setValues objectForKey:@(BPAnimatedObjectSetHeight)] boolValue];
    BOOL xOriginSet = [[setValues objectForKey:@(BPAnimatedObjectSetX)] boolValue];
    BOOL yOriginSet = [[setValues objectForKey:@(BPAnimatedObjectSetY)] boolValue];
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintWidth)]) {
        frame.size.width = objectFrame.size.width + [[allConstraints objectForKey:@(BPLayoutConstraintWidth)] floatValue];;
        widthSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintHeight)]) {
        frame.size.height = objectFrame.size.height + [[allConstraints objectForKey:@(BPLayoutConstraintHeight)] floatValue];;
        heightSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintTopToTopLayout)]) {
        frame.origin.y = objectFrame.origin.y + [[allConstraints objectForKey:@(BPLayoutConstraintTopToTopLayout)] floatValue];
        yOriginSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintTopToBottomLayout)]) {
        if (!yOriginSet) {
            frame.origin.y = objectFrame.origin.y + objectFrame.size.height + [[allConstraints objectForKey:@(BPLayoutConstraintTopToBottomLayout)] floatValue];
            yOriginSet = YES;
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintBottomToBottomLayout)]) {
        if (!heightSet && yOriginSet) {
            CGFloat height = objectFrame.origin.y + objectFrame.size.height - frame.origin.y - [[allConstraints objectForKey:@(BPLayoutConstraintBottomToBottomLayout)] floatValue];
            if (height > 0.0) {
                frame.size.height = height;
                heightSet = YES;
            } else {
                NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
            }
        } else if (!yOriginSet) {
            NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
        } else {
            NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintBottomToTopLayout)]) {
        if (!heightSet && yOriginSet) {
            CGFloat height = objectFrame.origin.y - frame.origin.y - [[allConstraints objectForKey:@(BPLayoutConstraintBottomToTopLayout)] floatValue];
            if (height > 0.0) {
                frame.size.height = height;
                heightSet = YES;
            }
        } else if (!yOriginSet) {
            NSLog(@"Breaking BPLayoutConstraintBottomToTopLayout");
        } else {
            NSLog(@"Breaking BPLayoutConstraintBottomToTopLayout");
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintLeftToLeading)]) {
        frame.origin.x = objectFrame.origin.x + [[allConstraints objectForKey:@(BPLayoutConstraintLeftToLeading)] floatValue];
        xOriginSet = YES;
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintLeftToTrailing)]) {
        if (!xOriginSet) {
            frame.origin.x = objectFrame.origin.x + objectFrame.size.width + [[allConstraints objectForKey:@(BPLayoutConstraintLeftToTrailing)] floatValue];
            xOriginSet = YES;
        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintRightToTrailing)]) {
        NSLog(@"BPAnimatedObject Please use relationships in a left right fasion");
//        if (!widthSet && xOriginSet) {
//            CGFloat width = (superviewFrame.size.width - frame.origin.x - [[allConstraints objectForKey:@(BPLayoutConstraintRightToTrailing)] floatValue]);
//            if (width > 0.0) {
//                frame.size.width = width;
//                widthSet = YES;
//            } else if (superviewFrame.size.width > 0) {
//                NSLog(@"Breaking BPLayoutConstraintRightToTrailing");
//            }
//        } else if (!xOriginSet) {
//            frame.origin.x = (superviewFrame.size.width - frame.size.width - [[allConstraints objectForKey:@(BPLayoutConstraintRightToTrailing)] floatValue]);
//            xOriginSet = YES;
//        } else if (superviewFrame.size.width > 0) {
//            NSLog(@"Breaking BPLayoutConstraintRightToTrailing");
//        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintRightToLeading)]) {
        NSLog(@"BPAnimatedObject Please use relationships in a left right fasion");
//        if (!widthSet && xOriginSet) {
//            CGFloat width = ((-[[allConstraints objectForKey:@(BPLayoutConstraintRightToLeading)] floatValue]) - frame.origin.x);
//            if (width > 0.0) {
//                frame.size.width = width;
//                widthSet = YES;
//            } else {
//                NSLog(@"Breaking BPLayoutConstraintRightToLeading");
//            }
//        } else if (!xOriginSet) {
//            frame.origin.x = (-([[allConstraints objectForKey:@(BPLayoutConstraintRightToLeading)] floatValue] + frame.size.width));
//            xOriginSet = YES;
//        } else {
//            NSLog(@"Breaking BPLayoutConstraintRightToLeading");
//        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintCenterVertical)]) {
        NSLog(@"BPAnimatedObject Not Implemented");
//        if (!yOriginSet) {
//            frame.origin.y = (superviewFrame.size.height / 2) - (frame.size.height / 2) + [[allConstraints objectForKey:@(BPLayoutConstraintCenterVertical)] floatValue];
//            yOriginSet = YES;
//        } else if (superviewFrame.size.height > 0) {
//            NSLog(@"Breaking BPLayoutConstraintCenterVertical");
//        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintCenterHorizontal)]) {
        NSLog(@"BPAnimatedObject Not Implemented");
//        if (!xOriginSet) {
//            frame.origin.x = (superviewFrame.size.width / 2) - (frame.size.width / 2) + [[allConstraints objectForKey:@(BPLayoutConstraintCenterHorizontal)] floatValue];
//            xOriginSet = YES;
//        } else if (superviewFrame.size.width > 0) {
//            NSLog(@"Breaking BPLayoutConstraintCenterHorizontal");
//        }
    }
    if ([[allConstraints allKeys] containsObject:@(BPLayoutConstraintKeepRatio)]) {
        NSLog(@"BPAnimatedObject Not Implemented");
//        if (!heightSet || !widthSet) {
//            if (heightSet) {
//                CGFloat newWidth = (fallbackFrame.size.width * frame.size.height) / fallbackFrame.size.height;
//                if (newWidth > 0)
//                    frame.size.width = newWidth;
//            } else {
//                CGFloat newHeight = (fallbackFrame.size.height * frame.size.width) / fallbackFrame.size.width;
//                if (newHeight > 0)
//                    frame.size.height = newHeight;
//            }
//        }
    }
    return @{@(BPAnimatedObjectSetFrame) : [NSValue valueWithCGRect:frame], @(BPAnimatedObjectSetHeight) : @(heightSet), @(BPAnimatedObjectSetWidth) : @(widthSet), @(BPAnimatedObjectSetX) : @(xOriginSet), @(BPAnimatedObjectSetY) : @(yOriginSet)};
}

@end
