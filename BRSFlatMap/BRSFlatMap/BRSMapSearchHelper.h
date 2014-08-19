//
//  BRSMapSearchController.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/20/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
@import MapKit;
@protocol BRSMapSearchHelperDelegate;
#import <Foundation/Foundation.h>

@interface BRSMapSearchHelper : NSObject

@property (nonatomic, strong) NSMutableArray *resultPlaces;
@property (nonatomic, weak) id<BRSMapSearchHelperDelegate> delegate;

- (void)startSearch:(NSString *)searchString forLocation:(CLLocationCoordinate2D)location;
- (void)updateSearchResultForKeyword:(NSString *) keyword;
@end


@protocol BRSMapSearchHelperDelegate <NSObject>

- (void)MapSearchController:(BRSMapSearchHelper *) mapSearchHelper DidGetSearchResponse:(MKLocalSearchResponse *) response;

@end
