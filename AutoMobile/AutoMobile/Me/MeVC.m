//
//  MeVC.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "MeVC.h"
#import "User.h"
#import "Car.h"
#import "MeCarList.h"
#import "MyCar.h"
#import "ShowCarDetailVC.h"

#import "JDStatusBarNotification.h"

@interface MeVC () <UITextFieldDelegate>
{
    CGPoint scrollViewOffset;
    BOOL signupViewShowing;
    BOOL editViewShowing;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *signupView;
@property (weak, nonatomic) IBOutlet UITextField *signupname;
@property (weak, nonatomic) IBOutlet UITextField *signupUsername;
@property (weak, nonatomic) IBOutlet UITextField *signupEmail;
@property (weak, nonatomic) IBOutlet UITextField *signupPassword;
@property (weak, nonatomic) IBOutlet UITextField *signupConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *signupCompany;
@property (weak, nonatomic) IBOutlet UITextField *signupPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signupViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *signupCloseImage;
@property (weak, nonatomic) IBOutlet UIScrollView *editView;
@property (weak, nonatomic) IBOutlet UITextField *editname;
@property (weak, nonatomic) IBOutlet UITextField *editUsername;
@property (weak, nonatomic) IBOutlet UITextField *editEmail;
@property (weak, nonatomic) IBOutlet UITextField *editcurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *editNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *editCompany;
@property (weak, nonatomic) IBOutlet UITextField *editPhone;
@property (weak, nonatomic) IBOutlet UIImageView *editCloseImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewTopConstraint;
@end

@implementation MeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    signupViewShowing = NO;
    editViewShowing = NO;
    
    self.signupViewTopConstraint.constant = -409;
    self.signupCloseImage.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"Next"].CGImage scale:1.0 orientation:UIImageOrientationLeft];
    
    self.editViewTopConstraint.constant = -409;
    self.editCloseImage.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"Next"].CGImage scale:1.0 orientation:UIImageOrientationLeft];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    keyboardToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Next"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 20;
    [keyboardToolbar setItems:@[previousButton, fixedSpace, nextButton, flexibleSpace, doneButton]];
    
    self.loginEmail.delegate = self;
    self.loginPassword.delegate = self;
    
    self.signupname.inputAccessoryView = keyboardToolbar;
    self.signupUsername.inputAccessoryView = keyboardToolbar;
    self.signupEmail.inputAccessoryView = keyboardToolbar;
    self.signupPassword.inputAccessoryView = keyboardToolbar;
    self.signupConfirmPassword.inputAccessoryView = keyboardToolbar;
    self.signupCompany.inputAccessoryView = keyboardToolbar;
    self.signupPhone.inputAccessoryView = keyboardToolbar;
    
    self.signupname.delegate = self;
    self.signupUsername.delegate = self;
    self.signupEmail.delegate = self;
    self.signupPassword.delegate = self;
    self.signupConfirmPassword.delegate = self;
    self.signupCompany.delegate = self;
    self.signupPhone.delegate = self;
    
    self.editname.inputAccessoryView = keyboardToolbar;
    self.editUsername.inputAccessoryView = keyboardToolbar;
    self.editEmail.inputAccessoryView = keyboardToolbar;
    self.editcurrentPassword.inputAccessoryView = keyboardToolbar;
    self.editNewPassword.inputAccessoryView = keyboardToolbar;
    self.editCompany.inputAccessoryView = keyboardToolbar;
    self.editPhone.inputAccessoryView = keyboardToolbar;
    
    self.editname.delegate = self;
    self.editUsername.delegate = self;
    self.editEmail.delegate = self;
    self.editcurrentPassword.delegate = self;
    self.editNewPassword.delegate = self;
    self.editCompany.delegate = self;
    self.editPhone.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        self.loginView.hidden = YES;
        [self setupUserInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.topViewController.title = @"Me";
}

- (void)previousTextField
{
    if (signupViewShowing) {
        if (self.signupUsername.isFirstResponder) {
            [self.signupname becomeFirstResponder];
        } else if (self.signupEmail.isFirstResponder) {
            [self.signupUsername becomeFirstResponder];
        } else if (self.signupPassword.isFirstResponder) {
            [self.signupEmail becomeFirstResponder];
        } else if (self.signupConfirmPassword.isFirstResponder) {
            [self.signupPassword becomeFirstResponder];
        } else if (self.signupCompany.isFirstResponder) {
            [self.signupConfirmPassword becomeFirstResponder];
        } else if (self.signupPhone.isFirstResponder) {
            [self.signupCompany becomeFirstResponder];
        }
    }
    if (editViewShowing) {
        if (self.editUsername.isFirstResponder) {
            [self.editname becomeFirstResponder];
        } else if (self.editEmail.isFirstResponder) {
            [self.editUsername becomeFirstResponder];
        } else if (self.editcurrentPassword.isFirstResponder) {
            [self.editEmail becomeFirstResponder];
        } else if (self.editNewPassword.isFirstResponder) {
            [self.editcurrentPassword becomeFirstResponder];
        } else if (self.editCompany.isFirstResponder) {
            [self.editNewPassword becomeFirstResponder];
        } else if (self.editPhone.isFirstResponder) {
            [self.editCompany becomeFirstResponder];
        }
    }
}

