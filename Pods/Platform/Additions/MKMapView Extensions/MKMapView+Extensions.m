//
//  MKMapView+Extensions.m
//
//  Created by Cory Imdieke on 1/14/11.
//  Copyright 2011 Mobile Vision Software Group. All rights reserved.
//

#import "MKMapView+Extensions.h"


@implementation MKMapView (Extensions)

- (void)zoomToFitMapAnnotations{
    if([self.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in self.annotations){
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    newRegion.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    newRegion.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    newRegion.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
	if([self.annotations count] == 1){
		newRegion.span.latitudeDelta = newRegion.span.latitudeDelta + kMKMapViewZoomToFitSinglePinZoomLevel;
		newRegion.span.longitudeDelta = newRegion.span.longitudeDelta + kMKMapViewZoomToFitSinglePinZoomLevel;
	}
    
    newRegion = [self regionThatFits:newRegion];
    [self setRegion:newRegion animated:YES];
}

@end
