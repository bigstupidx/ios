//
//  UIStoryboard+MultipleStoryboards.m
//  KamayutMedia
//
//  Created by Zune Moe on 2/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "UIStoryboard+MultipleStoryboards.h"

@implementation UIStoryboard (MultipleStoryboards)
+ (UIStoryboard *)getNewsStoryboard {
    return [UIStoryboard storyboardWithName:@"News" bundle:nil];
}

+(UIStoryboard *)getSellStoryboard {
    return [UIStoryboard storyboardWithName:@"Sell" bundle:nil];
}

+(UIStoryboard *)getBuyStoryboard {
    return [UIStoryboard storyboardWithName:@"Buy" bundle:nil];
}

+(UIStoryboard *)getNearbyStoryboard {
    return [UIStoryboard storyboardWithName:@"Nearby" bundle:nil];
}

+(UIStoryboard *)getMeStoryboard {
    return [UIStoryboard storyboardWithName:@"Me" bundle:nil];
}
@end
