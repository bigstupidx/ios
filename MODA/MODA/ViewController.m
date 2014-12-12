//
//  ViewController.m
//  MODA
//
//  Created by Macbook Pro on 12/6/13.
//  Copyright (c) 2013 Ignite Software Solution. All rights reserved.
//

#import "ViewController.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "ArticleListVC.h"
#import "ModaHomeCell.h"
#import "UIColor+UIColor_PXExtentions.h"
#import "AGPhotoBrowserView.h"

#import "MODAdataFetching.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MSAdvers.h"
#import "ZMFMDBSQLiteHelper.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"


@interface ViewController ()<AGPhotoBrowserDataSource, AGPhotoBrowserDelegate>
{
    BOOL isFromLeft;
    UITabBarController* tabBar;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
//@property (strong, nonatomic) NSArray *picArray;
@property (strong, nonatomic)  AGPhotoBrowserView *photoView;
@property (nonatomic, strong) NSMutableArray *photoHolder;
@property (nonatomic, strong) NSMutableArray *urlStrHolder;

@end

@implementation ViewController

- (NSMutableArray *) photoHolder {
    if (!_photoHolder) _photoHolder = [NSMutableArray array];
    return _photoHolder;
}

- (AGPhotoBrowserView *)browserView
{
	if (!_photoView) {
        
		_photoView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.frame];
		_photoView.delegate = self;
		_photoView.dataSource = self;
        _photoView.doneButton.hidden = YES;
        _photoView.overlayView.hidden = YES;
	}
	
	return _photoView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSLog(@"Available fonts: %@", [UIFont familyNames]);
    //self.navigationItem.title = @"MODA";
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentCenter;
    lbNavTitle.text = @"MODA";
    lbNavTitle.textColor = [UIColor whiteColor];
    lbNavTitle.font = [UIFont fontWithName:@"BauerBodoni BT" size:50.0];
    lbNavTitle.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = lbNavTitle;
    self.array = @[@"FASHION", @"BEAUTY", @"LIVING", @"FEATURES", @"EVENTS", @"PHOTO GALLERY", @"VIDEO"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    isFromLeft = YES;
    self.urlStrHolder = [[NSMutableArray alloc] init];
    
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];

    NSArray *adsArr = [sqlHelper executeQuery:@"select image_url,position from adver_list where position='home'"];
    for(NSDictionary* adsDict in adsArr) {
        NSMutableDictionary* mulDict = [[NSMutableDictionary alloc] init];
        MSAdvers* adsObj = [[MSAdvers alloc] initWithAdsUrl:[adsDict objectForKey:@"image_url"] withPosition:[adsDict objectForKey:@"position"] withWebURL:nil];
        [self.urlStrHolder addObject:[adsDict objectForKey:@"image_url"]];
        NSString* str = [adsObj.adsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mulDict setObject:[NSURL URLWithString:str] forKey:@"Image"];
        [self.photoHolder addObject:mulDict];
    }
    
    [self.view addSubview:self.photoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishArticlesDownload:) name:@"finishArticlesDownload" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"MODA Home Screen"];
    // Send the screen view.
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowFirstAdsView"]) {
        if (self.photoHolder.count > 0) {
            self.tableView.backgroundColor = [UIColor blackColor];
            [[self browserView] showFromIndex:0 withView:self.view];
            double delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //code to be executed on the main queue after delay
                [self dismissAdsView];
                [self.tableView reloadData];
            });
            
            //        [self performSelector:@selector(dismissAdsView) withObject:nil afterDelay:5.0];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowFirstAdsView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            [self.tableView reloadData];
        }
        
    } else {
        [self.tableView reloadData];
    }

    
}

- (void) showHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}

- (void) hideHud
{
    
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
}

- (void)finishArticlesDownload:(NSNotification*)notification
{
    [self hideHud];
}


- (void)setupTabBarController
{
    
    UIStoryboard *sbBeauty = [UIStoryboard getLivingArticleStoryboard];
    UIViewController *vcBeauty = [sbBeauty instantiateInitialViewController];
    
    
//    UIStoryboard *sbFeat = [UIStoryboard getLivingArticleStoryboard];
    UIViewController *vcFeat = [sbBeauty instantiateInitialViewController];
    
    
//    UIStoryboard *sbEvents = [UIStoryboard getLivingArticleStoryboard];
    UIViewController *vcEvents = [sbBeauty instantiateInitialViewController];
    
//    UIStoryboard *sbFashion = [UIStoryboard getLivingArticleStoryboard];
    UIViewController *vcFashion = [sbBeauty instantiateInitialViewController];
    
//    UIStoryboard *sbLiving = [UIStoryboard getLivingArticleStoryboard];
    UIViewController *vcLiving = [sbBeauty instantiateInitialViewController];
    
    tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[vcFashion, vcBeauty, vcLiving, vcFeat, vcEvents];
    [[[tabBar.tabBar items] objectAtIndex:0] setTitle:@"FASHION"];
    [[[tabBar.tabBar items] objectAtIndex:1] setTitle:@"BEAUTY"];
    [[[tabBar.tabBar items] objectAtIndex:2] setTitle:@"LIVING"];
    [[[tabBar.tabBar items] objectAtIndex:3] setTitle:@"FEATURES"];
    [[[tabBar.tabBar items] objectAtIndex:4] setTitle:@"EVENTS"];

}

