//
//  AdCell.m
//  MMJunction
//
//  Created by Zune Moe on 3/6/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AdCell.h"
#import "UIImageView+WebCache.h"

@implementation AdCell
{
    Ad *_ad;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(Ad *)ad
{
    _ad = ad;
    [self.adImageView setImageWithURL:[NSURL URLWithString:ad.url]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (IBAction)adViewTapped:(id)sender {
    // show webView
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
