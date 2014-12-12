//
//  EventsDetailsVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "EventsDetailsVC.h"
#import "EventDetailsView.h"

#import "Event.h"
#import "User.h"

#import "SwipeView.h"
#import "GHContextMenuView.h"
#import "TWMessageBarManager.h"
#import "ZMFMDBSQLiteHelper.h"

@interface EventsDetailsVC () <SwipeViewDataSource, SwipeViewDelegate, GHContextOverlayViewDataSource, GHContextOverlayViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) GHContextMenuView *contextMenu;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;
@property (assign, nonatomic) int swipeViewCurrentIndex; // START POINT
@end

@implementation EventsDetailsVC

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
    self.db = [ZMFMDBSQLiteHelper new];
    [self.db createAttendTable];
    
    // swipeview configuration
    self.swipeView.alignment = SwipeViewAlignmentCenter;
    self.swipeView.pagingEnabled = YES;
    self.swipeView.itemsPerPage = 1;
    self.swipeView.truncateFinalPage = YES;
    
    self.swipeView.currentItemIndex = self.currentIndex;
    [self.swipeView reloadData];
    
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.layer.cornerRadius = 17;
	[self.backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Event Details View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.contextMenu = [[GHContextMenuView alloc] init];
//    self.contextMenu.delegate = self;
//    self.contextMenu.dataSource = self;
//    [self.swipeView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self.contextMenu action:@selector(longPressDetected:)]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        [self.delegate eventsDetailsVCWasDismissed:self.eventsArray offset:self.offset];
    }
}
- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loadMore:(__unused id)sender
{
    self.offset++;
    self.parameters[@"offset"] = @(self.offset);
    [Event getAllEvents:self.parameters block:^(NSArray *events, NSError *error) {
        if (events.count > 0) {
            for (Event *event in events) {
                [self.eventsArray addObject:event];
            }
            [self.swipeView reloadData];
        }
    }];
}

