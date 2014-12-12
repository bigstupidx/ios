//
//  mmJunctionClient.h
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AFHTTPClient.h"

@interface mmJunctionAPIClient : AFHTTPClient
+ (instancetype)sharedEventsClient;
+ (instancetype)sharedNearbyClient;
@end
