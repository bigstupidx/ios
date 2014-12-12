//
//  Ad.h
//  MMJunction
//
//  Created by Zune Moe on 3/6/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Ad : JSONModel
@property (strong, nonatomic) NSString<Optional> *url;
@property (strong, nonatomic) NSString<Optional> *website;

+ (void)getAds:(void(^)(NSArray *ads, NSError *error))callback;
@end
