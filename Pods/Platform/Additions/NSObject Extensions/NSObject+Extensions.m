//
//  NSObject+Extensions.m
//
//  Created by Cory Imdieke on 7/5/11.
//  Copyright 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "NSObject+Extensions.h"
#import <objc/runtime.h>

@interface NSObject (PrivExtensions)
+ (void)performInBackgroundAfterDelay:(NSTimeInterval)delayTime waitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block;
+ (void)performOnMainThreadAfterDelay:(NSTimeInterval)delayTime waitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block;
@end

@implementation NSObject (Extensions)

#pragma mark - Context Switching
#pragma mark Background Thread

+ (void)performInBackgroundWithBlock:(dispatch_block_t)block{
	[self performInBackgroundAfterDelay:0.0 waitUntilDone:NO withBlock:block];
}

+ (void)performInBackgroundWaitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block{
	[self performInBackgroundAfterDelay:0.0 waitUntilDone:wait withBlock:block];
}

+ (void)performInBackgroundAfterDelay:(NSTimeInterval)delayTime withBlock:(dispatch_block_t)block{
	[self performInBackgroundAfterDelay:delayTime waitUntilDone:NO withBlock:block];
}

// Can have a delay or wait until done but not both
+ (void)performInBackgroundAfterDelay:(NSTimeInterval)delayTime waitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block{
	dispatch_queue_t backgroundQueue = dispatch_queue_create(NULL, 0);
	
	if(delayTime > 0.0){
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC);
		dispatch_after(popTime, backgroundQueue, block);
	} else if(wait){
		dispatch_sync(backgroundQueue, block);
	} else {
		dispatch_async(backgroundQueue, block);
	}
}

#pragma mark Main Thread

+ (void)performOnMainThreadWithBlock:(dispatch_block_t)block{
	[self performOnMainThreadAfterDelay:0.0 waitUntilDone:NO withBlock:block];
}

+ (void)performOnMainThreadWaitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block{
	[self performOnMainThreadAfterDelay:0.0 waitUntilDone:wait withBlock:block];
}

+ (void)performOnMainThreadAfterDelay:(NSTimeInterval)delayTime withBlock:(dispatch_block_t)block{
	[self performOnMainThreadAfterDelay:delayTime waitUntilDone:NO withBlock:block];
}

// Can have a delay or wait until done but not both
+ (void)performOnMainThreadAfterDelay:(NSTimeInterval)delayTime waitUntilDone:(BOOL)wait withBlock:(dispatch_block_t)block{
	if(delayTime > 0.0){
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), block);
	} else if(wait){
		dispatch_sync(dispatch_get_main_queue(), block);
	} else {
		dispatch_async(dispatch_get_main_queue(), block);
	}
}

@end
