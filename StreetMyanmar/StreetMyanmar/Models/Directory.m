//
//  Directory.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/11/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "Directory.h"
#import "StreetMyanmarAPIClient.h"

@implementation Directory

+ (void)getDirectory:(NSDictionary *)parameters block:(void(^)(NSArray *directories, NSError *error))callback
{
    [[StreetMyanmarAPIClient sharedClient] postPath:@"api" parameters:@{@"apikey": @"a3b4b74330724a927bec"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if ([JSON[@"status"] isEqualToNumber:@1]) {
            [[StreetMyanmarAPIClient sharedClient] getPath:@"directories" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                NSLog(@"json; %@", JSON);
                NSMutableArray *directories = [NSMutableArray arrayWithCapacity:JSON.count];
                for (NSDictionary *dict in JSON) {
                    Directory *directory = [[Directory alloc] initWithDictionary:dict error:nil];
                    [directories addObject:directory];
                }
                if (callback) {
                    callback([NSArray arrayWithArray:directories], nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (callback) {
                    callback([NSArray array], error);
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
