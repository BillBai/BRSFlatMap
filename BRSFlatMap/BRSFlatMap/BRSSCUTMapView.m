//
//  BRSSCUTMapView.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
#import "BRSSCUTMapView.h"

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
     this is just a hack.
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
    } else {
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

@end
