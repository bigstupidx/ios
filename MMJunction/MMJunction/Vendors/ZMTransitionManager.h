//
//  ZMTransitionManager.h
//  MMJunction
//
//  Created by Zune Moe on 2/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TransitionStep) {
    INITIAL = 0,
    MODAL
};

@interface ZMTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) TransitionStep transitionTo;
@end
