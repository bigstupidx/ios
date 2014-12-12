//
//  IntroVC.m
//  MMJunction
//
//  Created by Zune Moe on 3/3/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "IntroVC.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "AppDelegate.h"

@interface IntroVC () <EAIntroDelegate>

@end

@implementation IntroVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	EAIntroPage *introPage = [EAIntroPage page];
    introPage.title = @"Welcome to MMJunction";
    introPage.bgImage = [UIImage imageNamed:@"mmJunction_background"];
    
    EAIntroPage *introPage1 = [EAIntroPage page];
    introPage1.bgImage = [UIImage imageNamed:@"Tutorial_Checkin"];
    
    EAIntroPage *introPage2 = [EAIntroPage page];
    introPage2.bgImage = [UIImage imageNamed:@"Tutorial_Event"];
    
    EAIntroPage *introPage3 = [EAIntroPage page];
    introPage3.bgImage = [UIImage imageNamed:@"Tutorial_Swipe"];
    
    EAIntroPage *introPage4 = [EAIntroPage page];
    introPage4.bgImage = [UIImage imageNamed:@"Tutorial_Share"];
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:self.view.frame andPages:@[introPage, introPage1, introPage2, introPage3, introPage4]];
    introView.delegate = self;
    [introView showInView:self.view animateDuration:0.3];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Tutorial View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)introDidFinish:(EAIntroView *)introView
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"App First Time Use"] isEqualToString:@"YES"]) {
        [(AppDelegate *) [[UIApplication sharedApplication] delegate] setupSubscribeView];
    } else {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
    }
}

@end
