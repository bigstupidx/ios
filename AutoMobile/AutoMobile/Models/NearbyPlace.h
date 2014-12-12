//
//  NearbyPlace.h
//  AutoMobile
//
//  Created by Zune Moe on 31/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface NearbyPlace : JSONModel

@property (strong, nonatomic) NSString<Optional> *buildingname;
@property (strong, nonatomic) NSString<Optional> *buildingno;
@property (strong, nonatomic) NSString<Optional> *catid;
@property (strong, nonatomic) NSString<Optional> *catname;
@property (strong, nonatomic) NSString<Optional> *city;
@property (strong, nonatomic) NSString<Optional> *closingdate;
@property (strong, nonatomic) NSString<Optional> *closinghr;
@property (strong, nonatomic) NSString<Optional> *country;
@property (strong, nonatomic) NSString<Optional> *description;
@property (strong, nonatomic) NSString<Optional> *directoryid;
@property (strong, nonatomic) NSString<Optional> *email;
@property (strong, nonatomic) NSString<Optional> *feature;
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString<Optional> *latitude;
@property (strong, nonatomic) NSString<Optional> *locationid;
@property (strong, nonatomic) NSString<Optional> *longitude;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *openinghr;
@property (strong, nonatomic) NSString<Optional> *phone;
@property (strong, nonatomic) NSString<Optional> *photoname;
@property (strong, nonatomic) NSString<Optional> *promotion;
@property (strong, nonatomic) NSString<Optional> *quarter;
@property (strong, nonatomic) NSString<Optional> *roomno;
@property (strong, nonatomic) NSString<Optional> *street;
@property (strong, nonatomic) NSArray<Optional> *subcat;
@property (strong, nonatomic) NSString<Optional> *township;
@property (strong, nonatomic) NSString<Optional> *website;
@property (strong, nonatomic) NSString<Optional> *zipcode;

+ (void) getNearbyPlaces:(NSDictionary *)parameters block:(void(^)(NSArray *places, NSError *error))callback;

+ (void)getDirectories:(NSDictionary*)param block:(void(^)(NSArray *places, NSError *error))callback;

@end
