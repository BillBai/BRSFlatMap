//
//  BRSSCUTMapView.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
#import "BRSSCUTMapView.h"

@interface BRSSCUTMapView()
@property (nonatomic) BOOL longPressing;

@end


@implementation BRSSCUTMapView

+ (MKCoordinateRegion)northCampusRegion
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(23.155631, 113.347406);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01062, 0.0103);
    return MKCoordinateRegionMake(center, span);
}

// TODO : this region is not properly setted
+ (MKCoordinateRegion)HEMCCampusRegion
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(23.155631, 113.347406);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01062, 0.0103);
    return MKCoordinateRegionMake(center, span);
}

- (id)initWithFrame:(CGRect)frame Campus:(SCUTCampus)campus
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self switchToCampus:campus];
    [self addGestureRecognizers];
    self.longPressing = NO;
    
    return self;
}

- (void)switchToCampus:(SCUTCampus)campus
{
    switch (campus) {
        case SCUTCampusHEMC:
            [self setRegion:[BRSSCUTMapView HEMCCampusRegion] animated:NO];
            break;
        case SCUTCampusNorth:
            [self setRegion:[BRSSCUTMapView northCampusRegion] animated:NO];
            break;
        default:
            break;
    }
}

- (void)addGestureRecognizers
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    /*
     add this double tap gesture to prevent the double-tap-map-zoom gesture to be recognized as single tap.
     this is a ugly hack.
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                      initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTapGuestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGuestureRecognizer.numberOfTapsRequired = 1;
    [singleTapGuestureRecognizer requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTapGuestureRecognizer];
}

- (void)handleLongPress:(UIGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self];
    CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.gestureDelegate respondsToSelector:@selector(mapView:didLongPressOnPoint:)]) {
            [self.gestureDelegate mapView:self didLongPressOnPoint:touchMapCoordinate];
        }
        self.longPressing = NO;
    } else {
        if (self.longPressing) {
            return;
        }
        self.longPressing = YES;
        
        if ([self.gestureDelegate respondsToSelector:@selector(mapView:LongPressingOnPoint:)]) {
            [self.gestureDelegate mapView:self LongPressingOnPoint:touchMapCoordinate];
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint touchPoint = [sender locationInView:self];
        CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
        if ([self.gestureDelegate respondsToSelector:@selector(mapView:didSingleTapOnPoint:)]) {
            [self.gestureDelegate mapView:self didSingleTapOnPoint:touchMapCoordinate];
        }
    }
}

// Do nothing while double tap, let the mapview to handle double tap zooming.
- (void)handleDoubleTap:(UITapGestureRecognizer *)sender
{
}

#pragma mark -
#pragma mark Map conversion methods

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(double)zoomLevel
{
    NSLog(@"in custom zoomlevel-->%f",zoomLevel);
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    double zoomExponent = 20.0 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}


@end
