//
//  automobileAPIClient.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "automobileAPIClient.h"

//static NSString * const autoMobileBaseURL = @"http://192.168.1.131/automobile_api/public/";
//static NSString * const nearbyBaseURL = @"http://streetmyanmar.com/";

@implementation automobileAPIClient

+ (instancetype)sharedClient
{
    static automobileAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[automobileAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://automobile.com.mm/"]];//autoMobileBaseURL
    });
    
    return _sharedClient;
}

+ (instancetype)sharedClientNearby
{
    static automobileAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[automobileAPIClient alloc] initWithBaseURL:[NSURL URLWithString:nearbyBaseURL]];
    });
    return _sharedClient;
}

@end
