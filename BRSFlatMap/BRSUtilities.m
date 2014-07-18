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

@end
