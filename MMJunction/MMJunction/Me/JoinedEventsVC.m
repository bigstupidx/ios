//
//  JoinedEventsVC.m
//  MMJunction
//
//  Created by Zune Moe on 3/3/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "JoinedEventsVC.h"
#import "EventsCell.h"
#import "EventsDetailsVC.h"
#import "Colours.h"
#import "ZMTransitionManager.h"
#import "UIStoryboard+MultipleStoryboards.h"

@interface JoinedEventsVC () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) ZMTransitionManager *transitionManager;
@end

@implementation JoinedEventsVC
{
    NSDictionary *colors;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backImageView.layer.cornerRadius = 17;
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Me Joined Events View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.transitionManager = [[ZMTransitionManager alloc] init];
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.joinedEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCell:self.joinedEvents[indexPath.row] indexPath:indexPath];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.modalPresentationStyle = UIModalPresentationCustom;
//    
//    UIStoryboard *sb = [UIStoryboard getEventsStoryboard];
//    EventsDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"EventsDetailsVC"];
//    vc.transitioningDelegate = self;
//    
//    vc.currentIndex = self.tableView.indexPathForSelectedRow.row;
//    vc.eventsArray = self.joinedEvents.mutableCopy;
//    vc.eventsColors = colors;
//    [self presentViewController:vc animated:YES completion:NULL];
//}

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
