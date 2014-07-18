//
//  BRSFlatMapViewController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSFlatMapViewController.h"
#import "BRSAnnotation.h"
#import <CCHMapClusterController/CCHMapClusterController.h>
/////////////tester///////////////
#import "BRSMapCoordinateTester.h"
/////////////////////////////////


@interface BRSFlatMapViewController()

@property (nonatomic, strong) CCHMapClusterController *mapClusterController;
@property (nonatomic, strong) BRSMapCoordinateTester *coordTester;

@end


@implementation BRSFlatMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView = [[BRSSCUTMapView alloc] initWithFrame:self.view.frame Campus:SCUTCampusNorth];
    self.mapView.delegate = self;
    self.mapView.gestureDelegate = self;
    [self.view addSubview:self.mapView];
    self.coordTester = [[BRSMapCoordinateTester alloc] initWithMapView:self.mapView];
    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    [self.mapClusterController addAnnotations:[self.coordTester centerAnnotations] withCompletionHandler:NULL];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
	{
		MKPolygonRenderer* render = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
		render.fillColor = [UIColor grayColor];
        render.strokeColor = [UIColor grayColor];
        render.lineWidth = 3.0;
        render.alpha = 0.4;
        return render;
	}
	return nil;
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
    [BRSUtilities BRSCoordiinateLog:coord];
    
    BRSAnnotation *annotation = [[BRSAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title = @"hello";
    annotation.subtitle = @"map";
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)mapView:(BRSSCUTMapView *)mapView didSingleTapOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"did single tap");
    //[self.mapView removeAnnotations:[self.mapView annotations]];
}

@end
