//
//  BRSMapCoordinateTester.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/18/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSMapCoordinateTester.h"
#import "BRSAnnotation.h"
@implementation BRSMapCoordinateTester

- (NSMutableArray *)testdata
{
    if (!_testdata) {
        _testdata = [NSMutableArray array];
    }
    return _testdata;
}

- (id)initWithMapView:(MKMapView *)mapview
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.mapView = mapview;
    [self loadTestData];
    return self;
}

- (void)loadTestData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"North" ofType:@"geojson"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *testdata = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.testdata = testdata[@"features"];
    
}

- (void)addAnnotationsToMapView:(NSArray *)annotations
{
    
}

- (void)addAllPolygonsAndAnnotationsToMap
{
    for (NSDictionary *feature in self.testdata) {
        NSArray *points = feature[@"geometry"][@"coordinates"];
        NSUInteger count = points.count;
        CLLocationCoordinate2D coords[count];
        for (NSInteger i = 0; i < points.count; i++) {
            CLLocationDegrees lat = [(NSNumber *)points[i][1] doubleValue];
            CLLocationDegrees lon = [(NSNumber *)points[i][0] doubleValue];
            coords[i] = CLLocationCoordinate2DMake(lat, lon);
        }
        [self.mapView addOverlay:[MKPolygon polygonWithCoordinates:coords count:count]];
        CLLocationDegrees lat = [(NSNumber *)feature[@"properties"][@"center"][1] doubleValue];
        CLLocationDegrees lon = [(NSNumber *)feature[@"properties"][@"center"][0] doubleValue];
        BRSAnnotation *annotation = [[BRSAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        annotation.title = feature[@"properties"][@"name"];
        //annotation.subtitle = @"map";
        [self.mapView addAnnotation:annotation];
    }
}

- (NSArray *)centerAnnotations
{
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSDictionary *feature in self.testdata) {
        CLLocationDegrees lat = [(NSNumber *)feature[@"properties"][@"center"][1] doubleValue];
        CLLocationDegrees lon = [(NSNumber *)feature[@"properties"][@"center"][0] doubleValue];
        BRSAnnotation *annotation = [[BRSAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        annotation.title = feature[@"properties"][@"name"];
        [annotations addObject:annotation];
    }
    return [annotations copy];
}

- (NSArray *)buildingPolygons
{
    NSMutableArray *polygons = [NSMutableArray array];

    for (NSDictionary *feature in self.testdata) {
        NSArray *points = feature[@"geometry"][@"coordinates"];
        NSUInteger count = points.count;
        CLLocationCoordinate2D coords[count];
        for (NSInteger i = 0; i < points.count; i++) {
            CLLocationDegrees lat = [(NSNumber *)points[i][1] doubleValue];
            CLLocationDegrees lon = [(NSNumber *)points[i][0] doubleValue];
            coords[i] = CLLocationCoordinate2DMake(lat, lon);
        }
        [polygons addObject:[MKPolygon polygonWithCoordinates:coords count:count]];
    }
    return [polygons copy];
}


@end
