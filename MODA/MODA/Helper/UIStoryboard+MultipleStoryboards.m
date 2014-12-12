//
//  UIStoryboard+MultipleStoryboards.m
//  Moda
//
//  Created by Zune Moe on 21/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "UIStoryboard+MultipleStoryboards.h"

@implementation UIStoryboard (MultipleStoryboards)
+ (UIStoryboard *)getMainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}
+ (UIStoryboard *)getPhotoGalleryStoryboard {
    return [UIStoryboard storyboardWithName:@"PhotoGallery" bundle:nil];
}
+ (UIStoryboard *)getBeautyArticleStoryboard {
    return [UIStoryboard storyboardWithName:@"Beauty" bundle:nil];
}
+ (UIStoryboard *)getShoppingStoryboard {
    return [UIStoryboard storyboardWithName:@"Shopping" bundle:nil];
}
+ (UIStoryboard *)getFeatureArticleStoryboard {
    return [UIStoryboard storyboardWithName:@"Feature" bundle:nil];
}
+ (UIStoryboard *)getEventsArticleStoryboard {
    return [UIStoryboard storyboardWithName:@"Events" bundle:nil];
}
+ (UIStoryboard *)getFashionArticleStoryboard {
    return [UIStoryboard storyboardWithName:@"Fashion" bundle:nil];
}
+ (UIStoryboard *)getLivingArticleStoryboard {
    return [UIStoryboard storyboardWithName:@"Living" bundle:nil];
}

+ (UIStoryboard*)getVideoListStoryboard {
    return [UIStoryboard storyboardWithName:@"VideoList" bundle:nil];
}
@end
