//
//  BRSAnnotation.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//
@import MapKit;
#import <Foundation/Foundation.h>

@interface BRSAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
