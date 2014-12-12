//
//  MultiLineSegmentedControl.h
//  MMTicketing
//
//  Created by Macbook Pro on 3/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiLineSegmentedControl : UISegmentedControl
- (void)setMultilineTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
@end
