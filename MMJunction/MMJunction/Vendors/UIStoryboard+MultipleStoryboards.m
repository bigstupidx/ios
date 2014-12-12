//
//  UIStoryboard+MultipleStoryboards.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "UIStoryboard+MultipleStoryboards.h"

@implementation UIStoryboard (MultipleStoryboards)

+ (UIStoryboard *)getCheckinStoryboard
{
    return [UIStoryboard storyboardWithName:@"Checkin" bundle:nil];
}

+ (UIStoryboard *)getEventsStoryboard
{
    return [UIStoryboard storyboardWithName:@"Events" bundle:nil];
}

+ (UIStoryboard *)getHotEventsStoryboard
{
    return [UIStoryboard storyboardWithName:@"HotEvents" bundle:nil];
}

+ (UIStoryboard *)getPromotionsStoryboard
{
    return [UIStoryboard storyboardWithName:@"Promotions" bundle:nil];
}

+ (UIStoryboard *)getMeStoryboard
{
    return [UIStoryboard storyboardWithName:@"Me" bundle:nil];
}

+ (UIStoryboard *)getIntroStoryboard
{
    return [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
}

@end
