//
//  EventsVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "EventsVC.h"
#import "EventsCell.h"
#import "EventsDetailsVC.h"
#import "AdCell.h"

// model
#import "Event.h"
#import "Ad.h"

// vendors
#import "Reachability.h"
#import "ZMFMDBSQLiteHelper.h"
#import "ZMTransitionManager.h"
#import "Colours.h"

@interface EventsVC () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *leftMenuImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightMenuImageView;
@property (weak, nonatomic) IBOutlet UIView *searchViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewContainerTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *searchViewInnerContainer;
@property (weak, nonatomic) IBOutlet UITextField *searchViewStartDate;
@property (weak, nonatomic) IBOutlet UITextField *searchViewEndDate;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSArray *allEventsArray; // allEventsArray and cityEventsArray are used to hold temp data due to internal filter processes of city and categories, after the data is processed transfer it to eventsArray to show
@property (strong, nonatomic) NSArray *cityEventsArray;
@property (strong, nonatomic) NSArray *subscribedEventsArray;
@property (strong, nonatomic) NSArray *eventsArray; // use eventsArray for tableView
@property (strong, nonatomic) NSArray *adsArray;

@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) ZMTransitionManager *transitionManager;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIDatePicker *datePicker;



@property (strong, nonatomic) IBOutlet UIView *errorIndicatorContainer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *lblIndicatorStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnReload;

@end

