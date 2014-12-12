//
//  UIView+LayerShot.m
//  MMTicketing
//
//  Created by Macbook Pro on 3/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "UIView+LayerShot.h"

@implementation UIView (LayerShot)

- (UIImage *)imageFromLayer
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
