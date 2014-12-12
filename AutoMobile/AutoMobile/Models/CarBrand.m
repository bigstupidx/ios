//
//  CarBrand.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "CarBrand.h"
#import "automobileAPIClient.h"

@implementation CarBrand
+ (void) getCarBrandsWithCatId:(int)catid block:(void(^)(NSArray *brands, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:@"makelists" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *brands = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            CarBrand *brand = [[CarBrand alloc] initWithDictionary:dict error:nil];
            [brands addObject:brand];
        }
        if (callback) {
            callback([NSArray arrayWithArray:brands], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void)getAvailableCarBrandsWithCatId:(int)catid block:(void(^)(NSArray *brands, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:[NSString stringWithFormat:@"makelistsbycatid/%d", catid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *brands = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            CarBrand *brand = [[CarBrand alloc] initWithDictionary:dict error:nil];
            [brands addObject:brand];
        }
        if (callback) {
            callback([NSArray arrayWithArray:brands], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

@end
