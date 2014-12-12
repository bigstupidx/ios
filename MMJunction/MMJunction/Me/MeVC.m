//
//  MeVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "MeVC.h"
#import "InfoVC.h"
#import "SubscribedVC.h"
#import "JoinedEventsVC.h"
#import "CheckinsVC.h"
#import "CheckinEventsVC.h"

#import "User.h"

#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "ZMTransitionManager.h"
#import "FBShimmeringView.h"

@interface MeVC () <UIViewControllerTransitioningDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *profileInfoContainer;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *loginoutButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *editViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *editViewName;
@property (weak, nonatomic) IBOutlet UITextField *editViewEmail;
@property (weak, nonatomic) IBOutlet UITextField *editViewPassword;
@property (weak, nonatomic) IBOutlet UITextField *editViewCurrentPassword;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (strong, nonatomic) ZMTransitionManager *transitionManager;

@property (strong, nonatomic) IBOutlet UIView *indicatorView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation MeVC
{
    BOOL editViewShowing;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.transitionManager = [[ZMTransitionManager alloc] init];
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    self.editViewName.delegate = self;
    self.editViewEmail.delegate = self;
    self.editViewPassword.delegate = self;
    self.editViewCurrentPassword.delegate = self;
    
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 60;
    self.profileImage.layer.borderWidth = 4;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _indicatorView.layer.cornerRadius = 3.5;
    
    if (userInfo) {
        if ([FBSession activeSession].isOpen) {
            self.editButton.hidden = YES;
        } else {
            self.editButton.hidden = NO;
        }
        
        [self updateProfileInfo:userInfo];
        [self.loginoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        self.editButton.hidden = YES;
        self.profileImage.image = [UIImage imageNamed:@"placeholder"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Me View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    editViewShowing = NO;
    CGSize editViewSize = self.editViewContainer.frame.size;
    self.editViewContainer.frame = CGRectMake(-320, self.editViewContainer.frame.origin.y, editViewSize.width, editViewSize.height);
}

#pragma mark - Custom Methods

- (void)updateProfileInfo:(NSDictionary *)userInfo
{
    [self.profileImage setImageWithURL:[NSURL URLWithString:userInfo[@"photo"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
     self.profileName.text = userInfo[@"name"];
    
    self.shimmeringView.shimmering = YES;
    self.shimmeringView.shimmeringBeginFadeDuration = 0.3;
    self.shimmeringView.shimmeringOpacity = 0.4;
    self.shimmeringView.shimmeringPauseDuration = 0.6;
    self.shimmeringView.shimmeringSpeed = 120;
    self.shimmeringView.contentView = self.profileName;
}

- (void)hideKeyboards
{
    [self.editViewName resignFirstResponder];
    [self.editViewEmail resignFirstResponder];
    [self.editViewPassword resignFirstResponder];
    [self.editViewCurrentPassword resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)subscribedEvents:(id)sender {
    self.modalPresentationStyle = UIModalPresentationCustom;
    SubscribedVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscribedVC"];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)showInfoPage:(id)sender {
    self.modalPresentationStyle = UIModalPresentationCustom;
    InfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)showTutorialPage:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupIntroView];
}

- (IBAction)logoutNow:(id)sender {
    if ([self.loginoutButton.titleLabel.text isEqualToString:@"Logout"]) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[FBSession activeSession] closeAndClearTokenInformation];
        
        self.profileImage.image = [UIImage imageNamed:@"placeholder"];
        self.profileName.text = @"";
        
        [self.loginoutButton setTitle:@"Login" forState:UIControlStateNormal];
        
        self.editButton.hidden = YES;
    } else {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupLoginView];
    }
}

- (IBAction)editNow:(id)sender {
    if (editViewShowing) {
        [self hideKeyboards];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGSize editViewSize = self.editViewContainer.frame.size;
            self.editViewContainer.frame = CGRectMake(-320, self.editViewContainer.frame.origin.y, editViewSize.width, editViewSize.height);
        } completion:NULL];
    } else {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        self.editViewName.placeholder = userInfo[@"name"];
        self.editViewEmail.placeholder = userInfo[@"email"];
        
        [UIView animateWithDuration:0.4 animations:^{
            CGSize editViewSize = self.editViewContainer.frame.size;
            self.editViewContainer.frame = CGRectMake(20, self.editViewContainer.frame.origin.y, editViewSize.width, editViewSize.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                CGSize editViewSize = self.editViewContainer.frame.size;
                self.editViewContainer.frame = CGRectMake(0, self.editViewContainer.frame.origin.y, editViewSize.width, editViewSize.height);
            }];
        }];
    }
    editViewShowing = !editViewShowing;
}

