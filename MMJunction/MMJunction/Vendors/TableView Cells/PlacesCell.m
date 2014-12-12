//
//  PlacesCell.m
//  MMJunction
//
//  Created by Zune Moe on 2/24/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "PlacesCell.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"

@implementation PlacesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(Place *)place distance:(NSString *)distance
{
    self.placeName.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.placeAddress.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
    self.placeName.text = place.name;
//    NSMutableString *address = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@ m ∙", distance]];
//    if (place.roomno) {
//        [address appendFormat:@" %@ ∙", place.roomno];
//    }
//    [address appendFormat:@" %@", place.street];
    if (place.promotion_list) {
        self.placeAddress.text = [NSString stringWithFormat:@"%@ checkins to get %@", place.promotion_list[@"checkin_count"], place.promotion_list[@"description"]];
    } else {
        self.placeAddress.text = @"No promotion";
    }
    //self.placeAddress.text = address;
    
    [self.placeImageView setImageWithURL:[NSURL URLWithString:@""]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)setupEvent:(Event *)event
{
    self.placeName.font = [UIFont zawgyiOneFontWithSize:15];
    self.placeAddress.font = [UIFont zawgyiOneFontWithSize:13];
    self.placeName.text = event.name;
    self.placeAddress.text = event.l_name;
    [self.placeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MMJunctionImageURL, event.banner]]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
