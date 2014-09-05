//
//  BPAnimatedObject.m
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import "BPAnimatedObject.h"

@interface BPAnimatedObject (){
    BOOL startSet;
    BOOL centerSet;
    BOOL endSet;
}

@end

@implementation BPAnimatedObject
@synthesize startPosition, centerPosition, endPosition, startConstraints, centerConstraints, endConstraints, startAlpha, centerAlpha, endAlpha, animatedObject, landscapeCenterAlpha, landscapeCenterConstraints, landscapeCenterPosition, landscapeEndAlpha, landscapeEndConstraints, landscapeEndPosition, landscapeStartAlpha, landscapeStartConstraints, landscapeStartPosition, zOrder, differentLandscapeConstraints;

- (instancetype)init{
    self = [super init];
    if (self) {
        zOrder = 10;
        differentLandscapeConstraints = NO;
    }
    return self;
}

#pragma mark - Setters

- (void)setAnimatedObject:(UIView *)newObject{
    if (!startSet){
        startPosition = newObject.frame;
        landscapeStartPosition = newObject.frame;
    }
    if (!centerSet){
        centerPosition = newObject.frame;
        landscapeCenterPosition = newObject.frame;
    }
    if (!endSet){
        endPosition = newObject.frame;
        landscapeEndPosition = newObject.frame;
    }
    animatedObject = newObject;
}

- (void)setStartPosition:(CGRect)position{
    startPosition = position;
    startSet = YES;
}

- (void)setCenterPosition:(CGRect)position{
    centerPosition = position;
    centerSet = YES;
}

- (void)setEndPosition:(CGRect)position{
    endPosition = position;
    endSet = YES;
}

#pragma mark - Custom

- (void)addToSuperview:(UIView *)superview{
    if (animatedObject && animatedObject.superview != superview){
        [animatedObject setFrame:[self startFrame]];
        [animatedObject setAlpha:([self isLandscape] ? landscapeStartAlpha : landscapeEndAlpha)];
        [animatedObject setHidden:YES];
        [superview addSubview:animatedObject];
        [animatedObject.layer setZPosition:zOrder];
    }
}

- (void)removeFromSuperview{
    if (animatedObject){
        [animatedObject removeFromSuperview];
    }
}

