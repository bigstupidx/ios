//
//  PhotoGalleryVC.m
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

#import "PhotoGalleryVC.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "AGPhotoBrowserView.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

@interface PhotoGalleryVC () <UIScrollViewDelegate, AGPhotoBrowserDelegate, AGPhotoBrowserDataSource>
{
    BOOL isPhotoViewOn;
    int currentPhotoIndex;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong, nonatomic)  AGPhotoBrowserView *photoView;
@property (nonatomic, strong) NSMutableArray *photoHolder;

//@property (strong, nonatomic) IBOutlet AGPhotoBrowserView *photoView;


@end

@implementation PhotoGalleryVC

- (NSMutableArray *) pageImages {
    if(!_pageImages) _pageImages = [NSMutableArray array];
    return _pageImages;
}

- (NSMutableArray *) pageViews {
    if(!_pageViews) _pageViews = [NSMutableArray array];
    return _pageViews;
}

- (NSMutableArray *) photoHolder {
    if (!_photoHolder) _photoHolder = [NSMutableArray array];
    return _photoHolder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    [self.view addSubview:self.photoView];
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.pageImages = self.album.photos.mutableCopy;

    
    for (int i=0; i < self.pageImages.count; i++)
    {
        NSMutableDictionary* mulDict = [[NSMutableDictionary alloc] init];
        Photo *photo = self.pageImages[i];
        NSURL *imgLink = photo.imageURL;
        NSLog(@"URL : %@",imgLink);
        [mulDict setObject:imgLink forKey:@"Image"];
        [mulDict setObject:[NSString stringWithFormat:@"Image %d Title",i+1] forKey:@"Title"];
        [mulDict setObject:[NSString stringWithFormat:@"%d / %d", i+1, self.pageImages.count] forKey:@"Description"];
        
        [self.photoHolder addObject:mulDict];
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Gallery Photo Screen"];
    // Send the screen view.
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    CGSize size = self.view.frame.size;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden =YES;
    currentPhotoIndex = 0;
    [self.browserView showFromIndex:0 withView:self.view];
    isPhotoViewOn = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (isPhotoViewOn) {
        [self.photoView hideWithCompletion:nil];
        _photoView = nil;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
   // CGSize size = _swipeView.frame.size;
    if (isPhotoViewOn) {
//        [self.photoView hideWithCompletion:nil];
//        _photoView = nil;
        [self.browserView showFromIndex:currentPhotoIndex withView:self.view]; // Access Current Photo
    }
    
}

- (AGPhotoBrowserView *)browserView
{
	if (!_photoView) {
		_photoView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.frame];
		_photoView.delegate = self;
		_photoView.dataSource = self;
	}
	
	return _photoView;
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
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
	NSString* strTitle = [[self.photoHolder objectAtIndex:index] objectForKey:@"Title"];
    return strTitle;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
	NSString* strDesc = [[self.photoHolder objectAtIndex:index] objectForKey:@"Description"];
    return strDesc;
}


#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
    [self.navigationController popViewControllerAnimated:YES];
	// -- Dismiss
	NSLog(@"Dismiss the photo browser here");
	[self.photoView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
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




#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
//    if(scrollView == self.scrollView) [self loadVisiblePages];
}

@end
