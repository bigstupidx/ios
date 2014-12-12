//
//  CarModel.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "CarModel.h"
#import "automobileAPIClient.h"

@implementation CarModel

+ (void) getCarModelsWithMakeId:(int)makeid block:(void(^)(NSArray *models, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:[NSString stringWithFormat:@"modellist"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            CarModel *model = [[CarModel alloc] initWithDictionary:dict error:nil];
            [models addObject:model];
        }
        if (callback) {
            callback([NSArray arrayWithArray:models], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void) getAvailableCarModelsWithMakeId:(int)makeid block:(void(^)(NSArray *models, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:[NSString stringWithFormat:@"modellistsbymakeid/%d", makeid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            CarModel *model = [[CarModel alloc] initWithDictionary:dict error:nil];
            [models addObject:model];
        }
        if (callback) {
            callback([NSArray arrayWithArray:models], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

@end
