//
//  BRSMapSearchController.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/20/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BRSMapSearchDelegate;

@interface BRSMapSearchController : NSObject

@property (nonatomic, strong) NSArray *resultPlaces;
@property (nonatomic, weak) id<BRSMapSearchDelegate> delegate;

- (void)startSearch:(NSString *)searchString forLocation:(CLLocationCoordinate2D)location;

@end



@protocol BRSMapSearchDelegate <NSObject>

- (void)MapSearchController:(BRSMapSearchController *) mapSearchController DidGetSearchResponse:(MKLocalSearchResponse *) response;

@end
