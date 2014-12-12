//
//  ShowCarDetailVC.h
//  AutoMobile
//
//  Created by Macbook Pro on 8/21/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCar.h"
#import "User.h"

@interface ShowCarDetailVC : UIViewController

@property (strong, nonatomic) MyCar* carinfo;
@property (strong, nonatomic) User* userinfo;

@end
