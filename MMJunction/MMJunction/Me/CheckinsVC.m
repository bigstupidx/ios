//
//  CheckinsVC.m
//  MMJunction
//
//  Created by Zune Moe on 3/3/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "CheckinsVC.h"
#import "CheckinCountCell.h"

@interface CheckinsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@end

@implementation CheckinsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backImageView.layer.cornerRadius = 17;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Me Checkin History View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.checkinCountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CheckinCountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CheckinCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setupCell:self.checkinCountArray[indexPath.row] place:self.checkinDetailsArray[indexPath.row]];
    
    return cell;
}

@end
