//
//  RoomInfoVC.h
//  HotelBooking
//
//  Created by Macbook Pro on 9/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomInfoVC : UIViewController

@property (strong, nonatomic) NSDictionary* roomInfoDict;
@property (strong, nonatomic) NSString* strRoomno;
@property (strong, nonatomic) NSString* strRoomFacility;
@property (strong, nonatomic) NSArray* occupydateWithStatus;

@property (assign, nonatomic) BOOL isRoomAdding;
@property (assign, nonatomic) int bookingid;
@property (assign, nonatomic) int room_plan_id;

@end
