//
//  ArticleListVC.h
//  Moda
//
//  Created by Zune Moe on 28/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *articleArray;

@property (nonatomic, strong) NSString* strTabbarTitle;


@end
