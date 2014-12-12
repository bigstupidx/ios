//
//  Directory.h
//  StreetMyanmar
//
//  Created by Zune Moe on 3/11/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Directory : JSONModel

@property (strong, nonatomic) NSString<Optional> *buildingname;
@property (strong, nonatomic) NSString<Optional> *buildingno;
@property (assign, nonatomic) int catid;
@property (strong, nonatomic) NSString<Optional> *catname;
@property (strong, nonatomic) NSString<Optional> *city;
@property (strong, nonatomic) NSString<Optional> *closingdate;
@property (strong, nonatomic) NSString<Optional> *closinghr;
@property (strong, nonatomic) NSString<Optional> *country;
@property (assign, nonatomic) int directoryid;
@property (strong, nonatomic) NSString<Optional> *email;
@property (strong, nonatomic) NSString<Optional> *feature;
@property (assign, nonatomic) int locationid;
@property (strong, nonatomic) NSString<Optional> *latitude;
@property (strong, nonatomic) NSString<Optional> *longitude;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *openinghr;
@property (strong, nonatomic) NSString<Optional> *phone;
@property (strong, nonatomic) NSString<Optional> *photoname;
@property (strong, nonatomic) NSString<Optional> *promotion;
@property (strong, nonatomic) NSString<Optional> *quarter;
@property (strong, nonatomic) NSString<Optional> *roomno;
@property (strong, nonatomic) NSString<Optional> *street;
@property (strong, nonatomic) NSString<Optional> *township;
@property (strong, nonatomic) NSString<Optional> *website;
@property (strong, nonatomic) NSString<Optional> *zipcode;

+ (void)getDirectory:(NSDictionary *)parameters block:(void(^)(NSArray *directories, NSError *error))callback;
@end
