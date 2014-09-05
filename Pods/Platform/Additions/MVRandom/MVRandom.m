//
//  MVRandom.m
//
//  Created by Cory Imdieke on 7/14/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "MVRandom.h"


@implementation MVRandom

+ (CGFloat)randomFloatBetween:(CGFloat)firstFloat andFloat:(CGFloat)secondFloat{
	double random = (double)arc4random() / 0x100000000;
    CGFloat diff = secondFloat - firstFloat;
    CGFloat r = random * diff;
    return firstFloat + r;
}

+ (NSInteger)randomIntegerBetween:(NSInteger)firstInt andInteger:(NSInteger)secondInt{
	return (NSInteger)firstInt + arc4random() % (secondInt - firstInt + 1);
}

+ (BOOL)randomBoolean{
	return [self randomIntegerBetween:0 andInteger:1] == 0;
}

#pragma mark Seeded randoms

+ (CGFloat)randomFloatBetween:(CGFloat)firstFloat andFloat:(CGFloat)secondFloat withSeed:(unsigned)seed{
	srand(seed);
	double random = (double)rand() / 0x100000000;
    CGFloat diff = secondFloat - firstFloat;
    CGFloat r = random * diff;
    return firstFloat + r;
}

+ (NSInteger)randomIntegerBetween:(NSInteger)firstInt andInteger:(NSInteger)secondInt withSeed:(unsigned)seed{
	srand(seed);
	return (NSInteger)firstInt + rand() % (secondInt - firstInt + 1);
}

+ (BOOL)randomBooleanWithSeed:(unsigned)seed{
	return [self randomIntegerBetween:0 andInteger:1 withSeed:seed] == 0;
}

@end
