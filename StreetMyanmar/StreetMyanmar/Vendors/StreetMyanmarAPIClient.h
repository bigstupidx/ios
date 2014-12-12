//
//  StreetMyanmarAPIClient.h
//  StreetMyanmar
//
//  Created by Zune Moe on 3/11/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AFHTTPClient.h"

@interface StreetMyanmarAPIClient : AFHTTPClient
+ (instancetype)sharedClient;
+ (instancetype)sharedClientNearby;
@end
