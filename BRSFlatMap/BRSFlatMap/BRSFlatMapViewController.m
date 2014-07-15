//
//  BRSFlatMapViewController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSFlatMapViewController.h"
#import "BRSAnnotation.h"

@implementation BRSFlatMapViewController

- (void)viewDidLoad
{
    self.mapView = [[BRSSCUTMapView alloc] initWithFrame:self.view.frame Campus:SCUTCampusNorth];
    self.mapView.delegate = self;
    self.mapView.gestureDelegate = self;
    [self.view addSubview:self.mapView];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *annotationView = nil;
	if ([annotation isKindOfClass:[BRSAnnotation class]])
	{
		annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
		if (annotationView == nil)
		{
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
			annotationView.canShowCallout = YES;
			annotationView.animatesDrop = YES;
		}
	}
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{}

#pragma mark - BRSMapViewDelegate

- (void)mapView:(BRSSCUTMapView *)mapView didLongPressOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"did long press");
}

- (void)mapView:(BRSSCUTMapView *)mapView LongPressingOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"long pressing");
    
    BRSAnnotation *annotation = [[BRSAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title = @"hello";
    annotation.subtitle = @"map";
    [self.mapView addAnnotation:annotation];
    
}

- (void)mapView:(BRSSCUTMapView *)mapView didSingleTapOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"did single tap");
}

@end
