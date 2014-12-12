//
//  Car.h
//  AutoMobile
//
//  Created by Zune Moe on 24/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface Car : JSONModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int catid;
@property (strong, nonatomic) NSString<Optional> *catname;
@property (assign, nonatomic) int makeid;
@property (strong, nonatomic) NSString<Optional> *makename;
@property (assign, nonatomic) int modelid;
@property (strong, nonatomic) NSString<Optional> *modelname;
@property (strong, nonatomic) NSString<Optional> *country;
@property (assign, nonatomic) int countryid;
@property (strong, nonatomic) NSString<Optional> *condition;
@property (assign, nonatomic) int conditionid;
@property (assign, nonatomic) int user;
@property (strong, nonatomic) NSString<Optional> *bodytype;
@property (assign, nonatomic) int bodytypeid;
@property (strong, nonatomic) NSString<Optional> *drive;
@property (assign, nonatomic) int driveid;
@property (strong, nonatomic) NSString<Optional> *fuel;
@property (assign, nonatomic) int fuelid;
@property (strong, nonatomic) NSString<Optional> *trans;
@property (assign, nonatomic) int transid;
@property (strong, nonatomic) NSArray<Optional> *equipment;
@property (strong, nonatomic) NSArray<Optional> *equipmentid;
@property (assign, nonatomic) int year;
@property (assign, nonatomic) int month;
@property (strong, nonatomic) NSString<Optional> *vincode;
@property (assign, nonatomic) int mileage;
@property (assign, nonatomic) unsigned int price;
@property (assign, nonatomic) unsigned int bprice;
@property (strong, nonatomic) NSString<Optional> *color;
@property (assign, nonatomic) int colorid;
@property (assign, nonatomic) int intcolor;
@property (assign, nonatomic) int doors;
@property (assign, nonatomic) int seats;
@property (strong, nonatomic) NSString<Optional> *engine;
@property (strong, nonatomic) NSDate<Optional> *creatdate;
@property (strong, nonatomic) NSDate<Optional> *expirdate;
@property (strong, nonatomic) NSString<Optional> *embedcode;
@property (assign, nonatomic) int fcommercial;
@property (assign, nonatomic) int ffeatured;
@property (assign, nonatomic) int ftop;
@property (assign, nonatomic) int special;
@property (assign, nonatomic) int fauction;
@property (assign, nonatomic) int hits;
@property (assign, nonatomic) int ordering;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) int expemail;
@property (strong, nonatomic) NSString<Optional> *otherinfo;
@property (assign, nonatomic) int unweight;
@property (assign, nonatomic) int grweight;
@property (assign, nonatomic) float length;
@property (assign, nonatomic) float width;
@property (strong, nonatomic) NSString<Optional> *displacement;
@property (assign, nonatomic) int solid;
@property (strong, nonatomic) NSString<Optional> *imgmain;
@property (assign, nonatomic) int imgcount;

+ (void)getCarsWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *cars, NSError *error))callback;
+ (void)postCarWithParameters:(NSDictionary *)parameters block:(void(^)(NSError *error))callback;
+ (void)getMyCarsList:(NSDictionary *)parameters block:(void(^)(NSArray *cars, NSError *error))callback;
+ (void)deleteMyCar:(int)carid block:(void(^)(NSDictionary *status, NSError *error))callback;
+ (void)updateMyCar:(NSDictionary *)parameters withcarid:(NSString*)carid block:(void(^)(NSDictionary *status, NSError *error))callback;
@end
