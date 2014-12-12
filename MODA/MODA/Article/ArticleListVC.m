 //
//  ArticleListVC.m
//  Moda
//
//  Created by Zune Moe on 28/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ArticleListVC.h"
#import "ArticleListCell.h"
#import "ArticleDetailVC.h"
#import "Article.h"
#import "UIColor+UIColor_PXExtentions.h"
#import "ArticleDetailHolderVC.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "ModaAdsCell.h"

#import "UIImageView+WebCache.h"
#import "MSAdvers.h"
#import "ZMFMDBSQLiteHelper.h"
#import "MODAdataFetching.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

@interface ArticleListVC () <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>

{
    BOOL viewAlign;
    NSString* currentVC;
    UILabel* headerLbl;
    NSArray* onlyArticleArr;
    int currentIndex;
    
    UITabBarController* tabBar;
}

@property (nonatomic, assign) CATransform3D slide;
@property (nonatomic, strong) NSArray* adsArr;
@property (nonatomic, strong) UITabBarController* tabbarController;
@property (nonatomic, strong) NSMutableArray* adsArray;
@property (nonatomic, assign) BOOL isEndOfTableView;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation ArticleListVC

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Article Detail Segue"]) {
        ArticleDetailHolderVC *detailVC = segue.destinationViewController;
//        detailVC.article = self.articleArray[self.tableView.indexPathForSelectedRow.row];
//        detailVC.articleArr = [self.articleArray copy];
//        detailVC.currentTabTitle = self.strTabbarTitle;
//        detailVC.onlyArticleArr = [onlyArticleArr copy];
//        detailVC.currentIndex = currentIndex;
//        detailVC.currentTabTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"];
        NSMutableArray* mulTempArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.articleArray.count; i++) {
            if (![self.articleArray[i] isKindOfClass:[MSAdvers class]]) {
                [mulTempArr addObject:self.articleArray[i]];
            }
        }
        detailVC.onlyArticleArr = [mulTempArr mutableCopy]; //NSDictionary in NSMutableArr
        
        NSDictionary* curArticle = self.articleArray[self.tableView.indexPathForSelectedRow.row];
        for (int i = 0; i < mulTempArr.count; i++)
        {
            NSDictionary* eachArticle = mulTempArr[i];
            if ([[curArticle objectForKey:@"id"] isEqualToString:[eachArticle objectForKey:@"id"]]) {
                detailVC.currentIndex = i;
                break;
            }
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isEndOfTableView = NO;
   
    
    self.tabBarController.delegate = self;
    
    self.tabBarController.navigationItem.hidesBackButton = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"BackWhite.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"BackWhite.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.tabBarController.navigationItem.leftBarButtonItem = customBarItem;
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];//[UIColor pxColorWithHexValue:@"#f4f3f3"];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];//[UIColor pxColorWithHexValue:@"f4f3f3"];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillArticleArr:) name:@"fillArticleArr" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedArticleDownload:) name:@"finishedArticleDownload" object:nil];
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSString* tabStr = tabBarController.tabBar.selectedItem.title;
    if (![tabStr isEqualToString:currentVC]) {
        currentVC = tabStr;
        [[NSUserDefaults standardUserDefaults] setObject:currentVC forKey:@"CurrentViewController"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.navigationController.topViewController.title = currentVC;
       // [self fillArticleArr:nil];
    
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedArticleDownload:) name:@"finishedArticleDownload" object:nil];
    
    currentVC = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"];
    self.navigationController.topViewController.title = currentVC;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"%@ Article List Screen",currentVC]];
    // Send the screen view.
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        if ([self isRetina4InchDisplay]) {
            self.navigationController.navigationBar.translucent = NO;
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length+66.0, 0);
        }
        else {
            self.navigationController.navigationBar.translucent = NO;
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length+156.0, 0);
        }

    } else {
        //self.tabBarController.tabBar.translucent = NO;
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 125)];
        footer.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footer;
    }
    
    
    
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    self.adsArray = [[NSMutableArray alloc] init];
    NSArray *adsArr = [sqlHelper executeQuery:@"select image_url,position,website_url from adver_list where position='list'"];
    for(NSDictionary* adsDict in adsArr) {
        MSAdvers* adsObj = [[MSAdvers alloc] initWithAdsUrl:[adsDict objectForKey:@"image_url"] withPosition:[adsDict objectForKey:@"position"] withWebURL:[adsDict objectForKey:@"website_url"]];
        [self.adsArray addObject:adsObj];
    }
    self.isFirstLoad = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // self.navigationController.navigationBar.topItem.title = currentVC;
    [self fillArticleArr:nil];
   
}

