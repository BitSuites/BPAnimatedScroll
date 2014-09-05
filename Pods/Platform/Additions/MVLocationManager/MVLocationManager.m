//
//  MVLocationManager.m
//
//  Created by Cory Imdieke on 12/21/11.
//  Copyright (c) 2011 Mobile Vision Software Group, LLC. All rights reserved.
//

#import "MVLocationManager.h"
#import "UIAlertView+Blocks.h"
#import "UIDevice+Extensions.h"

#if __has_feature(objc_arc) != 1
#error This code requires ARC
#endif

@interface MVLocationManager (){
    CLLocationManager *locationManager;
    
    LocationManagerHandlerBlock returnHandler;
}

@end

@implementation MVLocationManager

@synthesize timeoutValue, showDeniedMessage;

#pragma mark Singleton

static MVLocationManager *sharedInstance;

- (id)init{
    self = [super init];
    if(self){
		self.timeoutValue = 120.0;
		self.showDeniedMessage = YES;
        locationManager = [[CLLocationManager alloc] init];
		[locationManager setDelegate:self];
    }
    return self;
}

+ (id)sharedManager{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [self new];
	});
	
	return sharedInstance;
}

#pragma mark Setup

- (void)setDesiredAccuracy:(CLLocationAccuracy)accuracy{
	[locationManager setDesiredAccuracy:accuracy];
}

- (CLLocationAccuracy)desiredAccuracy{
	return [locationManager desiredAccuracy];
}

#pragma mark Location

- (void)getUsersCurrentLocationWithHandler:(void(^)(BOOL success, BOOL denied, CLLocation *location))handler{
	if([locationManager location]){
		if(fabs([[[locationManager location] timestamp] timeIntervalSinceDate:[NSDate date]]) < self.timeoutValue){
			// Manager's cached value is appropriate to return
			returnHandler = nil;
			if(handler)
				handler(YES, NO, [locationManager location]);
			return;
		}
	}
	
	// Update user's location
	returnHandler = handler;
	[locationManager startUpdatingLocation];
}

#pragma mark Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	// Make sure the location is within the timeout value, or ignore and wait for a more recent location
	if(fabs([[newLocation timestamp] timeIntervalSinceDate:[NSDate date]]) < self.timeoutValue){
		if(returnHandler){
			returnHandler(YES, NO, newLocation);
			returnHandler = nil;
		}
		[manager stopUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	if ([error code] == kCLErrorDenied) {
		if (showDeniedMessage) {
			NSString *device = @"Device";
            if ([[UIDevice currentDevice] deviceFamily] == UIDeviceFamilyAppleTV){
                device = @"Apple TV";
            } else if ([[UIDevice currentDevice] deviceFamily] == UIDeviceFamilyiPad){
                device = @"iPad";
            } else if ([[UIDevice currentDevice] deviceFamily] == UIDeviceFamilyiPhone){
                device = @"iPhone";
            } else if ([[UIDevice currentDevice] deviceFamily] == UIDeviceFamilyiPod){
                device = @"iPod";
            }
            [[[UIAlertView alloc] initWithTitle:@"Access Denied" message:[NSString stringWithFormat:@"To use your current location, go to %@ Settings > Privacy > Location Services and set %@ to on.", device, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] cancelButtonItem:[RIButtonItem itemWithLabel:@"OK"] otherButtonItems:nil] show];
        }
		if(returnHandler){
			returnHandler(NO, YES, nil);
			returnHandler = nil;
		}
	} else {
		if(returnHandler){
			returnHandler(NO, NO, nil);
			returnHandler = nil;
		}
		NSLog(@"Location Services Failed: %@", [error localizedDescription]);
	}
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
	if(status != kCLAuthorizationStatusAuthorized && status != kCLAuthorizationStatusNotDetermined){
		if(returnHandler){
			returnHandler(NO, NO, nil);
			returnHandler = nil;
		}
	}
}

@end