@implementation EventsVC
{
    NSInteger offset;
    NSDictionary *colors;
    NSString *selectedCity;
    NSString *selectedCategory;
    BOOL fetchingMoreDataFinished; // boolean to prevent multiple api requests to server
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedCity = @"All";
    selectedCategory = @"Subscribed";
    fetchingMoreDataFinished = YES;
    
    offset = 1;
    self.transitionManager = [[ZMTransitionManager alloc] init];
    self.db = [ZMFMDBSQLiteHelper new];
        
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    self.parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"limit": @10,
                                                                      @"offset": @(offset)}];
    
    // setup date picker for search view
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.searchViewStartDate.inputView = self.datePicker;
    self.searchViewEndDate.inputView = self.datePicker;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //self.searchViewStartDate.text = [formatter stringFromDate:[NSDate date]];
    
    // setup pull to refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reset:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading events..."];
    [self setRefreshControl:self.refreshControl];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;
    
    // hide search view initially
    self.searchViewContainerTopConstraint.constant = -79;
    self.searchViewInnerContainer.hidden = YES;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventLeftMenuDismissed:) name:@"EventLeftMenuDismissed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventRightMenuDismissed:) name:@"EventRightMenuDismissed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubscribedEvents:) name:@"updateSubscribedEvents" object:nil];
    
    [self.db createEventTable];
    self.eventsArray = [self.db retrieveFromEventTable:@"select * from Event"];
    [self.tableView reloadData];
    
    if (self.reachable) {
        NSArray *subscribeIdsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscribe_id"];
        NSMutableString *subscribeId = [NSMutableString string];
        if (subscribeIdsArray.count > 0) {
            for (int i = 0; i < subscribeIdsArray.count; i++) {
                [subscribeId appendFormat:@"%@,", [subscribeIdsArray[i] allValues].firstObject];
            }
        }
        [Event getSubscribedEvents:@{@"subscribe_id": subscribeId} block:^(NSArray *events, NSError *error) {
            self.subscribedEventsArray = events;
            self.eventsArray = self.subscribedEventsArray;
            [self.tableView reloadData];
        }];
        
        // fetch ads at startup
        [Ad getAds:^(NSArray *ads, NSError *error) {
            self.adsArray = ads;
        }];
        if ([selectedCity isEqualToString:@"All"]) {
            if ([subscribeId isEqualToString:@""]) {
                [self reload:nil];
            }
            self.parameters[@"offset"] = @(offset);
            [Event getAllEvents:self.parameters block:^(NSArray *events, NSError *error) {
                [self loadMoreEvents:events]; // add data into allEventsArray
                // save to db only if it is Event class
                for (id event in events) {
                    if ([event isKindOfClass:[Event class]]) {
                        [self.db insertIntoEventTable:event];
                    }
                }
                
                fetchingMoreDataFinished = YES; // now new data is fetched so open way for another api request
                offset++;
            }];
        } else {
            [Event getAllEventsWithLocation:selectedCity block:^(NSArray *events, NSError *error) {
                self.cityEventsArray = events;
//                if (self.adsArray.count >0) {
//                    self.eventsArray = [self combineEventsAndAds:events ads:self.adsArray];
//                } else {
//                    self.eventsArray = events;
//                }
//                [self.tableView reloadData];
                
                for (id event in events) {
                    if ([event isKindOfClass:[Event class]]) {
                        [self.db insertIntoEventTable:event];
                    }
                }
            }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Events View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)errorViewHidden:(BOOL)hidden text:(NSString *)text hideActivityIndicator:(BOOL)aiHidden hideButton:(BOOL)bHidden
{
    self.errorIndicatorContainer.hidden = hidden;
    self.lblIndicatorStatus.text = text;
    self.spinner.hidden = aiHidden;
    if (aiHidden) {
        [self.spinner stopAnimating];
    } else {
        [self.spinner startAnimating];
    }
    self.btnReload.hidden = bHidden;
}


//- (void)activityViewHidden:(BOOL)hidden
//{
//    _indicatorView.hidden = hidden;
//    if (hidden) {
//        [_indicator stopAnimating];
//    } else {
//        [_indicator startAnimating];
//    }
//}


- (void)datePickerChanged:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (self.searchViewStartDate.isEditing) {
        self.searchViewStartDate.text = [formatter stringFromDate:[picker date]];
    }
    if (self.searchViewEndDate.isEditing) {
        self.searchViewEndDate.text = [formatter stringFromDate:[picker date]];
    }
}

- (NSArray *)combineEventsAndAds:(NSArray *)events ads:(NSArray *)ads
{
    // combine events and ads into single array (1 ad after 3 events)
    int initialIndex = 3; // ad start from index 3 and every 3 other events
    int counter = 4; // counter index for ad position after initial index 7, 11, 15
    int adsCount = events.count / 3; // number of ads for a given events
    int currentAdsIndex = 0;
    int currentEventIndex = 0;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:events.count + adsCount]; // final combined array
    for (int i = 0; i < events.count + adsCount; i++) {
        if (i == initialIndex) { // array index for ad, add ad into array
            initialIndex += counter; // next ad index
            [array addObject:ads[currentAdsIndex]];
            currentAdsIndex++; // current ad index from ads array
            if (currentAdsIndex >= ads.count) { // no more new ad to show, reset index
                currentAdsIndex = 0;
            }
        } else { // array index for event, add event into array
            [array addObject:events[currentEventIndex]];
            currentEventIndex++; // current event index from events array
        }
    }
    return array.mutableCopy;
}

