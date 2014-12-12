//
//  SaleReportVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/16/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SaleReportVC.h"
#import "MultiLineSegmentedControl.h"
#import "ZMFMDBSQLiteHelper.h"
#import "BookListCell.h"
#import "SaleReportDetailVC.h"

@interface SaleReportVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MultiLineSegmentedControl* multiSegCon;
@property (strong, nonatomic) MultiLineSegmentedControl* segControl;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (assign, nonatomic) BOOL isSelectingFromDate;
@property (strong, nonatomic) NSArray* tablefiller;
@property (assign, nonatomic) int selectedBld;
@property (assign, nonatomic) int selectedFloor;
@property (strong, nonatomic) NSArray* resultArr;

@property (weak, nonatomic) IBOutlet UIView *viewBldBg;
@property (weak, nonatomic) IBOutlet UIView *viewFloorBg;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *btnDismiss;
@property (weak, nonatomic) IBOutlet UITableView *tbTotalByDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbheight;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblcheckindate;
@property (weak, nonatomic) IBOutlet UILabel *lbltitletotal;
@property (weak, nonatomic) IBOutlet UILabel *lbltitletotalamt;
@property (weak, nonatomic) IBOutlet UILabel *lblViewtitle;

- (IBAction)SelectFromDate:(id)sender;
- (IBAction)SelectToDate:(id)sender;
- (IBAction)Search:(id)sender;
- (IBAction)DismissThisView:(id)sender;


@end

