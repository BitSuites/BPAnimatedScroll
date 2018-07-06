//
//  BPAnimatedPage.m
//  AnitmatedIntro
//
//  Created by Justin Carstens on 5/5/14.
//  Copyright (c) 2014 Bitsuites. All rights reserved.
//

#import "BPAnimatedPage.h"
#import "BPAnimatedObject.h"

@interface BPAnimatedPage ()

@end

@implementation BPAnimatedPage
@synthesize objects;

- (void)setObjects:(NSMutableArray *)newObjects {
    objects = newObjects;
}

- (void)addObject:(BPAnimatedObject *)object {
    if (!objects)
        objects = [[NSMutableArray alloc] init];
    [objects addObject:object];
}

- (void)addObject:(BPAnimatedObject *)object atIndex:(NSUInteger)index {
    if (!objects)
        objects = [[NSMutableArray alloc] init];
    [objects insertObject:object atIndex:index];
}

- (void)removeObject:(BPAnimatedObject *)object {
    if (!objects)
        return;
    [objects removeObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    if (!objects)
        return;
    [objects removeObjectAtIndex:index];
}

- (void)removeFromSuperview {
    for (BPAnimatedObject *nextObject in objects) {
        [nextObject removeFromSuperview];
    }
}

- (void)addToSuperview:(UIView *)superview {
    for (BPAnimatedObject *nextObject in objects) {
        [nextObject addToSuperview:superview];
    }
}

- (void)animateToPercent:(CGFloat)percent leftSide:(BOOL)leftSide {
    for (BPAnimatedObject *nextObject in objects) {
        [nextObject animateToPercent:percent leftSide:leftSide];
    }
}

@end
