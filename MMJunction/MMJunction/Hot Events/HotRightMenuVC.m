//
//  HotRightMenuVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/27/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "HotRightMenuVC.h"
#import "UIViewController+RESideMenu.h"

@interface HotRightMenuVC ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (assign, readwrite, nonatomic) MenuAligment alignment; //EDITED
@end

@implementation HotRightMenuVC
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
    titles = @[@"Any", @"Entertainment", @"Sports", @"Business", @"Promotion", @"Film", @"IT", @"Education", @"Art", @"Literature", @"Volunteering", @"Dhama", @"Community"];
    
	self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotRightMenuDismissed" object:nil userInfo:@{@"category": titles[self.tableView.indexPathForSelectedRow.row]}];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

@end
