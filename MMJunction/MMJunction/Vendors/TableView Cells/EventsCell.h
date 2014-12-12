//
//  EventsCell.h
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventCategory;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventNumber;
@property (weak, nonatomic) IBOutlet UIView *eventStatus;

- (void)setupCell:(Event *)event indexPath:(NSIndexPath *)indexPath;

@end
