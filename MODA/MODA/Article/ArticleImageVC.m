//
//  ArticleImageVC.m
//  Moda
//
//  Created by Zune Moe on 3/12/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "ArticleImageVC.h"

@interface ArticleImageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ArticleImageVC
-(BOOL) prefersStatusBarHidden { return YES; }
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    else
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.imageView.image = self.image;
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
