//
//  Event.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "Event.h"
#import "mmJunctionAPIClient.h"
#import "NSString+HTML.h"

@implementation Event

+(JSONKeyMapper*)keyMapper //map "description" to "event_description" to prevent weird bug with JSON model
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description": @"event_description"}];
}

+ (void)getAllEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"allevents" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
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

+ (void)getAllEventsWithLocation:(NSString *)city block:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:[NSString stringWithFormat:@"events/%@", city.lowercaseString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:JSON.count];
         NSLog(@"NO SEARCH RESULT RETURN : %@",JSON);
        for (NSDictionary *dict in JSON) {
            NSLog(@"NO SEARCH RESULT RETURN : %@",dict[@"message"]);
            NSMutableDictionary *m_dict = [NSMutableDictionary dictionaryWithDictionary:dict];
            
            if (m_dict[@"message"]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"NO Search result." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else {
                m_dict[@"name"] = [self stripHTML:m_dict[@"name"]];
                m_dict[@"l_name"] = [self stripHTML:m_dict[@"l_name"]];
                m_dict[@"l_address"] = [self stripHTML:m_dict[@"l_address"]];
                m_dict[@"description"] = [self stripHTML:m_dict[@"description"]];
                Event *event = [[Event alloc] initWithDictionary:m_dict error:nil];
                [events addObject:event];
            }
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

+ (void)getTodayEvents:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"events/today" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
            NSMutableDictionary *m_dict = [NSMutableDictionary dictionaryWithDictionary:dict];
            m_dict[@"name"] = [self stripHTML:m_dict[@"name"]];
            m_dict[@"l_name"] = [self stripHTML:m_dict[@"l_name"]];
            m_dict[@"l_address"] = [self stripHTML:m_dict[@"l_address"]];
            m_dict[@"description"] = [self stripHTML:m_dict[@"description"]];
            NSError *error = nil;
            Event *event = [[Event alloc] initWithDictionary:m_dict error:&error];
            NSLog(@"error: %@", error);
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

+ (void)getFeaturedEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"featuredevents" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
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

+ (void)getHotEvents:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"allcheckin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"hot json: %@", JSON);
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:[JSON[@"checkin_events"] count]];
        for (NSDictionary *dict in JSON[@"checkin_events"]) {
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

+ (void)getPromotionEvents:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"promotion" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
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

+ (void)getJoinedEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"attendevents" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSArray *array = JSON[@"attend_events"];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            NSMutableDictionary *m_dict = [NSMutableDictionary dictionaryWithDictionary:dict];
            m_dict[@"name"] = [self stripHTML:m_dict[@"name"]];
            m_dict[@"l_name"] = [self stripHTML:m_dict[@"l_name"]];
            m_dict[@"l_address"] = [self stripHTML:m_dict[@"l_address"]];
            m_dict[@"description"] = [self stripHTML:m_dict[@"description"]];
            NSError *error;
            Event *event = [[Event alloc] initWithDictionary:m_dict error:&error];
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

+ (void)getSubscribedEvents:(NSDictionary *)parameters block:(void(^)(NSArray *events, NSError *error))callback
{
    [[mmJunctionAPIClient sharedEventsClient] getPath:@"evetsbytags" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:JSON.count];
        for (NSDictionary *dict in JSON) {
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

+ (NSString *) stripHTML:(NSString *)input {
    //NSLog(@"input: %@", input);
    if (![input isKindOfClass:[NSNull class]]) {
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
    return nil;
}

@end