- (IBAction)updateProfile:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    NSArray *separatedImageURL = [userInfo[@"photo"] componentsSeparatedByString:@"/"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     userInfo[@"email"], @"Email",
                                                                                     userInfo[@"firstname"], @"FirstName",
                                                                                     userInfo[@"lastname"], @"LastName",
                                                                                     userInfo[@"name"], @"Name",
                                                                                     separatedImageURL.lastObject, @"Photo",
                                                                                     userInfo[@"userid"], @"UserID",
                                                                                     self.editViewPassword.text, @"NewPassword",
                                                                                     self.editViewCurrentPassword.text, @"OldPassword",
                                                                                     nil]];
    if (![self.editViewName.text isEqualToString:@""]) {
        parameters[@"Name"] = self.editViewName.text;
        parameters[@"FirstName"] = self.editViewName.text;
    }
    if (![self.editViewEmail.text isEqualToString:@""]) {
        parameters[@"Email"] = self.editViewEmail.text;
    }
    if (![self.editViewPassword.text isEqualToString:@""]) {
        parameters[@"NewPassword"] = self.editViewPassword.text;
    }
    if (![self.editViewCurrentPassword.text isEqualToString:@""]) {
        parameters[@"CurrentPassword"] = self.editViewCurrentPassword.text;
        
        [User userUpdateProfile:parameters block:^(NSDictionary *user, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            if ([user[@"status"] intValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self updateProfileInfo:user];
                
                [self hideKeyboards];
                [self editNow:nil]; // hide edit view
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fill all the fields to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password" message:@"Enter current password to update your profile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)joinedEvents:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        [self activityViewHidden:NO];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSDictionary *parameters = @{@"UserID": userInfo[@"userid"]};
        [Event getJoinedEvents:parameters block:^(NSArray *events, NSError *error) {
            [self activityViewHidden:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (events.count > 0) {
                self.modalPresentationStyle = UIModalPresentationCustom;
                JoinedEventsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinedEventsVC"];
                vc.joinedEvents = events;
                vc.transitioningDelegate = self;
                [self presentViewController:vc animated:YES completion:NULL];
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You have no joined events." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)checkins:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        [self activityViewHidden:NO];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSDictionary *parameters = @{@"UserID": userInfo[@"userid"]};
        [User userCheckinPlaces:parameters block:^(NSArray *placesCount, NSError *error) {
            
            NSLog(@"places; %@", placesCount);
            if (placesCount.count > 0) {
                NSMutableString *parameterString = [NSMutableString string];
                for (NSDictionary *dict in placesCount) {
                    [parameterString appendFormat:@"%@,", dict[@"locationid"]];
                }
                NSDictionary *parameter = @{@"groupid": parameterString};
                [User userCheckinPlacesDetails:parameter block:^(NSArray *places, NSError *error) {
                    [self activityViewHidden:YES];
                    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
                    self.modalPresentationStyle = UIModalPresentationCustom;
                    CheckinsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinsVC"];
                    vc.checkinCountArray = placesCount;
                    vc.checkinDetailsArray = places;
                    vc.transitioningDelegate = self;
                    [self presentViewController:vc animated:YES completion:NULL];
                }];
            }
            else {
                [self activityViewHidden:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You have no checkin place." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)checkinEvents:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        [self activityViewHidden:NO];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSDictionary *parameters = @{@"UserID": userInfo[@"userid"]};
        [User userCheckinEvents:parameters block:^(NSArray *events, NSError *error)
        {
            [self activityViewHidden:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (events.count > 0) {
                self.modalPresentationStyle = UIModalPresentationCustom;
                CheckinEventsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinEventsVC"];
                vc.joinedEvents = events;
                vc.transitioningDelegate = self;
                [self presentViewController:vc animated:YES completion:NULL];
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You have no checkin event." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)activityViewHidden:(BOOL)hidden
{
    _indicatorView.hidden = hidden;
    if (hidden) {
        [_indicator stopAnimating];
    } else {
        [_indicator startAnimating];
    }
}


#pragma mark - Delegate Methods

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
