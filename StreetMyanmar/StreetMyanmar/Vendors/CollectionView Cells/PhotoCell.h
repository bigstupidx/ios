//
//  PhotoCell.h
//  StreetMyanmar
//
//  Created by Zune Moe on 3/14/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHGallery.h"
@interface PhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (void)setupCell:(MHGalleryItem *)photo;
@end
