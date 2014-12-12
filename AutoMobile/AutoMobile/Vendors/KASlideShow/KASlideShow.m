//
//  KASlideShow.m
//
// Copyright 2013 Alexis Creuzot
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "KASlideShow.h"
#import "UIImageView+WebCache.h"


#define kSwipeTransitionDuration 0.25

typedef NS_ENUM(NSInteger, KASlideShowSlideMode) {
    KASlideShowSlideModeForward,
    KASlideShowSlideModeBackward
};

@interface KASlideShow()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@property (strong,nonatomic) UIImageView * topImageView;
@property (strong,nonatomic) UIImageView * bottomImageView;
@property (strong,nonatomic) NSArray *imgURLArray;
@property (assign, nonatomic) BOOL isStart;

@end

@implementation KASlideShow

@synthesize delegate;
@synthesize delay;
@synthesize transitionDuration;
@synthesize transitionType;
@synthesize images;

- (void)awakeFromNib
{
    [self setDefaultValues];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void) setDefaultValues
{
    self.clipsToBounds = YES;
    self.images = [NSMutableArray array];
    _currentIndex = 0;
    delay = 3;
    
    transitionDuration = 1;
    transitionType = KASlideShowTransitionFade;
    _doStop = YES;
    _isAnimating = NO;
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
    } else {
        if ([self isRetina4InchDisplay]) {
            _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_topImageView.frame.size.width / 2) - 30, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
            _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_bottomImageView.frame.size.width / 2) - 30, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        } else {
            _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_topImageView.frame.size.width / 2) - 80, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
            _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_bottomImageView.frame.size.width / 2) - 80, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        }
        
        
    }


    _topImageView.clipsToBounds = YES;
    _bottomImageView.clipsToBounds = YES;
    //[self setImagesContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:_bottomImageView];
    [self addSubview:_topImageView];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];

}

- (void)deviceOrientationDidChange:(NSNotification*)notification
{
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];

    } else {
        if ([self isRetina4InchDisplay]) {
            _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_topImageView.frame.size.width / 2) - 30, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
            _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_bottomImageView.frame.size.width / 2) - 30, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        } else {
            _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_topImageView.frame.size.width / 2) - 80, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
            _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - (_bottomImageView.frame.size.width / 2) - 80, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        }
        
    }
}

- (void) setImagesContentMode:(UIViewContentMode)mode
{
    _topImageView.contentMode = mode;
    _bottomImageView.contentMode = mode;
}

- (UIViewContentMode) imagesContentMode
{
    return _topImageView.contentMode;
}

- (void) addGesture:(KASlideShowGestureType)gestureType
{
    switch (gestureType)
    {
        case KASlideShowGestureTap:
            [self addGestureTap];
            break;
        case KASlideShowGestureSwipe:
            [self addGestureSwipe];
            break;
        case KASlideShowGestureAll:
            [self addGestureTap];
            [self addGestureSwipe];
            break;
        default:
            break;
    }
}

- (void) addImagesFromResources:(NSArray *) names
{
    self.imgURLArray = [names copy];
    if (self.images.count > 0) {
        [self.images removeAllObjects];
    }
    if (names.count == 0) {
        [self addImage:[UIImage imageNamed:@"automobile_pattern.png"]];
    }
    UIImageView* imgView = [[UIImageView alloc] init];
    for(NSString * name in names){
        NSString* strName = [NSString stringWithFormat:@"http://www.automobile.com.mm/%@",name];
        NSURL* imgUrl = [NSURL URLWithString:[strName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imgView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"automobile_pattern.png"] completed:nil];
        [self addImage:imgView.image];
    }
}

- (void) addImage:(UIImage*) image
{
    [self.images addObject:image];
    
    if([self.images count] == 1){
        _topImageView.image = image;
    }else if([self.images count] == 2){
        _bottomImageView.image = image;
    }
}

- (void) emptyAndAddImagesFromResources:(NSArray *)names
{
    [self.images removeAllObjects];
    _currentIndex = 0;
    [self addImagesFromResources:names];
}

- (void) start
{
    
    _doStop = NO;
    self.isStart = YES;
    [self performSelector:@selector(next) withObject:nil afterDelay:delay];
}

