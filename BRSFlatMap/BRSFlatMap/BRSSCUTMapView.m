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
    //longPressGestureRecognizer.minimumPressDuration = 0.7; //user needs to press for 2 seconds
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer *tapGuestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGuestureRecognizer];
}

- (void)handleLongPress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
    }
    else
    {
        CGPoint touchPoint = [sender locationInView:self];
        CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
        if ([self.gestureDelegate conformsToProtocol:@protocol(BRSMapViewDelegate)]) {
            [self.gestureDelegate mapView:self didLongpressOnPoint:touchMapCoordinate];
        }
    }
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchPoint = [sender locationInView:self];
        CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
        if ([self.gestureDelegate conformsToProtocol:@protocol(BRSMapViewDelegate)]) {
            [self.gestureDelegate mapView:self didTapOnPoint:touchMapCoordinate];
        }
    }
}

@end
