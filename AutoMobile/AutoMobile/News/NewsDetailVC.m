//
//  NewsDetailVC.m
//  AutoMobile
//
//  Created by Zune Moe on 31/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NewsDetailVC.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"

@interface NewsDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (weak, nonatomic) IBOutlet UILabel *newsHits;
@property (weak, nonatomic) IBOutlet UILabel *newsDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblNewCat;

@end

@implementation NewsDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"News Detail";
    
    [self setBackBtn];
    
    self.lblNewCat.font = [UIFont zawgyiOneFontWithSize:16];
    self.lblNewCat.text = self.selectedNews.catename;
    
    self.newsTitle.font = [UIFont zawgyiOneFontWithSize:17];
    self.newsDescription.font = [UIFont zawgyiOneFontWithSize:15];
    
    self.newsTitle.text = self.selectedNews.title;
    self.newsDescription.text = [self.selectedNews.fulltext stringByConvertingHTMLToPlainText];;
//    self.newsHits.text = [NSString stringWithFormat:@"Hits: %d", self.selectedNews.hits];
    self.newsDate.text = self.selectedNews.created;
//    NSString *imageURL = [self scanImageURLFromHTMLString:self.selectedNews.fulltext];
    if (self.selectedNews.image) {
        [self.newsImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", newsImageBaseURL, self.selectedNews.image]]
                           placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    } else {
        self.newsImageViewHeightConstraint.constant = 0;
    }
    
}

- (void)setBackBtn
{
    self.navigationItem.backBarButtonItem = nil;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back_unselected.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateSelected];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)dismissThisView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)scanImageURLFromHTMLString:(NSString *)string
{
    NSString *url = nil;
    NSString *htmlString = string;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
    }
    return url;
}

@end
