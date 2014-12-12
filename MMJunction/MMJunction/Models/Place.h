//
//  Place.h
//  MMJunction
//
//  Created by Zune Moe on 2/24/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Place : JSONModel
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int directoryid;
@property (assign, nonatomic) int locationid;
@property (strong, nonatomic) NSString<Optional> *roomno;
@property (strong, nonatomic) NSString<Optional> *buildingname;
@property (strong, nonatomic) NSString<Optional> *buildingno;
@property (strong, nonatomic) NSString<Optional> *street;
@property (strong, nonatomic) NSString<Optional> *quarter;
@property (strong, nonatomic) NSString<Optional> *township;
@property (strong, nonatomic) NSString<Optional> *city;
@property (strong, nonatomic) NSString<Optional> *zipcode;
@property (strong, nonatomic) NSString<Optional> *latitude;
@property (strong, nonatomic) NSString<Optional> *longitude;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *photoname;
@property (strong, nonatomic) NSDictionary<Optional> *promotion_list;

+ (void)getNearbyPlaces:(NSDictionary *)parameters block:(void(^)(NSArray *places, NSError *error))callback;
@end
