//
//  MyCar.m
//  AutoMobile
//
//  Created by Macbook Pro on 8/21/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "MyCar.h"
#import "automobileAPIClient.h"

@implementation MyCar

+ (void)getMyCarsList:(NSDictionary *)parameters block:(void(^)(NSArray *cars, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:@"mycar" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *cars = [NSMutableArray arrayWithCapacity:JSON.count];
        //NSLog(@"car JSON: %@", JSON);
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


@end