- (void)fillArticleArr:(NSNotification*)notification
{
    
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray* arsArr = [NSArray array];
    NSString* currentTable;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"EVENTS"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from event_list"];
        currentTable = @"event_list";
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"FEATURES"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from feature_list"];
        currentTable = @"feature_list";
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"BEAUTY"]) {
        
        
        arsArr = [sqlHelper executeQuery:@"select * from beauty_list"];
        currentTable = @"beauty_list";
        
    } 
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"FASHION"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from fashion_list"];
        currentTable = @"fashion_list";
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"LIVING"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from living_list"];
        currentTable = @"living_list";
    }
    
    if (arsArr.count == 0 && self.isFirstLoad) {
        self.isEndOfTableView = NO;
        self.isFirstLoad = NO;
        if ([self connectedToInternet]) {
            [self showHud:@"Downloading Articles..."];
            MODAdataFetching* dataFetcher = [[MODAdataFetching alloc] init];
            [dataFetcher articleDownloadWithHTTP:[NSString stringWithFormat:@"http://www.moda.com.mm/mobile/%@?offset=1&limit=10",currentTable] withKey:[NSString stringWithFormat:@"%@",currentTable]];

        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
        
    }
    else {
        if (self.isEndOfTableView || (arsArr.count < 3 && self.isFirstLoad)) {
            self.isEndOfTableView = NO;
            if ([self connectedToInternet]) {
                
                [self showHud:@"Downloading Articles..."];
                
                self.isFirstLoad = NO;
                MODAdataFetching* dataFetcher = [[MODAdataFetching alloc] init];
                [dataFetcher articleDownloadWithHTTP:[NSString stringWithFormat:@"http://www.moda.com.mm/mobile/%@?offset=1&limit=%d",currentTable,arsArr.count+10] withKey:[NSString stringWithFormat:@"%@",currentTable]];
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            
        }
        
    }
    
    if (self.adsArray.count > 0 && arsArr.count > 0) {
        self.articleArray = [self getAds:arsArr];
    }
    else {
        self.articleArray = [arsArr copy];
    }

    [self.tableView reloadData];
}

- (BOOL)connectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)finishedArticleDownload:(NSNotification*)notification
{
    [self hideHud];
    MODAdataFetching* dataFetcher = (MODAdataFetching*)notification.object;
    if (!dataFetcher.isArticleError && !dataFetcher.isArticleMaxoffset) {
        [self fillArticleArr:nil];
    }
    else if (dataFetcher.isVideoError) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Gallery Download Error" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void) showHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}

- (void) hideHud
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}



- (NSArray*) getAds:(NSArray*)placesArr
{

    NSInteger fixNum = 1; // 3-5-7-9
    NSInteger multiplier = 2;
    int articleCount = placesArr.count;
    NSMutableArray* resultArr = [placesArr mutableCopy];
    for (int i=0; i < self.adsArray.count; i++) {
        NSInteger randNum =  fixNum * multiplier; // Generate Fix Number
        fixNum += multiplier;
        
        if (randNum < articleCount) {
            [resultArr insertObject:self.adsArray[i] atIndex:randNum];
        }
        else {
            [resultArr addObject:self.adsArray[i]];
            break;
        }
    }
    
    return resultArr;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
////    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
////        CGFloat verticalOffset = -20;
////        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
////    } else {
////        CGFloat verticalOffset = 14;
////        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
////    }
//    
//    [self.navigationController.navigationBar setNeedsLayout];
//}

//- (void)deviceOrientationDidChange:(NSNotification*)notification
//{
//    [self.tableView reloadData];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.articleArray[indexPath.row] isKindOfClass:[MSAdvers class]]) {
        
        static NSString *adsCellID = @"ModaAds";
        ModaAdsCell* cell = [self.tableView dequeueReusableCellWithIdentifier:adsCellID];
        //cell.cellAdsImg.image = [UIImage imageNamed:self.articleArray[indexPath.row]];
        MSAdvers* ads = self.articleArray[indexPath.row];
        NSString* strurl = ads.adsUrl;
        NSURL* imgUrl = [NSURL URLWithString:strurl];
        //UIImage* img = [UIImage imageNamed:self.articleArray[indexPath.row]];
        [cell.cellAdsImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"adsPlaceholder.png"] completed:nil];
        
