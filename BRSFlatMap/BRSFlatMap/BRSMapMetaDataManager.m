//
//  BRSMapMetaDataManager.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

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
        
        
        return self;
    }
    
    return nil;
}

- (void)loadFlatMapDataFromJSONFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testdata_2" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *flatMapData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}

@end
