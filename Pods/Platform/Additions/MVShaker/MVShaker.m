//
//  MVShaker.m
//
//  Created by Cory Imdieke on 4/21/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import "MVShaker.h"
#import "Platform.h"
#import <CoreMotion/CoreMotion.h>

static BOOL L0AccelerationIsShaking(CMAcceleration last, CMAcceleration current, double threshold) {
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

@interface MVShaker () {
	CMMotionManager *motionManager;
	BOOL histeresisExcited;
	CMAccelerometerData *lastAccelerationData;
}

@end

@implementation MVShaker

#pragma mark Singleton

static MVShaker *sharedInstance;

- (id)init{
    self = [super init];
    if(self){
        _accelerationThreshold = 2.0;
    }
    return self;
}

+ (id)sharedShaker{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [self new];
	});
	
	return sharedInstance;
}

#pragma mark - Shaker Methods

- (void)beginWatchingForShakes{
    motionManager = [[CMMotionManager alloc] init];
	motionManager.deviceMotionUpdateInterval = 1;
	[motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
		CMAcceleration acceleration = accelerometerData.acceleration;
		if (fabs(acceleration.x) > _accelerationThreshold
			|| fabs(acceleration.y) > _accelerationThreshold
			|| fabs(acceleration.z) > _accelerationThreshold)
        {
			if (lastAccelerationData) {
				if (!histeresisExcited && L0AccelerationIsShaking(lastAccelerationData.acceleration, acceleration, 0.7)) {
					histeresisExcited = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMVDeviceShakeDetected object:nil];
				} else if (histeresisExcited && !L0AccelerationIsShaking(lastAccelerationData.acceleration, acceleration, 0.2)) {
					histeresisExcited = NO;
				}
			}
			
			lastAccelerationData = accelerometerData;
        }
	}];
}

- (void)stopWatchingForShakes{
	[motionManager stopAccelerometerUpdates];
	motionManager = nil;
}

@end
