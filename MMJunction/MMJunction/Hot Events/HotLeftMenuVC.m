//
//  HotLeftMenuVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/27/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "HotLeftMenuVC.h"
#import "UIViewController+RESideMenu.h"

@interface HotLeftMenuVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (assign, readwrite, nonatomic) MenuAligment alignment; //EDITED

@end

@implementation HotLeftMenuVC
{
    NSArray *titles;
}
- (id)initWithAlignment:(MenuAligment)position
{
    self = [super init];
    if (self) {
        _alignment = position;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titles = @[@"All", @"Yangon", @"Mandalay"];
	self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 65 * 3) / 2.0f, self.view.frame.size.width, 65 * 3) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotLeftMenuDismissed" object:nil userInfo:@{@"city": titles[self.tableView.indexPathForSelectedRow.row]}];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

@end
