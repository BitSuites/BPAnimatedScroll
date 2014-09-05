//
//  NSObject+Extensions.h
//
//  Created by Cory Imdieke on 7/5/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Convenience methods added to `NSObject`.
@interface NSObject (Extensions)

///---------------------------------------------------------------------------------------
/// @name Performing Blocks on a Background Thread
///---------------------------------------------------------------------------------------

/** Perform a block of code on the Background Thread.
 
 @param block Block of code to execute.
 */
+ (void)performInBackgroundWithBlock:(dispatch_block_t)block;

/** Perform a block of code on a Background Thread and optionally block the current thread until execution completes.
 
 @param wait `YES` to block the current thread, `NO` to perform asynchronously.
 @param block Block of code to execute.
 */
+ (void)performInBackgroundWaitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block;

/** Perform a block of code on a Background Thread after a specified amount of time.
 
 @param delayTime Time in seconds to wait before executing the block.
 @param block Block of code to execute.
 */
+ (void)performInBackgroundAfterDelay:(NSTimeInterval)delayTime withBlock:(dispatch_block_t)block;

///---------------------------------------------------------------------------------------
/// @name Performing Blocks on the Main Thread
///---------------------------------------------------------------------------------------

/** Perform a block of code on the Main Thread.
 
 @param block Block of code to execute.
 */
+ (void)performOnMainThreadWithBlock:(dispatch_block_t)block;

/** Perform a block of code on the Main Thread and optionally block the current thread until execution completes.
 
 @param wait `YES` to block the current thread, `NO` to perform asynchronously.
 @param block Block of code to execute.
 */
+ (void)performOnMainThreadWaitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block;

/** Perform a block of code on the Main Thread after a specified amount of time.
 
 @param delayTime Time in seconds to wait before executing the block.
 @param block Block of code to execute.
 */
+ (void)performOnMainThreadAfterDelay:(NSTimeInterval)delayTime withBlock:(dispatch_block_t)block;

@end
