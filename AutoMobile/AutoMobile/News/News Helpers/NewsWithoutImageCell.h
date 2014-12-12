//
//  NewsWithoutImageCell.h
//  AutoMobile
//
//  Created by Zune Moe on 29/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsWithoutImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *newsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *newsNoImageCategory;
@property (weak, nonatomic) IBOutlet UILabel *newsNoImageTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsNoImageDescription;
@property (weak, nonatomic) IBOutlet UILabel *newsNoImageHits;
@property (weak, nonatomic) IBOutlet UILabel *newsNoImageDate;

- (void) setupNewsWithoutImage:(News *)news;
@end
