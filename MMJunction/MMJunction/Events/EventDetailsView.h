//
//  EventDetailsView.h
//  MMJunction
//
//  Created by Zune Moe on 2/21/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Ad.h"
#import "GHContextMenuView.h"

@interface EventDetailsView : UIViewController
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Ad *ad;
@property (strong, nonatomic) UIColor *eventColor;
@property (strong, nonatomic) GHContextMenuView *contextMenu;
@end