//        CGSize imgSize = cell.cellAdsImg.image.size;
//        CGSize imgViewSize = cell.cellAdsImg.frame.size;//CGSizeMake(curCell.frame.size.width, curCell.cellAdsImg.frame.size.height);
//        
//        float imgRatio = imgSize.width / imgSize.height;
//        float viewRatio = imgViewSize.width / imgViewSize.height;
//        
//        float scale;
//        if (imgRatio > viewRatio) {
//            scale = imgSize.width / imgViewSize.width;
//        } else {
//            scale = imgSize.height / imgViewSize.height;
//        }
//        
//        CGRect frame = CGRectZero;
//        
//        frame.size = CGSizeMake(roundf(imgSize.width / scale), roundf(imgSize.height / scale));
//        frame.origin = CGPointMake((imgViewSize.width - frame.size.width)/2.0, cell.cellAdsImg.frame.origin.y);
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    }
    else {
        
        static NSString *CellIdentifier = @"Article Cell";
        ArticleListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSDictionary *article = self.articleArray[indexPath.row];
        cell.titleLabel.text = [article objectForKey:@"title"];//article.articleTitle;
        //cell.detailLabel.text = article.articleDetails;
        cell.authorLabel.text = @"Label"; //article.articleAuthor;
        //cell.cellImageView.image = [UIImage imageNamed:article.articlePhoto];
        NSString* imgurlStr = [[article objectForKey:@"image_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.cellImageView setImageWithURL:[NSURL URLWithString:imgurlStr] placeholderImage:[UIImage imageNamed:@"placeholderlist.png"] completed:nil];
        [cell.cellImageView sizeToFit];
        [cell.contentView setNeedsLayout];
        [cell.contentView layoutIfNeeded];
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height + 40;

        }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.articleArray[indexPath.row] isKindOfClass:[MSAdvers class]]) {
        
        static NSString *adsCellID = @"ModaAds";
        ModaAdsCell* cell = [self.tableView dequeueReusableCellWithIdentifier:adsCellID forIndexPath:indexPath];
        if(cell == nil) cell = [[ModaAdsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adsCellID];
        
        //NSString* imgStr = self.articleArray[indexPath.row];
        //cell.cellAdsImg.image = [UIImage imageNamed:imgStr];
        MSAdvers* ads = self.articleArray[indexPath.row];
        NSString* strurl = [ads.adsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"AdvertisementView" action:@"Show Ads View In Article List" label:strurl value:nil] build]];
        NSURL* imgUrl = [NSURL URLWithString:strurl];
        [cell.cellAdsImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"adsPlaceholder.png"] completed:nil];
        cell.cellAdsImg.contentMode = UIViewContentModeScaleAspectFit;
        cell.cellAdsImg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        cell.cellAdsImg.clipsToBounds = YES;
        cell.cellAdsImg.backgroundColor = [UIColor blackColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];
        cell.cellbgView.backgroundColor = [UIColor redColor];
        cell.cellbgView.layer.cornerRadius = 5;
        cell.cellbgView.layer.borderColor = [[UIColor colorWithRed:154.0/255.0 green:134.0/255.0 blue:36.0/255.0 alpha:1.0] CGColor];
        cell.cellbgView.layer.borderWidth = 0.5;
        //        cell.cellbgView.layer.shadowOffset = CGSizeMake(-2, 2);
        //        cell.cellbgView.layer.shadowRadius = 4;
        //        cell.cellbgView.layer.shadowOpacity = 0.8;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];
        
        
        return cell;

    }
    else {
        
        static NSString *CellIdentifier = @"Article Cell";
        ArticleListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(cell == nil) cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        NSDictionary *article = self.articleArray[indexPath.row];
        
        NSString* fontTitleName;
        NSString*  fontName;
        if ([[article objectForKey:@"status"] isEqualToString:@"1"]) {
            fontTitleName = @"BauerBodoni BT";
            fontName = @"Times New Roman";
        }
        else {
            fontTitleName = @"Zawgyi-One";
            fontName = @"Zawgyi-One";
        }
        cell.titleLabel.font = [UIFont fontWithName:fontTitleName size:16];
        cell.detailLabel.font = [UIFont fontWithName:fontName size:12];
        cell.authorLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        
        cell.titleLabel.text = [article objectForKey:@"title"];//article.articleTitle;
        cell.detailLabel.text = [article objectForKey:@"description"];//article.articleDetails;
        cell.authorLabel.text = [article objectForKey:@"issue"];
        
        NSString* imgurlStr = [[article objectForKey:@"image_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.cellImageView setImageWithURL:[NSURL URLWithString:imgurlStr] placeholderImage:[UIImage imageNamed:@"placeholderlist.png"] completed:nil];
        cell.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        cell.cellImageView.clipsToBounds = YES;
        cell.bgView.backgroundColor =  [UIColor whiteColor];
        cell.bgView.layer.cornerRadius = 5;
        cell.bgView.layer.borderColor = [[UIColor redColor] CGColor];//[[UIColor colorWithRed:154.0/255.0 green:134.0/255.0 blue:36.0/255.0 alpha:1.0] CGColor];
        cell.bgView.layer.borderWidth = 0.5;
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];
        
        cell.cellHeader.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:154.0/255.0 green:134.0/255.0 blue:36.0/255.0 alpha:1.0];
        cell.cellHeader.layer.cornerRadius = 5;
        cell.cellHeaderLbl.text = [article objectForKey:@"type"]; //article.articleSubCat;
        cell.cellHeaderLbl.textColor = [UIColor whiteColor];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.articleArray[indexPath.row] isKindOfClass:[MSAdvers class]]) {
        MSAdvers* ads = self.articleArray[indexPath.row];
        NSString* strURL = [ads.adsWeburl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    }
}

