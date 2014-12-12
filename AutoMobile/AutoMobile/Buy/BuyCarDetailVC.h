//
//  BuyCarDetailVC.h
//  AutoMobile
//
//  Created by Zune Moe on 27/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@protocol BuyCarDetailVCDelegate
- (void)buyCarDetailVCWasPopped:(NSArray *)carList offset:(NSInteger)_offset;
@end

@interface BuyCarDetailVC : UIViewController
@property (strong, nonatomic) NSMutableArray *carArray;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger offset;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (weak, nonatomic) id<BuyCarDetailVCDelegate> delegate;
@end
