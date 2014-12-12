//
//  AGPhotoBrowserView.h
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGPhotoBrowserOverlayView.h"
#import "AGPhotoBrowserZoomableView.h"

#import "AGPhotoBrowserDelegate.h"
#import "AGPhotoBrowserDataSource.h"

@interface AGPhotoBrowserView : UIView

@property (nonatomic, weak) id<AGPhotoBrowserDelegate> delegate;
@property (nonatomic, weak) id<AGPhotoBrowserDataSource> dataSource;

@property (nonatomic, strong, readonly) UIButton *doneButton;
@property (nonatomic, strong) AGPhotoBrowserOverlayView *overlayView;

@property (nonatomic, strong) AGPhotoBrowserZoomableView *imageView;

- (void)show:(UIView*)view;
- (void)showFromIndex:(NSInteger)initialIndex withView:(UIView*)view;
- (void)hideWithCompletion:( void (^) (BOOL finished) )completionBlock;

@end
