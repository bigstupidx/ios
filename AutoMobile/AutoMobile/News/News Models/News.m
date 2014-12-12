//
//  News.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "News.h"

// vendors
#import "automobileAPIClient.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
@implementation News

+ (void)getNewsWithOffset:(int)offset block:(void (^)(NSArray *news, NSError *error))callback
{
    NSDictionary *parameters = @{@"limit": @"10",
                                 @"offset": @(offset)};
    [[automobileAPIClient sharedClient] getPath:@"newslists" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *news = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            NSString *fulltext = [dict[@"fulltext"] stringByConvertingHTMLToPlainText];
            fulltext = [fulltext stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            NSString *introtext = [dict[@"introtext"] stringByConvertingHTMLToPlainText];
            introtext = [introtext  stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            NSMutableDictionary *imageURLseparatedNews = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   dict[@"catename"], @"catename",
                                                   dict[@"created"], @"created",
                                                   dict[@"hits"], @"hits",
                                                   dict[@"id"], @"id",
                                                   dict[@"title"], @"title",
                                                   introtext, @"introtext",
                                                   fulltext, @"fulltext",
                                                   dict[@"image"], @"image"
                                                   , nil];
            News *newsFeed = [[News alloc] initWithDictionary:imageURLseparatedNews error:nil];
            [news addObject:newsFeed];
        }
        if (callback) {
            callback([NSArray arrayWithArray:news], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback([NSArray array], error);
        }
    }];
}

+ (NSString *)scanImageURLFromHTMLString:(NSString *)string
{
    NSString *url = nil;
    NSString *htmlString = string;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
    }
    return url;
}

@end
