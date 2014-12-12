//
//  InfoVC.m
//  MMJunction
//
//  Created by Zune Moe on 3/7/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "InfoVC.h"
#import "InfoCell.h"
#import "FBShimmeringView.h"

@interface InfoVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (weak, nonatomic) IBOutlet UILabel *developerInfoLabel;
@property (strong, nonatomic) NSArray *openSourceLicensesArray;
@end

@implementation InfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rateViewHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    self.closeImageView.layer.cornerRadius = 15;
    self.closeImageView.layer.borderWidth = 1;
    self.closeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.shimmeringView.shimmering = YES;
    self.shimmeringView.shimmeringBeginFadeDuration = 0.3;
    self.shimmeringView.shimmeringOpacity = 0.4;
    self.shimmeringView.shimmeringPauseDuration = 0.6;
    self.shimmeringView.shimmeringSpeed = 120;
    self.shimmeringView.contentView = self.developerInfoLabel;
    
	NSDictionary *license1 = @{@"name": @"AFNetworking",
                               @"url": @"https://github.com/AFNetworking/AFNetworking",
                               @"license": @"MIT-licensed"};
    NSDictionary *license2 = @{@"name": @"JSONModel",
                               @"url": @"https://github.com/icanzilb/JSONModel",
                               @"license": @"MIT-licensed"};
    NSDictionary *license3 = @{@"name": @"FMDB",
                               @"url": @"https://github.com/ccgus/fmdb",
                               @"license": @"MIT-licensed"};
    NSDictionary *license4 = @{@"name": @"RESideMenu",
                               @"url": @"https://github.com/MahirEusufzai/RESideMenu",
                               @"license": @"MIT-licensed"};
    NSDictionary *license5 = @{@"name": @"EAIntroView",
                               @"url": @"https://github.com/ealeksandrov/EAIntroView",
                               @"license": @"MIT-licensed"};
    NSDictionary *license6 = @{@"name": @"SwipeView",
                               @"url": @"https://github.com/nicklockwood/SwipeView",
                               @"license": @"MIT-licensed"};
    NSDictionary *license7 = @{@"name": @"SDWebImage",
                               @"url": @"https://github.com/rs/SDWebImage",
                               @"license": @"MIT-licensed"};
    NSDictionary *license8 = @{@"name": @"GHContextMenu",
                               @"url": @"https://github.com/GnosisHub/GHContextMenu",
                               @"license": @"MIT-licensed"};
    NSDictionary *license9 = @{@"name": @"Shimmer",
                               @"url": @"https://github.com/facebook/Shimmer",
                               @"license": @"BSD-licensed"};
    NSDictionary *license10 = @{@"name": @"TWMessageBarManager",
                               @"url": @"https://github.com/terryworona/TWMessageBarManager",
                               @"license": @"MIT-licensed"};
    NSDictionary *license11 = @{@"name": @"GoogleAnalytics",
                               @"url": @"http://www.google.com/analytics/mobile/",
                               @"license": @""};
    self.openSourceLicensesArray = @[license1, license2, license3, license4, license5, license6, license7, license8, license9, license10, license11];
    [self.tableView reloadData];
}

- (IBAction)showYourLove:(id)sender {
    NSLog(@"showing love");
    if (self.rateViewHeightConstraint.constant == 0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.rateViewHeightConstraint.constant = 68;
            [self.view layoutIfNeeded];
        }];
    } else if (self.rateViewHeightConstraint.constant == 68) {
        [UIView animateWithDuration:1.0 animations:^{
            self.rateViewHeightConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return @"Open source contributions";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.openSourceLicensesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCell:self.openSourceLicensesArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openSourceLicensesArray[indexPath.row][@"url"]]];
}

@end
