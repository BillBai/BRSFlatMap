//
//  BRSFlatMapViewController.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BRSSCUTMapView.h"
#import "BRSMapMetaDataManager.h"

@interface BRSFlatMapViewController : UIViewController <BRSMapViewDelegate,MKMapViewDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) BRSSCUTMapView *mapView;
@property (nonatomic, strong) BRSMapMetaDataManager *mapDataManager;

@end
