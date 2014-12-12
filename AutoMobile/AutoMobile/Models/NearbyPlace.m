//
//  NearbyPlace.m
//  AutoMobile
//
//  Created by Zune Moe on 31/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NearbyPlace.h"
#import "automobileAPIClient.h"
@implementation NearbyPlace

+ (void) getNearbyPlaces:(NSDictionary *)parameters block:(void(^)(NSArray *places, NSError *error))callback
{//.../mobile/directories?
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"radius",
                           @"16.775849", @"lat",
                           @"96.147169", @"lng",
                           @"16", @"cat_id",
                           @"", @"subcat_id", nil];
    [[automobileAPIClient sharedClientNearby] postPath:@"api" parameters:@{@"apikey": @"a3b4b74330724a927bec"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dct = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:NULL];
        if ([[NSString stringWithFormat:@"%@", [dct objectForKey:@"status"]] isEqualToString:@"1"]) {
            [[automobileAPIClient sharedClientNearby] getPath:@"api/nearby" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                NSMutableArray *places = [NSMutableArray arrayWithCapacity:JSON.count];
                for (NSDictionary *dict in JSON) {
                    NearbyPlace *place = [[NearbyPlace alloc] initWithDictionary:dict error:nil];
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
    } failure:NULL];
}

+ (void)getDirectories:(NSDictionary*)param block:(void(^)(NSArray *places, NSError *error))callback
{
    [[automobileAPIClient sharedClientNearby] getPath:@"mobile/directories" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *places = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            NearbyPlace *place = [[NearbyPlace alloc] initWithDictionary:dict error:nil];
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
