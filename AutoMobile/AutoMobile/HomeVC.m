//
//  HomeVC.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "HomeVC.h"
#import "UIStoryboard+MultipleStoryboards.h"

@interface HomeVC ()
@property (strong, nonatomic) UITabBarController *tabController;
@property (weak, nonatomic) IBOutlet UIButton *sell;
@property (weak, nonatomic) IBOutlet UIButton *news;
@property (weak, nonatomic) IBOutlet UIButton *buy;
@property (weak, nonatomic) IBOutlet UIButton *me;
@property (weak, nonatomic) IBOutlet UIButton *nearby;
@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sell.titleLabel.font = [UIFont fontWithName:@"AuroraBT-BoldCondensed" size:20];
    self.buy.titleLabel.font = [UIFont fontWithName:@"AuroraBT-BoldCondensed" size:20];
    self.me.titleLabel.font = [UIFont fontWithName:@"AuroraBT-BoldCondensed" size:20];
    self.news.titleLabel.font = [UIFont fontWithName:@"AuroraBT-BoldCondensed" size:20];
    self.nearby.titleLabel.font = [UIFont fontWithName:@"AuroraBT-BoldCondensed" size:20];
    
//    // showing white status
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
//    // preventing weird inset
//    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
//        [self setAutomaticallyAdjustsScrollViewInsets: NO];
//    }
//
//    // navigation bar work
//    NSShadow *shadow = [[NSShadow alloc] init];
//    [shadow setShadowOffset:CGSizeMake(1, 1)];
//    [shadow setShadowColor:[UIColor clearColor]];
//    [shadow setShadowBlurRadius:1];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIStoryboard *sb = [UIStoryboard getNearbyStoryboard];
    UIViewController *nearbyVC = [sb instantiateInitialViewController];
    nearbyVC.tabBarItem.title = @"Nearby";
    
    sb = [UIStoryboard getSellStoryboard];
    UIViewController *sellVC = [sb instantiateInitialViewController];
    sellVC.tabBarItem.title = @"Sell";
    
    sb = [UIStoryboard getBuyStoryboard];
    UIViewController *buyVC = [sb instantiateInitialViewController];
    buyVC.tabBarItem.title = @"Buy";
    
    sb = [UIStoryboard getNewsStoryboard];
    UIViewController *newsVC = [sb instantiateInitialViewController];
    newsVC.tabBarItem.title = @"News";
    
    sb = [UIStoryboard getMeStoryboard];
    UIViewController *meVC = [sb instantiateInitialViewController];
    meVC.tabBarItem.title = @"Me";
    
    self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = @[sellVC, buyVC, nearbyVC, newsVC, meVC];
    
    [[[self.tabController.tabBar items] objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"ic_sell_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_sell_unselected"]];
    [[[self.tabController.tabBar items] objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"ic_buy_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_buy_unselected"]];
    [[[self.tabController.tabBar items] objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"ic_nearby_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_nearby_unselected"]];
    [[[self.tabController.tabBar items] objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"ic_news_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_news_unselected"]];
    [[[self.tabController.tabBar items] objectAtIndex:4] setFinishedSelectedImage:[UIImage imageNamed:@"ic_me_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_me_unselected"]];
    
    [[[self.tabController.tabBar items] objectAtIndex:0] setTitle:@"Sell"];
    UITabBarItem* item0 = [[self.tabController.tabBar items] objectAtIndex:0];
    item0.titlePositionAdjustment = UIOffsetMake(0.0, 4.0);
    [[[self.tabController.tabBar items] objectAtIndex:1] setTitle:@"Buy"];
    item0 = [[self.tabController.tabBar items] objectAtIndex:1];
    item0.titlePositionAdjustment = UIOffsetMake(0.0, 4.0);
    [[[self.tabController.tabBar items] objectAtIndex:2] setTitle:@"Directory"];
    item0 = [[self.tabController.tabBar items] objectAtIndex:2];
    item0.titlePositionAdjustment = UIOffsetMake(0.0, 4.0);
    [[[self.tabController.tabBar items] objectAtIndex:3] setTitle:@"News"];
    item0 = [[self.tabController.tabBar items] objectAtIndex:3];
    item0.titlePositionAdjustment = UIOffsetMake(0.0, 4.0);
    [[[self.tabController.tabBar items] objectAtIndex:4] setTitle:@"Me"];
    item0 = [[self.tabController.tabBar items] objectAtIndex:4];
    item0.titlePositionAdjustment = UIOffsetMake(0.0, 4.0);

    CGRect frame = CGRectMake(0, 0, 480, 49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    UIImage *i = [UIImage imageNamed:@"tabbarimg.png"];
    UIColor *c = [[UIColor alloc] initWithPatternImage:i];
    v.backgroundColor = c;
    [[self.tabController tabBar] insertSubview:v atIndex:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)sellTapped:(id)sender {
    self.tabController.selectedIndex = 0;
    [self.navigationController pushViewController:self.tabController animated:YES];
}

- (IBAction)buyTapped:(id)sender {
    self.tabController.selectedIndex = 1;
    [self.navigationController pushViewController:self.tabController animated:YES];
}

- (IBAction)nearbyTapped:(id)sender {
    self.tabController.selectedIndex = 2;
    [self.navigationController pushViewController:self.tabController animated:YES];
}

- (IBAction)newsTapped:(id)sender {
    self.tabController.selectedIndex = 3;
    [self.navigationController pushViewController:self.tabController animated:YES];
}

- (IBAction)meTapped:(id)sender {
    self.tabController.selectedIndex = 4;
    [self.navigationController pushViewController:self.tabController animated:YES];
}

@end
