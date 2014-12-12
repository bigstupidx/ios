//
//  LoginVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/26/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "LoginVC.h"
#import "SignupVC.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import "User.h"

@interface LoginVC () <FBLoginViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginViewContainer;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *activityViewContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.email.delegate = self;
    self.password.delegate = self;
    self.loginViewContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_lines"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Login View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)activityViewHidden:(BOOL)hidden
{
    self.activityViewContainer.hidden = hidden;
    if (hidden) {
        [self.activityView stopAnimating];
    } else {
        [self.activityView startAnimating];
    }
}

- (void) fetchedDataWithFQL: (NSDictionary<FBGraphUser> *) user
{
    NSString *query = [NSString stringWithFormat:@"SELECT pic_square, sex, email, birthday FROM user WHERE uid = me()"];
    NSDictionary *fqlParam = @{@"q": query};
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:fqlParam HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            // Get the url data to display
            NSArray *urlPath = (NSArray *) result[@"data"];
            NSDictionary *pic_path = [urlPath lastObject];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user[@"id"], @"userid",user.name,@"name",pic_path[@"pic_square"], @"photo",nil];
            NSDictionary *loginParameters = @{@"FirstName": user.first_name,
                                              @"LastName": user.last_name,
                                              @"Email": pic_path[@"email"],
                                              @"Ouid": user[@"id"],
                                              @"Photo": parameters[@"photo"],
                                              @"Gender": pic_path[@"sex"],
                                              @"DOB": pic_path[@"birthday"]};
            
            [User userFacebookLogin:loginParameters block:^(NSDictionary *user, NSError *error) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                if ([[user objectForKey:@"status"] intValue] == 1) {
                    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userInfo"];
                    if ([[user objectForKey:@"role"] isEqualToString:@"8"]) {
                        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:@"YES" forKey:@"admin"]];
                    }
                    else{
                        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:@"NO" forKey:@"admin"]];
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
                }
                [self activityViewHidden:YES];
            }];
        }
    }];
}

- (IBAction)loginTapped:(id)sender {
    [self activityViewHidden:NO];
    NSDictionary *parameters = @{@"Email": self.email.text,
                                 @"Password": self.password.text};
    
    [User userLogin:parameters block:^(NSDictionary *user, NSError *error) {
        NSLog(@"user: %@", user);
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if ([[user objectForKey:@"status"] intValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to login, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [self activityViewHidden:YES];
    }];
}

- (IBAction)signupTapped:(id)sender {
    SignupVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)skippedLogin:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
}

#pragma mark - FBLoginView delegate

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [self activityViewHidden:NO];
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 dispatch_async(kBgQueue, ^{
                     [self performSelectorOnMainThread:@selector(fetchedDataWithFQL:) withObject:user waitUntilDone:YES];
                 });
             }
         }];
    }
}

@end
