//
//  NewsCell.m
//  AutoMobile
//
//  Created by Zune Moe on 28/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"

@implementation NewsCell

//static NSString *imageBaseURL = @"http://192.168.1.123/";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setupNewsWithImage:(News *)news
{
    self.newsCategory.font = [UIFont zawgyiOneFontWithSize:17];
    self.newsTitle.font = [UIFont zawgyiOneFontWithSize:16];
    self.newsDescription.font = [UIFont zawgyiOneFontWithSize:14];
    
    self.newsCategory.text = news.catename;
    self.newsTitle.text = news.title;
    [self.newsImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", newsImageBaseURL, news.image]]
                           placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.newsDescription.text = news.introtext;
//    self.newsHits.text = [NSString stringWithFormat:@"Hits: %d", news.hits];
    self.newsDate.text = news.created;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
