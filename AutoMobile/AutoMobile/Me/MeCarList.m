//
//  MeCarList.m
//  AutoMobile
//
//  Created by Zune Moe on 2/13/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "MeCarList.h"
#import "BuyCarListCell.h"
#import "MeCarDetailsVC.h"
#import "ShowCarDetailVC.h"
#import "JDStatusBarNotification.h"

@interface MeCarList () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MeCarList

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Car List";
    
    [self setBackBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    NSDictionary *parameters = @{@"userid": userInfo[@"userid"],
                                 @"offset": @"1",
                                 @"limit": @1000000
                                 };
    [self JDStatusBarHidden:NO status:@"Fetching cars list..." duration:0];
    [MyCar getMyCarsList:parameters block:^(NSArray *cars, NSError *error) {
        if(!error && cars.count > 0) {
            [self JDStatusBarHidden:YES status:@"" duration:0];
            
            _cars = [cars copy];
            [_tableView reloadData];

        } else {
            [self JDStatusBarHidden:NO status:@"Error retrieving car list. Try again later." duration:2];
        }
    }];

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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CarDetailsSegue"]) {
//        MeCarDetailsVC *vc = segue.destinationViewController;
//        vc.car = self.cars[self.tableView.indexPathForSelectedRow.row];
        
        MyCar* mycarobj = (MyCar*)self.cars[self.tableView.indexPathForSelectedRow.row];
        ShowCarDetailVC* vc = segue.destinationViewController;
        
        [User getUserWithId:[mycarobj.userid intValue] bloc:^(User *user, NSError *error) {
            
            if (!error) {
                vc.userinfo = user;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDownloaduserinfo" object:user];
            }
        }];
        
        
        vc.carinfo = mycarobj;
    }
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BuyCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BuyCarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCell:self.cars[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car *carToDelete = self.cars[indexPath.row];
        [Car deleteMyCar:carToDelete.id block:^(NSDictionary *status, NSError *error) {
            if ([status[@"status"] isEqualToNumber:@1]) {
                [self.cars removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully removed" message:@"The car you've selected was successfully removed from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to delete" message:@"An error occur while trying to delete the data. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

@end
