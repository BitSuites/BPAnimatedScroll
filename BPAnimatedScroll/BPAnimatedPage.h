//
//  BPAnimatedPage.h
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAnimatedObject.h"

@interface BPAnimatedPage : NSObject

@property (nonatomic, readonly) NSMutableArray *objects;

- (void)setObjects:(NSMutableArray *)objects;
- (void)addObject:(BPAnimatedObject *)object;
- (void)addObject:(BPAnimatedObject *)object atIndex:(NSUInteger)index;
- (void)removeObject:(BPAnimatedObject *)object;
- (void)removeObjectAtIndex:(NSUInteger)index;

// Local Use Only Need to make Private
- (void)removeFromSuperview;
- (void)addToSuperview:(UIView *)superview;
- (void)animateToPercent:(CGFloat)percent leftSide:(BOOL)leftSide;


@end
