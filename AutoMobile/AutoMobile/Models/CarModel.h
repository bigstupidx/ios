//
//  CarModel.h
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface CarModel : JSONModel
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int makeid;
@property (strong, nonatomic) NSString *name;


+ (void)getCarModelsWithMakeId:(int)makeid block:(void(^)(NSArray *models, NSError *error))callback;
+ (void)getAvailableCarModelsWithMakeId:(int)makeid block:(void(^)(NSArray *models, NSError *error))callback;
@end
