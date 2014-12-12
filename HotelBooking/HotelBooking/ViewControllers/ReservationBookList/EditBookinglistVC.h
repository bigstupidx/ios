//
//  EditBookinglistVC.h
//  HotelBooking
//
//  Created by Macbook Pro on 9/11/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBookinglistVC : UIViewController

@property (strong, nonatomic) NSArray* tableFiller;
@property (assign, nonatomic) int roomid;
@property (assign, nonatomic) int roomdetailid;
@property (strong, nonatomic) NSString* paidStatus;
@property (assign, nonatomic) int bookid;

@end
