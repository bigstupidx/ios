//
//  StreetMyanmarAPIClient.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/11/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "StreetMyanmarAPIClient.h"

@implementation StreetMyanmarAPIClient

+ (instancetype)sharedClient
{
    static StreetMyanmarAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[StreetMyanmarAPIClient alloc] initWithBaseURL:[NSURL URLWithString:StreetMyanmarURL]];
    });
    return _sharedClient;
}

+ (instancetype)sharedClientNearby
{
    static StreetMyanmarAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[StreetMyanmarAPIClient alloc] initWithBaseURL:[NSURL URLWithString:StreetMyanmarNearbyURL]];
    });
    return _sharedClient;
}

@end
