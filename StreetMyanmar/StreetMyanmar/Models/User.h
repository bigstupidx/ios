//
//  User.h
//  StreetMyanmar
//
//  Created by Zune Moe on 3/12/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface User : JSONModel

+ (void)userUploadCheckinPhoto:(UIImage *)image block:(void(^)(NSString *photoname, NSError *error))callback;
+ (void)userPostCheckin:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback;

+ (void)userFacebookLogin:(NSDictionary *)parameters block:(void(^)(NSDictionary * user, NSError *error))callback;
@end
