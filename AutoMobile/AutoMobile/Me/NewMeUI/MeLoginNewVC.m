//
//  MeLoginNewVC.m
//  AutoMobile
//
//  Created by Macbook Pro on 8/28/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "MeLoginNewVC.h"
#import "User.h"
#import "JDStatusBarNotification.h"
#import "Reachability.h"

@interface MeLoginNewVC () <UITextFieldDelegate>

@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UIView *viewBkg;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnLoginClicked:(id)sender;

@end

@implementation MeLoginNewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewBkg.layer.cornerRadius = 6;
    _btnCancel.layer.cornerRadius = 5;
    _btnOk.layer.cornerRadius = 5;
    
    _txtEmail.delegate = self;
    _txtPassword.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _txtEmail) {
        [_txtPassword becomeFirstResponder];
    }
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-50,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (IBAction)btnCancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnLoginClicked:(id)sender {
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (!self.reachable) {
        [self JDStatusBarHidden:NO status:@"No internet connection." duration:3.0f];
        return;
    }

    NSDictionary *parameters = @{@"email": _txtEmail.text,
                                 @"password": _txtPassword.text};
    [User loginUserWith:parameters block:^(NSDictionary *message, NSError *error) {
        NSLog(@"mess: %@", message);
        if ([message[@"status"] isEqualToNumber:@1]) {
            [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
           
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message[@"message"] message:message[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];

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

@end
