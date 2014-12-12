//
//  ShowCarDetailVC.m
//  AutoMobile
//
//  Created by Macbook Pro on 8/21/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "ShowCarDetailVC.h"
#import "KASlideShow.h"
#import "NEUPagingSegmentedControl.h"
#import "NEUBorderedView.h"
#import "User.h"
#import "UIFont+ZawgyiOne.h"
#import <MessageUI/MessageUI.h>
#import "JDStatusBarNotification.h"
#import "UIPhotoGalleryView.h"
#import "SellFormVC.h"

@interface ShowCarDetailVC () <NEUPagingSegmentedControlDelegate, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, UIPhotoGalleryDataSource, UIPhotoGalleryDelegate>
@property (nonatomic, strong) NEUPagingSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) NSInteger curindex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) UITextField* txt1;
@property (nonatomic, strong) UITextField* txt2;
@property (nonatomic, strong) UITextView* txt3;
@property (nonatomic, strong) NSMutableArray* imgArr;
@property (weak, nonatomic) IBOutlet KASlideShow *slideshow;

@property (weak, nonatomic) IBOutlet UILabel *lblCarTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIPhotoGalleryView *photoview;
@property (weak, nonatomic) IBOutlet UILabel *imgIndicator;
- (IBAction)playSlideShow:(id)sender;


@property (assign,nonatomic) BOOL isPlaying;


@end

@implementation ShowCarDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackBtn];
    
    self.title = @"Car Detail";
    
    _imgArr = [NSMutableArray new];
    if (_carinfo.image.length > 0) {
        [_imgArr addObject:[NSString stringWithFormat:@"http://www.automobile.com.mm/%@",_carinfo.image]];
    }
    for (NSString* strImg in _carinfo.image_list) {
        [_imgArr addObject:[NSString stringWithFormat:@"http://www.automobile.com.mm/%@",strImg]];
    }
    if (_imgArr.count > 0) {
        _imgIndicator.text = [NSString stringWithFormat:@"1 of %d",_imgArr.count];
    
    }
    
    _curindex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAgain:) name:@"playAgain" object:nil];
    _isPlaying = NO;
    
    _photoview.initialIndex = 4;
    _photoview.showsScrollIndicator = YES;
    _photoview.galleryMode = UIPhotoGalleryModeImageRemote;
    
    _photoview.subviewGap = 30;
    _photoview.verticalGallery = _photoview.peakSubView = NO;

    
    CGRect slice, remainder;
    CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMinYEdge);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:remainder];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    self.segments = @[@"CAR INFO", @"EQUIPMENT", @"SELLER INFO", @"CONTACT"];
    
    self.segmentedControl = [[NEUPagingSegmentedControl alloc] initWithFrame:slice];
    self.segmentedControl.segmentTitles = self.segments;
    self.segmentedControl.scrollView = self.scrollView;
    self.segmentedControl.delegate = self;
    
    [self.viewContent addSubview:self.scrollView];
    [self.viewContent addSubview:self.segmentedControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userinfo:) name:@"userinfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userinfo:) name:@"finishDownloaduserinfo" object:nil];
    
    [_btnPlay setImage:[UIImage imageNamed:@"playcircle.png"] forState:UIControlStateNormal];
    _btnPlay.tintColor = [UIColor blackColor];
    
    _lblCarTitle.text = [NSString stringWithFormat:@"%@ %@",_carinfo.make, _carinfo.model];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutScrollViewPages];
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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(gotoEditDetailView)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)dismissThisView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoEditDetailView
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Sell" bundle:nil];
    SellFormVC* vc = (SellFormVC*)[sb instantiateViewControllerWithIdentifier:@"SellFormVC"];
    vc.selectedCategory = @{@"id": _carinfo.catid, @"name": _carinfo.category};
    vc.mycarinfo = _carinfo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userinfo:(NSNotification*)noti
{
    User* user = (User*)noti.object;
    _userinfo = user;
    [self createScrollViewPagesWithSegments:self.segments];
    [self viewDidLayoutSubviews];
}

