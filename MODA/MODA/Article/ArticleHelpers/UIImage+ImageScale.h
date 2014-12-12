//
//  UIImage+ImageScale.h
//  MODA
//
//  Created by Macbook Pro on 1/7/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageScale)

- (UIImage *) scaleToSize: (CGSize)size;
- (UIImage *) scaleProportionalToSize: (CGSize)size;

@end
