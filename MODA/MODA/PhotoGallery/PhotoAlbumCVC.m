//
//  PhotoAlbumCVC.m
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "PhotoAlbumCVC.h"
#import "PhotoAlbumLayout.h"
#import "Album.h"
#import "Photo.h"
#import "AlbumTitleResuableView.h"
#import "AlbumPhotoCell.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "UIImageView+WebCache.h"
#import "PhotoGalleryVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MODAdataFetching.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

#define NUMBER_OF_IMAGES 24
static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface PhotoAlbumCVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet PhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@property (strong, nonatomic) Album *selectedAlbum;
@property (assign, nonatomic) BOOL isEndOfCollView;
@property (assign, nonatomic) BOOL isFirstLoad;

@end

@implementation PhotoAlbumCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.albums = [NSMutableArray array];
    
    self.isEndOfCollView = NO;
    self.isFirstLoad = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedGalleryDownload:) name:@"finishedGalleryDownload" object:nil];
    [self downloadGallery];
    
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[AlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[AlbumTitleResuableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    if(!self.thumbnailQueue) self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    self.navigationItem.hidesBackButton = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"BackWhite.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"BackWhite.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Gallery Album Screen"];
    // Send the screen view.
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.navigationController.topViewController.title = @"GALLERY";
    [self.collectionView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Album *album = self.albums[section];
    return album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AlbumPhotoCell *photoCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                              forIndexPath:indexPath];
    
    Album *album = self.albums[indexPath.section];
    Photo *photo = album.photos[indexPath.item];
    
    // load photo images in the background
    __weak PhotoAlbumCVC *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //UIImage *image = [photo image];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                AlbumPhotoCell *cell =
                (AlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                //cell.imageView.image = image;
                if(indexPath.item == 0)[cell.imageView setImageWithURL:photo.imageURL
                                                      placeholderImage:[UIImage imageNamed:@"moda"]];
                else cell.imageView.image = [UIImage imageNamed:@"moda"];
            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    AlbumTitleResuableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:AlbumTitleIdentifier
                                              forIndexPath:indexPath];
    
    Album *album = self.albums[indexPath.section];
    titleView.titleLabel.text = album.name;
    
    return titleView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.selectedAlbum = self.albums[indexPath.section];
//    [self.browserView showFromIndex:0];
    UIStoryboard *sb = [UIStoryboard getPhotoGalleryStoryboard];
    PhotoGalleryVC *galleryVC = [sb instantiateViewControllerWithIdentifier:@"Photo Gallery"];
    galleryVC.album = self.albums[indexPath.section];
    [self.navigationController pushViewController:galleryVC animated:YES];
}

- (BOOL)connectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
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


- (void)downloadGallery
{
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray* galleryArr = [sqlHelper executeQuery:@"select * from gallery_list"];
    
    if (((self.isFirstLoad)&&(galleryArr.count < 10)) || self.isEndOfCollView == YES) {
        self.isEndOfCollView = NO;
        self.isFirstLoad = NO;
        if ([self connectedToInternet]) {
            [self showHud:@"Downloading Gallery..."];
            MODAdataFetching* dataFetcher = [[MODAdataFetching alloc] init];
            [dataFetcher galleryDownloadingWithLimit:galleryArr.count+10];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }
    if (galleryArr.count > 0) {
        [self.albums removeAllObjects];
    }
    
    for (NSDictionary* galDict in galleryArr) {
        NSMutableArray* mulArr = [NSMutableArray array];
        NSString* str = [[galDict objectForKey:@"image_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        Photo* foto = [[Photo alloc] initWithImageUrl:[NSURL URLWithString:str]];
        [mulArr addObject:foto];
        NSArray* fotoArr = [sqlHelper executeQuery:[NSString stringWithFormat:@"select imagename from gallery_list_gallery where id='%@'",[galDict objectForKey:@"id"]]];
        for (NSDictionary* fotoDict in fotoArr) {
            NSString* urlStr = [[fotoDict objectForKey:@"imagename"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            Photo* fotoObj = [[Photo alloc] initWithImageUrl:[NSURL URLWithString:urlStr]];
            [mulArr addObject:fotoObj];
        }
        Album* albumObj = [[Album alloc] initWithName:[galDict objectForKey:@"title"] withPhotos:mulArr];
        [self.albums addObject:albumObj];
        
        [self.collectionView reloadData];

    }
}

- (void)finishedGalleryDownload:(NSNotification*)notification
{
    [self hideHud];
    self.isFirstLoad = NO;
    MODAdataFetching* dataFetcher = (MODAdataFetching*)notification.object;
    if (!dataFetcher.isGalleryError && !dataFetcher.isGalleryMaxOffset) {
        [self downloadGallery];
    }
    else if (dataFetcher.isGalleryError) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Gallery Download Error" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"SCROLLVIEW Y = %f, HEIGHT = %f, CURRENT PoINT = %f, CONTENT HEIGHT = %f",scrollView.contentOffset.y,scrollView.frame.size.height,scrollView.contentOffset.y+scrollView.frame.size.height,[scrollView contentSize].height);
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) == [scrollView contentSize].height)
    {
        self.isEndOfCollView = YES;
        [self downloadGallery];
        return;
    }
}

    

//#pragma mark - Getters
//
//- (AGPhotoBrowserView *)browserView
//{
//	if (!_browserView) {
//		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.bounds];
//		_browserView.delegate = self;
//		_browserView.dataSource = self;
//	}
//	
//	return _browserView;
//}
//
//#pragma mark - AGPhotoBrowser datasource
//
//- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
//{
//    return self.selectedAlbum.photos.count;
//}
//
//- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
//{
//    Photo *photo = self.selectedAlbum.photos[index];
//    UIImageView *tempImageView = [UIImageView new];
//    [tempImageView setImageWithURL:photo.imageURL
//                  placeholderImage:[UIImage imageNamed:@"moda"]];
//    return tempImageView.image;
//}
//
//- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
//{
//    Photo *photo = self.selectedAlbum.photos[index];
//    return photo.title;
//}
//
//- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
//{
//    Photo *photo = self.selectedAlbum.photos[index];
//    return photo.description;
//}
//
//#pragma mark - AGPhotoBrowser delegate
//
//- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
//{
//    //[self.browserView hideWithCompletion:NULL];
//    [self.browserView hideWithCompletion:^(BOOL finished){
//		NSLog(@"Dismissed!");
//	}];
//}
//
//- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
//{
//    Photo *photo = self.selectedAlbum.photos[index];
//    activityController = [[UIActivityViewController alloc] initWithActivityItems:@[photo.title, photo.postURL] applicationActivities:nil];
//    NSArray *excludedActivities = @[UIActivityTypePostToWeibo,
//                                    UIActivityTypePrint,
//                                    UIActivityTypeCopyToPasteboard,
//                                    UIActivityTypeAssignToContact,
//                                    UIActivityTypeSaveToCameraRoll,
//                                    UIActivityTypePostToFlickr,
//                                    UIActivityTypePostToVimeo,
//                                    UIActivityTypePostToTencentWeibo];
//    activityController.excludedActivityTypes = excludedActivities;
//    activityController.completionHandler = ^(NSString *activityType, BOOL completed){
//        //[self.popup dismissPopoverAnimated:YES];
//        NSLog(@"ACTIVITY CONTROLLER COMPLETION HANDLER!!!!");
////        [self.browserView hideWithCompletion:^(BOOL finished){
////            NSLog(@"Dismissed!");
////            //[activityController dismissViewControllerAnimated:YES completion:nil];
////            //[activityController removeFromParentViewController];
////        }];
//    };
//
////    [self.view bringSubviewToFront:activityController.view];
//    //[self.view sendSubviewToBack:self.browserView];
//    
//    [self presentViewController:activityController animated:YES completion:nil];
//}

//- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    [controller dismissViewControllerAnimated:YES completion:nil];
//    if (result == MFMailComposeResultCancelled) {
//        
//    }
//}

@end