- (IBAction)showHideSearchView:(id)sender {
    if (self.searchViewContainerTopConstraint.constant == -79) {
        // show search view
        [UIView animateWithDuration:0.5 animations:^{
            self.searchViewInnerContainer.hidden = NO;
            self.searchViewContainerTopConstraint.constant = 0; // way of doing animation with autolayout, will properly do the animation, only if you call layoutIfNeeded.
            [self.view layoutIfNeeded];
        }];
    } else if (self.searchViewContainerTopConstraint.constant == 0) {
        // do the search algorithm
        if (![self.searchViewStartDate.text isEqualToString:@""]) {
            self.eventsArray = [self filterEventWithDate:self.searchViewStartDate.text endDate:self.searchViewEndDate.text];
            [self.tableView reloadData];
            if (self.eventsArray.count > 0) {
                [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
            }
            else {
                [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
            }
            
        }
        
        // hide search view
        [self.searchViewStartDate resignFirstResponder];
        [self.searchViewEndDate resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            self.searchViewContainerTopConstraint.constant = -79;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            // hide container view due to search view is visible while left/ right menu views are showing
            self.searchViewInnerContainer.hidden = YES;
        }];
    }
}

- (NSArray *)filterEventWithDate:(NSString *)startDateString endDate:(NSString *)endDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:startDateString];
    NSDate *endDate = nil;
    if (endDateString) {
        endDate = [formatter dateFromString:endDateString];
    }
    NSMutableArray *filteredArray = [NSMutableArray array];
    for (id item in self.allEventsArray) {
        if ([item isKindOfClass:[Event class]]) {
            Event *event = (Event *)item;
            NSDate *eventStartDate = [formatter dateFromString:event.startdate];
            NSDate *eventEndDate = [formatter dateFromString:event.enddate];
            if (!endDate) { // filter between start and end dates
                if (([startDate compare:eventEndDate] == NSOrderedSame || [startDate compare:eventEndDate] == NSOrderedAscending) && ([endDate compare:eventStartDate] == NSOrderedSame || [endDate compare:eventStartDate] == NSOrderedDescending)) {
                    [filteredArray addObject:event];
                }
            } else { // filter from start to end of array
                if (([startDate compare:eventEndDate] == NSOrderedSame || [startDate compare:eventEndDate] == NSOrderedAscending)) {
                    [filteredArray addObject:event];
                }
            }
        }
    }
    return filteredArray;
}

- (void)reset:(__unused id)sender
{
    // reset data on pull to refresh
    if ([selectedCity isEqualToString:@"All"]) {
        selectedCategory = @"Any";
        offset = 1;
        [self reload:nil];
    } else {
        [self.refreshControl endRefreshing];
    }
}

- (void)reload:(__unused id)sender
{
    // fetch data
    self.parameters[@"offset"] = @(offset);
    [Event getAllEvents:self.parameters block:^(NSArray *events, NSError *error) {
        [self loadMoreEvents:events]; // add data into allEventsArray
        NSArray *categoryFilteredArray = [self filterEventCategoy:self.allEventsArray]; // filter category
        if (self.adsArray.count > 0) { // add ads if there are ads
            self.eventsArray = [self combineEventsAndAds:categoryFilteredArray ads:self.adsArray];
        } else { // no ads
            self.eventsArray =  categoryFilteredArray;
        }
        [self.tableView reloadData];

        // save to db only if it is Event class
        for (id event in events) {
            if ([event isKindOfClass:[Event class]]) {
                [self.db insertIntoEventTable:event];
            }
        }
        
        fetchingMoreDataFinished = YES; // now new data is fetched so open way for another api request
        [self.refreshControl endRefreshing];
        offset++;
    }];
}

- (void)loadMoreEvents:(NSArray *)events
{
    // append data to allEventsArray if offset is not 1
    if (offset == 1) {
        self.allEventsArray = events;
        return;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.allEventsArray];
    for (Event *event in events) {
        [temp addObject:event];
    }
    self.allEventsArray = temp;
}

//- (void)eventsDetailsVCWasDismissed:(NSArray *)eventsArray offset:(NSInteger)_offset
//{
//    offset = _offset;
//    self.eventsArray = [eventsArray mutableCopy];
//    [self.tableView reloadData];
//}

