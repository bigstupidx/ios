//
//  BuyCarListVC.m
//  AutoMobile
//
//  Created by Zune Moe on 24/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "BuyCarListVC.h"
#import "BuyCarListCell.h"
#import "BuyCarDetailVC.h"
#import "ShowCarDetailVC.h"
#import "User.h"

#import "Car.h"

#import "JDStatusBarNotification.h"
#import "ZMFMDBSQLiteHelper.h"

@interface BuyCarListVC () <UITableViewDataSource, UITableViewDelegate, BuyCarDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *carMutableArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation BuyCarListVC
{
    BOOL fetchingMoreDataFinished;
    NSInteger offset;
}

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
    fetchingMoreDataFinished = YES;
    offset = [self.parameters[@"offset"] integerValue];
    self.carMutableArray = [NSMutableArray arrayWithArray:self.carArray];
    self.title = @"Car List";//[NSString stringWithFormat:@"%@, %@", self.brand, self.model];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing feeds..."];
    [self setRefreshControl:self.refreshControl];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;
    
    [self setBackBtn];
}

- (void)setBackBtn
{
    self.navigationItem.backBarButtonItem = nil;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back_unselected.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateSelected];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)dismissThisView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Custom methods

- (void) JDStatusBarHidden:(BOOL)yes
{
    if(yes) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        [JDStatusBarNotification showWithStatus:@"Loading more cars..." styleName:@"StatusBarStyle"];
        [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)reload:(__unused id)sender
{
    offset = 1;
    self.parameters[@"offset"] = @(offset);
    [Car getCarsWithParameters:self.parameters block:^(NSArray *cars, NSError *error) {
        if (cars.count > 0) {
            self.carMutableArray = [cars mutableCopy];
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadMore:(__unused id)sender
{
    [self JDStatusBarHidden:NO];
    offset++;
    self.parameters[@"offset"] = @(offset);
    [Car getCarsWithParameters:self.parameters block:^(NSArray *cars, NSError *error) {
        if (cars.count > 0) {
            for (Car *car in cars) {
                [self.carMutableArray addObject:car];
            }
            [self.tableView reloadData];
        }
        fetchingMoreDataFinished = YES;
        [self JDStatusBarHidden:YES];
    }];
}

- (void)buyCarDetailVCWasPopped:(NSArray *)carList offset:(NSInteger)_offset
{
    offset = _offset;
    self.carMutableArray = [carList mutableCopy];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Buy Car Detail Segue"]) {
//        BuyCarDetailVC *vc = segue.destinationViewController;
//        vc.carArray = self.carMutableArray;
//        vc.currentIndex = self.tableView.indexPathForSelectedRow.row;
//        vc.offset = offset;
//        vc.parameters = self.parameters;
//        vc.delegate = self;
        MyCar* mycarobj = (MyCar*)self.carMutableArray[self.tableView.indexPathForSelectedRow.row];
        ShowCarDetailVC* vc = segue.destinationViewController;
        
        [User getUserWithId:[mycarobj.userid intValue] bloc:^(User *user, NSError *error) {

            if (!error) {
                vc.userinfo = user;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfo" object:user];
            }
        }];
        
        
        vc.carinfo = (MyCar*)self.carMutableArray[self.tableView.indexPathForSelectedRow.row];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carMutableArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BuyCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BuyCarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setupCell:(MyCar *)self.carMutableArray[indexPath.row]];
    
    return cell;
}

//#pragma mark - UITableViewDelegate Methods
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ((indexPath.section == [self.tableView numberOfSections] - 1) && (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) && fetchingMoreDataFinished) {
//        fetchingMoreDataFinished = NO;
//        [self loadMore:nil];
//    }
//}

@end
