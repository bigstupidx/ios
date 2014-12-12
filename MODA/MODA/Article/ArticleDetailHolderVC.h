//
//  ArticleDetailHolderVC.h
//  Moda
//
//  Created by Macbook Pro on 12/17/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@class Article;

@interface ArticleDetailHolderVC : UIViewController //<UIPageViewControllerDataSource>

@property (strong, nonatomic) Article *article;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (strong, nonatomic) NSArray *articleArr;
@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, strong) Article* currentArticle;
@property (strong, nonatomic) NSMutableArray* onlyArticleArr;

@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) IBOutlet SwipeView *swipeView;


@end
