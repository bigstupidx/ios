//
//  UIStoryboard+MultipleStoryboards.h
//  KamayutMedia
//
//  Created by Zune Moe on 2/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (MultipleStoryboards)
+(UIStoryboard *)getNewsStoryboard;
+(UIStoryboard *)getSellStoryboard;
+(UIStoryboard *)getBuyStoryboard;
+(UIStoryboard *)getNearbyStoryboard;
+(UIStoryboard *)getMeStoryboard;
@end
