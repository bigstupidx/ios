//
//  VideoCell.m
//  MODA
//
//  Created by Macbook Pro on 1/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)updateConstraints
//{
//    [super updateConstraints];
//    self.vTitleWidthConstrait.constant = 298;
//}


@end
