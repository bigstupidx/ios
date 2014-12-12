//
//  NewsVC.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NewsVC.h"
#import "NewsCell.h"
#import "NewsWithoutImageCell.h"
#import "NewsDetailVC.h"

// models
#import "News.h"

#import "UIImageView+WebCache.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"

@interface NewsVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *newsArray;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation NewsVC
{
    BOOL fetchingMoreDataFinished;
    int pageNumberOffset;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageNumberOffset = 1;
    fetchingMoreDataFinished = YES;
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    [self retrieveFromDatabase];
    if (self.reachable) { // have internet connection
        [self reload:nil];
    }

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing feeds..."];
    [self setRefreshControl:self.refreshControl];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.topViewController.title = @"News";
}


- (void)retrieveFromDatabase
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    NSArray *news = [db executeQuery:@"select * from News order by created desc"];
    NSMutableArray *newsList = [NSMutableArray array];
    for (NSDictionary *dict in news) {
        News *newsFeed = [[News alloc] initWithDictionary:dict error:nil];
        [newsList addObject:newsFeed];
    }
    self.newsArray = newsList;
    [self.tableView reloadData];
}

- (NSString *)scanImageURLFromHTMLString:(NSString *)string
{
    NSString *url = nil;
    NSString *htmlString = string;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
    }
    return url;
}

// load feeds at viewdidload
- (void)reload:(__unused id)sender {
    [self JDStatusBarHidden:NO];
    [News getNewsWithOffset:pageNumberOffset block:^(NSArray *news, NSError *error)
    {
        if (!error) {
            ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
            [db createNewsTable:news.firstObject];
            for (News *newsFeed in news) {
                [db executeUpdate:[NSString stringWithFormat:@"delete from News where id = '%d'", newsFeed.id]];
                [db insertNewsIntoTable:newsFeed];
            }
            [self retrieveFromDatabase];
        }
        if (news.count > 0) {
            fetchingMoreDataFinished = YES;
        }
        [self JDStatusBarHidden:YES];
        [self.refreshControl endRefreshing];
    }];
    pageNumberOffset++;
}

#pragma mark - Custom methods

- (void) JDStatusBarHidden:(BOOL)yes
{
    if(yes) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        [JDStatusBarNotification showWithStatus:@"Updating news..." styleName:@"StatusBarStyle"];
        [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"News Detail Segue"]) {
        NewsDetailVC *vc = segue.destinationViewController;
        vc.selectedNews = self.newsArray[self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = self.newsArray[indexPath.row];
    static NSString *CellIdentifier = @"News With Image Cell ";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setupNewsWithImage:news];

    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 294;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = self.newsArray[indexPath.row];
    static NSString *CellIdentifier = @"News With Image Cell ";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupNewsWithImage:news];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *containerParentView = [(NewsCell *)cell newsContainerView];
    containerParentView.layer.masksToBounds = YES;
    containerParentView.layer.cornerRadius = 5;
    
    if ((indexPath.section == [self.tableView numberOfSections] - 1) && (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) && fetchingMoreDataFinished) {
        fetchingMoreDataFinished = NO;
        [self reload:nil];
    }
}

@end
