//
//  SaleReportDetailVC.h
//  HotelBooking
//
//  Created by Macbook Pro on 9/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleReportDetailVC : UIViewController

@property (strong, nonatomic) NSArray* tablefiller;
@property (assign, nonatomic) int totalamt;
@property (strong, nonatomic) NSArray* resultArr;
@property (strong, nonatomic) NSString* chkindate;

@end
