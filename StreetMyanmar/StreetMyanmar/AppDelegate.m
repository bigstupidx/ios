//
//  AppDelegate.m
//  StreetMyanmar
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AppDelegate.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DirectoryDetailsVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [FBLoginView class];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = paths[0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.db"];
    [self createAndCheckDatabase:path db:@"database.db"];
    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"App First Time Use": @"YES"}];
//    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"App First Time Use"] isEqualToString:@"YES"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"App First Time Use"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self setupIntroView];
//    } else {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]) {
            NSLog(@"userinfo: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
            [self setupTabBarController];
        } else {
            //[[FBSession activeSession] closeAndClearTokenInformation];
            [self setupLoginView];
        }
//    }
    
    [self setupTestView];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupTestView
{
    UIStoryboard *sb = [UIStoryboard getDirectoryStoryboard];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DirectoryDetailsVC"];
    self.window.rootViewController = vc;
}

- (void)setupIntroView
{
    
}

- (void)setupLoginView
{
    UIStoryboard *sb = [UIStoryboard getLoginStoryboard];
    UIViewController *vc = [sb instantiateInitialViewController];
    self.window.rootViewController = vc;
}

- (void)setupTabBarController
{
    UIStoryboard *sb = [UIStoryboard getDirectoryStoryboard];
    UIViewController *directoryVC = [sb instantiateInitialViewController];
    directoryVC.tabBarItem.title = @"Directory";
    
    sb = [UIStoryboard getCheckinStoryboard];
    UIViewController *checkinVC = [sb instantiateInitialViewController];
    checkinVC.tabBarItem.title = @"Checkin";
    
    sb = [UIStoryboard getHotPlacesStoryboard];
    UIViewController *hotVC = [sb instantiateInitialViewController];
    hotVC.tabBarItem.title = @"Hot";
    
    sb = [UIStoryboard getMeStoryboard];
    UIViewController *meVC = [sb instantiateInitialViewController];
    meVC.tabBarItem.title = @"Me";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[checkinVC, directoryVC, hotVC, meVC];
    self.window.rootViewController = tabBarController;
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
