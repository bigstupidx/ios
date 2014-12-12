//
//  BookListCell.h
//  HotelBooking
//
//  Created by Macbook Pro on 9/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellname;
@property (weak, nonatomic) IBOutlet UILabel *cellnrc;
@property (weak, nonatomic) IBOutlet UILabel *cellbookdate;
@property (weak, nonatomic) IBOutlet UILabel *cellroomno;
@property (weak, nonatomic) IBOutlet UILabel *cellroomtype;
@property (weak, nonatomic) IBOutlet UIView *viewDays;
@property (weak, nonatomic) IBOutlet UILabel *cellamt;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;


@end
