//
//  Car.m
//  AutoMobile
//
//  Created by Zune Moe on 24/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "Car.h"
#import "automobileAPIClient.h"
#import "MyCar.h"


@implementation Car

+ (void)getCarsWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *cars, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:[NSString stringWithFormat:@"carlists/%@/%@/%@",parameters[@"catid"],parameters[@"makeid"],parameters[@"modelid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *cars = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            MyCar *car = [[MyCar alloc] initWithDictionary:dict error:nil];
            [cars addObject:car];
        }
        if (callback) {
            callback([NSArray arrayWithArray:cars], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void)postCarWithParameters:(NSDictionary *)parameters block:(void(^)(NSError *error))callback
{
    [[automobileAPIClient sharedClient] postPath:@"car" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (callback) {
            callback(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

+ (void)getMyCarsList:(NSDictionary *)parameters block:(void(^)(NSArray *cars, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:@"mycar" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *cars = [NSMutableArray arrayWithCapacity:JSON.count];
        //NSLog(@"car JSON: %@", JSON);
        for (NSDictionary *dict in JSON) {
            Car *car = [[Car alloc] initWithDictionary:dict error:nil];
            [cars addObject:car];
        }
        if (callback) {
            callback([NSArray arrayWithArray:cars], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void)deleteMyCar:(int)carid block:(void(^)(NSDictionary *status, NSError *error))callback
{
    [[automobileAPIClient sharedClient] postPath:[NSString stringWithFormat:@"car/%d", carid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (void)updateMyCar:(NSDictionary *)parameters withcarid:(NSString*)carid block:(void(^)(NSDictionary *status, NSError *error))callback
{
    [[automobileAPIClient sharedClient] postPath:[NSString stringWithFormat:@"car/update/%@",carid] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"json: %@", JSON);
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

@end
