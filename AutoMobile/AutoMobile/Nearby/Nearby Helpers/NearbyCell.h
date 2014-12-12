//
//  NearbyCell.h
//  AutoMobile
//
//  Created by Zune Moe on 31/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyPlace.h"

@interface NearbyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeTitle;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeph;

- (void)setupCell:(NearbyPlace *)place;
@end