- (void) next
{
    [self addImagesFromResources:self.imgURLArray];
    if(! _isAnimating &&
       [self.images count] >1){
        
        // Next Image
        NSUInteger nextIndex = (_currentIndex+1)%[self.images count];
        _topImageView.image = self.images[_currentIndex];
        _bottomImageView.image = self.images[nextIndex];
        _currentIndex = nextIndex;
        
        // Animate
        switch (transitionType) {
            case KASlideShowTransitionFade:
                [self animateFade];
                break;
                
            case KASlideShowTransitionSlide:
                [self animateSlide:KASlideShowSlideModeForward];
                break;
                
        }
        
        if (self.isStart && ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentIndex"] != _currentIndex)) {
            
            self.isStart = NO;
//            self.imgurl = self.imgURLArray[_currentIndex];
            [[NSUserDefaults standardUserDefaults] setInteger:_currentIndex forKey:@"currentIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"SHOW TOP ADS %d %@", _currentIndex,self.imgURLArray[_currentIndex]);
        }
        else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentIndex"] != _currentIndex) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:_currentIndex forKey:@"currentIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"SHOW TOP ADS %d %@", _currentIndex,self.imgURLArray[_currentIndex]);
        }

    
        // Call delegate //SMT : COMMENT OUT // DON'T CALL ITS DELEGATE (BAD_EXE_ACCESS)
//        if([delegate respondsToSelector:@selector(kaSlideShowDidNext:)]){
//            [delegate kaSlideShowDidNext:self];
//        }
    }
}


- (void) previous
{
    [self addImagesFromResources:self.imgURLArray];
    if(! _isAnimating &&
       [self.images count] >1){
        
        // Previous image
        NSUInteger prevIndex;
        if(_currentIndex == 0){
            prevIndex = [self.images count] - 1;
        }else{
            prevIndex = (_currentIndex-1)%[self.images count];
        }
        _topImageView.image = self.images[_currentIndex];
        _bottomImageView.image = self.images[prevIndex];
        _currentIndex = prevIndex;
        
        // Animate
        switch (transitionType) {
            case KASlideShowTransitionFade:
                [self animateFade];
                break;
                
            case KASlideShowTransitionSlide:
                [self animateSlide:KASlideShowSlideModeBackward];
                break;
        }
        
        // Call delegate
        if([delegate respondsToSelector:@selector(kaSlideShowDidPrevious:)]){
            [delegate kaSlideShowDidPrevious:self];
        }
    }
    
}

- (void) animateFade
{
    _isAnimating = YES;
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         _topImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         _topImageView.image = _bottomImageView.image;
                         _topImageView.alpha = 1;
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                             
                         }
                     }];
}

- (void) animateSlide:(KASlideShowSlideMode) mode
{
    _isAnimating = YES;
    
    if(mode == KASlideShowSlideModeBackward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(- _bottomImageView.frame.size.width, 0);
    }else if(mode == KASlideShowSlideModeForward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(_bottomImageView.frame.size.width, 0);
    }
    
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         
                         if(mode == KASlideShowSlideModeBackward){
                             _topImageView.transform = CGAffineTransformMakeTranslation( _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }else if(mode == KASlideShowSlideModeForward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(- _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                     }
                     completion:^(BOOL finished){
                         
                         _topImageView.image = _bottomImageView.image;
                         _topImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}


- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

#pragma mark - Gesture Recognizers initializers
- (void) addGestureTap
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          
                                                          initWithTarget:self action:@selector(handleSingleTap:)];
    
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) addGestureSwipe
{
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    [self addGestureRecognizer:swipeRightGestureRecognizer];
}

#pragma mark - Gesture Recognizers handling
- (void)handleSingleTap:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint pointTouched = [gesture locationInView:self.topImageView];
    
    if (pointTouched.x <= self.topImageView.center.x)
    {
        [self previous];
    }
    else
    {
        [self next];
    }
}

- (void) handleSwipe:(id)sender
{
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)sender;
    
    float oldTransitionDuration = self.transitionDuration;
    
    self.transitionDuration = kSwipeTransitionDuration;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self next];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self previous];
    }
    
    self.transitionDuration = oldTransitionDuration;
}

- (BOOL)isRetina4InchDisplay {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        return NO;
    return (CGSizeEqualToSize([[UIScreen mainScreen] currentMode].size, CGSizeMake(640, 1136)));
}


@end

