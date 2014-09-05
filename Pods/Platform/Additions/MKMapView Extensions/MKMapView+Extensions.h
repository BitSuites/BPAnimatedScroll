//
//  MKMapView+Extensions.h
//
//  Created by Cory Imdieke on 1/14/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kMKMapViewZoomToFitSinglePinZoomLevel 0.05

/// Provides extensions to `NSFileManager` for convenience.
@interface MKMapView (Extensions)

///---------------------------------------------------------------------------------------
/// @name Convenience Additions
///---------------------------------------------------------------------------------------

/// Zooms the map to exactly fit the current annotations.
- (void)zoomToFitMapAnnotations;

@end
