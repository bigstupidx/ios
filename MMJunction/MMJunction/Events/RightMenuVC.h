//
//  RightMenuVC.h
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface RightMenuVC : UIViewController <RESideMenuDelegate>
- (id)initWithAlignment:(MenuAligment)position;
@end