- (void)createScrollViewPagesWithSegments:(NSArray *)segments
{
    
    for (NSInteger i = 0, count = [segments count]; i < count; i++) {
        NEUBorderedView *view = [[NEUBorderedView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIWebView* mywebview = [[UIWebView alloc] initWithFrame:view.bounds];
        if (i == 0) {
            NSString* htmlStr = [NSString stringWithFormat:@"<html><head></head><body style='margin:0; font-family:Zawgyi-One; font-size: 11;'><div style='padding-left: 10px; padding-top: 10px; line-height:30px;'> ကားထုုတ္လုုပ္သည့္ႏွစ္ : %@</br> ေလာင္စာအမိ်ဴးအစား: %@ </br> အေရာင္: %@ </br> ကားေဘာ္ဒီအမ်ိဴးအစား: %@ </br> ဂီယာအမ်ိဴးအစား: %@ </br> အင္ဂ်င္ပါ၀ါ: %@ </br> လုုိင္စင္အမ်ိဴးအစား: %@ </br> ကားနံပါတ္: %@ </br> ေမာင္းႏွင္ျပီးကီလုုိ: %@ </br> Owner Book: %@ </br> ကားအေျခအေန: %@ </br> Vehical Location </br> Country: %@</div></body></html>",self.carinfo.year,self.carinfo.fuel,self.carinfo.color,self.carinfo.bodytype,self.carinfo.transmission,self.carinfo.enginepower,self.carinfo.licenseno,self.carinfo.carno,self.carinfo.mileage,self.carinfo.ownerbook,self.carinfo.condition,self.carinfo.country];
            [mywebview loadHTMLString:htmlStr baseURL:nil];
        } else if (i == 1) {
            NSMutableString* htmlStr = [NSMutableString stringWithString:@"<html><head></head><body style='margin:0; font-family:Zawgyi-One; font-size: 11;'><div style='padding-left: 10px; padding-top: 10px; line-height:20px;'><b>ပါ၀င္ပစၥည္းမ်ား</b></br>"];
            for (NSDictionary* dict in _carinfo.equipments) {
                [htmlStr appendFormat:@"- %@ </br>",dict[@"name"]];
            }
            [htmlStr appendString:@"</div></body></html>"];
            [mywebview loadHTMLString:htmlStr baseURL:nil];
            
        } else if (i == 2) {
            NSLog(@"user %@",_userinfo);
            NSString* username = _userinfo.name;
            NSString* htmlStr = [NSString stringWithFormat:@"<html><head></head><body style='margin:0; font-family:Zawgyi-One; font-size: 11;'><div style='padding-left: 10px; padding-top: 10px; line-height:30px;'> <b>ေရာင္းသူ၏ အခ်က္အလက္မ်ား</b></br>Name: %@</br> Company Name: %@ </br> Website: %@ </br> Phone: %@ </br> Email: %@ </br> Country: %@</div></body></html>",username, _userinfo.company, _userinfo.website, _userinfo.phone, _userinfo.email, _userinfo.country];
            [mywebview loadHTMLString:htmlStr baseURL:nil];
        } else if (i == 3) {
            UIView* myview = [[UIView alloc] initWithFrame:view.bounds];
            myview.backgroundColor = [UIColor whiteColor];
        
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            [myview addGestureRecognizer:singleFingerTap];
            
            _txt1 = [[UITextField alloc] initWithFrame:CGRectMake(5, 20, 300, 40)];
            _txt1.layer.borderColor = [[UIColor orangeColor] CGColor];
            _txt1.placeholder = @"Name";
            _txt1.layer.borderWidth = 1.0f;
            _txt1.layer.cornerRadius = 5;
            _txt1.keyboardType = UIKeyboardTypeDefault;
            _txt1.font = [UIFont zawgyiOneFontWithSize:13.0f];
            _txt1.delegate = self;
            
            [_txt1 setBorderStyle:UITextBorderStyleNone];
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            _txt1.leftView = paddingView;
            _txt1.leftViewMode = UITextFieldViewModeAlways;
            
            [myview addSubview:_txt1];
            
            _txt2 = [[UITextField alloc] initWithFrame:CGRectMake(5, 70, 300, 40)];
            _txt2.layer.borderColor = [[UIColor orangeColor] CGColor];
            _txt2.placeholder = @"Phone";
            _txt2.layer.borderWidth = 1.0f;
            _txt2.layer.cornerRadius = 5;
            _txt2.keyboardType = UIKeyboardTypeDefault;
            _txt2.font = [UIFont zawgyiOneFontWithSize:13.0f];
            _txt2.delegate = self;
            
            [_txt2 setBorderStyle:UITextBorderStyleNone];
            UIView *padview2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            _txt2.leftView = padview2;
            _txt2.leftViewMode = UITextFieldViewModeAlways;
            
            [myview addSubview:_txt2];
            
            _txt3 = [[UITextView alloc] initWithFrame:CGRectMake(5, 120, 300, 100)];
            _txt3.layer.borderColor = [[UIColor orangeColor] CGColor];
            _txt3.layer.borderWidth = 1.0f;
            _txt3.layer.cornerRadius = 5;
            _txt3.font = [UIFont zawgyiOneFontWithSize:13.0f];
            _txt3.delegate = self;
            _txt3.text = @"Message";
            _txt3.textColor = [UIColor lightGrayColor];
            [myview addSubview:_txt3];
            
            UIButton *but=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            but.frame= CGRectMake(5, 240, 300, 40);
            but.backgroundColor = [UIColor orangeColor];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [but setTitle:@"Send" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(sendContactInfo) forControlEvents:UIControlEventTouchUpInside];
            but.layer.cornerRadius = 5;
            [myview addSubview:but];
            
            [view addSubview:myview];
            [_scrollView addSubview:view];
            return;
        }
        
        mywebview.scrollView.scrollEnabled = NO;
        mywebview.scrollView.bounces = NO;
        [view addSubview:mywebview];
        [self.scrollView addSubview:view];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
    [self.view endEditing:YES];
}

- (void)sendContactInfo
{
    if (_txt3.text.length == 0 || [_txt3.text isEqualToString:@"Message"]) {
        return;
    }
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:[NSArray arrayWithObjects:_userinfo.email,nil]];
        [mailController setSubject:@"Contact Subject"];
        [mailController setMessageBody:[NSString stringWithFormat:@"Name: %@ </br> Phone: %@ </br> <p>%@</p>",_txt1.text,_txt2.text,_txt3.text] isHTML:YES];
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        
        [self JDStatusBarHidden:NO status:@"No Mail Account." duration:3.0f];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}


- (void)layoutScrollViewPages
{
    CGSize pageSize = self.scrollView.bounds.size;
    self.scrollView.contentSize = CGSizeMake(pageSize.width * [self.segments count], pageSize.height);
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect pageFrame = (CGRect) {
            .origin.x = pageSize.width * idx,
            .origin.y = 0,
            .size = pageSize
        };
        view.frame = CGRectInset(pageFrame, 5, 5);
        [view setNeedsDisplay];
    }];
    CGPoint contentOffset = CGPointMake(pageSize.width * self.segmentedControl.currentIndex, 0);
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Message"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Message";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - KASlideShow delegate

- (void) kaSlideShowDidNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidNext, index : %d",slideShow.currentIndex);
}

