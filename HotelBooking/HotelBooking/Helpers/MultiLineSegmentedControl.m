//
//  MultiLineSegmentedControl.m
//  MMTicketing
//
//  Created by Macbook Pro on 3/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "MultiLineSegmentedControl.h"
#import "UIView+LayerShot.h"

@interface MultiLineSegmentedControl()
@property (nonatomic, retain) UILabel *theLabel;
@end

@implementation MultiLineSegmentedControl
@synthesize theLabel;

//- (void)dealloc
//{
//    self.theLabel = nil;
//    [super dealloc];
//}


- (UILabel *)theLabel
{
    if (!self->theLabel) {
        
        self->theLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self->theLabel.textColor = [UIColor whiteColor];
        self->theLabel.backgroundColor = [UIColor clearColor];
        self->theLabel.font = [UIFont boldSystemFontOfSize:13];
        self->theLabel.textAlignment = NSTextAlignmentCenter;
        self->theLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        self->theLabel.shadowColor = [UIColor darkGrayColor];
        self->theLabel.numberOfLines = 0;
    }
    
    return self->theLabel;
}


- (void)setMultilineTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    self.theLabel.text = title;
    [self.theLabel sizeToFit];
    
    [self setImage:self.theLabel.imageFromLayer forSegmentAtIndex:segment];
}

@end