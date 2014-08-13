//
//  BRSMapMetaDataManager.h
//  BRSFlatMap
//
//  Created by Bill Bai on 7/15/14.
//  Copyright (c) 2014 Bill Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRSPlace.h"

@interface BRSMapMetaDataManager : NSObject

@property (nonatomic, strong) NSArray *flatMapMetaData;

+ (instancetype)sharedDataManager;

@end
