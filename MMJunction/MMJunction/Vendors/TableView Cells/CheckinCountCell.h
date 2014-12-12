//
//  CheckinCountCell.h
//  MMJunction
//
//  Created by Zune Moe on 3/5/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface CheckinCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *checkinImageView;
@property (weak, nonatomic) IBOutlet UILabel *checkinTitle;
@property (weak, nonatomic) IBOutlet UILabel *checkinCount;
@property (weak, nonatomic) IBOutlet UILabel *checkinMaxCount;
@property (weak, nonatomic) IBOutlet UIProgressView *checkinProgress;

- (void)setupCell:(NSDictionary *)count place:(Place *)place;
@end
