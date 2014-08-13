//
//  BRSUtilities.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/18/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSUtilities.h"

@implementation BRSUtilities

+ (void)BRSCoordiinateLog:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"Coord=> latitude %f, longitude %f", coordinate.latitude, coordinate.longitude);
}

+ (CLLocationCoordinate2D)locationCoordinateFromArray:(NSArray *)coordArray
{
    CLLocationDegrees lat = [(NSNumber *)coordArray[1] doubleValue];
    CLLocationDegrees lon = [(NSNumber *)coordArray[0] doubleValue];
    return CLLocationCoordinate2DMake(lat, lon);
}

+ (MKPolygon *)polygonFromArray:(NSArray *)boundaryArray
{
    NSUInteger count = boundaryArray.count;
    CLLocationCoordinate2D coords[count];
    for (NSInteger i = 0; i < count; i++) {
        coords[i] = [BRSUtilities locationCoordinateFromArray:boundaryArray[i]];
    }
    
    return [MKPolygon polygonWithCoordinates:coords count:count];
}
@end
