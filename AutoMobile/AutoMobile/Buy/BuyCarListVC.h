//
//  BuyCarListVC.h
//  AutoMobile
//
//  Created by Zune Moe on 24/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCarListVC : UIViewController
@property (strong, nonatomic) NSArray *carArray;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *model;
@end
