//
//  VideoCell.h
//  MODA
//
//  Created by Macbook Pro on 1/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIWebView *utubeView;

@property (strong, nonatomic) IBOutlet UILabel *vTitle;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cellBGviewHeightCostrait;

@property (strong, nonatomic) IBOutlet UIView *cellBGview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vTitleWidthConstrait;

@property (strong, nonatomic) IBOutlet UIButton *btnFBshare;



@property (strong, nonatomic) IBOutlet UIView *cellFirstBGView;

@end
