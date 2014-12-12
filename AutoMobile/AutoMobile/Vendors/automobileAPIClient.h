//
//  automobileAPIClient.h
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "AFHTTPClient.h"

@interface automobileAPIClient : AFHTTPClient
+ (instancetype) sharedClient;
+ (instancetype) sharedClientNearby;
@end
