//
//  Event.h
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Event : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *starttime;
@property (strong, nonatomic) NSString<Optional> *endtime;
@property (strong, nonatomic) NSString<Optional> *startdate;
@property (strong, nonatomic) NSString<Optional> *enddate;
@property (assign, nonatomic) int rsvp;
@property (assign, nonatomic) int priority;
@property (strong, nonatomic) NSString<Optional> *banner;
@property (assign, nonatomic) int user_id;
@property (assign, nonatomic) int tags_id;
@property (strong, nonatomic) NSString<Optional> *tags;
@property (strong, nonatomic) NSString<Optional> *l_name;
@property (strong, nonatomic) NSString<Optional> *l_address;
@property (strong, nonatomic) NSString<Optional> *l_city;
@property (strong, nonatomic) NSString<Optional> *l_longitude;
@property (strong, nonatomic) NSString<Optional> *l_latitude;
@property (strong, nonatomic) NSString<Optional> *event_description;

+ (void)getAllEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback;
+ (void)getAllEventsWithLocation:(NSString *)city block:(void(^)(NSArray *events, NSError *error))callback;
+ (void)getTodayEvents:(void(^)(NSArray *events, NSError *error))callback;
+ (void)getFeaturedEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback;
+ (void)getHotEvents:(void(^)(NSArray *events, NSError *error))callback;
+ (void)getPromotionEvents:(void(^)(NSArray *events, NSError *error))callback;

+ (void)getJoinedEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback;

+ (void)getSubscribedEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback;
@end
