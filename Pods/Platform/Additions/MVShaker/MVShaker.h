//
//  MVShaker.h
//
//  Created by Cory Imdieke on 4/21/10.
//  Copyright 2010 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMVDeviceShakeDetected @"MVShakeDetected"

@interface MVShaker : NSObject

/** Acceleration Threashold is the threashold to wich a shake is detected
 
 Default value if none supplied iPad 2.0 iPhone 5.0
 */
@property (nonatomic) float accelerationThreshold;

+ (id)sharedShaker;

/** Begin watching for shakes to occur getting notification when they do
 */
- (void)beginWatchingForShakes;

/** Stop watching for shakes on device 
 */
- (void)stopWatchingForShakes;

@end
