//
//  CarBrand.h
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface CarBrand : JSONModel
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int catid;
@property (strong, nonatomic) NSString *name;

+ (void)getCarBrandsWithCatId:(int)catid block:(void(^)(NSArray *brands, NSError *error))callback;
+ (void)getAvailableCarBrandsWithCatId:(int)catid block:(void(^)(NSArray *brands, NSError *error))callback;
@end
