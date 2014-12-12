//
//  CreateEditProfileVC.m
//  AutoMobile
//
//  Created by Macbook Pro on 8/28/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "CreateEditProfileVC.h"
#import "UIFont+ZawgyiOne.h"
#import "User.h"
#import "JDStatusBarNotification.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"

@interface CreateEditProfileVC () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Reachability* reachability;
@property (assign, nonatomic) BOOL reachable;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirm;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblPh;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;

@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtEdit;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirm;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany;
@property (weak, nonatomic) IBOutlet UITextField *txtPh;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
- (IBAction)Showcitypickerview:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewCity;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) UIPickerView* citypickerview;
@property (strong, nonatomic) NSArray* citypickerarray;
@property (strong, nonatomic) NSNumber* selectedcityindex;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)Submit:(id)sender;

@end

@implementation CreateEditProfileVC

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
    
    self.title = @"User Register";
    
    [self decorateView];
    [self setlabels];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (self.reachable) {
        [User getCityList:^(NSArray *citylist, NSError *error) {
            _citypickerarray = [citylist copy];
            if (_isEditing) {
                NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
                _txtCity.text = userinfo[@"country"];
            } else _txtCity.text = _citypickerarray[0][@"name"];
            [_citypickerview reloadAllComponents];
            [_txtCity reloadInputViews];
        }];
    }
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    keyboardToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneCitySelection)];
    [keyboardToolbar setItems:@[flexibleSpace, doneButton]];

    _txtCity.inputAccessoryView = keyboardToolbar;
    
    [self.scrollview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    [self setBackBtn];
    
    if (_isEditing) {
        NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
        _txtName.text = userinfo[@"name"];
        _txtUsername.text = userinfo[@"username"];
        _txtCompany.text = userinfo[@"companyname"];
        _txtEdit.text = userinfo[@"email"];
        _txtPh.text = userinfo[@"phone"];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"New Password *"];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor redColor]
                     range:NSMakeRange(13, 1)];
        [_lblConfirm setAttributedText: text];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setlabels
{
    _lblName.font = [UIFont ayarFontWithSize:13.0f];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Name *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(5, 1)];
    [_lblName setAttributedText: text];
    
    _lblUsername.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"User Name *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(10, 1)];
    [_lblUsername setAttributedText: text];
    
    _lblEmail.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Email *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(6, 1)];
    [_lblEmail setAttributedText: text];
    
    _lblPassword.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Password *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(9, 1)];
    [_lblPassword setAttributedText: text];
    
    _lblConfirm.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Confirm Password *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(17, 1)];
    [_lblConfirm setAttributedText: text];
    
    _lblCompany.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Company Name *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(13, 1)];
    [_lblCompany setAttributedText: text];
    
    _lblPh.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Phone No. *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(10, 1)];
    [_lblPh setAttributedText: text];
    
    _lblCity.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"City *"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(5, 1)];
    [_lblCity setAttributedText: text];
}

