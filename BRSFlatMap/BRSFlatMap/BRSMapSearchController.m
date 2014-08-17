//
//  BRSMapSearchController.m
//  BRSFlatMap
//
//  Created by Bill Bai on 7/20/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import "BRSMapSearchController.h"

@interface BRSMapSearchController()

@property (nonatomic, strong) MKLocalSearch *localSearch;

@end

@implementation BRSMapSearchController

#pragma mark - Search Method
- (void)startSearch:(NSString *)searchString forLocation:(CLLocationCoordinate2D)location
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = location.latitude;
    newRegion.center.longitude = location.longitude;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(MapSearchController:DidGetSearchResponse:)]) {
                [self.delegate MapSearchController:self DidGetSearchResponse:response];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil) {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



@end
