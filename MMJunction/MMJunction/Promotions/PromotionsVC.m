//
//  PromotionsVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/26/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "PromotionsVC.h"
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

@interface PromotionsVC () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *leftMenuImageView;
@property (weak, nonatomic) IBOutlet UIView *errorViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *errorActivityIndicator;
@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) ZMTransitionManager *transitionManager;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation PromotionsVC
{
    NSInteger offset;
    NSDictionary *colors;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    offset = 1;
    self.transitionManager = [[ZMTransitionManager alloc] init];
    self.db = [ZMFMDBSQLiteHelper new];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
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
    
    [self.leftMenuImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftMenu)]];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reset:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading events..."];
    [self setRefreshControl:self.refreshControl];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;
    
    [self.db createHotEventTable];
    self.eventsArray = [self.db retrieveFromEventTable:@"select * from PromotionEvent"];
    [self.tableView reloadData];
    if (self.reachable) {
        [self reloadEvents:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Promotion View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)reset:(__unused id)sender
{
    [self reloadEvents:nil];
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
    if (self.eventsArray.count == 0) {
        [self errorViewHidden:NO text:@"Searching events..." hideActivityIndicator:NO hideButton:YES];
    }
    
    [Event getPromotionEvents:^(NSArray *events, NSError *error) {
        if (events.count > 0) {
            self.eventsArray = events;
            [self.tableView reloadData];
        }
        
        if (self.eventsArray.count > 0) {
            [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
        } else {
            [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
        }
        
        for (Event *event in events) {
            //[self.db insertIntoHotEventTable:event];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)showLeftMenu
{
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentLeft];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    UIStoryboard *sb = [UIStoryboard getEventsStoryboard];
    EventsDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"EventsDetailsVC"];
    vc.transitioningDelegate = self;
    
    vc.currentIndex = self.tableView.indexPathForSelectedRow.row;
    vc.eventsArray = self.eventsArray.mutableCopy;
    vc.eventsColors = colors;
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
