//
//  UIStoryboard+MultipleStoryboards.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "UIStoryboard+MultipleStoryboards.h"

@implementation UIStoryboard (MultipleStoryboards)

+ (UIStoryboard *)getHotPlacesStoryboard
{
    return [UIStoryboard storyboardWithName:@"HotPlaces" bundle:nil];
}

+ (UIStoryboard *)getCheckinStoryboard
{
    return [UIStoryboard storyboardWithName:@"Checkin" bundle:nil];
}

+ (UIStoryboard *)getDirectoryStoryboard
{
    return [UIStoryboard storyboardWithName:@"Directory" bundle:nil];
}

+ (UIStoryboard *)getLoginStoryboard
{
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
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
