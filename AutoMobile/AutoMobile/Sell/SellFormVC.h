//
//  SellFormVC.h
//  AutoMobile
//
//  Created by Zune Moe on 29/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCar.h"

@interface SellFormVC : UIViewController
@property (strong, nonatomic) NSDictionary *selectedCategory;
@property (strong, nonatomic) MyCar* mycarinfo;
@end
