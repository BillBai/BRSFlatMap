//
//  BRSUtilities.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/18/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@interface BRSUtilities : NSObject

+ (void)BRSCoordiinateLog:(CLLocationCoordinate2D)coordinate;

+ (CLLocationCoordinate2D)locationCoordinateFromArray:(NSArray *)coordArray;
+ (MKPolygon *)polygonFromArray:(NSArray *)boundaryArray;
+ (CLLocationDistance)distanceFromCoord1:(CLLocationCoordinate2D)coord1 toCoord2:(CLLocationCoordinate2D)coord2;
@end
