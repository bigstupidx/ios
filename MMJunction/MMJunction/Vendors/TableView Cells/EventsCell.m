//
//  EventsCell.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "EventsCell.h"
#import "UIFont+ZawgyiOne.h"
#import "Colours.h"
#import "UIImageView+WebCache.h"

@implementation EventsCell
{
    NSDictionary *colors;
    NSDictionary *selectedColors;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    colors = @{@"Art": [UIColor infoBlueColor],
               @"Business": [UIColor successColor],
               @"Community": [UIColor warningColor],
               @"Dhama": [UIColor tealColor],
               @"Education": [UIColor denimColor],
               @"Entertainment": [UIColor violetColor],
               @"Film": [UIColor watermelonColor],
               @"IT": [UIColor periwinkleColor],
               @"Literature": [UIColor carrotColor],
               @"Promotion": [UIColor skyBlueColor],
               @"Sports": [UIColor emeraldColor],
               @"Volunteering": [UIColor oliveColor]
               };
    selectedColors = @{@"Art": [UIColor indigoColor],
                       @"Business": [UIColor chartreuseColor],
                       @"Community": [UIColor goldColor],
                       @"Dhama": [UIColor denimColor],
                       @"Education": [UIColor indigoColor],
                       @"Entertainment": [UIColor coolPurpleColor],
                       @"Film": [UIColor strawberryColor],
                       @"IT": [UIColor blueberryColor],
                       @"Literature": [UIColor burntOrangeColor],
                       @"Promotion": [UIColor indigoColor],
                       @"Sports": [UIColor chartreuseColor],
                       @"Volunteering": [UIColor hollyGreenColor]
                       };
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCell:(Event *)event indexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [NSDate dateWithTimeInterval:23400 sinceDate:[formatter dateFromString:event.startdate]];
    NSDate *endDate = [NSDate dateWithTimeInterval:23400 sinceDate:[formatter dateFromString:event.enddate]];
    NSDate *now = [NSDate dateWithTimeInterval:23400 sinceDate:[NSDate date]];
    
    if (([now compare:startDate] == NSOrderedSame || [now compare:startDate] == NSOrderedDescending) && [now compare:endDate] == NSOrderedAscending) {
        // ongoing event
        self.eventStatus.backgroundColor = [UIColor greenColor];
    } else if ([now compare:startDate] == NSOrderedAscending) {
        // future event
        self.eventStatus.backgroundColor = [UIColor mustardColor];
    }
    
    self.eventStatus.layer.cornerRadius = 6;    
    self.eventCategory.textColor = colors[event.tags];
    self.eventTitle.font = [UIFont zawgyiOneFontWithSize:16];
    
    self.eventCategory.text = event.tags;
    self.eventTitle.text = event.name;
    self.eventTime.text = [NSString stringWithFormat:@"%@ to %@", event.starttime, event.endtime];
    self.eventImageView.image = [UIImage imageNamed:event.tags];
    [self.eventImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MMJunctionImageURL, event.banner]]
                        placeholderImage:[UIImage imageNamed:event.tags]];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = selectedColors[event.tags];
    [self setSelectedBackgroundView:bgColorView];
}

//- (NSComparisonResult) compareDate:(NSDate *)date
//{
//    // convert UTC time to local time by adding 23400 seconds (+6:30GMT)
//    //NSDate *now = [NSDate dateWithTimeInterval:23400 sinceDate:[NSDate date]];
//    NSDate *now = [NSDate date];
//    return [now compare:date];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