@implementation SaleReportVC

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimg.jpg"]];
    
    _scrollview.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    
    _lblViewtitle.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lblViewtitle.text = @"အေရာင္း စာရင္း";
    
    _lblcheckindate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblcheckindate.text = @"ေငြေပးေခ်သည့္ေန ့ရက္";
    
    _lbltitletotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitletotal.text = @"စုုစုုေပါင္း";
    
    _lbltitletotalamt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltitletotalamt.text = @"စုုစုုေပါင္း :";
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _btnSearch.layer.cornerRadius = 5;
    _btnSearch.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btnSearch.layer.borderWidth = 1.5f;
    
    _btnFromDate.layer.cornerRadius = 5;
    _btnFromDate.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btnFromDate.layer.borderWidth = 1.5f;
    
    _btnToDate.layer.cornerRadius = 5;
    _btnToDate.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btnToDate.layer.borderWidth = 1.5f;
    
    _btnDismiss.layer.cornerRadius = 10;
    _btnDismiss.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnDismiss.layer.borderWidth = 1.5f;
    
    NSArray* muArr = @[@"၂ထပ္တုုိက္ အမွတ္(၁)", @"၂ထပ္တိုုက္ အမွတ္(၂)", @"လံုုးခ်င္း"];
    
    _multiSegCon = [[MultiLineSegmentedControl alloc] initWithItems:muArr];
    
    [_multiSegCon setTintColor:[UIColor whiteColor]];
    [_multiSegCon setBackgroundColor:[UIColor blackColor]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Zawgyi-One" size:17], NSFontAttributeName, nil];
    [_multiSegCon setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _multiSegCon.frame = CGRectMake(0, 0, _viewBldBg.frame.size.width, _multiSegCon.frame.size.height * 2.5);
    
    [_multiSegCon addTarget:self action:@selector(pickBuilding) forControlEvents:UIControlEventValueChanged];
    
    [_viewBldBg addSubview:_multiSegCon];
    _multiSegCon.center = [_viewBldBg convertPoint:_viewBldBg.center fromView:_viewBldBg.superview];
    
    _multiSegCon.selectedSegmentIndex = 0; //To see Full lbl in segCont
    _selectedBld = 1;
    
    _segControl = [[MultiLineSegmentedControl alloc] initWithItems:@[@"အေပၚထပ္", @"ေအာက္ထပ္"]];
    
    [_segControl setTintColor:[UIColor whiteColor]];
    [_segControl setBackgroundColor:[UIColor blackColor]];
    [_segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _segControl.frame = CGRectMake(0, 0, _viewFloorBg.frame.size.width, _segControl.frame.size.height * 2.5);
    
    [_segControl addTarget:self action:@selector(floorChanged) forControlEvents:UIControlEventValueChanged];
    
    [_viewFloorBg addSubview:_segControl];
    _segControl.center = [_viewFloorBg convertPoint:_viewFloorBg.center fromView:_viewFloorBg.superview];
    
    _segControl.selectedSegmentIndex = 0;
    _selectedFloor = 1;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strtdydate = [dateFormatter stringFromDate:[NSDate date]];
    [_btnFromDate setTitle:strtdydate forState:UIControlStateNormal];
    [_btnToDate setTitle:strtdydate forState:UIControlStateNormal];
    [self searchTotalByCheckindate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDatefromSaleReport:) name:@"didSelectDatefromSaleReport" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"SaleReportVC" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resizeTableview
{
    float tbheight = 58 * _tablefiller.count;
    _tbheight.constant = tbheight + 30;
}

- (void)searchTotalByCheckindate
{
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    _resultArr = [db executeQuery:[NSString stringWithFormat:@"SELECT room_id, tbl_booking_detail.id, tbl_room_plan.room_no, tbl_room.price, arrival_date, check_in_no, total_amt FROM tbl_booking_detail join tbl_room on tbl_room.id=tbl_booking_detail.room_id join tbl_room_plan on tbl_room_plan.id=tbl_room.room_plan_id where arrival_date between '%@' and '%@' and tbl_room_plan.building_id='%d' and tbl_room_plan.floor_id='%d'",_btnFromDate.titleLabel.text, _btnToDate.titleLabel.text, _selectedBld, _selectedFloor]];
    
    NSArray* dateArr = [_resultArr valueForKey:@"arrival_date"];
    NSArray *cleanedArray = [[NSSet setWithArray:dateArr] allObjects];
    
    NSMutableArray* muArr = [NSMutableArray new];
    int total_tb_Amt = 0;
    for (NSString* strdate in cleanedArray) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"arrival_date MATCHES[cd] %@", strdate];
        NSArray * match = [_resultArr filteredArrayUsingPredicate:predicate];
        
        int totalamt = 0;
        for (NSDictionary* dict in match) {
            totalamt += [dict[@"total_amt"] intValue];
        }
        total_tb_Amt += totalamt;
        [muArr addObject:@{@"date": strdate, @"total_amt": @(totalamt)}];
    }
    
    _lblTotalAmt.text = [NSString stringWithFormat:@"%d Ks", total_tb_Amt];
    _tablefiller = [muArr copy];
    [_tbTotalByDate reloadData];
    [self resizeTableview];
}


- (void)pickBuilding
{
    _selectedBld = _multiSegCon.selectedSegmentIndex+1;
    if (_selectedBld == 3) {
        _viewFloorBg.hidden = YES;
    } else _viewFloorBg.hidden = NO;
    [self searchTotalByCheckindate];
}

- (void)floorChanged
{
    _selectedFloor = _segControl.selectedSegmentIndex+1;
    [self searchTotalByCheckindate];
}

- (void)didSelectDatefromSaleReport:(NSNotification*)noti
{
    NSString* strDate = (NSString*)noti.object;
    
    if (_isSelectingFromDate) {
        [_btnFromDate setTitle:strDate forState:UIControlStateNormal];
    }
    else [_btnToDate setTitle:strDate forState:UIControlStateNormal];
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)SelectFromDate:(id)sender {
    _isSelectingFromDate = YES;
}

- (IBAction)SelectToDate:(id)sender {
    
    _isSelectingFromDate = NO;
}

- (IBAction)Search:(id)sender {
    
    if ([_btnFromDate.titleLabel.text isEqualToString:@"From Date"] && [_btnToDate.titleLabel.text isEqualToString:@"To Date"]) {
        return;
    }
    
    [self searchTotalByCheckindate];
    
}

- (IBAction)DismissThisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tablefiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"saleallcell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* chkindict = _tablefiller[indexPath.row];
    
    cell.cellbookdate.text = chkindict[@"date"];
    cell.cellamt.text = [NSString stringWithFormat:@"%@ Ks",chkindict[@"total_amt"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* chkindict = _tablefiller[indexPath.row];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"arrival_date MATCHES[cd] %@", chkindict[@"date"]];
    NSArray * match = [_resultArr filteredArrayUsingPredicate:predicate];
    
    NSArray* chkinNoArr = [match valueForKey:@"check_in_no"];
    NSArray *cleanedArray = [[NSSet setWithArray:chkinNoArr] allObjects];
    
    NSMutableArray* muPassedArr = [[NSMutableArray alloc] initWithCapacity:cleanedArray.count];
    for (NSString* strchkinnum in cleanedArray) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"check_in_no MATCHES[cd] %@", strchkinnum];
        NSArray * chkinmatch = [_resultArr filteredArrayUsingPredicate:predicate];
        
        NSMutableString* muStr = [NSMutableString new];
        int totalamt = 0;
        for (NSDictionary* dict in chkinmatch) {
            [muStr appendFormat:@"%@, ", dict[@"room_no"]];
            totalamt += [dict[@"total_amt"] intValue];
        }
        
        [muPassedArr addObject:@{@"checkinno": strchkinnum, @"rooms": muStr, @"total_amt": @(totalamt)}];
        
    }
    
    SaleReportDetailVC* nexvc = (SaleReportDetailVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleReportDetailVC"];
    nexvc.chkindate = chkindict[@"date"];
    nexvc.tablefiller = [muPassedArr copy];
    nexvc.totalamt = [chkindict[@"total_amt"] intValue];
    nexvc.resultArr = [_resultArr copy];
    
    [self presentViewController:nexvc animated:YES completion:nil];
}

@end
