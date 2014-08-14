//
//  BRSMapMetaDataManager.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
#import "BRSUtilities.h"
#import "BRSMapMetaDataManager.h"

@implementation BRSMapMetaDataManager

+ (instancetype)sharedDataManager
{
    static BRSMapMetaDataManager *_mapMetaDataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapMetaDataManager = [[BRSMapMetaDataManager alloc] init];
    });
    
    return _mapMetaDataManager;
}

- (NSArray *)flatMapMetaData
{
    if (!_flatMapMetaData) {
        _flatMapMetaData = [NSArray array];
    }
    
    return _flatMapMetaData;
}

-(id)init
{
    self = [super init];
    if (self) {
        
        [self loadFlatMapDataFromJSONFile];
        return self;
    }
    
    return nil;
}

static NSString *kJSONMapFeaturesKey = @"features";

- (void)loadFlatMapDataFromJSONFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"North" ofType:@"geojson"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *flatMapData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSMutableArray *places = [[NSMutableArray alloc] init];
    for (NSDictionary *feature in flatMapData[kJSONMapFeaturesKey]) {
        CLLocationCoordinate2D center = [BRSUtilities locationCoordinateFromArray:feature[@"properties"][@"center"]];
        NSString *title = feature[@"properties"][@"name"];
        MKPolygon *boudary = [BRSUtilities polygonFromArray:feature[@"geometry"][@"coordinates"]];
        BRSPlace *place = [[BRSPlace alloc] initWithTitle:title Subtitle:nil coord:center boudary:boudary type:0 subPlaces:nil];
        [places addObject:place];
    }
    self.flatMapMetaData = [places copy];
}

@end
