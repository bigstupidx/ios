//
//  ArticleDetailHolderVC.m
//  Moda
//
//  Created by Macbook Pro on 12/17/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "ArticleDetailHolderVC.h"
#import "ArticleDetailVC.h"
#import "Article.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "AGPhotoBrowserView.h"

#import "UIImageView+WebCache.h"
#import "ZMFMDBSQLiteHelper.h"
#import "MODAdataFetching.h"

#import <Social/Social.h>
#import "Reachability.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"


@interface ArticleDetailHolderVC () <SwipeViewDataSource, SwipeViewDelegate, AGPhotoBrowserDelegate, AGPhotoBrowserDataSource>
{
    UIView* oldView;
    NSString* currentVCName;
    BOOL isPhotoViewOn;
    
    int currentPhotoIndex;
}
@property (nonatomic, strong) NSMutableArray *photoHolder;
@property (strong, nonatomic)  AGPhotoBrowserView *photoView;
@property (nonatomic, assign) BOOL isReturnFromDownloading;

@end

@implementation ArticleDetailHolderVC

- (NSMutableArray *) photoHolder {
    if (!_photoHolder) _photoHolder = [NSMutableArray array];
    return _photoHolder;
}

- (NSMutableArray *) onlyArticleArr {
    if (!_onlyArticleArr) _onlyArticleArr = [NSMutableArray array];
    return _onlyArticleArr;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isPhotoViewOn = NO;
    [self.view addSubview:_swipeView];
    [_swipeView addSubview:self.photoView];
    
    currentVCName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"];
    self.isReturnFromDownloading = NO;
    
    self.navigationItem.hidesBackButton = YES;
    CGRect frameimgback1 = CGRectMake(0, 0, 30, 30);
    UIButton *back = [[UIButton alloc] initWithFrame:frameimgback1];
    [back setImage:[UIImage imageNamed:@"BackWhite.png"] forState:UIControlStateNormal];
    [back addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnL = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = btnL;
    
    //CGRect frameimgback1 = CGRectMake(0, 0, 30, 30);
    UIButton *share = [[UIButton alloc] initWithFrame:frameimgback1];
    [share setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnLShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItem = btnLShare;
    
    _swipeView.backgroundColor = [UIColor whiteColor];
    _swipeView.pagingEnabled = YES;
    self.navigationController.navigationBar.translucent = NO;
    _swipeView.currentItemIndex = self.currentIndex;
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(childVCFrameUpdate:) name:@"childVCFrameUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewTapped:) name:@"imageViewTapped" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedMoreArticleDownload:) name:@"finishedMoreArticleDownload" object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Article Detail Screen"];
    // Send the screen view.
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    self.navigationController.topViewController.title = currentVCName;
    currentPhotoIndex = 0;
}

- (void)childVCFrameUpdate:(NSNotification*)notification
{
    ArticleDetailVC* childvc = (ArticleDetailVC*)notification.object;
    childvc.view.frame = self.view.frame;
}


- (void)imageViewTapped:(NSNotification*)notification
{
    if (self.photoHolder.count > 0) {
        [self.photoHolder removeAllObjects];
    }
    
    NSDictionary* currentAr = [[NSUserDefaults standardUserDefaults] objectForKey:@"curArticle"];
    //Article* storedArticle = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject]
    
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray* galleryArr = [sqlHelper executeQuery:[NSString stringWithFormat:@"select * from gallery where id='%@'",[currentAr objectForKey:@"id"]]];//[NSString ]];
    
    NSMutableDictionary* mulDict = [[NSMutableDictionary alloc] init];
    NSString* imgUrlStr = [[currentAr objectForKey:@"image_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL* imgurl = [NSURL URLWithString:imgUrlStr];
    [mulDict setObject:imgurl forKey:@"Image"];
    [mulDict setObject:[NSString stringWithFormat:@"%d / %d", 1, galleryArr.count+1] forKey:@"Description"];
    [self.photoHolder addObject:mulDict];
    
    int i =0;
    for (NSDictionary* imgUrl in galleryArr) {
        NSString* str = [imgUrl objectForKey:@"gallery_img_url"]; 
        NSMutableDictionary* mulDict = [[NSMutableDictionary alloc] init];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // remove space in str
        
        NSURL* url = [NSURL URLWithString:str];
        [mulDict setObject:url forKey:@"Image"];
        [mulDict setObject:[NSString stringWithFormat:@"%d / %d", 2+i, galleryArr.count+1] forKey:@"Description"];
        [self.photoHolder addObject:mulDict];
        i++;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.hidden =YES;
    }
    if (!isPhotoViewOn) {
        currentPhotoIndex = 0;
    }
    [self.browserView showFromIndex:currentPhotoIndex withView:self.view];
    isPhotoViewOn = YES;
}

- (void)shareArticle
{
    NSDictionary* currentAr = [[NSUserDefaults standardUserDefaults] objectForKey:@"curArticle"];
    UIImageView* imgView = [[UIImageView alloc] init];
    NSString* str = [[currentAr objectForKey:@"image_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [imgView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"PlaceHolderModa.png"] completed:nil];
    SLComposeViewController *slComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [slComposer setInitialText:@"Check out this Article on MODA"];
    NSURL* sampleURL = [NSURL URLWithString:[[currentAr objectForKey:@"web_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [slComposer addURL:sampleURL];
    [slComposer addImage:imgView.image];
    [self presentViewController:slComposer animated:YES completion:nil];
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    [self.childViewControllers.lastObject willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
//    [_swipeView reloadData];
    
}

- (void)deviceOrientationDidChange:(NSNotification*)notification
{
    if (isPhotoViewOn) {
        [self.photoView hideWithCompletion:nil];
    }
    _photoView = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    ((ArticleDetailVC*)(self.childViewControllers.lastObject)).view.frame = self.view.frame;
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"parentRotate" object:self];
    
     [_swipeView reloadData];
    
//    CGSize size = _swipeView.frame.size;
    
    if (isPhotoViewOn) {
        
        [self.browserView showFromIndex:currentPhotoIndex withView:self.view];
    }

}

- (ArticleDetailVC *)viewControllerAtIndex:(NSUInteger)index {
    
    UIStoryboard *sb = [UIStoryboard getLivingArticleStoryboard];

    ArticleDetailVC *childViewController = (ArticleDetailVC*) [sb instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
    
    NSDictionary* curArticle = self.onlyArticleArr[index];

    childViewController.article = curArticle;
    [self addChildViewController:childViewController]; //*** viewWillAppear ... of child VC to get called ***
    
    return childViewController;
    
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return self.onlyArticleArr.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    ArticleDetailVC* currentVC = [self viewControllerAtIndex:index];

    view = currentVC.view;

    int maxCount = self.onlyArticleArr.count - 1;
    
    if (!self.isReturnFromDownloading) {
        if (index == maxCount) {
            [self downloadMoreArticle];
        }
    }
    self.isReturnFromDownloading = NO;
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.view.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    NSDictionary* nowArticle = self.onlyArticleArr[_swipeView.currentItemIndex];
    
    [[NSUserDefaults standardUserDefaults] setObject:nowArticle forKey:@"curArticle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// PHOTO SCROLLER METHODS
- (AGPhotoBrowserView *)browserView
{
	if (!_photoView) {
		_photoView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.frame];
		_photoView.delegate = self;
		_photoView.dataSource = self;
	}
	
	return _photoView;
}

- (void)downloadMoreArticle
{
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray *arsArr = [NSArray array];
    NSString *currentTable;
    
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
    
    if ([self connectedToInternet]) {
        MODAdataFetching* dataFetcher = [[MODAdataFetching alloc] init];
        dataFetcher.isMoreArticleDownload = YES;
        [dataFetcher articleDownloadWithHTTP:[NSString stringWithFormat:@"http://www.moda.com.mm/mobile/%@?offset=1&limit=%d",currentTable,arsArr.count+10] withKey:[NSString stringWithFormat:@"%@",currentTable]];
    } else {
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        
    }


}

- (BOOL)connectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)finishedMoreArticleDownload:(NSNotification*)notification
{
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray *arsArr = [NSArray array];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"EVENTS"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from event_list"];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"FEATURES"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from feature_list"];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"BEAUTY"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from beauty_list"];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"FASHION"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from fashion_list"];
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewController"] isEqualToString:@"LIVING"]) {
        
        arsArr = [sqlHelper executeQuery:@"select * from living_list"];
        
    }
    self.onlyArticleArr = [arsArr copy];
    self.isReturnFromDownloading = YES;
    [_swipeView reloadData];
}


#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    int count = self.photoHolder.count;
	return count;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    currentPhotoIndex = index;
    NSURL* imgURL = [[self.photoHolder objectAtIndex:index] objectForKey:@"Image"];
    UIImageView *newPageView = [[UIImageView alloc] init];
    [newPageView setImageWithURL:imgURL
                placeholderImage:[UIImage imageNamed:@"PlaceHolderModa.png"]];
//    UIImage* img = newPageView.image;
    
    return newPageView.image;
    
    //return [[self.photoHolder objectAtIndex:index] objectForKey:@"Image"];
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
    return @"";
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
    NSString* strDesc = [[self.photoHolder objectAtIndex:index] objectForKey:@"Description"];
    return strDesc;
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	[self.photoView hideWithCompletion:^(BOOL finished){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            self.navigationController.navigationBar.hidden =NO;
            self.navigationController.navigationBar.translucent = NO;
        }
        isPhotoViewOn = NO;
	}];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{

    NSURL* imgURL = [[self.photoHolder objectAtIndex:index] objectForKey:@"Image"];
    
    SLComposeViewController *slComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [slComposer setInitialText:@"Check out this Photo on MODA"];
    [slComposer addURL:imgURL];
    [self presentViewController:slComposer animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
