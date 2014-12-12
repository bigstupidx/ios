//
//  CarAssiciation.m
//  AutoMobile
//
//  Created by Zune Moe on 29/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "CarAssociation.h"
#import "automobileAPIClient.h"

@implementation CarAssociation

+ (void)getCarAssociation:(void (^)(CarAssociation *, NSError *))callback
{
    [[automobileAPIClient sharedClient] getPath:@"carassociation" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        CarAssociation *carassociation = [[CarAssociation alloc] initWithDictionary:JSON error:nil];
        if (callback) {
            callback(carassociation, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([CarAssociation new], error);
        }
    }];
}

+ (void) getEnginePower:(void(^)(NSArray *brands, NSError *error))callback
{
    [[automobileAPIClient sharedClient] getPath:@"enginepowers" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *brands = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
//            CarBrand *brand = [[CarBrand alloc] initWithDictionary:dict error:nil];
            [brands addObject:dict];
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
