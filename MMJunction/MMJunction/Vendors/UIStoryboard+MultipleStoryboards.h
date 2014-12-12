//
//  UIStoryboard+MultipleStoryboards.h
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (MultipleStoryboards)

+ (UIStoryboard *)getCheckinStoryboard;
+ (UIStoryboard *)getEventsStoryboard;
+ (UIStoryboard *)getHotEventsStoryboard;
+ (UIStoryboard *)getPromotionsStoryboard;
+ (UIStoryboard *)getMeStoryboard;
+ (UIStoryboard *)getIntroStoryboard;

@end
