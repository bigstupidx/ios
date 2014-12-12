//
//  PlacesCell.h
//  MMJunction
//
//  Created by Zune Moe on 2/24/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PlacesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;

- (void)setupCell:(Place *)place distance:(NSString *)distance;

@end
