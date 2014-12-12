//
//  NewsWithoutImageCell.m
//  AutoMobile
//
//  Created by Zune Moe on 29/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NewsWithoutImageCell.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"

@implementation NewsWithoutImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setupNewsWithoutImage:(News *)news
{
    self.newsNoImageCategory.text = news.catename;
    self.newsNoImageTitle.text = news.title;
    self.newsNoImageDescription.text = [news.introtext stringByConvertingHTMLToPlainText];
    self.newsNoImageHits.text = [NSString stringWithFormat:@"Hits: %d", news.hits];
    self.newsNoImageDate.text = news.created;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
