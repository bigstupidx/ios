//
//  User.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/12/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "User.h"
#import "StreetMyanmarAPIClient.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation User

+ (void)userUploadCheckinPhoto:(UIImage *)image block:(void(^)(NSString *photoname, NSError *error))callback
{
    // currently no photo upload api in streetmyanmar, so this is just a placeholder implementation of photo upload
    [[StreetMyanmarAPIClient sharedClient] postPath:@"api" parameters:@{@"apikey": @"a3b4b74330724a927bec"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if ([JSON[@"status"] isEqualToNumber:@1]) {
            NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);
            if (imageToUpload)
            {
                AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:StreetMyanmarURL]];
                
                // change path: later to match the real photo upload api from streetmyanmar
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

+ (void)userPostCheckin:(NSDictionary *)parameters block:(void(^)(NSDictionary *status, NSError *error))callback
{
    [[StreetMyanmarAPIClient sharedClient] postPath:@"api" parameters:@{@"apikey": @"a3b4b74330724a927bec"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if ([JSON[@"status"] isEqualToNumber:@1]) {
            [[StreetMyanmarAPIClient sharedClient] postPath:@"checkin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                NSLog(@"json: %@", JSON);
                if (callback) {
                    callback(JSON, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (callback) {
                    callback([NSDictionary dictionary], error);
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

+ (void)userFacebookLogin:(NSDictionary *)parameters block:(void(^)(NSDictionary * user, NSError *error))callback
{
    [[StreetMyanmarAPIClient sharedClient] postPath:@"api" parameters:@{@"apikey": @"a3b4b74330724a927bec"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if ([JSON[@"status"] isEqualToNumber:@1]) {
            [[StreetMyanmarAPIClient sharedClient] postPath:@"facebooklogin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *user = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:Nil];
                if (callback) {
                    callback(user, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (callback) {
                    callback(nil, error);
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
