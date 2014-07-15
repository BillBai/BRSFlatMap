//
//  BRSFlatMapViewController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSFlatMapViewController.h"

@implementation BRSFlatMapViewController

- (void)viewDidLoad
{
    self.mapView = [[BRSSCUTMapView alloc] initWithFrame:self.view.frame Campus:SCUTCampusNorth];
    self.mapView.delegate = self;
    self.mapView.gestureDelegate = self;
    [self.view addSubview:self.mapView];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{}

#pragma mark - BRSMapViewDelegate

- (void)mapView:(BRSSCUTMapView *)mapView didLongpressOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"longpress");
}

- (void)mapView:(BRSSCUTMapView *)mapView didTapOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"tap");
}

@end
