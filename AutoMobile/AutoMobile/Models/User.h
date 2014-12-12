//
//  User.h
//  AutoMobile
//
//  Created by Zune Moe on 27/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface User : JSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *firstname;
@property (strong, nonatomic) NSString<Optional> *email;
@property (strong, nonatomic) NSString<Optional> *lastname;
@property (strong, nonatomic) NSString<Optional> *company;
@property (strong, nonatomic) NSString<Optional> *phone;
@property (strong, nonatomic) NSString<Optional> *country;
@property (strong, nonatomic) NSString<Optional> *website;

+ (void)getUserWithId:(int)userid bloc:(void(^)(User *user, NSError *error))callback;
+ (void)signupUserWith:(NSDictionary *)parameters block:(void(^)(NSDictionary *message, NSError *error))callback;
+ (void)loginUserWith:(NSDictionary *)parameters block:(void(^)(NSDictionary *message, NSError *error))callback;
+ (void)updateUserWith:(NSDictionary *)parameters block:(void(^)(NSDictionary *message, NSError *error))callback;
+ (void) getCityList:(void(^)(NSArray *citylist, NSError *error))callback;
@end
