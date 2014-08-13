//
//  BRSFlatMapViewController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSUtilities.h"
#import "BRSFlatMapViewController.h"
#import "BRSAnnotation.h"
#import "BRSMapSearchController.h"
#import <CCHMapClusterController/CCHMapClusterController.h>
#import <CCHMapClusterController/CCHMapClusterControllerDelegate.h>
/////////////tester///////////////
#import "BRSMapCoordinateTester.h"
/////////////////////////////////


@interface BRSFlatMapViewController() <CCHMapClusterControllerDelegate>

@property (nonatomic, strong) CCHMapClusterController *mapClusterController;
@property (nonatomic, strong) BRSMapCoordinateTester *coordTester;
@property (nonatomic, strong) BRSMapSearchController *searchController;
@end


@implementation BRSFlatMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView = [[BRSSCUTMapView alloc] initWithFrame:self.view.frame Campus:SCUTCampusNorth];
    self.mapView.delegate = self;
    self.mapView.gestureDelegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
    
    //self.coordTester = [[BRSMapCoordinateTester alloc] initWithMapView:self.mapView];
    //[self.coordTester addAllPolygonsAndAnnotationsToMap];
    
//    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
//    self.mapClusterController.delegate = self;
//    [self.mapClusterController addAnnotations:[self.coordTester centerAnnotations] withCompletionHandler:NULL];
    
//    self.searchController = [[BRSMapSearchController alloc] init];
//    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(23.15651951321689, 113.34891394936777);
//    [BRSUtilities BRSCoordiinateLog:userLocation];
//    [self.searchController startSearch:@"华南理工" forLocation:userLocation];
    //NSLog(@"%@", self.searchController.resultPlaces);
}

#pragma mark - CCHMapClusterControlerDelegate

- (void)mapClusterController:(CCHMapClusterController *)mapClusterController willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController subtitleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
    return nil;
}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController titleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation
{
    return nil;
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
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
		render.fillColor = [UIColor blueColor];
        //render.strokeColor = [UIColor grayColor];
        //render.lineWidth = 3.0;
        render.alpha = 0.4;
        return render;
	}
	return nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"now zoom level---> %f", [self getZoomLevel]);
}

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


#pragma mark - Map Utlities

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
- (double) getZoomLevel
{
    return 21.00 - log2(self.mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.mapView.bounds.size.width));
}

@end
