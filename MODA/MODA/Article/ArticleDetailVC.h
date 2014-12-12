//
//  ArticleDetailVC.h
//  Moda
//
//  Created by Zune Moe on 28/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface ArticleDetailVC : UIViewController
@property (strong, atomic) NSDictionary *article;

@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;


@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;


//- (void)calculateScaleAndContainerFrame;


@end
