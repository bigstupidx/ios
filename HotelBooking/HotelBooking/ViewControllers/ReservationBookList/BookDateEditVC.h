//
//  BookDateEditVC.h
//  HotelBooking
//
//  Created by Macbook Pro on 9/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDateEditVC : UIViewController

@property (strong, nonatomic) NSMutableArray* bookdates;
@property (assign, nonatomic) int roomid;
@property (assign, nonatomic) int roomdetailid;
@property (strong, nonatomic) NSString* paidStatus;
@property (assign, nonatomic) int bookid;

@end
