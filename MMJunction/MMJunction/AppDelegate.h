//
//  AppDelegate.h
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMFMDBSQLiteHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;

- (void)setupIntroView;
- (void)setupSubscribeView;
- (void)setupLoginView;
- (void)setupTabBarController;

@end
