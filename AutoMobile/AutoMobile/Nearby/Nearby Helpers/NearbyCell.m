//
//  NearbyCell.m
//  AutoMobile
//
//  Created by Zune Moe on 31/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NearbyCell.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"

@implementation NearbyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(NearbyPlace *)place
{
    self.placeTitle.font = [UIFont zawgyiOneFontWithSize:16];
    self.placeAddress.font = [UIFont zawgyiOneFontWithSize:14];
    self.placeph.font = [UIFont zawgyiOneFontWithSize:14];
    
    self.placeTitle.text = place.name;
    self.placeAddress.text = [NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@ %@", place.buildingno, place.street, place.roomno, place.buildingname, place.township, place.city, place.zipcode];
    if (place.phone.length > 0) self.placeph.text = place.phone;
    else self.placeph.text = @"-";
    
    [self.placeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://streetmyanmar.com/img/%@",place.photoname]]
                        placeholderImage:[UIImage imageNamed:@"placeholderNearby.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
