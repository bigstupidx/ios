//
//  EventDetailsView.m
//  MMJunction
//
//  Created by Zune Moe on 2/21/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "EventDetailsView.h"
#import "UIFont+ZawgyiOne.h"
#import "UIImageView+WebCache.h"

@interface EventDetailsView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventCategory;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventVenue;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UIView *eventInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *eventInfoDecorator;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@end

@implementation EventDetailsView

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.event) {
//        self.scrollView.delegate = self;
        
        [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self.contextMenu action:@selector(longPressDetected:)]];
        
        self.eventTitle.font = [UIFont zawgyiOneFontWithSize:16];
        self.eventDescription.font = [UIFont zawgyiOneFontWithSize:15];
        self.eventVenue.font = [UIFont zawgyiOneFontWithSize:14];
        
        self.eventDescription.textColor = [UIColor darkGrayColor];
        self.eventVenue.textColor = [UIColor darkGrayColor];
        
        self.eventInfoContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_lines"]];
        self.eventInfoDecorator.backgroundColor = self.eventColor;
        
        self.eventCategory.textColor = self.eventColor;
        self.eventCategory.text = self.event.tags;
        self.eventTitle.text = self.event.name;
        self.eventDescription.text = self.event.event_description;
        self.eventDate.text = [NSString stringWithFormat:@"%@ to %@", self.event.startdate, self.event.enddate];
        self.eventTime.text = [NSString stringWithFormat:@"%@ to %@", self.event.starttime, self.event.endtime];
        self.eventVenue.text = self.event.l_name;
        
        [self.bannerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MMJunctionImageURL, self.event.banner]]
                             placeholderImage:[UIImage imageNamed:@"Stars"]];
    }
    
    if (self.ad) {
        self.adImageView.hidden = NO;
        [self.adImageView setImageWithURL:[NSURL URLWithString:self.ad.url]
                         placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Event Details Swipe View"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat scrollOffset = scrollView.contentOffset.y;
//    CGRect imageFrame = self.bannerImageView.frame;
//    CGFloat scale = 1.0;
//    if (scrollOffset < 0) {
//        // Adjust image proportionally
//        scale = 1.0;
//        imageFrame.origin.y = floorf(scrollOffset * -0.8);
//        scale += (scrollOffset * -0.005);
//    } else {
//        // We're scrolling up, return to normal behavior
//        imageFrame.origin.y = floorf(scrollOffset * -0.6);
//    }
//    self.bannerImageView.frame = imageFrame;
//    self.bannerImageView.transform = CGAffineTransformMakeScale(scale, scale);
//}

@end
