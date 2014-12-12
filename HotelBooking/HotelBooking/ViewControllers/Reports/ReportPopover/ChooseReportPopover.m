//
//  ChooseReportPopover.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/16/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ChooseReportPopover.h"
#import "SaleReportVC.h"
#import "ReportWeeklyMonthlyVC.h"

@interface ChooseReportPopover ()

@property (weak, nonatomic) IBOutlet UIButton *btnSaleReport;
@property (weak, nonatomic) IBOutlet UIButton *btnoccupacy;


- (IBAction)SaleReport:(id)sender;
- (IBAction)OccupacyReport:(id)sender;

@end

@implementation ChooseReportPopover

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
    
    _btnSaleReport.layer.cornerRadius = 5.0f;
    _btnoccupacy.layer.cornerRadius = 5.0f;
    
    _btnSaleReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    [_btnSaleReport setTitle:@"အေရာင္း စာရင္း" forState:UIControlStateNormal];
    
    _btnoccupacy.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    [_btnoccupacy setTitle:@"ေန ့အလုုိက္အေရာင္း စာရင္း" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)SaleReport:(id)sender {
    
    SaleReportVC* nexvc = (SaleReportVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleReportVC"];
    
    [self presentViewController:nexvc animated:YES completion:nil];
}

- (IBAction)OccupacyReport:(id)sender {
    
    ReportWeeklyMonthlyVC* nexvc = (ReportWeeklyMonthlyVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ReportWeeklyMonthlyVC"];
    
    [self presentViewController:nexvc animated:YES completion:nil];
}
@end
