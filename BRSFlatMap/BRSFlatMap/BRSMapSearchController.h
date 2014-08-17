//
//  BRSMapSearchController.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/20/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
@import MapKit;
@protocol BRSMapSearchDelegate;
#import <Foundation/Foundation.h>

@interface BRSMapSearchController : NSObject <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *resultPlaces;
@property (nonatomic, weak) id<BRSMapSearchDelegate> delegate;

- (void)startSearch:(NSString *)searchString forLocation:(CLLocationCoordinate2D)location;

@end


@protocol BRSMapSearchDelegate <NSObject>

- (void)MapSearchController:(BRSMapSearchController *) mapSearchController DidGetSearchResponse:(MKLocalSearchResponse *) response;

@end
