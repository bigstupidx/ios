//
//  AppDelegate.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "GAI.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "LeftMenuVC.h"
#import "RightMenuVC.h"
#import "HotLeftMenuVC.h"
#import "HotRightMenuVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [FBLoginView class];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-42435435-2"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = paths[0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.db"];
    [self createAndCheckDatabase:path db:@"database.db"];
    
    [self.db createEventTable];
    [self.db createHotEventTable];
    [self.db createAttendTable];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"App First Time Use": @"YES"}];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"App First Time Use"] isEqualToString:@"YES"]) {
        [self setupIntroView];
    } else {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]) {
            [self setupTabBarController];
        } else {
            [[FBSession activeSession] closeAndClearTokenInformation];
            [self setupLoginView];
        }
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) createAndCheckDatabase:(NSString *)path db:(NSString *)dbName
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:path];
    if(success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:path error:nil];
}

- (void)setupLoginView
{
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *loginVC = [loginSB instantiateInitialViewController];
    
    self.window.rootViewController = loginVC;
}

- (void)setupSubscribeView
{
    UIStoryboard *sb = [UIStoryboard getMeStoryboard];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SubscribedVC"];
    
    self.window.rootViewController = vc;
}

- (void)setupTabBarController
{
    UIStoryboard *sb = [UIStoryboard getEventsStoryboard];
    
    UIViewController *vc = [sb instantiateInitialViewController];
    LeftMenuVC *leftMenuVC = [[LeftMenuVC alloc] initWithAlignment:MenuAligmentLeft];
    RightMenuVC *rightMenuVC = [[RightMenuVC alloc] initWithAlignment:MenuAligmentRight];
    RESideMenu *sideMenuController = [[RESideMenu alloc] initWithContentViewController:vc leftMenuViewController:leftMenuVC rightMenuViewController:rightMenuVC];
    sideMenuController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuController.contentViewScaleValue = 0.75f;
    sideMenuController.tabBarItem.title = @"Event";
    sideMenuController.tabBarItem.image = [UIImage imageNamed:@"Event_Line"];
    
    sb = [UIStoryboard getCheckinStoryboard];
    UIViewController *checkinVC = [sb instantiateInitialViewController];
    checkinVC.tabBarItem.title = @"Checkin";
    checkinVC.tabBarItem.image = [UIImage imageNamed:@"Checkin_Line"];
    
    sb = [UIStoryboard getHotEventsStoryboard];
    UIViewController *hotEventsVC = [sb instantiateInitialViewController];
    HotLeftMenuVC *hotLeftVC = [[HotLeftMenuVC alloc] initWithAlignment:MenuAligmentLeft];
    HotRightMenuVC *hotRightVC = [[HotRightMenuVC alloc] initWithAlignment:MenuAligmentRight];
    RESideMenu *hotEventsSideMenu = [[RESideMenu alloc] initWithContentViewController:hotEventsVC leftMenuViewController:hotLeftVC rightMenuViewController:hotRightVC];
    hotEventsSideMenu.backgroundImage = [UIImage imageNamed:@"Stars"];
    hotEventsSideMenu.contentViewScaleValue = 0.75f;
    hotEventsSideMenu.tabBarItem.title = @"Hot";
    hotEventsSideMenu.tabBarItem.image = [UIImage imageNamed:@"Hot_Line"];
    
    sb = [UIStoryboard getPromotionsStoryboard];
    UIViewController *promotionsVC = [sb instantiateInitialViewController];
    promotionsVC.tabBarItem.title = @"Promo";
    promotionsVC.tabBarItem.image = [UIImage imageNamed:@"Promotion_Line"];
    
    sb = [UIStoryboard getMeStoryboard];
    UIViewController *meVC = [sb instantiateInitialViewController];
    meVC.tabBarItem.title = @"Me";
    meVC.tabBarItem.image = [UIImage imageNamed:@"User_Line"];
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = @[checkinVC, hotEventsSideMenu, sideMenuController, promotionsVC, meVC];
    tabController.tabBar.translucent = NO;
    tabController.selectedIndex = 2;
    self.window.rootViewController = tabController;
}

- (void)setupIntroView
{
    UIStoryboard *sb = [UIStoryboard getIntroStoryboard];
    UIViewController *vc = [sb instantiateInitialViewController];
    self.window.rootViewController = vc;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (![token isEqualToString:oldToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"My token is: %@", token);
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