- (void)setBackBtn
{
    self.navigationItem.backBarButtonItem = nil;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back_unselected.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateSelected];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)dismissThisView
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)decorateView
{
    _txtName.layer.cornerRadius = 6;
    _txtName.layer.borderWidth = 1.5f;
    _txtName.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _txtUsername.layer.cornerRadius = 6;
    _txtUsername.layer.borderWidth = 1.5f;
    _txtUsername.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _txtEdit.layer.cornerRadius = 6;
    _txtEdit.layer.borderWidth = 1.5f;
    _txtEdit.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _txtPassword.layer.cornerRadius = 6;
    _txtPassword.layer.borderWidth = 1.5f;
    _txtPassword.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _txtConfirm.layer.cornerRadius = 6;
    _txtConfirm.layer.borderWidth = 1.5f;
    _txtConfirm.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _txtCompany.layer.cornerRadius = 6;
    _txtCompany.layer.borderWidth = 1.5f;
    _txtCompany.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _txtPh.layer.cornerRadius = 6;
    _txtPh.layer.borderWidth = 1.5f;
    _txtPh.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _viewCity.layer.cornerRadius = 6;
    _viewCity.layer.borderWidth = 1.5f;
    _viewCity.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    self.citypickerview = [[UIPickerView alloc] init];
    self.citypickerview.translatesAutoresizingMaskIntoConstraints = NO;
    self.citypickerview.delegate = self;
    self.citypickerview.dataSource = self;
    self.citypickerview.showsSelectionIndicator = YES;
    self.txtCity.inputView = self.citypickerview;
    self.citypickerarray = @[@"Yangon",@"Mandalay"];
    
    self.txtCity.font = [UIFont zawgyiOneFontWithSize:13.0f];
    
    _btnSubmit.layer.cornerRadius = 6; 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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


- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)doneCitySelection
{
    [_txtCity resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.scrollview.contentOffset = CGPointMake(0, textField.frame.origin.y + 50);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _txtName) {
        [_txtUsername becomeFirstResponder];
    } else if (textField == _txtUsername) {
        [_txtEdit becomeFirstResponder];
    } else if (textField == _txtEdit) {
        [_txtPassword becomeFirstResponder];
    } else if (textField == _txtPassword) {
        [_txtConfirm becomeFirstResponder];
    } else if (textField == _txtConfirm) {
        [_txtCompany becomeFirstResponder];
    } else if (textField == _txtCompany) {
        [_txtPh becomeFirstResponder];
    } else if (textField == _txtPh) {
        [_txtCity becomeFirstResponder];
    }
    return YES;
}


- (IBAction)Showcitypickerview:(id)sender {
}

#pragma mark - PickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _citypickerarray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _citypickerarray[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _txtCity.text = _citypickerarray[row][@"name"];
    _selectedcityindex = _citypickerarray[row][@"id"];
}
- (IBAction)Submit:(id)sender {
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    if (!self.reachable) {
        [self JDStatusBarHidden:NO status:@"No internet connection." duration:3.0f];
        return;
    }
    if (_txtName.text.length == 0 || _txtUsername.text.length == 0 || _txtPassword.text.length == 0 || _txtConfirm.text.length == 0 || _txtCompany.text.length == 0 || _txtEdit.text.length == 0 || _txtPh.text.length == 0 || _txtCompany.text.length == 0 || _txtCity.text.length == 0) {
        return;
    }
    if (_isEditing) {
        [self updateUserInfo];
        return;
    }
    NSDictionary *parameters = @{@"name": self.txtName.text,
                                 @"username": self.txtUsername.text,
                                 @"email": self.txtEdit.text,
                                 @"password": self.txtPassword.text,
                                 @"companyname": self.txtCompany.text,
                                 @"phone": self.txtPh.text,
                                 @"country": _txtCity.text};
    if ([self.txtPassword.text isEqualToString:self.txtConfirm.text] && ![self.txtPassword.text isEqualToString:@""]) {
        
        [self JDStatusBarHidden:NO status:@"Submitting..." duration:0];
        
        [User signupUserWith:parameters block:^(NSDictionary *message, NSError *error) {
            
            if ([message[@"status"] isEqualToNumber:@0] && !error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message[@"message"] message:message[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [self JDStatusBarHidden:YES status:@"" duration:0];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords did not match" message:@"The two passwords must be the same" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (void)updateUserInfo
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    NSDictionary *updatedInfo = @{@"name": _txtName.text,
                                  @"username": _txtUsername.text,
                                  @"email": _txtEdit.text,
                                  @"currentpassword": _txtPassword.text,
                                  @"newpassword": _txtConfirm.text,
                                  @"companyname": _txtCompany.text,
                                  @"phone": _txtPh.text,
                                  @"country": _txtCity.text,
                                  @"userid": userInfo[@"userid"]};
    [User updateUserWith:updatedInfo block:^(NSDictionary *message, NSError *error) {
        NSLog(@"mess: %@", message);
        if ([message[@"status"] isEqualToNumber:@0] && !error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message[@"message"] message:message[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

@end
