//
//  UIStoryboard+MultipleStoryboards.h
//  Moda
//
//  Created by Zune Moe on 21/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (MultipleStoryboards)
+ (UIStoryboard *)getMainStoryboard;
+ (UIStoryboard *)getPhotoGalleryStoryboard;
+ (UIStoryboard *)getBeautyArticleStoryboard;
+ (UIStoryboard *)getShoppingStoryboard;
+ (UIStoryboard *)getFeatureArticleStoryboard;
+ (UIStoryboard *)getEventsArticleStoryboard;
+ (UIStoryboard *)getFashionArticleStoryboard;
+ (UIStoryboard *)getLivingArticleStoryboard;
+ (UIStoryboard*)getVideoListStoryboard;
@end
