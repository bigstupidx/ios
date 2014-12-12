//
//  AppDelegate.m
//  MODA
//
//  Created by Macbook Pro on 12/6/13.
//  Copyright (c) 2013 Ignite Software Solution. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+UIColor_PXExtentions.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "ViewController.h"
#import "MODAdataFetching.h"
#import "GAI.h"

static NSString *const kGaPropertyId = @"UA-47563054-1"; // Placeholder property ID.
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 30;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47563054-1"];

    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor,
                                               [UIFont fontWithName:@"BauerBodoni BT" size:25.0],UITextAttributeFont,nil]; //pxColorWithHexValue:@"9a8624"
//
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar_Landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)  {
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], UITextAttributeTextColor,
                                                           [UIFont fontWithName:@"BauerBodoni BT" size:15.0], UITextAttributeFont, nil]
                                                 forState:UIControlStateNormal];
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], UITextAttributeTextColor,
                                                           [UIFont fontWithName:@"BauerBodoni BT" size:15.0], UITextAttributeFont, nil]
                                                 forState:UIControlStateNormal];
    }
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor redColor], UITextAttributeTextColor,
                                                       [UIFont fontWithName:@"BauerBodoni BT" size:15.0], UITextAttributeFont, nil]
                                             forState:UIControlStateHighlighted];
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor pxColorWithHexValue:@"ffffff"]];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//        self.window.tintColor = [UIColor redColor];//[UIColor colorWithRed:154.0/255.0 green:134.0/255.0 blue:36.0/255.0 alpha:1.0];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowFirstAdsView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MODAdataFetching* dataFetcher = [[MODAdataFetching alloc] init];
    [dataFetcher adsDownloading];
    
    return YES;
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

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    UIViewController *currentViewController = [self topViewController];
    
    // Check whether it implements a dummy methods called canRotate
    if ([currentViewController respondsToSelector:@selector(canNotRotate)]) {
        // Unlock landscape view orientations for this view controller
        return UIInterfaceOrientationMaskPortrait;
    }
    
    // Only allow portrait (standard behaviour)
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
