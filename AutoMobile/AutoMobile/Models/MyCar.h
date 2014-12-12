//
//  MyCar.h
//  AutoMobile
//
//  Created by Macbook Pro on 8/21/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface MyCar : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* userid;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* catid;
@property (strong, nonatomic) NSString* makeid;
@property (strong, nonatomic) NSString* make;
@property (strong, nonatomic) NSString* modelid;
@property (strong, nonatomic) NSString* model;
@property (strong, nonatomic) NSString* conditionid;
@property (strong, nonatomic) NSString* condition;
@property (strong, nonatomic) NSString* bodyid;
@property (strong, nonatomic) NSString* bodytype;
@property (strong, nonatomic) NSString* colorid;
@property (strong, nonatomic) NSString* color;
@property (strong, nonatomic) NSString* seater;
@property (strong, nonatomic) NSString* seatrow;
@property (strong, nonatomic) NSString* year;
@property (strong, nonatomic) NSString* price;
@property (strong, nonatomic) NSString* slip;
@property (strong, nonatomic) NSString* negotiate;
@property (strong, nonatomic) NSString* mileage;
@property (strong, nonatomic) NSString* fuel;
@property (strong, nonatomic) NSString* fuelid;
@property (strong, nonatomic) NSString* transmissionid;
@property (strong, nonatomic) NSString* transmission;
@property (strong, nonatomic) NSString* handdrive;
@property (strong, nonatomic) NSString* image;
@property (strong, nonatomic) NSArray<Optional> *image_list;
@property (strong, nonatomic) NSArray<Optional> *equipments;
@property (strong, nonatomic) NSString* cityid;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* licenseno;
@property (strong, nonatomic) NSString<Optional>* carno;
@property (strong, nonatomic) NSString* ownerbook;
@property (strong, nonatomic) NSString* enginepower_id;
@property (strong, nonatomic) NSString* enginepower;
@property (strong, nonatomic) NSString<Optional> *description;
@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* viewcount;
@property (strong, nonatomic) NSString* created_at;
@property (strong, nonatomic) NSString* updated_at;

+ (void)getMyCarsList:(NSDictionary *)parameters block:(void(^)(NSArray *cars, NSError *error))callback;

@end
