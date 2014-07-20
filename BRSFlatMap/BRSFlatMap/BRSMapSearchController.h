//
//  BRSMapSearchController.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/20/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRSMapSearchController : NSObject

@property (nonatomic, strong) NSArray *resultPlaces;


- (void)startSearch:(NSString *)searchString forLocation:(CLLocationCoordinate2D)location;

@end
