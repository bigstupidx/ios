//
//  Ad.m
//  MMJunction
//
//  Created by Zune Moe on 3/6/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "Ad.h"
#import "mmJunctionAPIClient.h"

@implementation Ad
+ (void)getAds:(void(^)(NSArray *ads, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"adver" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray *array = JSON[@"mobileadv"];
        NSMutableArray *ads = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            Ad *ad = [[Ad alloc] initWithDictionary:dict error:nil];
            [ads addObject:ad];
        }
        if (callback) {
            callback([NSArray arrayWithArray:ads], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}
@end
