//
//  DirectoryDetailsVC.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/12/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "DirectoryDetailsVC.h"
#import "UIImageView+WebCache.h"
#import "MHGallery.h"
#import "PhotoCell.h"
#import "FBShimmeringView.h"
#import "UIImage+ImageEffects.h"

@interface DirectoryDetailsVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *directoryBannerBlurredImageView;
@property (weak, nonatomic) IBOutlet UIImageView *directoryBannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *directoryName;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *photosArray;
@end

@implementation DirectoryDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    MHGalleryItem *landschaft = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail1.jpg"
                                                      galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft1 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail2.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft2 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail3.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft3 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail4.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft4 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail5.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft5 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail6.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft6 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail7.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft7 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail8.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft8 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail9.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft9 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail10.jpg"
                                                       galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft10 = [[MHGalleryItem alloc]initWithURL:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail11.jpg"
                                                        galleryType:MHGalleryTypeImage];
    self.photosArray = @[landschaft, landschaft1, landschaft2, landschaft3, landschaft4, landschaft5, landschaft6, landschaft7, landschaft8, landschaft9, landschaft10];
    [self.collectionView reloadData];
    [self setupDirectoryDetails];
}

- (void) setupDirectoryDetails
{
    self.directoryBannerImageView.layer.masksToBounds = YES;
    self.directoryBannerImageView.layer.cornerRadius = 10;
    
    self.directoryBannerImageView.image = [UIImage imageNamed:@"placeholder"];
    self.directoryBannerBlurredImageView.image = [UIImage imageNamed:@"placeholder"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        UIImage *banner = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/thumbnail2.jpg"]]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            self.directoryBannerImageView.image = banner;
            self.directoryBannerBlurredImageView.image = [banner applyBlurWithRadius:10
                                                                           tintColor:[UIColor colorWithWhite:1.0 alpha:0.3]
                                                               saturationDeltaFactor:1.2
                                                                           maskImage:nil];
        });
    });
    
    self.shimmeringView.shimmering = YES;
    self.shimmeringView.shimmeringBeginFadeDuration = 0.3;
    self.shimmeringView.shimmeringOpacity = 0.4;
    self.shimmeringView.shimmeringPauseDuration = 0.6;
    self.shimmeringView.shimmeringSpeed = 120;
    self.shimmeringView.contentView = self.directoryName;
    self.directoryName.text = @"Test Restaurant";
//    [self.directoryBannerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", StreetMyanmarDirectoryImageURL, self.directory.photoname]]
//                                  placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    UIImage *banner = self.directoryBannerImageView.image;
//    self.directoryBannerBlurredImageView.image = [banner applyLightEffect];
//    self.directoryName.text = self.directory.name;
}

- (IBAction)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Photo Cell" forIndexPath:indexPath];
    [cell setupCell:self.photosArray[indexPath.item]];
    return cell;
}

@end
