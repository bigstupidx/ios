//
//  AppDelegate.h
//  StreetMyanmar
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupIntroView;
- (void)setupLoginView;
- (void)setupTabBarController;
@end
