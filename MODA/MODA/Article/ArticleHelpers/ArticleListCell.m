//
//  ArticleListCell.m
//  Moda
//
//  Created by Zune Moe on 28/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "ArticleListCell.h"

@implementation ArticleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:16];
        self.authorLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14];
        self.detailLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14];
//        self.cellImageView.frame = CGRectMake(self.cellImageView.frame.origin.x, self.cellImageView.frame.origin.y, self.cellImageView.frame.size.width, self.cellImageView.frame.size.height);
//        self.cellImageView.contentMode = UIViewContentModeScaleToFill;
//        self.cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        self.cellImageView.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
