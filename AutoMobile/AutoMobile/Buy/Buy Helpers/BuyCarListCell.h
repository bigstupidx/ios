//
//  BuyCarListCell.h
//  AutoMobile
//
//  Created by Zune Moe on 24/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCar.h"

@interface BuyCarListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIImageView *carSpecialImageView;
@property (weak, nonatomic) IBOutlet UILabel *carTitle;
@property (weak, nonatomic) IBOutlet UILabel *carYear;
@property (weak, nonatomic) IBOutlet UILabel *carPrice;

- (void) setupCell:(MyCar *)car;
@end
