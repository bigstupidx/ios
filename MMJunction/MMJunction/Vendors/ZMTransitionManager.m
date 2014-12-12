//
//  ZMTransitionManager.m
//  MMJunction
//
//  Created by Zune Moe on 2/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ZMTransitionManager.h"

@implementation ZMTransitionManager

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //STEP 1
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* inView = [transitionContext containerView];

    if (self.transitionTo == MODAL) {
        CGRect offScreenFrame = inView.frame;
        offScreenFrame.origin.y = inView.frame.size.height;
        toVC.view.frame = offScreenFrame;
        
        [inView insertSubview:toVC.view aboveSubview:fromVC.view];
        
        CFTimeInterval duration = 0.5;
        CFTimeInterval halfDuration = duration/2;
        
        CATransform3D t1 = [self firstTransform];
        CATransform3D t2 = [self secondTransformWithView:fromVC.view];
        
        
        [UIView animateKeyframesWithDuration:halfDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
                fromVC.view.layer.transform = t1;
                fromVC.view.alpha = 0.6;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
                
                fromVC.view.layer.transform = t2;
            }];
            
        } completion:^(BOOL finished) {
        }];
        
        
        [UIView animateWithDuration:duration delay:(halfDuration - (0.3*halfDuration)) usingSpringWithDamping:0.7f initialSpringVelocity:6.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            toVC.view.frame = inView.frame;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        toVC.view.frame = inView.frame;
        CATransform3D scale = CATransform3DIdentity;
        toVC.view.layer.transform = CATransform3DScale(scale, 0.6, 0.6, 1);
        toVC.view.alpha = 0.6;
        
        [inView insertSubview:toVC.view belowSubview:fromVC.view];
        
        CGRect frameOffScreen = inView.frame;
        frameOffScreen.origin.y = inView.frame.size.height;
        
        NSTimeInterval duration = 0.5;
        NSTimeInterval halfDuration = duration/2;
        
        CATransform3D t1 = [self firstTransform];
        
        [UIView animateKeyframesWithDuration:halfDuration delay:halfDuration - (0.3*halfDuration) options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
                toVC.view.layer.transform = t1;
                toVC.view.alpha = 1.0;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
                
                toVC.view.layer.transform = CATransform3DIdentity;
            }];
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
        
        [UIView animateWithDuration:halfDuration animations:^{
            fromVC.view.frame = frameOffScreen;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    return t1;
    
}

-(CATransform3D)secondTransformWithView:(UIView*)view{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    return t2;
}

@end
