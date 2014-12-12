//
//  Place.m
//  MMJunction
//
//  Created by Zune Moe on 2/24/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "Place.h"
#import "StreetMyanmarAPIClient.h"
@implementation Place

+ (void)getNearbyPlaces:(NSDictionary *)parameters block:(void(^)(NSArray *places, NSError *error))callback
{
    [[StreetMyanmarAPIClient sharedClientNearby] getPath:@"nearby" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *places = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            NSError *error = nil;
            Place *place = [[Place alloc] initWithDictionary:dict error:&error];
            [places addObject:place];
        }
        if (callback) {
            callback([NSArray arrayWithArray:places], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

@end