- (NSInteger) numberOfMenuItems
{
    return 3;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    NSArray *indexes = [self.swipeView indexesForVisibleItems]; // this cause the problem // SMT //
    if ([[self.eventsArray objectAtIndex:[indexes.firstObject integerValue]] isKindOfClass:[Event class]]) {
        Event *event = [self.eventsArray objectAtIndex:[indexes.firstObject integerValue]];
        switch (index) {
            case 0:
            {
                NSDictionary *dictionary = [self.db executeQuery:[NSString stringWithFormat:@"select * from Attend where eventid = '%d'", event.id]].firstObject;
                NSLog(@"attend: %@", [self.db executeQuery:[NSString stringWithFormat:@"select * from Attend where eventid = '%d'", event.id]].firstObject);
                if ([dictionary[@"eventid"] isEqualToString:[NSString stringWithFormat:@"%d", event.id]]) {
                    NSLog(@"STAR FULL");
                    imageName = @"Favorites_Full";
                } else {
                    NSLog(@"STAR LINE");
                    imageName = @"Favorites_Line";
                }
            }
                break;
            case 1:
                imageName = @"Facebook";
                break;
            case 2:
                imageName = @"Email_Circle";
                break;
                
            default:
                break;
        }
    }
    else {
        
        Event *event = [self.eventsArray objectAtIndex:_swipeViewCurrentIndex];
        switch (index) {
            case 0:
            {
                NSDictionary *dictionary = [self.db executeQuery:[NSString stringWithFormat:@"select * from Attend where eventid = '%d'", event.id]].firstObject;
                NSLog(@"attend: %@", [self.db executeQuery:[NSString stringWithFormat:@"select * from Attend where eventid = '%d'", event.id]].firstObject);
                if ([dictionary[@"eventid"] isEqualToString:[NSString stringWithFormat:@"%d", event.id]]) {
                    NSLog(@"STAR FULL");
                    imageName = @"Favorites_Full";
                } else {
                    NSLog(@"STAR LINE");
                    imageName = @"Favorites_Line";
                }
            }
                break;
            case 1:
                imageName = @"Facebook";
                break;
            case 2:
                imageName = @"Email_Circle";
                break;
                
            default:
                break;
        }
    }
    return [UIImage imageNamed:imageName];

}

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSArray *indexes = [self.swipeView indexesForVisibleItems];
    Event *event = [self.eventsArray objectAtIndex:[indexes.firstObject integerValue]];
    switch (selectedIndex) {
        case 0:
            // Join event pressed
        {
            EventDetailsView *swipeContentView = [self viewAtIndex:[indexes.firstObject integerValue]];
            
            NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            if (userInfo) {
                NSDictionary *dictionary = [self.db executeQuery:[NSString stringWithFormat:@"select * from Attend where eventid = '%d'", event.id]].firstObject;
                NSDictionary *parameter = @{@"EventID": @(event.id),
                                            @"UserID": userInfo[@"userid"]};
                if ([dictionary[@"eventid"] isEqualToString:[NSString stringWithFormat:@"%d", event.id]]) {
                    [User userUnAttendEvent:parameter block:^(NSDictionary *status, NSError *error) {
                        if ([status[@"status"] isEqualToNumber:@1]) {
                            [self.db executeUpdate:[NSString stringWithFormat:@"delete from Attend where eventid = '%d'", event.id]];
                            [swipeContentView.contextMenu reloadData];
                            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Successful" description:@"Successfully unjoined this event" type:TWMessageBarMessageTypeSuccess duration:2.0];
                        }
                    }];
                } else {
                    [User userAttendEvent:parameter block:^(NSDictionary *status, NSError *error) {
                        if ([status[@"status"] isEqualToNumber:@1]) {
                            [self.db insertAttendIntoTable:event.id];
                            [swipeContentView.contextMenu reloadData];
                            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Successful" description:@"Successfully joined this event" type:TWMessageBarMessageTypeSuccess duration:2.0];
                        }
                    }];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Please login first to attend an event" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 1:
            // Facebook selected
        {
            SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookSheet setInitialText:event.name];
            [facebookSheet addURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", MMJunctionShareURL, event.id]]];
            [self presentViewController:facebookSheet animated:YES completion:NULL];
        }
            break;
        case 2:
            // Mail selected
        {
            if ([MFMailComposeViewController canSendMail]) {
                NSString *mailTitle = event.name;
                NSString *mailBody = [NSString stringWithFormat:@"<h2>%@</h2> \n\n%@ \n\n<a href=\"%@%d\">%@%d</a>",event.name, event.event_description, MMJunctionShareURL, event.id, MMJunctionShareURL, event.id];
                
                MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
                mailComposer.mailComposeDelegate = self;
                [mailComposer setSubject:mailTitle];
                [mailComposer setMessageBody:mailBody isHTML:YES];
                [self presentViewController:mailComposer animated:YES completion:NULL];

            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please set up a Mail account in order to send email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}

- (EventDetailsView *)viewAtIndex:(NSInteger)index
{
    EventDetailsView *view = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailsView"];
    
    if ([self.eventsArray[index] isKindOfClass:[Event class]]) {
        Event *event = self.eventsArray[index];
        view.event = event;
        view.eventColor = self.eventsColors[event.tags];
        GHContextMenuView *contextMenu = [[GHContextMenuView alloc] init];
        contextMenu.delegate = self;
        contextMenu.dataSource = self;
        view.contextMenu = contextMenu;
//        [self addChildViewController:view];
    } else if ([self.eventsArray[index] isKindOfClass:[Ad class]]) {
        view.ad = self.eventsArray[index];
    }
    return view;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.eventsArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index < self.eventsArray.count) {
        view = [self viewAtIndex:index].view;
        return view;        
    }
//    else {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor darkGrayColor];
//        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//        indicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
//        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        [indicator startAnimating];
//        [view addSubview:indicator];
//        [self loadMore:nil];
//        return view;
//    }
    return nil;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.view.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    _swipeViewCurrentIndex = swipeView.currentItemIndex;
    _swipeViewCurrentIndex++;
//    EventDetailsView* detailView = [self viewAtIndex:swipeView.currentItemIndex];
//    [detailView.contextMenu reloadData];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
