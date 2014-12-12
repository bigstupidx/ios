//
//  mmJunctionClient.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "mmJunctionAPIClient.h"

@implementation mmJunctionAPIClient

+ (instancetype)sharedEventsClient
{
    static mmJunctionAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[mmJunctionAPIClient alloc] initWithBaseURL:[NSURL URLWithString:MMJunctionBaseURL]];
    });
    return _sharedClient;
}

+ (instancetype)sharedNearbyClient
{
    static mmJunctionAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[mmJunctionAPIClient alloc] initWithBaseURL:[NSURL URLWithString:MMJunctionNearbyURL]];
    });
    return _sharedClient;
}

@end