-(void)kaSlideShowDidPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidPrevious, index : %d",slideShow.currentIndex);
}

#pragma UIPhotoGalleryDataSource methods
- (NSInteger)numberOfViewsInPhotoGallery:(UIPhotoGalleryView *)photoGallery {
    return _imgArr.count;
}

- (NSURL*)photoGallery:(UIPhotoGalleryView *)photoGallery remoteImageURLAtIndex:(NSInteger)index {
    return _imgArr[index % _imgArr.count];
}

- (UIView*)photoGallery:(UIPhotoGalleryView *)photoGallery customViewAtIndex:(NSInteger)index {
    CGRect frame = CGRectMake(0, 0, photoGallery.frame.size.width, photoGallery.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%d", index+1];
    [view addSubview:label];
    
    return view;
}

- (UIView*)customTopViewForGalleryViewController:(UIPhotoGalleryViewController *)galleryViewController {
    return nil;
}


#pragma UIPhotoGalleryDelegate methods
- (void)photoGallery:(UIPhotoGalleryView *)photoGallery didTapAtIndex:(NSInteger)index {
    NSLog(@"%@", [photoGallery getCurrentView]);
}

- (void)photoGallery:(UIPhotoGalleryView *)photoGallery didMoveToIndex:(NSInteger)index {
    NSLog(@"Current Index : %d",_photoview.currentIndex);
    NSLog(@"didMoveToIndex : %d",index);
    _imgIndicator.text = [NSString stringWithFormat:@"%d of %d",_photoview.currentIndex+1,_imgArr.count];
    _curindex = _photoview.currentIndex;
}

- (UIPhotoGalleryDoubleTapHandler)photoGallery:(UIPhotoGalleryView *)photoGallery doubleTapHandlerAtIndex:(NSInteger)index {
    switch (photoGallery.galleryMode) {
        case UIPhotoGalleryModeImageLocal:
            return UIPhotoGalleryDoubleTapHandlerZoom;
            
        case UIPhotoGalleryModeImageRemote:
            return UIPhotoGalleryDoubleTapHandlerNone;
            
        default:
            return UIPhotoGalleryDoubleTapHandlerCustom;
    }
}

- (void)photoGallery:(UIPhotoGalleryView *)photoGallery didDoubleTapAtIndex:(NSInteger)index {
    NSLog(@"invoke");
}


- (IBAction)playSlideShow:(id)sender {
    
    if (_imgArr.count <= 1) {
        return;
    }
    _isPlaying = !_isPlaying;
//
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startPlay)   userInfo:nil repeats:YES];
    if (_isPlaying) {
        [_btnPlay setImage:[UIImage imageNamed:@"pausecircle.png"] forState:UIControlStateNormal];
        NSLog(@"Slideshow playing Current Index : %d",_photoview.currentIndex);
        [_photoview startslideshow:_curindex+1 isRepeat:_isPlaying];
        _imgIndicator.text = [NSString stringWithFormat:@"%d of %d",_curindex+2,_imgArr.count];
    } else [_btnPlay setImage:[UIImage imageNamed:@"playcircle.png"] forState:UIControlStateNormal];
    
    
}

- (void)playAgain:(NSNotification*)noti
{
    NSNumber* num = (NSNumber*)noti.object;
    NSInteger intNum = [num integerValue];
    _curindex = intNum;
    if (_isPlaying) {
        NSNumber* num = (NSNumber*)noti.object;
        NSInteger numint = [num integerValue] + 1;
        if (numint == _imgArr.count) {
            numint = 0;
        }
        _imgIndicator.text = [NSString stringWithFormat:@"%d of %d",numint+1,_imgArr.count];
        [_photoview startslideshow:numint isRepeat:_isPlaying];
    }
    
}

@end
