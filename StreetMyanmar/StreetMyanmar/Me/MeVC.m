//
//  MeVC.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/13/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>

#import "MeVC.h"
#import "AppDelegate.h"
#import "FXBlurView.h"
#import "FBShimmeringView.h"
#import "UIImageView+WebCache.h"

@interface MeVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *profileViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation MeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        [self.loginButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        self.shimmeringView.shimmering = YES;
        self.shimmeringView.shimmeringBeginFadeDuration = 0.3;
        self.shimmeringView.shimmeringOpacity = 0.4;
        self.shimmeringView.shimmeringPauseDuration = 0.6;
        self.shimmeringView.shimmeringSpeed = 120;
        self.shimmeringView.contentView = self.profileName;
        
        self.profileName.text = userInfo[@"name"];
        [self.profileImageView setImageWithURL:[NSURL URLWithString:userInfo[@"photo"]]
                              placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else {
        [self.loginButton setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    }
}

- (IBAction)loginButtonTapped:(id)sender {
    if ([self.loginButton.imageView.image isEqual:[UIImage imageNamed:@"logout"]]) {
        // clear fbsession and userInfo from NSUserDefaults
        [[FBSession activeSession] closeAndClearTokenInformation];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.profileImageView.image = [UIImage imageNamed:@"placeholder"];
        self.profileName.text = @"";
        
        [self.loginButton setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    } else if ([self.loginButton.imageView.image isEqual:[UIImage imageNamed:@"login"]]) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupLoginView];
    }
}

@end
