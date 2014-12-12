//
//  InfoCell.m
//  MMJunction
//
//  Created by Zune Moe on 3/7/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(NSDictionary *)dictionary
{
    self.vendorName.text = dictionary[@"name"];
    self.vendorURL.text = dictionary[@"url"];
    self.vendorLicense.text = dictionary[@"license"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