- (BOOL)isRetina4InchDisplay {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        return NO;
    return (CGSizeEqualToSize([[UIScreen mainScreen] currentMode].size, CGSizeMake(640, 1136)));
}


#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) == [scrollView contentSize].height)
    {
        self.isEndOfTableView = YES;
        [self fillArticleArr:nil];
        return;
	}
}


//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.articleArray[indexPath.row] isKindOfClass:[MSAdvers class]]) {
//        ModaAdsCell* listCell = (ModaAdsCell*) cell;
//        listCell.cellbgView.layer.shadowOffset = CGSizeMake(-2, 2);
//        listCell.cellbgView.layer.shadowRadius = 3;
//        listCell.cellbgView.layer.shadowOpacity = 0.8;
//    } else {
//        ArticleListCell* listCell = (ArticleListCell*)cell;
//        listCell.bgView.layer.shadowOffset = CGSizeMake(-2, 2);
//        listCell.bgView.layer.shadowRadius = 3;
//        listCell.bgView.layer.shadowOpacity = 0.8;
//    }
    
    
    //1. Setup the CATransform3D structure
//    CATransform3D slide;
//    slide = CATransform3DMakeTranslation(-360, 0, 0.4);
//    slide.m34 = 1.0/ -600;
//    //cell.layer.opacity = 1;
//    //UIView* cellBgView = [(ArticleListCell*)cell bgView];
//    
//    //2. Define the initial state (Before the animation)
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    cell.layer.transform = self.slide;
//    
//    //3. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"translation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
////    cellBgView.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
    
//    if (![self.articleArray[indexPath.row] isKindOfClass:[Article class]])
//    {
//        ModaAdsCell* curCell = (ModaAdsCell*) cell;
//        
//        MSAdvers* ads = self.articleArray[indexPath.row];
//        NSString* strurl = ads.adsUrl;
//        NSURL* imgUrl = [NSURL URLWithString:strurl];
//        //UIImage* img = [UIImage imageNamed:self.articleArray[indexPath.row]];
//        [curCell.cellAdsImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"photo-01.jpg"] completed:nil];
//        
//        CGSize imgSize = curCell.cellAdsImg.image.size;
//        CGSize imgViewSize = curCell.cellAdsImg.frame.size;//CGSizeMake(curCell.frame.size.width, curCell.cellAdsImg.frame.size.height);
//        
//        float imgRatio = imgSize.width / imgSize.height;
//        float viewRatio = imgViewSize.width / imgViewSize.height;
//        
//        float scale;
//        if (imgRatio > viewRatio) {
//            scale = imgSize.width / imgViewSize.width;
//        } else {
//            scale = imgSize.height / imgViewSize.height;
//        }
//        
//        CGRect frame = CGRectZero;
//        
//        frame.size = CGSizeMake(roundf(imgSize.width / scale), roundf(imgSize.height / scale));
//        frame.origin = CGPointMake((imgViewSize.width - frame.size.width)/2.0, curCell.cellAdsImg.frame.origin.y);
//        
//        [curCell.cellAdsImg setFrame:frame];
//        
//        [cell.contentView layoutSubviews];
//    }

//}



//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.tabBarController.tabBar removeObserver:self forKeyPath:@"selectedItem"];
//}

@end
