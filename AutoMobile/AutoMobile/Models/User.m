//
//  User.m
//  AutoMobile
//
//  Created by Zune Moe on 27/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "User.h"
#import "automobileAPIClient.h"

@implementation User

+ (void) getUserWithId:(int)userid bloc:(void(^)(User *user, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:[NSString stringWithFormat:@"user/%d", userid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        User *user = [[User alloc] initWithDictionary:JSON error:nil];
        if (callback) {
            callback(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([User new], error);
        }
    }];
}

+ (void) signupUserWith:(NSDictionary *)parameters block:(void(^)(NSDictionary *message, NSError *error))callback
{
    [[automobileAPIClient sharedClient] postPath:@"user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(json, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (void) loginUserWith:(NSDictionary *)parameters block:(void(^)(NSDictionary *message, NSError *error))callback
{
    [[automobileAPIClient sharedClient] postPath:@"user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(json, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback ) {
            callback([NSDictionary dictionary], error);
        }
    }];
}
+ (void) updateUserWith:(NSDictionary *)parameters block:(void(^)(NSDictionary *message, NSError *error))callback
{
    [[automobileAPIClient sharedClient] postPath:@"user/edit" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(json, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (void) getCityList:(void(^)(NSArray *citylist, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:@"countrylist" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray* citylist = [JSON copy];
        
        if (callback) {
            callback(citylist, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray new], error);
        }
    }];
}


@end
