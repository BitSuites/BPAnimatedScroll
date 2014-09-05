//
//  MVLocationManager.h
//
//  Created by Cory Imdieke on 12/21/11.
//  Copyright (c) 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationManagerHandlerBlock)(BOOL success, BOOL denied, CLLocation *location);

/// Easy to use interface for `CLLocationManager` with a block-based API
@interface MVLocationManager : NSObject <CLLocationManagerDelegate>

/** Time in seconds to wait before hitting up the hardware instead of using cached values.
 
 Default is 120 seconds (2 minutes)
 */
@property (nonatomic, assign) NSTimeInterval timeoutValue;

/** Desired accuracy for location results.
 */
@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/** If access is denied show message on how to resolve
 */
@property (nonatomic, assign) BOOL showDeniedMessage;

/** Singleton instance
 */
+ (id)sharedManager;

///---------------------------------------------------------------------------------------
/// @name Location
///---------------------------------------------------------------------------------------

/** Spins off an asynchronous request for the user's location.
 
 @param handler Completion handler block to run upon completion
 */
- (void)getUsersCurrentLocationWithHandler:(LocationManagerHandlerBlock)handler;

@end