- (void)dismissAdsView
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.photoView hideWithCompletion:nil];

}

- (void)canNotRotate { }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = @"homeCell";
    ModaHomeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil) {
        cell = [[ModaHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
            }
    cell.cellLabel.font = [UIFont fontWithName:@"BauerBodoni BT" size:16];
    cell.cellLabel.textColor = [UIColor pxColorWithHexValue:@"000000"];
    //cell.cellLabel.textAlignment = NSTextAlignmentCenter;
    cell.cellBgView.backgroundColor = [UIColor whiteColor];//[UIColor pxColorWithHexValue:@"9a8624"];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_lines.png"]];//[UIColor pxColorWithHexValue:@"eaeaea"];
    cell.cellBgView.layer.cornerRadius = 2;
    cell.cellBgView.layer.borderColor = [[UIColor blackColor] CGColor];//[[UIColor pxColorWithHexValue:@"9a8624"] CGColor];
    cell.cellBgView.layer.borderWidth = 0.5;

    cell.cellLabel.text = self.array[indexPath.row];//indexPath.section
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setupTabBarController];
    if (indexPath.row < 5) {
        [tabBar setSelectedIndex:indexPath.row];
        
        ArticleListVC* listVC = [[ArticleListVC alloc] init];
        UITabBarItem* item = tabBar.tabBar.items[indexPath.row];
        listVC.strTabbarTitle = item.title;
        [[NSUserDefaults standardUserDefaults] setObject:item.title forKey:@"CurrentViewController"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"fillArticleArr" object:self];
        
        [self.navigationController pushViewController:tabBar animated:YES];

    }
    else if (indexPath.row == 5) {
        UIStoryboard *sbGallery = [UIStoryboard getPhotoGalleryStoryboard];
        UIViewController *vcGallery = [sbGallery instantiateInitialViewController];
        [self.navigationController pushViewController:vcGallery animated:YES];
    } else if (indexPath.row == 6) {
        UIStoryboard *sbVideo = [UIStoryboard getVideoListStoryboard];
        UIViewController *vcVideo = [sbVideo instantiateInitialViewController];
        [self.navigationController pushViewController:vcVideo animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //1. Setup the CATransform3D structure
    CATransform3D slide;
    if (isFromLeft) {
        slide = CATransform3DMakeTranslation(-360, 0, 0.4);
        isFromLeft = NO;
    } else {
        slide = CATransform3DMakeTranslation(360, 0, 0.4);
        isFromLeft = YES;
    }
    
    slide.m34 = 1.0/ -600;
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = slide;
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"translation" context:NULL];
    [UIView setAnimationDuration:0.6];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectZero];
//    footer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];//[UIColor pxColorWithHexValue:@"000000"];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] initWithFrame:CGRectZero];
//    header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];//[UIColor pxColorWithHexValue:@"000000"];
    return header;
}

// PHOTO SCROLLER METHODS

#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    return 1;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
//    NSUInteger currentAdsIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"InitialAdsIndex"];
//    if (((self.photoHolder.count-1) <= currentAdsIndex)) {
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"InitialAdsIndex"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    }
//    else if ((self.photoHolder.count-1) > currentAdsIndex) {
//        [[NSUserDefaults standardUserDefaults] setInteger:currentAdsIndex+1 forKey:@"InitialAdsIndex"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
//    currentAdsIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"InitialAdsIndex"];
    //return [[self.photoHolder objectAtIndex:currentAdsIndex] objectForKey:@"Image"];
//    UIImage* pHimg;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"adsImage"]) {
//        NSArray* arrImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"adsImage"];
//        pHimg = arrImg[0];
//    }
//    if (!pHimg) {
//        pHimg = [UIImage imageNamed:@"PlaceHolderModa.png"];
//    }
//    
    NSURL* imgURL = [[self.photoHolder objectAtIndex:0] objectForKey:@"Image"];
    UIImageView *newPageView = [[UIImageView alloc] init];
    [newPageView setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"PlaceHolderModa.png"]];
     NSString* str = self.urlStrHolder[0];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"AdvertisementView" action:@"Show Ads View In Home Screen" label:str value:nil] build]];
    return newPageView.image;
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
}

 
@end
