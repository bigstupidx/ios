//
//  PhotoGalleryDetailVC.m
//  Moda
//
//  Created by Zune Moe on 22/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "PhotoGalleryDetailVC.h"

@interface PhotoGalleryDetailVC ()
{
    BOOL closeShowing;
}
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation PhotoGalleryDetailVC
-(BOOL) prefersStatusBarHidden { return YES; }
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    else
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:imageTap];
    self.imageView.image = self.image;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.btnClose.alpha = 0.0;
        self.toolBar.alpha = 0.0;
    } completion:NULL];
}

- (void) tapOnImageView
{
    [UIView animateWithDuration:0.4 animations:^{
        if(closeShowing) {
            self.btnClose.alpha = 0.0;
            self.toolBar.alpha = 0.0;
        } else {
            self.btnClose.alpha = 1.0;
            self.toolBar.alpha = 1.0;
        }
        closeShowing = !closeShowing;
    }];
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

@end
