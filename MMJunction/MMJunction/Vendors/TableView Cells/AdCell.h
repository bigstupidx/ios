//
//  AdCell.h
//  MMJunction
//
//  Created by Zune Moe on 3/6/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ad.h"

@interface AdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

- (void)setupCell:(Ad *)ad;
@end
