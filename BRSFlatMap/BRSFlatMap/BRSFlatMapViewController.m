//
//  BRSFlatMapViewController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
#import "MKPolygon+PointInPolygon.h"

#import "BRSPlace.h"
#import "BRSUtilities.h"
#import "BRSFlatMapViewController.h"
#import "BRSAnnotation.h"
#import "BRSMapSearchController.h"
#import <CCHMapClusterController/CCHMapClusterController.h>
#import <CCHMapClusterController/CCHMapClusterControllerDelegate.h>

/////////////tester///////////////
#import "BRSMapCoordinateTester.h"
/////////////////////////////////

#define MAP_TOOL_BAR_HEIGHT 44.0


@interface BRSFlatMapViewController() <CCHMapClusterControllerDelegate, BRSMapSearchDelegate>

@property (nonatomic, strong) CCHMapClusterController *mapClusterController;
@property (nonatomic, strong) BRSMapCoordinateTester *coordTester;
@property (nonatomic, strong) BRSMapSearchController *searchController;

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) UISearchDisplayController *searchDisplayContrl;
@property (nonatomic, strong) UISearchBar *searchBar;

@end


@implementation BRSFlatMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    
    
    /* add the mapView */
    self.mapView = [[BRSSCUTMapView alloc] initWithFrame:self.view.frame Campus:SCUTCampusNorth];
    self.mapView.delegate = self;
    self.mapView.gestureDelegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
    
    /* add the tool bar */
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0,
                                                               screenHeight - MAP_TOOL_BAR_HEIGHT,
                                                               screenWidth,
                                                               MAP_TOOL_BAR_HEIGHT)];
    [self.view addSubview:self.toolBar];
    
    /* search display controller */
    self.searchBar = [[UISearchBar alloc] init];
    self.searchDisplayContrl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayContrl.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayContrl.delegate = self;
    self.searchDisplayContrl.searchResultsDataSource = self;
    self.searchDisplayContrl.searchResultsDelegate = self;
    
    
    
//    self.coordTester = [[BRSMapCoordinateTester alloc] initWithMapView:self.mapView];
//    [self.coordTester addAllPolygonsAndAnnotationsToMap];
    
//    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
//    self.mapClusterController.delegate = self;
//    [self.mapClusterController addAnnotations:[self.coordTester centerAnnotations] withCompletionHandler:NULL];
    
//    self.searchController = [[BRSMapSearchController alloc] init];
//    self.searchController.delegate = self;
//    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(23.15651951321689, 113.34891394936777);
//    [BRSUtilities BRSCoordiinateLog:userLocation];
//    [self.searchController startSearch:@"猪脚饭" forLocation:userLocation];
}

- (void)viewWillLayoutSubviews
{
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    
    self.mapView.frame = self.view.frame;
    self.toolBar.frame =CGRectMake(0.0, screenHeight - MAP_TOOL_BAR_HEIGHT, screenWidth, MAP_TOOL_BAR_HEIGHT);
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
    //NSLog(@"now zoom level---> %f", [self getZoomLevel]);
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
    
    BRSPlace *place = [self placeForCoordinate:coord];
    if (place) {
        annotation.title = place.title;
        annotation.subtitle = place.subtitle;
    } else {
        annotation.title = @"hello";
        annotation.subtitle = @"map";
    }
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)mapView:(BRSSCUTMapView *)mapView didSingleTapOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"did single tap");
    //[self.mapView removeAnnotations:[self.mapView annotations]];
}

#pragma mark - BRSMapSearchDelegate

-(void)MapSearchController:(BRSMapSearchController *)mapSearchController DidGetSearchResponse:(MKLocalSearchResponse *)response
{
    NSLog(@"%@", [response mapItems]);
}


#pragma mark - Map Utlities

- (BRSPlace *)placeForCoordinate:(CLLocationCoordinate2D)coord
{
    BRSMapMetaDataManager *manager = [BRSMapMetaDataManager sharedDataManager];
    
    BRSPlace *resultPlace = nil;
    for (BRSPlace *place in manager.flatMapMetaData) {
        if ([place.boundaryPolygon coordInPolygon:coord]) {
            resultPlace = place;
            break;
        }
    }
    
    if (!resultPlace) {
        CLLocationCoordinate2D firstCenterCoordinate = ((BRSPlace *)manager.flatMapMetaData[0]).centerCoordinate;
        CLLocationDistance distance = [BRSUtilities distanceFromCoord1:firstCenterCoordinate toCoord2:coord];
        NSUInteger placeIndex = 0;
        for (NSUInteger i = 0; i < manager.flatMapMetaData.count; i++) {
            BRSPlace *place = manager.flatMapMetaData[i];
            CLLocationDistance currentDistance = [BRSUtilities distanceFromCoord1:place.centerCoordinate toCoord2:coord];
            if (currentDistance < distance) {
                distance = currentDistance;
                placeIndex = i;
            }
        }
        resultPlace = manager.flatMapMetaData[placeIndex];
    }
    
    return resultPlace;
}

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
- (double) getZoomLevel
{
    return 21.00 - log2(self.mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.mapView.bounds.size.width));
}

@end
