//
//  ModaAdsCell.h
//  MODA
//
//  Created by Macbook Pro on 12/26/13.
//  Copyright (c) 2013 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModaAdsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellbgView;

@property (strong, nonatomic) IBOutlet UIImageView *cellAdsImg;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btmSpaceImgViewConstrait;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnSpaceContentViewConstrait;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstrait;

@end