- (void)animateToPercent:(CGFloat)percent leftSide:(BOOL)leftSide{
    if (!animatedObject)
        return;
    if (percent <= 0){
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

- (BOOL)isLandscape{
    UIViewController *foundController = [animatedObject firstAvailableUIViewController];
    if (differentLandscapeConstraints && foundController && UIInterfaceOrientationIsLandscape([foundController interfaceOrientation])){
        return YES;
    } else {
        return NO;
    }
}

- (CGRect)startFrame{
    if ([self isLandscape]){
        return [self frameFromConstraints:landscapeStartConstraints withFallbackFrame:landscapeStartPosition];
    } else {
        return [self frameFromConstraints:startConstraints withFallbackFrame:startPosition];
    }
}

- (CGRect)centerFrame{
    if ([self isLandscape]){
        return [self frameFromConstraints:landscapeCenterConstraints withFallbackFrame:landscapeCenterPosition];
    } else {
        return [self frameFromConstraints:centerConstraints withFallbackFrame:centerPosition];
    }
}

- (CGRect)endFrame{
    if ([self isLandscape]){
        return [self frameFromConstraints:landscapeEndConstraints withFallbackFrame:landscapeEndPosition];
    } else {
        return [self frameFromConstraints:endConstraints withFallbackFrame:endPosition];
    }
}

- (CGRect)frameFromConstraints:(NSDictionary *)constraints withFallbackFrame:(CGRect)frame{
	CGRect fallbackFrame = frame;
    if (!constraints)
        return frame;
    CGRect superviewFrame = CGRectMake(0, 0, 0, 0);
    if (animatedObject.superview){
        superviewFrame = animatedObject.superview.frame;
    }
    BOOL widthSet = NO;
    BOOL heightSet = NO;
    BOOL xOriginSet = NO;
    BOOL yOriginSet = NO;
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintWidth)]){
        float widthValue = [[constraints objectForKey:@(BPLayoutConstraintWidth)] floatValue];
        if (widthValue < 0){
            frame.size.width = (superviewFrame.size.width + widthValue);
        } else {
            frame.size.width = widthValue;
        }
        widthSet = YES;
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintHeight)]){
        float heightValue = [[constraints objectForKey:@(BPLayoutConstraintHeight)] floatValue];
        if (heightValue < 0){
            frame.size.height = (superviewFrame.size.width + heightValue);
        } else{
            frame.size.height = heightValue;
        }
        heightSet = YES;
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintTopToTopLayout)]){
        frame.origin.y = [[constraints objectForKey:@(BPLayoutConstraintTopToTopLayout)] floatValue];
        yOriginSet = YES;
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintTopToBottomLayout)]){
        if (!yOriginSet){
            frame.origin.y = (superviewFrame.size.height + [[constraints objectForKey:@(BPLayoutConstraintTopToBottomLayout)] floatValue]);
            yOriginSet = YES;
        } else if (superviewFrame.size.height > 0){
            NSLog(@"Breaking BPLayoutConstraintTopToBottomLayout");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintBottomToBottomLayout)]){
        if (!heightSet && yOriginSet){
            CGFloat height = (superviewFrame.size.height - frame.origin.y - [[constraints objectForKey:@(BPLayoutConstraintBottomToBottomLayout)] floatValue]);
            if (height > 0.0){
                frame.size.height = height;
                heightSet = YES;
            } else if (superviewFrame.size.height > 0){
                NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
            }
        } else if (!yOriginSet){
            frame.origin.y = (superviewFrame.size.height - frame.size.height - [[constraints objectForKey:@(BPLayoutConstraintBottomToBottomLayout)] floatValue]);
            yOriginSet = YES;
        } else if (superviewFrame.size.height > 0){
            NSLog(@"Breaking BPLayoutConstraintBottomToBottomLayout");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintBottomToTopLayout)]){
        if (!heightSet && yOriginSet){
            CGFloat height = ((-[[constraints objectForKey:@(BPLayoutConstraintBottomToTopLayout)] floatValue]) - frame.origin.y);
            if (height > 0.0){
                frame.size.height = height;
                heightSet = YES;
            } else {
                NSLog(@"Breaking BPLayoutConstraintBottomToTopLayout");
            }
        } else if (!yOriginSet){
            frame.origin.y = (-([[constraints objectForKey:@(BPLayoutConstraintBottomToTopLayout)] floatValue] + frame.size.height));
            yOriginSet = YES;
        } else {
            NSLog(@"Breaking BPLayoutConstraintBottomToTopLayout");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintLeftToLeading)]){
        frame.origin.x = [[constraints objectForKey:@(BPLayoutConstraintLeftToLeading)] floatValue];
        xOriginSet = YES;
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintLeftToTrailing)]){
        if (!xOriginSet){
            frame.origin.x = (superviewFrame.size.width + [[constraints objectForKey:@(BPLayoutConstraintLeftToTrailing)] floatValue]);
            xOriginSet = YES;
        } else if (superviewFrame.size.width > 0){
            NSLog(@"Breaking BPLayoutConstraintLeftToTrailing");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintRightToTrailing)]){
        if (!widthSet && xOriginSet){
            CGFloat width = (superviewFrame.size.width - frame.origin.x - [[constraints objectForKey:@(BPLayoutConstraintRightToTrailing)] floatValue]);
            if (width > 0.0){
                frame.size.width = width;
                widthSet = YES;
            } else if (superviewFrame.size.width > 0){
                NSLog(@"Breaking BPLayoutConstraintRightToTrailing");
            }
        } else if (!xOriginSet){
            frame.origin.x = (superviewFrame.size.width - frame.size.width - [[constraints objectForKey:@(BPLayoutConstraintRightToTrailing)] floatValue]);
            xOriginSet = YES;
        } else if (superviewFrame.size.width > 0){
            NSLog(@"Breaking BPLayoutConstraintRightToTrailing");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintRightToLeading)]){
        if (!widthSet && xOriginSet){
            CGFloat width = ((-[[constraints objectForKey:@(BPLayoutConstraintRightToLeading)] floatValue]) - frame.origin.x);
            if (width > 0.0){
                frame.size.width = width;
                widthSet = YES;
            } else {
                NSLog(@"Breaking BPLayoutConstraintRightToLeading");
            }
        } else if (!xOriginSet){
            frame.origin.x = (-([[constraints objectForKey:@(BPLayoutConstraintRightToLeading)] floatValue] + frame.size.width));
            xOriginSet = YES;
        } else {
            NSLog(@"Breaking BPLayoutConstraintRightToLeading");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintCenterVertical)]){
        if (!yOriginSet){
            frame.origin.y = (superviewFrame.size.height / 2) - (frame.size.height / 2) + [[constraints objectForKey:@(BPLayoutConstraintCenterVertical)] floatValue];
            yOriginSet = YES;
        } else if (superviewFrame.size.height > 0){
            NSLog(@"Breaking BPLayoutConstraintCenterVertical");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintCenterHorizontal)]){
        if (!xOriginSet){
            frame.origin.x = (superviewFrame.size.width / 2) - (frame.size.width / 2) + [[constraints objectForKey:@(BPLayoutConstraintCenterHorizontal)] floatValue];
            xOriginSet = YES;
        } else if (superviewFrame.size.width > 0){
            NSLog(@"Breaking BPLayoutConstraintCenterHorizontal");
        }
    }
    if ([[constraints allKeys] containsObject:@(BPLayoutConstraintKeepRatio)]){
		if (!heightSet || !widthSet){
			if (heightSet){
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

@end
