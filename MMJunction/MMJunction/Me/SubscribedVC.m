//
//  SubscribedVC.m
//  MMJunction
//
//  Created by Zune Moe on 3/24/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "SubscribedVC.h"
#import "User.h"
#import "AppDelegate.h"

@interface SubscribedVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *selectedCategoriesArray;

@property (assign, nonatomic) BOOL isCheckmark;
@end

@implementation SubscribedVC

- (NSMutableArray *)selectedCategoriesArray
{
    if (!_selectedCategoriesArray) {
        _selectedCategoriesArray = [NSMutableArray array];
    }
    return _selectedCategoriesArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.closeButton.layer.cornerRadius = 15;
    self.closeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.closeButton.layer.borderWidth = 1;
    
    self.categoriesArray = @[@{@"Entertainment": @"3"},
                             @{@"Sports": @"4"},
                             @{@"Business": @"2"},
                             @{@"Promotion": @"9"},
                             @{@"Film": @"12"},
                             @{@"IT": @"1"},
                             @{@"Education": @"8"},
                             @{@"Art": @"7"},
                             @{@"Literature": @"6"},
                             @{@"Volunteering": @"5"},
                             @{@"Dhama": @"10"},
                             @{@"Community": @"11"}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectedCategoriesArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"subscribe_id"] mutableCopy];
    NSLog(@"cate: %@", self.selectedCategoriesArray);
}

- (IBAction)dismissVC:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedCategoriesArray forKey:@"subscribe_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableString *subscribeId = [NSMutableString string];
    if (self.selectedCategoriesArray.count > 0) {
        for (int i = 0; i < self.selectedCategoriesArray.count - 1; i++) {
            [subscribeId appendFormat:@"%@, ", [self.selectedCategoriesArray[i] allValues].firstObject];
        }
        [subscribeId appendFormat:@"%@", [self.selectedCategoriesArray.lastObject allValues].firstObject];
    }
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"device token: %@", deviceToken);
    if (![subscribeId isEqualToString:@""] && deviceToken) {
        NSDictionary *parameter = @{@"gcm_id": deviceToken,
                                    @"subscribe_id": subscribeId,
                                    @"device": @"ios"};
        [User userSubscribe:parameter block:^(NSDictionary *status, NSError *error) {
            NSLog(@"status: %@", status);
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"App First Time Use"] isEqualToString:@"YES"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"App First Time Use"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [(AppDelegate *) [UIApplication sharedApplication].delegate setupLoginView];
            }
//            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
    } else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"App First Time Use"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"App First Time Use"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [(AppDelegate *) [UIApplication sharedApplication].delegate setupLoginView];
        }
//        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSubscribedEvents" object:self];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *category = self.categoriesArray[indexPath.row];
    cell.textLabel.text = category.allKeys.firstObject;
    cell.imageView.image = [UIImage imageNamed:category.allKeys.firstObject];
    
    //To Check checkmark
    if (!_isCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *category = self.categoriesArray[indexPath.row];
    for (NSDictionary *dict in self.selectedCategoriesArray) {
        if ([dict.allKeys.firstObject isEqualToString:category.allKeys.firstObject]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _isCheckmark = YES;
        }
        else _isCheckmark = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select");
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.selectedCategoriesArray removeObject:self.categoriesArray[indexPath.row]];
    [self.selectedCategoriesArray addObject:self.categoriesArray[indexPath.row]];
    NSLog(@"cat select: %@", self.selectedCategoriesArray);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did deselect");
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    [self.selectedCategoriesArray removeObjectIdenticalTo:self.categoriesArray[indexPath.row]];
    NSLog(@"cat deselect: %@", self.selectedCategoriesArray);
}

@end
