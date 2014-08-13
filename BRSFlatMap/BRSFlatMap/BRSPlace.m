//
//  BRSPlace.m
//  BRSFlatMap
//
//  Created by Bill Bai on 8/14/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSPlace.h"

@implementation BRSPlace

- (id)initWithTitle:(NSString *)title Subtitle:(NSString *)subtitle coord:(CLLocationCoordinate2D)coord boudary:(MKPolygon *)boundary type:(BRSPlaceType)type subPlaces:(NSArray *)sub
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.centerCoordinate = coord;
        self.boundaryPolygon = boundary;
        self.type = type;
        self.subPlaces = sub;
        
        return self;
    }
    
    return nil;
}

@end
