//
//  MVRandom.h
//
//  Created by Cory Imdieke on 7/14/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Convenience methods to get random numbers.
@interface MVRandom : NSObject

/** Generates a random float between two values.
 
 @param firstFloat The lowest value that can be returned randomly.
 @param secondFloat The highest value that can be returned randomly.
 @return Returns a `CGFloat` of a random number between `firstFloat` and `secondFloat`.
 */
+ (CGFloat)randomFloatBetween:(CGFloat)firstFloat andFloat:(CGFloat)secondFloat;

/** Generates a random integer between two values.
 
 @param firstInt The lowest value that can be returned randomly.
 @param secondInt The highest value that can be returned randomly.
 @return Returns an `NSInteger` of a random number between `firstInt` and `secondInt`.
 */
+ (NSInteger)randomIntegerBetween:(NSInteger)firstInt andInteger:(NSInteger)secondInt;

/** Generates a random boolean value.
 
 @return Randomly returns `YES` or `NO`.
 */
+ (BOOL)randomBoolean;

// Seeded random numbers

+ (CGFloat)randomFloatBetween:(CGFloat)firstFloat andFloat:(CGFloat)secondFloat withSeed:(unsigned)seed;

+ (NSInteger)randomIntegerBetween:(NSInteger)firstInt andInteger:(NSInteger)secondInt withSeed:(unsigned)seed;

+ (BOOL)randomBooleanWithSeed:(unsigned)seed;

@end
