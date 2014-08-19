//
//  BRSFlatMapViewController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
#import "MKPolygon+PointInPolygon.h"
#import "NSArray+BRSMostNearestElements.h"

#import "BRSPlace.h"
#import "BRSUtilities.h"
#import "BRSFlatMapViewController.h"
#import "BRSAnnotation.h"
#import "BRSMapSearchHelper.h"
#import <CCHMapClusterController/CCHMapClusterController.h>
#import <CCHMapClusterController/CCHMapClusterControllerDelegate.h>

/////////////tester///////////////
#import "BRSMapCoordinateTester.h"
/////////////////////////////////

#define MAP_TOOL_BAR_HEIGHT 44.0


@interface BRSFlatMapViewController() <CCHMapClusterControllerDelegate, BRSMapSearchHelperDelegate>

/* Annotation Cluster*/
@property (nonatomic, strong) CCHMapClusterController *mapClusterController;
@property (nonatomic, strong) BRSMapCoordinateTester *coordTester;

/* Tool Bar*/
@property (nonatomic, strong) UIToolbar *toolBar;

/* search and display */
@property (nonatomic, strong) UISearchDisplayController *searchDisplayContrl;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) BRSMapSearchHelper *searchHelper;

/* Map Property */
@property (nonatomic, strong) BRSAnnotation *currentPinAnnotation;

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
    
    self.searchHelper = [[BRSMapSearchHelper alloc] init];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    
    self.searchDisplayContrl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayContrl.delegate = self;
    self.searchDisplayContrl.searchResultsDataSource = self;
    self.searchDisplayContrl.searchResultsDelegate = self;
    self.searchDisplayContrl.displaysSearchBarInNavigationBar = YES;
    
    
    
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
    if (place) {    // found a place
        annotation.title = place.title;
        annotation.subtitle = place.subtitle;
        self.currentPinAnnotation = annotation;
        [self showCurrentPinAnnotation];
    } else {        // if no corresponding place was found, search the surrounding places
        NSArray *resultPlaces = [self surrondingPlacesForCoordinate:coord Count:3];
        for (BRSPlace *place in resultPlaces) {
            BRSAnnotation *annotation = [self AnnotationForPlace:place];
            [self.mapView addAnnotation:annotation];
            [self.mapView selectAnnotation:annotation animated:NO];
        }
    }
}

- (void)mapView:(BRSSCUTMapView *)mapView didSingleTapOnPoint:(CLLocationCoordinate2D)coord
{
    NSLog(@"did single tap");
    [self clearNormalAnnotations];
    //[self.mapView removeAnnotations:[self.mapView annotations]];
}



#pragma mark - BRSMapSearchDelegate

-(void)MapSearchController:(BRSMapSearchHelper *)mapSearchController DidGetSearchResponse:(MKLocalSearchResponse *)response
{
    NSLog(@"%@", [response mapItems]);
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearNormalAnnotations];
    BRSPlace *place = (BRSPlace *)self.searchHelper.resultPlaces[indexPath.row];
    [self.mapView addAnnotation:[self AnnotationForPlace:place]];
    [self.searchDisplayContrl setActive:NO];
}



#pragma mark - UITAbleViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchHelper.resultPlaces count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BRSSearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = ((BRSPlace *)self.searchHelper.resultPlaces[indexPath.row]).title;
    cell.detailTextLabel.text = @"233";
    return cell;
}


#pragma mark - UISearchDisplayControllerDelegate


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchHelper updateSearchResultForKeyword:searchString];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"wii begin");
    //NSLog(@"%@", controller.searchBar.delegate);
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayContrl setActive:YES animated:YES];
    return YES;
}


#pragma mark - Map Utlities

- (BRSAnnotation *)AnnotationForPlace:(BRSPlace *)place
{
    BRSAnnotation *annotation = [[BRSAnnotation alloc] init];
    annotation.title = place.title;
    annotation.subtitle = place.subtitle;
    annotation.coordinate = place.centerCoordinate;
    return annotation;
}

- (void)showCurrentPinAnnotation
{
    [self clearNormalAnnotations];
    [self.mapView addAnnotation:self.currentPinAnnotation];
    [self.mapView selectAnnotation:self.currentPinAnnotation animated:YES];
}

- (void)clearNormalAnnotations
{
    NSArray *annotations = self.mapView.annotations;
    for (id<MKAnnotation> annotation in annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        [self.mapView removeAnnotation:annotation];
    }
}

- (BRSPlace *)placeForCoordinate:(CLLocationCoordinate2D)coord
{
    BRSMapMetaDataManager *manager = [BRSMapMetaDataManager sharedDataManager];
    
    for (BRSPlace *place in manager.flatMapMetaData) {
        if ([place.boundaryPolygon coordInPolygon:coord]) {
            return place;
        }
    }

    return nil; // not found
}

- (NSArray *)surrondingPlacesForCoordinate:(CLLocationCoordinate2D)coord Count:(NSUInteger)count
{
    
//    /* initailize the result array*/
//    NSMutableArray *surroundingPlaces = [NSMutableArray arrayWithCapacity:count];
//    for (NSUInteger i = 0; i < count; i++) {
//        [surroundingPlaces addObject:(BRSPlace *)manager.flatMapMetaData[0]];
//    }
//    
//    for (BRSPlace *place in manager.flatMapMetaData) {
//        for (BRSPlace *resultPlace in surroundingPlaces) {
//            CLLocationDistance currentDistance = [BRSUtilities distanceFromCoord1:place.centerCoordinate toCoord2:coord];
//            CLLocationDistance resultDistance = [BRSUtilities distanceFromCoord1:resultPlace.centerCoordinate toCoord2:coord];
//            if (currentDistance < resultDistance) {
//                NSUInteger replaceIndex = [surroundingPlaces indexOfObject:resultPlace];
//                [surroundingPlaces replaceObjectAtIndex:replaceIndex withObject:place];
//            }
//        }
//    }
    BRSMapMetaDataManager *manager = [BRSMapMetaDataManager sharedDataManager];
    
    return [manager.flatMapMetaData most:count NearstElements:^ NSComparisonResult (BRSPlace *currentPlace, BRSPlace *resultPlace){
        CLLocationDistance currentDistance = [BRSUtilities distanceFromCoord1:currentPlace.centerCoordinate toCoord2:coord];
        CLLocationDistance resultDistance = [BRSUtilities distanceFromCoord1:resultPlace.centerCoordinate toCoord2:coord];
        return currentDistance < resultDistance ? NSOrderedAscending : NSOrderedDescending;
    }];
}

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
- (double) getZoomLevel
{
    return 21.00 - log2(self.mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.mapView.bounds.size.width));
}

@end
