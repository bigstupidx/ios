//
//  News.h
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface News : JSONModel
@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString<Optional> *introtext;

@property (strong, nonatomic) NSString<Optional> *fulltext;
@property (strong, nonatomic) NSString<Optional> *image;
@property (strong, nonatomic) NSString *catename;
@property (strong, nonatomic) NSString<Optional> *hits;
@property (strong, nonatomic) NSString<Optional> *created;

+ (void) getNewsWithOffset:(int)offset block:(void(^)(NSArray *news, NSError *error))callback;

@end
