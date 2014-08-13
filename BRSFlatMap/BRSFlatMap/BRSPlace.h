//
//  BRSPlace.h
//  BRSFlatMap
//
//  Created by Bill Bai on 8/14/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

@import MapKit;
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BRSPlaceType) {
    BRSPlaceStudentDorm,
    BRSPlaceDinning
};

@interface BRSPlace : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic)         CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) MKPolygon *boundaryPolygon;
@property (nonatomic)         BRSPlaceType type;
@property (nonatomic, strong) NSArray *subPlaces;

- (id)initWithTitle:(NSString *)title Subtitle:(NSString *)subtitle coord:(CLLocationCoordinate2D) coord boudary:(MKPolygon *)boundary type:(BRSPlaceType)type subPlaces:(NSArray *)sub;

@end
