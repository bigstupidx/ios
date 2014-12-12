//
//  CheckinCountCell.m
//  MMJunction
//
//  Created by Zune Moe on 3/5/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "CheckinCountCell.h"
#import "UIImageView+WebCache.h"

@implementation CheckinCountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(NSDictionary *)count place:(Place *)place
{
    self.checkinTitle.text = place.name;
    if (count[@"count"]) {
        self.checkinCount.text = count[@"count"];
    }
    if (place.promotion_list[@"checkin_count"]) {
        self.checkinMaxCount.text = place.promotion_list[@"checkin_count"];
    }
    if (count[@"count"] && place.promotion_list[@"checkin_count"]) {
        self.checkinProgress.hidden = NO;
        self.checkinProgress.progress = (1.0 / [place.promotion_list[@"checkin_count"] floatValue]) * [count[@"count"] floatValue];
    }
    [self.checkinImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@""]]
                          placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
