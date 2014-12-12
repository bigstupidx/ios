//
//  HotEventsVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "HotEventsVC.h"
#import "EventsCell.h"
#import "EventsDetailsVC.h"

// model
#import "Event.h"

// vendors
#import "Reachability.h"
#import "ZMFMDBSQLiteHelper.h"
#import "ZMTransitionManager.h"
#import "Colours.h"
#import "UIStoryboard+MultipleStoryboards.h"

@interface HotEventsVC () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *leftMenuImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightMenuImageView;
@property (weak, nonatomic) IBOutlet UIView *errorViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *errorActivityIndicator;
@property (strong, nonatomic) NSArray *allEventsArray;
@property (strong, nonatomic) NSArray *cityEventsArray;
@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) ZMTransitionManager *transitionManager;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HotEventsVC
{
    NSInteger offset;
    NSDictionary *colors;
    NSString *selectedCity;
    NSString *selectedCategory;
    BOOL fetchingMoreDataFinished;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    offset = 1;
    selectedCity = @"All";
    selectedCategory = @"Any";
    fetchingMoreDataFinished = YES;
    
    self.parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"limit": @10,
                                                                      @"offset": @(offset)}];
    
    self.transitionManager = [[ZMTransitionManager alloc] init];
    self.db = [ZMFMDBSQLiteHelper new];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reset:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading events..."];
    [self setRefreshControl:self.refreshControl];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;
    
    colors = @{@"Art": [UIColor infoBlueColor],
               @"Business": [UIColor successColor],
               @"Community": [UIColor warningColor],
               @"Dhama": [UIColor tealColor],
               @"Education": [UIColor denimColor],
               @"Entertainment": [UIColor violetColor],
               @"Film": [UIColor watermelonColor],
               @"IT": [UIColor periwinkleColor],
               @"Literature": [UIColor carrotColor],
               @"Promotion": [UIColor skyBlueColor],
               @"Sports": [UIColor emeraldColor],
               @"Volunteering": [UIColor oliveColor]
               };
    
    self.leftMenuImageView.layer.cornerRadius = 17;
    self.leftMenuImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftMenuImageView.layer.borderWidth = 0.3;
    self.rightMenuImageView.layer.cornerRadius = 17;
    self.rightMenuImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightMenuImageView.layer.borderWidth = 0.3;
    
    [self.leftMenuImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftMenu)]];
    [self.rightMenuImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRightMenu)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HotLeftMenuDismissed:) name:@"HotLeftMenuDismissed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HotRightMenuDismissed:) name:@"HotRightMenuDismissed" object:nil];
    
    [self.db createHotEventTable];
    self.eventsArray = [self.db retrieveFromEventTable:@"select * from HotEvent"];
    [self.tableView reloadData];
    
    if (self.reachable) {
        [self reloadEvents:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Hot Events View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)reset:(__unused id)sender
{
    offset = 1;
    [self reloadEvents:nil];
}

- (void)HotLeftMenuDismissed:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    selectedCity = userInfo[@"city"];
    if ([selectedCity isEqualToString:@"All"]) {
        self.eventsArray = [self filterEventCategoy:self.allEventsArray];
        [self.tableView reloadData];
    } else {
        [Event getAllEventsWithLocation:selectedCity block:^(NSArray *events, NSError *error) {
            self.cityEventsArray = events;
            self.eventsArray = [self filterEventCategoy:events];
            [self.tableView reloadData];
            
            for (Event *event in events) {
                [self.db insertIntoHotEventTable:event];
            }
        }];
    }
}

- (void)HotRightMenuDismissed:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    selectedCategory = userInfo[@"category"];
    if ([selectedCity isEqualToString:@"All"]) {
        self.eventsArray = [self filterEventCategoy:self.allEventsArray];
        [self.tableView reloadData];
    } else {
        self.eventsArray = [self filterEventCategoy:self.cityEventsArray];
        [self.tableView reloadData];
    }
}

- (NSArray *)filterEventCategoy:(NSArray *)array
{
    NSMutableArray *events = [NSMutableArray array];
    if ([selectedCategory isEqualToString:@"Any"]) {
        return array;
    } else {
        for (Event *event in array) {
            if ([selectedCategory isEqualToString:event.tags]) {
                [events addObject:event];
            }
        }
        return events;
    }
    return nil;
}

- (void)errorViewHidden:(BOOL)hidden text:(NSString *)text hideActivityIndicator:(BOOL)aiHidden hideButton:(BOOL)bHidden
{
    self.errorViewContainer.hidden = hidden;
    self.errorLabel.text = text;
    self.errorActivityIndicator.hidden = aiHidden;
    if (aiHidden) {
        [self.errorActivityIndicator stopAnimating];
    } else {
        [self.errorActivityIndicator startAnimating];
    }
    self.errorButton.hidden = bHidden;
}

- (IBAction)reloadEvents:(id)sender {
    self.parameters[@"offset"] = @(offset);
    if (self.eventsArray.count == 0) {
        [self errorViewHidden:NO text:@"Searching events..." hideActivityIndicator:NO hideButton:YES];
    }
    
    [Event getHotEvents:^(NSArray *events, NSError *error) {
        if (events.count > 0) {
            //[self loadMoreEvents:events];
            self.eventsArray = events;
            [self.tableView reloadData];
        }
        
        if (self.eventsArray.count > 0) {
            [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
        } else {
            [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
        }
        
        for (Event *event in events) {
            [self.db insertIntoHotEventTable:event];
        }
        fetchingMoreDataFinished = YES;
        [self.refreshControl endRefreshing];
        offset++;
    }];
//    [Event getFeaturedEvents:self.parameters block:^(NSArray *events, NSError *error) {
//        
//    }];
}

//- (void)loadMoreEvents:(NSArray *)events
//{
////    if (offset == 1) {
////        self.eventsArray = events;
////        return;
////    }
////    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.eventsArray];
////    for (Event *event in events) {
////        [temp addObject:event];
////    }
////    self.eventsArray = temp;
//    //NO need to use offset. pass all downloaded hot events to data source
//    self.eventsArray = events;
//}

//- (void)eventsDetailsVCWasDismissed:(NSArray *)eventsArray offset:(NSInteger)_offset
//{
//    offset = _offset;
//    self.eventsArray = [eventsArray mutableCopy];
//    [self.tableView reloadData];
//}

- (void)showLeftMenu
{
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentLeft];
}

- (void)showRightMenu
{
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentRight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCell:self.eventsArray[indexPath.row] indexPath:indexPath];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ((indexPath.section == [self.tableView numberOfSections] - 1) && (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) && fetchingMoreDataFinished) {
//        fetchingMoreDataFinished = NO;
//        [self reloadEvents:nil];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    UIStoryboard *sb = [UIStoryboard getEventsStoryboard];
    EventsDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"EventsDetailsVC"];
    vc.transitioningDelegate = self;
    
    vc.currentIndex = self.tableView.indexPathForSelectedRow.row;
    vc.eventsArray = self.eventsArray.mutableCopy;
    vc.eventsColors = colors;
    vc.parameters = self.parameters;
    vc.offset = offset;
    //vc.delegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - UIVieControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    self.transitionManager.transitionTo = MODAL;
    return self.transitionManager;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionManager.transitionTo = INITIAL;
    return self.transitionManager;
}

@end