- (void)nextTextField
{
    if (signupViewShowing) {
        if (self.signupname.isFirstResponder) {
            [self.signupUsername becomeFirstResponder];
        } else if (self.signupUsername.isFirstResponder) {
            [self.signupEmail becomeFirstResponder];
        } else if (self.signupEmail.isFirstResponder) {
            [self.signupPassword becomeFirstResponder];
        } else if (self.signupPassword.isFirstResponder) {
            [self.signupConfirmPassword becomeFirstResponder];
        } else if (self.signupConfirmPassword.isFirstResponder) {
            [self.signupCompany becomeFirstResponder];
        } else if (self.signupCompany.isFirstResponder) {
            [self.signupPhone becomeFirstResponder];
        }
    }
    if (editViewShowing) {
        if (self.editname.isFirstResponder) {
            [self.editUsername becomeFirstResponder];
        } else if (self.editUsername.isFirstResponder) {
            [self.editEmail becomeFirstResponder];
        } else if (self.editEmail.isFirstResponder) {
            [self.editcurrentPassword becomeFirstResponder];
        } else if (self.editcurrentPassword.isFirstResponder) {
            [self.editNewPassword becomeFirstResponder];
        } else if (self.editNewPassword.isFirstResponder) {
            [self.editCompany becomeFirstResponder];
        } else if (self.editCompany.isFirstResponder) {
            [self.editPhone becomeFirstResponder];
        }
    }
}

- (void)doneEditing
{
    if (self.signupname.isFirstResponder) {
        [self.signupname resignFirstResponder];
    }
    if (self.signupUsername.isFirstResponder) {
        [self.signupUsername resignFirstResponder];
    }
    if (self.signupEmail.isFirstResponder) {
        [self.signupEmail resignFirstResponder];
    }
    if (self.signupPassword.isFirstResponder) {
        [self.signupPassword resignFirstResponder];
    }
    if (self.signupConfirmPassword.isFirstResponder) {
        [self.signupConfirmPassword resignFirstResponder];
    }
    if (self.signupCompany.isFirstResponder) {
        [self.signupCompany resignFirstResponder];
    }
    if (self.signupPhone.isFirstResponder) {
        [self.signupPhone resignFirstResponder];
    }
    [self.signupView setContentOffset:scrollViewOffset animated:YES];
    
    if (self.editname.isFirstResponder) {
        [self.editname resignFirstResponder];
    }
    if (self.editUsername.isFirstResponder) {
        [self.editUsername resignFirstResponder];
    }
    if (self.editEmail.isFirstResponder) {
        [self.editEmail resignFirstResponder];
    }
    if (self.editcurrentPassword.isFirstResponder) {
        [self.editcurrentPassword resignFirstResponder];
    }
    if (self.editNewPassword.isFirstResponder) {
        [self.editNewPassword resignFirstResponder];
    }
    if (self.editCompany.isFirstResponder) {
        [self.editCompany resignFirstResponder];
    }
    if (self.editPhone.isFirstResponder) {
        [self.editPhone resignFirstResponder];
    }
    [self.editView setContentOffset:scrollViewOffset animated:YES];
    
    if (self.loginEmail.isFirstResponder) {
        [self.loginEmail resignFirstResponder];
    }
    if (self.loginPassword.isFirstResponder) {
        [self.loginPassword resignFirstResponder];
    }
}

#pragma mark - UITextField Delegate

