//
//  MeNewVC.m
//  AutoMobile
//
//  Created by Macbook Pro on 8/28/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "MeNewVC.h"
#import "MeLoginNewVC.h"
#import "TransitionDelegate.h"
#import "UIFont+ZawgyiOne.h"
#import "CreateEditProfileVC.h"
#import "MeCarList.h"

@interface MeNewVC ()

@property (weak, nonatomic) IBOutlet UIView *viewUserInfo;
@property (strong, nonatomic) TransitionDelegate* transitionController;
@property (weak, nonatomic) IBOutlet UIView *viewbgInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@property (weak, nonatomic) IBOutlet UIView *viewMainBkg;
- (IBAction)btnLoginMainClicked:(id)sender;
- (IBAction)btnCreateAccountClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblPh;
- (IBAction)EditProfile:(id)sender;
- (IBAction)ShowMyCarsList:(id)sender;
- (IBAction)Logout:(id)sender;


@end

@implementation MeNewVC
@synthesize transitionController;

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
    
    _viewMainBkg.layer.cornerRadius = 6;
    _viewMainBkg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _viewMainBkg.layer.borderWidth = 1.5f;
    
    self.transitionController = [[TransitionDelegate alloc] init];
    
    _lblName.font = [UIFont ayarFontWithSize:13.0f];
    _lblEmail.font = [UIFont ayarFontWithSize:13.0f];
    _lblCompany.font = [UIFont ayarFontWithSize:13.0f];
    _lblPh.font = [UIFont ayarFontWithSize:13.0f];
    
    _viewUserInfo.layer.cornerRadius = 6;
    _viewUserInfo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _viewUserInfo.layer.borderWidth = 1.5f;
    
    _btnLogout.layer.cornerRadius = 6;
    _btnLogout.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btnLogout.layer.borderWidth = 1.5f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.topViewController.title = @"Me";
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    if (userinfo) {
        _viewMainBkg.hidden = YES;
        _viewbgInfo.hidden = NO;
        _lblName.text = [NSString stringWithFormat:@"Name: %@", userinfo[@"name"]];
        _lblCompany.text = [NSString stringWithFormat:@"Company: %@", userinfo[@"companyname"]];
        _lblEmail.text = [NSString stringWithFormat:@"Email: %@", userinfo[@"email"]];
        _lblPh.text = [NSString stringWithFormat:@"Phone: %@", userinfo[@"phone"]];
        
    }
    else {
        _viewMainBkg.hidden = NO;
        _viewbgInfo.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btnLoginMainClicked:(id)sender {
    MeLoginNewVC* vc = (MeLoginNewVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"MeLoginNewVC"];
    vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    [vc setTransitioningDelegate:transitionController];
    vc.modalPresentationStyle= UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)btnCreateAccountClicked:(id)sender {
    
    CreateEditProfileVC* vc = (CreateEditProfileVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"CreateEditProfileVC"];
    vc.isEditing = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)EditProfile:(id)sender {
    CreateEditProfileVC* vc = (CreateEditProfileVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"CreateEditProfileVC"];
    vc.isEditing = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ShowMyCarsList:(id)sender {
    MeCarList *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeCarList"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)Logout:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _viewMainBkg.hidden = NO;
    _viewbgInfo.hidden = YES;
}
@end