- (void)EventLeftMenuDismissed:(NSNotification *)notification
{
//    [self activityViewHidden:NO];
    [self errorViewHidden:NO text:@"Searching events..." hideActivityIndicator:NO hideButton:YES];
    NSDictionary *userInfo = notification.userInfo;
    selectedCity = userInfo[@"city"]; // update city
    if ([selectedCity isEqualToString:@"All"]) { // update data
//        [self activityViewHidden:YES];
        if (self.allEventsArray.count > 0) {
            [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
        }
        else {
            [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
        }
        self.eventsArray = [self filterEventCategoy:self.allEventsArray];
        [self.tableView reloadData];
    } else { // city selected, use city api to request new data
        [Event getAllEventsWithLocation:selectedCity block:^(NSArray *events, NSError *error) {
            if (events.count > 0) {
                [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
            }
            else {
                [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
            }

            self.cityEventsArray = events;
            self.eventsArray = [self filterEventCategoy:events];
            [self.tableView reloadData];
            
            for (Event *event in events) {
                [self.db insertIntoEventTable:event];
            }
        }];
    }
}

- (void)EventRightMenuDismissed:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    selectedCategory = userInfo[@"category"]; // update category
    if ([selectedCategory isEqualToString:@"Subscribed"]) {
        self.eventsArray = self.subscribedEventsArray;
        [self.tableView reloadData];
        if (self.eventsArray.count > 0) {
            [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
        }
        else {
            [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
        }

    } else {
        if ([selectedCity isEqualToString:@"All"]) {
            self.eventsArray = [self filterEventCategoy:self.allEventsArray];
            [self.tableView reloadData];
            if (self.eventsArray.count > 0) {
                [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
            }
            else {
                [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
            }

        } else {
            self.eventsArray = [self filterEventCategoy:self.cityEventsArray];
            [self.tableView reloadData];
            if (self.eventsArray.count > 0) {
                [self errorViewHidden:YES text:nil hideActivityIndicator:YES hideButton:YES];
            }
            else {
                [self errorViewHidden:NO text:@"No events found right now." hideActivityIndicator:YES hideButton:NO];
            }

        }
    }
}

- (void)updateSubscribedEvents:(NSNotification*)notification
{
    NSArray *subscribeIdsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscribe_id"];
    NSMutableString *subscribeId = [NSMutableString string];
    if (subscribeIdsArray.count > 0) {
        for (int i = 0; i < subscribeIdsArray.count; i++) {
            [subscribeId appendFormat:@"%@,", [subscribeIdsArray[i] allValues].firstObject];
        }
    }
    [Event getSubscribedEvents:@{@"subscribe_id": subscribeId} block:^(NSArray *events, NSError *error) {
        self.subscribedEventsArray = events;
//        self.eventsArray = self.subscribedEventsArray;
//        [self.tableView reloadData];
    }];

}

- (NSArray *)filterEventCategoy:(NSArray *)array
{
    NSMutableArray *events = [NSMutableArray array];
    if ([selectedCategory isEqualToString:@"Any"] || [selectedCategory isEqualToString:@"Subscribed"]) {
        return array;
    } else {
        // filter event by category
        for (Event *event in array) {
            if ([selectedCategory isEqualToString:event.tags]) {
                [events addObject:event];
            }
        }
        return events;
    }
    return nil;
}
- (IBAction)showLeftMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentLeft];
}

- (IBAction)showRightMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentRight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.eventsArray[indexPath.row] isKindOfClass:[Event class]]) {
        static NSString *CellIdentifier = @"Cell";
        EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setupCell:self.eventsArray[indexPath.row] indexPath:indexPath];
        return cell;
    } else if ([self.eventsArray[indexPath.row] isKindOfClass:[Ad class]]) {
        static NSString *CellIdentifier = @"Ad Cell";
        AdCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[AdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setupCell:self.eventsArray[indexPath.row]];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.eventsArray[indexPath.row] isKindOfClass:[Event class]]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        EventsDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsDetailsVC"];
        vc.transitioningDelegate = self;
        
        vc.currentIndex = self.tableView.indexPathForSelectedRow.row;
        vc.eventsArray = self.eventsArray.mutableCopy;
        vc.eventsColors = colors;
        vc.parameters = self.parameters;
        vc.offset = offset;
        [self presentViewController:vc animated:YES completion:NULL];
    } else if ([self.eventsArray[indexPath.row] isKindOfClass:[Ad class]]) {
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == [self.tableView numberOfSections] - 1) && (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) && fetchingMoreDataFinished) { // fetch more event when the user scroll to the bottom of tableView
        if ([selectedCity isEqualToString:@"All"] && ![selectedCategory isEqualToString:@"Subscribed"]) {
            fetchingMoreDataFinished = NO; // prevent multiple api request until current process is finished
            [self reload:nil];
        }
    }
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
