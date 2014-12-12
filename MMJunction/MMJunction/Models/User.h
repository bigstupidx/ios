//
//  User.h
//  MMJunction
//
//  Created by Zune Moe on 2/28/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"
#import "mmJunctionAPIClient.h"

@interface User : JSONModel
//@property (assign, nonatomic) int userid;
//@property (strong, nonatomic) NSString<Optional> *email;
//@property (strong, nonatomic) NSString<Optional> *name;
//@property (strong, nonatomic) NSString<Optional> *firstname;
//@property (strong, nonatomic) NSString<Optional> *lastname;
//@property (strong, nonatomic) NSString<Optional> *photo;
//@property (assign, nonatomic) int role;
//@property (assign, nonatomic) int status;

// userInfos is saved in NSUserDefaults, so can't use JSONModel => if you want to use JSONModel, store userInfos in sqlite, need some modifications in LoginVC, SignupVC, MeVC
//                                                              => another approach is use JSONModel and convert model into dictionary before saving to NSUserDefaults

+ (void)userFacebookLogin:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback;
+ (void)userLogin:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback;
+ (void)userSignup:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback;
+ (void)userUpdateProfile:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback;

+ (void)userCheckin:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback;

+ (void)userSignupUploadPhoto:(UIImage *)image block:(void(^)(NSString *photoname, NSError *error))callback;
+ (void)userCheckinUploadPhoto:(UIImage *)image block:(void(^)(NSString *photoname, NSError *error))callback;

+ (void)userAttendEvent:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback;
+ (void)userUnAttendEvent:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback;

+ (void)userCheckinPlaces:(NSDictionary *)parameters block:(void(^)(NSArray *placesCount, NSError *error))callback;
+ (void)userCheckinPlacesDetails:(NSDictionary *)parameters block:(void(^)(NSArray *places, NSError *error))callback;
+ (void)userCheckinEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback;

+ (void)userSubscribe:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback;
@end
