//
//  User.m
//  MMJunction
//
//  Created by Zune Moe on 2/28/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "User.h"
#import "Event.h"
#import "Place.h"
#import "AFHTTPRequestOperation.h"
#import "NSString+HTML.h"

@implementation User
+ (void)userFacebookLogin:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"facebooklogin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(nil, error);
        }
    }];
}

+ (void)userLogin:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"signin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(nil, error);
        }
    }];
}

+ (void)userSignup:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(nil, error);
        }
    }];
}

+ (void)userUpdateProfile:(NSDictionary *)parameters block:(void(^)(NSDictionary *user, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"userupdate" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(nil, error);
        }
    }];
}

+ (void)userCheckin:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"checkin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (void)userSignupUploadPhoto:(UIImage *)image block:(void(^)(NSString *photoname, NSError *error))callback
{
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:MMJunctionBaseURL]];
        
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"user/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData: imageToUpload name:@"Picture" fileName:@"iOSUpload.jpeg" mimeType:@"image/jpeg"];
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
             NSArray *separatedImageURL = [json[@"photoname"] componentsSeparatedByString:@"/"];
             if (callback) {
                 callback(separatedImageURL.lastObject, nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (callback) {
                 callback([NSString string], error);
             }
         }];
        [operation start];
    }
}

+ (void)userCheckinUploadPhoto:(UIImage *)image block:(void(^)(NSString *photoname, NSError *error))callback
{
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {        
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:MMJunctionBaseURL]];
        
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"checkin/picture" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData: imageToUpload name:@"Picture" fileName:@"iOSUpload.jpeg" mimeType:@"image/jpeg"];
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
             if (callback) {
                 callback(json[@"photoname"], nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (callback) {
                 callback([NSString string], error);
             }
         }];
        [operation start];
    }
}

+ (void)userAttendEvent:(NSDictionary *)parameters block:(void(^)(NSDictionary * status, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"attends" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (void)userUnAttendEvent:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"unjoin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (void)userCheckinPlaces:(NSDictionary *)parameters block:(void(^)(NSArray *placesCount, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"checkin/place" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray *places = JSON[@"checkin_location"];
        if (callback) {
            callback(places, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void)userCheckinPlacesDetails:(NSDictionary *)parameters block:(void(^)(NSArray *places, NSError *error))callback
{
    [[mmJunctionAPIClient sharedNearbyClient] getPath:@"directories/group" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *places = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            Place *place = [[Place alloc] initWithDictionary:dict error:nil];
            [places addObject:place];
        }
        if (callback) {
            callback([NSArray arrayWithArray:places], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void)userCheckinEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"checkin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
        NSArray *array = JSON[@"checkin_events"];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            NSMutableDictionary *m_dict = [NSMutableDictionary dictionaryWithDictionary:dict];
            m_dict[@"name"] = [self stripHTML:m_dict[@"name"]];
            m_dict[@"l_name"] = [self stripHTML:m_dict[@"l_name"]];
            m_dict[@"l_address"] = [self stripHTML:m_dict[@"l_address"]];
            m_dict[@"description"] = [self stripHTML:m_dict[@"description"]];
            Event *event = [[Event alloc] initWithDictionary:m_dict error:nil];
            [events addObject:event];
        }
        if (callback) {
            callback([NSArray arrayWithArray:events], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (void)userSubscribe:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] postPath:@"gcmdevice" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (callback) {
            callback(JSON, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSDictionary dictionary], error);
        }
    }];
}

+ (NSString *) stripHTML:(NSString *)input {
    input = [input stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    input = [input stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    input = [input stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSRange r;
    NSString *s = input;
    
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    
    return [s kv_decodeHTMLCharacterEntities];
}

@end
