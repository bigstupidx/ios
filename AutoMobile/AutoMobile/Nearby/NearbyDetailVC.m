//
//  NearbyDetailVC.m
//  AutoMobile
//
//  Created by Zune Moe on 31/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "NearbyDetailVC.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"

@interface NearbyDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *openinghr;
@property (weak, nonatomic) IBOutlet UILabel *closingDate;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *website;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation NearbyDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Directory Detail";
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://streetmyanmar.com/img/%@",self.selectedPlace.photoname]]
                   placeholderImage:[UIImage imageNamed:@"placeholderNearby.png"]];
    self.openinghr.text = [NSString stringWithFormat:@"%@ - %@", self.selectedPlace.openinghr, self.selectedPlace.closinghr];
    self.closingDate.text = self.selectedPlace.closingdate;
    [self.phone setTitle:self.selectedPlace.phone forState:UIControlStateNormal];
    [self.website setTitle:self.selectedPlace.website forState:UIControlStateNormal];
    [self.email setTitle:self.selectedPlace.email forState:UIControlStateNormal];
    NSString* address = [NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@ %@", self.selectedPlace.buildingno, self.selectedPlace.street, self.selectedPlace.roomno, self.selectedPlace.buildingname, self.selectedPlace.township, self.selectedPlace.city, self.selectedPlace.zipcode];
    
    NSString *imageFileName = @"phone_1_icon";
    NSString *imageFileExtension = @"png";
    
    // load the path of the image in the main bundle (this gets the full local path to the image you need, including if it is localized and if you have a @2x version)
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageFileName ofType:imageFileExtension];
    
    // generate the html tag for the image (don't forget to use file:// for local paths)
    NSString *imgHTMLTag = [NSString stringWithFormat:@"<img src=\"file://%@\" width='22' height='22' />", imagePath];
    
    NSMutableString* htmlStr = [NSMutableString stringWithFormat:@"<html><head></head><body style='margin:0;'><div><font size='3' face='Zawgyi-One'>%@</font><hr>%@<font size='2' face='Zawgyi-One'>%@</font><hr></div></body></html>",address,imgHTMLTag,self.selectedPlace.phone];
    
    [_webview loadHTMLString:htmlStr baseURL:nil];
    
    _lblTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:19.0f];
    _lblTitle.text = self.selectedPlace.name;
    
    [self setBackBtn];
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


@end
