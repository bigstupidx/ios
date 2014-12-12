//
//  NewsCell.h
//  AutoMobile
//
//  Created by Zune Moe on 28/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *newsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *newsCategory;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UIView *newsImageViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (weak, nonatomic) IBOutlet UILabel *newsHits;
@property (weak, nonatomic) IBOutlet UILabel *newsDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsImageViewContainerHeightConstraint;

- (void) setupNewsWithImage:(News *)news;

@end
