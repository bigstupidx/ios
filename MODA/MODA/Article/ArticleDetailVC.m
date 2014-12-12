//
//  ArticleDetailVC.m
//  Moda
//
//  Created by Zune Moe on 28/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ArticleDetailVC.h"
#import "Article.h"
#import "ArticleImageVC.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "ArticleDetailHolderVC.h"
#import "KASlideShow.h"

#import "UIImage+ImageScale.h"

#import "UIImageView+WebCache.h"
#import "ZMFMDBSQLiteHelper.h"

@interface ArticleDetailVC () <UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect parentvcFrame;
}

@property (strong, nonatomic) IBOutlet KASlideShow *adsSlideShow;
@property (strong, nonatomic) UIImage* currentImg;

@end

@implementation ArticleDetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAdsSlideshow];
    
    
    UITapGestureRecognizer *gs = [[UITapGestureRecognizer alloc] init];
    gs.numberOfTapsRequired = 2;
    gs.delegate = self;
    [self.view addGestureRecognizer:gs];

    
    //UISCROLLVIEW WITH AUTOLAYOUT
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgScrollView addSubview:self.containerView];
    
    if (self.containerView) {
        UIView* supView = self.bgScrollView.superview;
        [supView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:supView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        
//        [supView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:supView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    }
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString* fontTitleName;
    NSString* fontName;
    
    if ([[self.article objectForKey:@"status"] isEqualToString:@"1"]) {
        fontTitleName = @"BauerBodoni BT";
        fontName = @"Times New Roman";
    }
    else {
        fontTitleName = @"Zawgyi-One";
        fontName = @"Zawgyi-One";
    }
    
    NSString* imgURL = [self.article objectForKey:@"image_url"];
    NSMutableString* htmlStr = [NSMutableString stringWithFormat:@"<html><head><style>img{max-width:100%%;height:auto !important;width:100%25;};</style></head><body style='margin:0;'><h2 style='color:#035367; padding-top: 10px; font-family: %@;' align='center'>%@</h2><img src=%@ align='center' border='0' height='200' width='300'><br/><br/><div style='padding-left: 10px; font-family: %@; font-size: 14;'>%@</div><br/>", fontTitleName, [self.article objectForKey:@"title"],[imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], fontName, [self.article objectForKey:@"description"]]; //auto !important
    
    NSString* videoStr = [self.article objectForKey:@"video"];
    if (videoStr.length > 0) {
        [htmlStr appendFormat:@"<br/><iframe class='youtube-player' type='text/html' width='100%%' height='200' src='http://%@' allowfullscreen frameborder='0'></iframe><br/>",[self.article objectForKey:@"video"]];
    }
    
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSArray* videoArr = [sqlHelper executeQuery:[NSString stringWithFormat:@"select * from video_url where id='%@'",[self.article objectForKey:@"id"]]];
    
    for (NSDictionary* vUrlDict in videoArr) {
        NSString* str = [vUrlDict objectForKey:@"url"];
        if (str.length > 0) {
            NSString* vUrl = [NSString stringWithFormat:@"http://%@",[vUrlDict objectForKey:@"url"]];
            [htmlStr appendFormat:@"<br/><br/><iframe class='youtube-player' type='text/html' width='100%%' height='200' src=%@ allowfullscreen frameborder='0'></iframe>",vUrl];
            
        }
        NSString* strDesc = [vUrlDict objectForKey:@"video_description"];
        if (strDesc.length > 0) {
            [htmlStr appendFormat:@"<br/><br/><div style='padding-left: 10px; font-family: %@; font-size: 14;'>%@</div>",fontName,[vUrlDict objectForKey:@"video_description"]];
        }
    }
    [htmlStr appendString:@"</body></html>"];
    
    [self.myWebView loadHTMLString:htmlStr baseURL:nil];

    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //Touch gestures below top bar should not make the page turn.
    //EDITED Check for only Tap here instead.
    if (touch.tapCount >=2)
    {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            CGPoint touchPoint = [touch locationInView:self.view];
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            bool pageFlag = [userDefaults boolForKey:@"pageDirectionRTLFlag"];
            NSLog(@"pageFlag tapbtnRight %d", pageFlag);
            
//            if(self.interfaceOrientation==UIInterfaceOrientationPortrait||self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
                NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
                NSString *urlToSave = [self.myWebView stringByEvaluatingJavaScriptFromString:imgURL];
                NSLog(@"urlToSave :%@",urlToSave);
                //            NSURL * imageURL = [NSURL URLWithString:urlToSave];
                //            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                //            UIImage * image = [UIImage imageWithData:imageData];
                //            imgView.image = image;
                if (urlToSave.length > 0 && [urlToSave isEqualToString:[self.article objectForKey:@"image_url"]]) {
                    [self imageViewTapped];
                }
//            }
        }
        

    }
    return YES;
}

- (void)imageViewTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewTapped" object:self];
}

- (void)setupAdsSlideshow
{
    _adsSlideShow.backgroundColor = [UIColor blackColor];
    [_adsSlideShow setDelay:3]; // Delay between transitions
    [_adsSlideShow setTransitionDuration:1]; // Transition duration
    [_adsSlideShow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_adsSlideShow setImagesContentMode:UIViewContentModeScaleAspectFit]; // Choose a content mode for images to display  //UIViewContentModeScaleToFill
    
    ZMFMDBSQLiteHelper* sqlHelper = [[ZMFMDBSQLiteHelper alloc] init];
    NSMutableArray* adsArray = [[NSMutableArray alloc] init];
    NSArray *adsArr = [sqlHelper executeQuery:@"select image_url,position from adver_list where position='top_slide'"];
    for(NSDictionary* adsDict in adsArr) {
//        MSAdvers* adsObj = [[MSAdvers alloc] initWithAdsUrl:[adsDict objectForKey:@"image_url"] withPosition:[adsDict objectForKey:@"position"]];
        NSString* imgUrlStr = [adsDict objectForKey:@"image_url"];
        [adsArray addObject:imgUrlStr]; 
    }

    [_adsSlideShow addImagesFromResources:adsArray];
    
    [_adsSlideShow start];
}

@end
