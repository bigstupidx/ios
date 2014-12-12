//
//  LoginVC.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/12/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>

#import "LoginVC.h"
#import "FXBlurView.h"
#import "AppDelegate.h"
#import "User.h"

@interface LoginVC () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FXBlurView *loginViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *skipLoginButton;
@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginViewContainer.dynamic = NO;
    self.loginViewContainer.blurRadius = 20;
    self.loginViewContainer.tintColor = [UIColor whiteColor];
    
    self.skipLoginButton.layer.cornerRadius = 2;
}

- (IBAction)skipLogin:(id)sender {
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

- (void) fetchedDataWithFQL: (NSDictionary<FBGraphUser> *) user
{
    NSString *query = [NSString stringWithFormat:@"SELECT pic_big, sex, email, birthday FROM user WHERE uid = me()"];
    NSDictionary *fqlParam = @{@"q": query};
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:fqlParam HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSArray *urlPath = (NSArray *) result[@"data"];
            NSDictionary *pic_path = [urlPath lastObject];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user[@"id"], @"userid",user.name,@"name",pic_path[@"pic_big"], @"photo",nil];
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
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
                }
            }];
        }
    }];
}

@end
