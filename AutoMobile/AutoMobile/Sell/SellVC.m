//
//  SellVC.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "SellVC.h"
#import "SellFormVC.h"
#import "UIFont+ZawgyiOne.h"
#import "SellCustomCell.h"
#import "JDStatusBarNotification.h"

@interface SellVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblThird;
@property (weak, nonatomic) IBOutlet UIButton *btnThird;
@property (weak, nonatomic) IBOutlet UIButton *btnFouth;
@property (weak, nonatomic) IBOutlet UILabel *lblFouth;

- (IBAction)onBtnFirstClicked:(id)sender;
- (IBAction)onBtnSecondClicked:(id)sender;
- (IBAction)onBtnThirdClicked:(id)sender;
- (IBAction)onBtnFouthClicked:(id)sender;

@property (strong, nonatomic) NSArray *sellCategoryArray;
@end

@implementation SellVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sellCategoryArray = @[@{@"name": @"ျမန္မာျပည္တြင္ေရာက္ရွိေနသည့္ကားမ်ား", @"id": @"1"},
                               @{@"name": @"CIF/FOB အၿပီးအစီးမွာယူတင္သြင္းေပးမည့္ကားမ်ား", @"id": @"2"},
                               @{@"name": @"စလစ္မ်ား", @"id": @"3"},
                               @{@"name": @"အပ္ႏွံရမည့္ ယာဥ္အိုယာဥ္ေဟာင္းမ်ား", @"id": @"4"}];
    [self setupButtons];
    [self setupBackButton];
    
    NSArray *familyNames = [UIFont familyNames];
    
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
            
        }
    }
}

- (void)setupButtons
{
    _lblFirst.font = [UIFont zawgyiOneFontWithSize:13];
    _lblFirst.text = @"ျမန္မာျပည္တြင္ေရာက္ရွိေနေသာ ကားမ်ား";
    _btnFirst.layer.borderWidth = 1.5f;
    _btnFirst.layer.borderColor = [[UIColor orangeColor] CGColor];
    _btnFirst.layer.cornerRadius = 5.0f;
    
    _lblSecond.font = [UIFont zawgyiOneFontWithSize:13];
    _lblSecond.text = @"ဆိပ္ကမ္းေရာက္ တန္ဖိုုးျဖင့္ေရာင္းမည့္ကားမ်ား";
    _btnSecond.layer.borderWidth = 1.5f;
    _btnSecond.layer.borderColor = [[UIColor orangeColor] CGColor];
    _btnSecond.layer.cornerRadius = 5.0f;
    
    _lblThird.font = [UIFont zawgyiOneFontWithSize:13];
    _lblThird.text = @"စလစ္မ်ား";
    _btnThird.layer.borderWidth = 1.5f;
    _btnThird.layer.borderColor = [[UIColor orangeColor] CGColor];
    _btnThird.layer.cornerRadius = 5.0f;
    
    _lblFouth.font = [UIFont zawgyiOneFontWithSize:13];
    _lblFouth.text = @"အပ္ႏွံရမည့္ ယာဥ္အုုိယာဥ္ေဟာင္းမ်ား";
    _btnFouth.layer.borderWidth = 1.5f;
    _btnFouth.layer.borderColor = [[UIColor orangeColor] CGColor];
    _btnFouth.layer.cornerRadius = 5.0f;

}

- (void)setupBackButton
{
    self.tabBarController.navigationItem.hidesBackButton = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"back_unselected.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.tabBarController.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.topViewController.title = @"Sell";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sellCategoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SellCell";
    SellCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.cellLbl.font = [UIFont zawgyiOneFontWithSize:13];
    cell.cellLbl.text = self.sellCategoryArray[indexPath.section][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellCustomCell* cuscell = (SellCustomCell*)cell;
    cuscell.cellBgView.layer.borderColor = [[UIColor orangeColor] CGColor];
    cuscell.cellBgView.layer.borderWidth = 1.5f;
    cuscell.cellBgView.layer.cornerRadius = 3;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SellFormVC"];
    NSDictionary* dict= self.sellCategoryArray[indexPath.section];
    vc.selectedCategory = self.sellCategoryArray[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBtnFirstClicked:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        SellFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SellFormVC"];
        NSDictionary* dict= self.sellCategoryArray[0];
        vc.selectedCategory = self.sellCategoryArray[0];
        [self.navigationController pushViewController:vc animated:YES];
    } else [self JDStatusBarHidden:NO status:@"You have to log in first." duration:3.0f];
}

- (IBAction)onBtnSecondClicked:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        SellFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SellFormVC"];
        NSDictionary* dict= self.sellCategoryArray[1];
        vc.selectedCategory = self.sellCategoryArray[1];
        [self.navigationController pushViewController:vc animated:YES];
    } else [self JDStatusBarHidden:NO status:@"You have to log in first." duration:3.0f];
}

- (IBAction)onBtnThirdClicked:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        SellFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SellFormVC"];
        NSDictionary* dict= self.sellCategoryArray[2];
        vc.selectedCategory = self.sellCategoryArray[2];
        [self.navigationController pushViewController:vc animated:YES];
    } else [self JDStatusBarHidden:NO status:@"You have to log in first." duration:3.0f];
}

- (IBAction)onBtnFouthClicked:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        SellFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SellFormVC"];
        NSDictionary* dict= self.sellCategoryArray[3];
        vc.selectedCategory = self.sellCategoryArray[3];
        [self.navigationController pushViewController:vc animated:YES];
    } else [self JDStatusBarHidden:NO status:@"You have to log in first." duration:3.0f];
}
@end