- (void) scrollToRectangle:(id)rect toView:(id)view
{
    CGPoint pt;
    CGRect rc = [rect bounds];
    rc = [rect convertRect:rc toView:view];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [view setContentOffset:pt animated:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (signupViewShowing) {
        [self scrollToRectangle:textField toView:self.signupView];
    }
    if (editViewShowing) {
        [self scrollToRectangle:textField toView:self.editView];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.signupView setContentOffset:scrollViewOffset animated:YES];
    [textField resignFirstResponder];
    if (textField == self.signupPhone) {
        [self signup:nil];
    }
    
    [self.editView setContentOffset:scrollViewOffset animated:YES];
    if (textField == self.editPhone) {
        [self updateUserInfo:nil];
    }
    return YES;
}

- (void)setupUserInfo
{
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    self.username.text = userinfo[@"name"];
}

- (IBAction)login:(id)sender {
    NSDictionary *parameters = @{@"email": self.loginEmail.text,
                                 @"password": self.loginPassword.text};
    [User loginUserWith:parameters block:^(NSDictionary *message, NSError *error) {
        NSLog(@"mess: %@", message);
        if ([message[@"status"] isEqualToNumber:@1]) {
            [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.loginView.hidden = YES;
            [self setupUserInfo];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message[@"message"] message:message[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)showSignupView:(id)sender {
    signupViewShowing = YES;
    self.signupViewTopConstraint.constant = 0;
    self.signupView.hidden = NO;
    [self.scrollView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7 animations:^{
        [self.scrollView layoutIfNeeded];
    }];
}
     
- (IBAction)hideSignupView:(id)sender {
    signupViewShowing = NO;
    self.signupViewTopConstraint.constant = -409;
    self.signupView.hidden = YES;
    [self.scrollView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7 animations:^{
        [self.scrollView layoutIfNeeded];
    }];
}

- (IBAction)signup:(id)sender {
    NSDictionary *parameters = @{@"name": self.signupname.text,
                                 @"username": self.signupUsername.text,
                                 @"email": self.signupEmail.text,
                                 @"password": self.signupPassword.text,
                                 @"companyname": self.signupCompany.text,
                                 @"phone": self.signupPhone.text,
                                 @"country": @"1"};
    if ([self.signupPassword.text isEqualToString:self.signupConfirmPassword.text] && ![self.signupPassword.text isEqualToString:@""]) {
        [User signupUserWith:parameters block:^(NSDictionary *message, NSError *error) {
            if ([message[@"status"] isEqualToNumber:@0] && !error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message[@"message"] message:message[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.loginView.hidden = YES;
                [self hideSignupView:nil];
                [self setupUserInfo];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords did not match" message:@"The two passwords must be the same" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)editUserInfo:(id)sender {
    editViewShowing = YES;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    self.editname.text = userInfo[@"name"];
    self.editUsername.text = userInfo[@"username"];
    self.editEmail.text = userInfo[@"email"];
    self.editCompany.text = userInfo[@"companyname"];
    self.editPhone.text = userInfo[@"phone"];
    
    self.editViewTopConstraint.constant = -0;
    [self.scrollView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7 animations:^{
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.editView.hidden = NO;
    }];
}

- (IBAction)updateUserInfo:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    NSDictionary *updatedInfo = @{@"name": self.editname.text,
                                  @"username": self.editUsername.text,
                                  @"email": self.editEmail.text,
                                  @"currentpassword": self.editcurrentPassword.text,
                                  @"newpassword": self.editNewPassword.text,
                                  @"companyname": self.editCompany.text,
                                  @"phone": self.editPhone.text,
                                  @"country": @"1",
                                  @"userid": userInfo[@"userid"]};
    [User updateUserWith:updatedInfo block:^(NSDictionary *message, NSError *error) {
        NSLog(@"mess: %@", message);
        if ([message[@"status"] isEqualToNumber:@0] && !error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message[@"message"] message:message[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self hideUpdateView:nil];
            [self setupUserInfo];
        }
    }];
}

- (IBAction)hideUpdateView:(id)sender {
    editViewShowing = NO;
    self.editViewTopConstraint.constant = -409;
    [self.scrollView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7 animations:^{
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.editView.hidden = YES;
    }];
}

- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.loginEmail.text = @"";
    self.loginPassword.text = @"";
    self.loginView.hidden = NO;
}

- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

- (IBAction)myCars:(id)sender {
//    ShowCarDetailVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowCarDetailVC"];
//    [self.navigationController pushViewController:vc animated:YES];
//    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
//    NSDictionary *parameters = @{@"userid": userInfo[@"userid"],
//                                 @"offset": @"1",
//                                 @"limit": @1000000
//                                 };
//    [self JDStatusBarHidden:NO status:@"Fetching cars list..." duration:0];
//    [MyCar getMyCarsList:parameters block:^(NSArray *cars, NSError *error) {
//        if(!error && cars.count > 0) {
//            [self JDStatusBarHidden:YES status:@"" duration:0];
            MeCarList *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeCarList"];
//            vc.cars = cars.mutableCopy;
            [self.navigationController pushViewController:vc animated:YES];
//        } else {
//            [self JDStatusBarHidden:NO status:@"Error retrieving car list. Try again later." duration:2];
//        }
//    }];
}

@end
