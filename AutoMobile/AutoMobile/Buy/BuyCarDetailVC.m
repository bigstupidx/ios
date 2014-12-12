//
//  BuyCarDetailVC.m
//  AutoMobile
//
//  Created by Zune Moe on 27/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "BuyCarDetailVC.h"
#import "BuyCarDetailView.h"

#import "SwipeView.h"
#import "Car.h"

@interface BuyCarDetailVC () <SwipeViewDataSource, SwipeViewDelegate>
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIImageView *swipeViewBackgroundImageView;
@end

@implementation BuyCarDetailVC

- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // showing white status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // preventing weird inset
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets: NO];
    }
    
    // navigation bar work
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1, 1)];
    [shadow setShadowColor:[UIColor clearColor]];
    [shadow setShadowBlurRadius:1];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // swipeview configuration
    self.swipeView.alignment = SwipeViewAlignmentCenter;
    self.swipeView.pagingEnabled = YES;
    self.swipeView.itemsPerPage = 1;
    self.swipeView.truncateFinalPage = YES;
    
    self.swipeView.currentItemIndex = self.currentIndex;
    [self.swipeView reloadData];
    
    self.swipeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"automobile_pattern.png"]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        [self.delegate buyCarDetailVCWasPopped:self.carArray offset:self.offset];
    }
}

- (void)loadMore:(__unused id)sender
{
    self.offset++;
    self.parameters[@"offset"] = @(self.offset);
    [Car getCarsWithParameters:self.parameters block:^(NSArray *cars, NSError *error) {
        if (cars.count > 0) {
            for (Car *car in cars) {
                [self.carArray addObject:car];
            }
            [self.swipeView reloadData];
        }
    }];
}

- (BuyCarDetailView *)viewAtIndex:(NSInteger)index
{
    BuyCarDetailView *view = (BuyCarDetailView *)[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCarDetailView"];
    view.selectedCar = self.carArray[index];
    return view;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.carArray.count + 1;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index < self.carArray.count) {
        view = [self viewAtIndex:index].view;
        return view;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        indicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [view addSubview:indicator];
        [self loadMore:nil];
        return view;
    }
    return nil;
}

@end
