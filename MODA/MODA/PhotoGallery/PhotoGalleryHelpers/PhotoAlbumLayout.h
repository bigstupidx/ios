//
//  PhotoAlbumLayout.h
//  Moda
//
//  Created by Zune Moe on 2/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString * const BHPhotoAlbumLayoutAlbumTitleKind;
@interface PhotoAlbumLayout : UICollectionViewLayout
@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat titleHeight;
@end
