//
//  EventsDetailsVC.h
//  MMJunction
//
//  Created by Zune Moe on 2/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsDetailsVCDelegate
- (void)eventsDetailsVCWasDismissed:(NSArray *)eventsArray offset:(NSInteger)_offset;
@end

@interface EventsDetailsVC : UIViewController
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NSDictionary *eventsColors;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger offset;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (weak, nonatomic) id<EventsDetailsVCDelegate> delegate;
@end
