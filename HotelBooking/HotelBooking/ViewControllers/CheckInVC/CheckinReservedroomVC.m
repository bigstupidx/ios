//
//  CheckinReservedroomVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CheckinReservedroomVC.h"
#import "BookListCell.h"
#import "ZMFMDBSQLiteHelper.h"
#import "JDStatusBarNotification.h"
#import "CheckinSlipVC.h"

@interface CheckinReservedroomVC () <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL ischecked;
@property (strong, nonatomic) NSMutableArray* pickedRoom;
@property (strong, nonatomic) NSString* voucherno;
@property (assign, nonatomic) unsigned long totalPayAmt;
@property (strong, nonatomic) NSString* strcheckindate;
@property (strong, nonatomic) NSMutableArray* selectedarr;

@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblPaidAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftAmt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbviewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckin;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCurrentAmt;
@property (weak, nonatomic) IBOutlet UILabel *lblRoom;
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
@property (weak, nonatomic) IBOutlet UILabel *lbldays;
@property (weak, nonatomic) IBOutlet UILabel *lblprice;
@property (weak, nonatomic) IBOutlet UILabel *lbltotalprice;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)Cancel:(id)sender;
- (IBAction)CheckIn:(id)sender;

@end

@implementation CheckinReservedroomVC

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
    
    _lblViewTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lblViewTitle.text = @"အခန္း စာရင္း";
    
    _lblRoom.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblRoom.text = @"အခန္းနံပါတ္";
    
    _lbldate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbldate.text = @"ငွားမည့္ေန ့မ်ား";
    
    _lbldays.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbldays.text = @"ေန ့ရက္ေပါင္း";
    
    _lblprice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblprice.text = @"အခန္းခ";
    
    _lbltotalprice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbltotalprice.text = @"စုုစုုေပါင္း အခန္းခ";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    _strcheckindate = [dateFormat stringFromDate:[NSDate date]];
    
    _ischecked = NO;
    
    int totalAmt = 0;
    int paidAmt = 0;
    for (NSDictionary* dict in _tableFiller) {
        totalAmt += [dict[@"price"] intValue] * ((NSArray*)dict[@"date"]).count;
        paidAmt += [dict[@"price"] intValue]* 0.1;
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%d", totalAmt];
    
    _pickedRoom = [NSMutableArray new];
    
    _voucherno = [self generateVoucherNumber];
    
    if (!_isCheckingIn) {
        _lblLeftAmt.hidden = YES;
        _lblTitleCurrentAmt.hidden = YES;
        [_btnCheckin setTitle:@"Check out" forState:UIControlStateNormal];
        
        _lblViewTitle.text = @"Check-in လုုပ္ထားေသာအခန္းစာရင္း";
    }
    
    _selectedarr = [[NSMutableArray alloc] initWithCapacity:_tableFiller.count];
    for (int i = 0; i < _tableFiller.count; i++) {
        [_selectedarr addObject:@"0"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllSelectedRooms) name:@"removeAllSelectedRooms" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resizetbview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAllSelectedRooms
{
    [_pickedRoom removeAllObjects];
    _selectedarr = [[NSMutableArray alloc] initWithCapacity:_tableFiller.count];
    for (int i = 0; i < _tableFiller.count; i++) {
        [_selectedarr addObject:@"0"];
    }
}

- (void)checkinthisroom:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSString* strselected = _selectedarr[btn.tag];
    
    _ischecked = !_ischecked;

    if ([strselected isEqualToString:@"0"]) {
        [btn setImage:[UIImage imageNamed:@"cb_glossy_on"] forState:UIControlStateNormal];
        NSDictionary* dict = _tableFiller[btn.tag];
//        NSArray* temparr = [_pickedRoom copy];
//        for (NSDictionary* finddict in temparr) {
//            if ([dict[@"detail_id"] isEqualToString:finddict[@"detail_id"]]) {
//                return;
//            }
//        }
        
        [_pickedRoom addObject:dict];
        _totalPayAmt += [dict[@"price"] intValue] * ((NSArray*)dict[@"date"]).count;
        _lblLeftAmt.text = [NSString stringWithFormat:@"%lu",_totalPayAmt];
        
        [_selectedarr replaceObjectAtIndex:btn.tag withObject:@"1"];
    }
    else {
        [btn setImage:[UIImage imageNamed:@"cb_glossy_off"] forState:UIControlStateNormal];
        NSDictionary* dict = _tableFiller[btn.tag];
        NSArray* temparr = [_pickedRoom copy];
        for (NSDictionary* finddict in temparr) {
            if ([dict[@"detail_id"] isEqualToString:finddict[@"detail_id"]]) {
                [_pickedRoom removeObject:finddict];
                _totalPayAmt -= [dict[@"price"] intValue] * ((NSArray*)dict[@"date"]).count;
                _lblLeftAmt.text = [NSString stringWithFormat:@"%lu",_totalPayAmt];
                
                [_selectedarr replaceObjectAtIndex:btn.tag withObject:@"0"];
                return;
            }
        }

    }
    
}

- (void)resizetbview
{
    float tbviewheight = 100 * _tableFiller.count;
    _tbviewHeight.constant = tbviewheight + 150;
}

- (NSString*)generateVoucherNumber
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd:hh:mm"];
    NSString* str = [dateFormat stringFromDate:[NSDate date]];

    return str;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 204, 9999)];
    label.numberOfLines=0;
    NSDictionary* bookdict = _tableFiller[indexPath.row];
    NSMutableString* muStr = [NSMutableString new];
    NSArray* arr = bookdict[@"date"];
    for (NSString* strdate in arr) {
        [muStr appendString:[NSString stringWithFormat:@"%@, ", strdate]];
    }
    
    label.text = muStr;
    
    CGSize maximumLabelSize = CGSizeMake(204, 9999);
    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    
    return expectedSize.height+50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"checkincell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* bookdict = _tableFiller[indexPath.row];
    
    cell.cellnrc.text = [NSString stringWithFormat:@"%lu", (unsigned long)((NSArray*)bookdict[@"date"]).count];
    
    cell.cellroomno.text = bookdict[@"roomno"];
//    cell.cellroomtype.text = [NSString stringWithFormat:@"%@",bookdict[@"type"]];
    NSMutableString* muStr = [NSMutableString new];
    NSArray* arr = bookdict[@"date"];
    for (NSString* strdate in arr) {
        [muStr appendString:[NSString stringWithFormat:@"%@, ", strdate]];
    }
    
    cell.cellbookdate.text = muStr;
    cell.cellamt.text = [NSString stringWithFormat:@"%@ Ks",bookdict[@"price"]];
    
    unsigned long totalamt = [bookdict[@"price"] intValue] * ((NSArray*)bookdict[@"date"]).count;
    cell.cellroomtype.text = [NSString stringWithFormat:@"%lu",totalamt];
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.viewDays.frame.size.width, cell.viewDays.frame.size.height);
//    btnCell.backgroundColor = [UIColor blueColor];
//    [btnCell setTitle:@"Select it" forState:UIControlStateNormal];
    [btnCell setImage:[UIImage imageNamed:@"cb_glossy_off"] forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(checkinthisroom:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.viewDays addSubview:btnCell];
    
    
    return cell;
}


- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)CheckIn:(id)sender {
    if (_pickedRoom.count == 0) {
        return;
    }
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    
    if (_isCheckingIn) {
        for (NSDictionary* dict in _pickedRoom) {
            unsigned long totalamt = [dict[@"price"] intValue] * ((NSArray*)dict[@"date"]).count;
            BOOL isUpdateSuccess = [db executeUpdate:[NSString stringWithFormat:@"update tbl_booking_detail set status='1', check_in_no='%@', arrival_date='%@', total_amt='%lu' where id='%d'",_voucherno, _strcheckindate, totalamt,[dict[@"detail_id"] intValue]]];
            
            if (isUpdateSuccess) {
                BOOL isRoomDateUpdateSuccess = [db executeUpdate:[NSString stringWithFormat:@"update tbl_booking_room_dates set status='1' where booking_detail_id='%d'", [dict[@"detail_id"] intValue]]];
            }
        }
        
        
        if (_tableFiller.count == _pickedRoom.count) {
            BOOL isbookingUpdateSuccess = [db executeUpdate:[NSString stringWithFormat:@"update tbl_booking set status='1' where id = '%d'", _bookid]];
            if (isbookingUpdateSuccess) {
                [self JDStatusBarHidden:NO status:@"Successfully CHECK IN all rooms." duration:3.0f];
            }
        }
        else [self JDStatusBarHidden:NO status:@"Successfully CHECK IN your chosen rooms." duration:3.0f];
    }
    else {
        for (NSDictionary* dict in _pickedRoom) {
            //CHECK OUT - STATUS = 2
            BOOL isUpdateSuccess = [db executeUpdate:[NSString stringWithFormat:@"update tbl_booking_detail set status='2' and departure_date='%@' where id='%d'", _strcheckindate,[dict[@"detail_id"] intValue]]];
            
            if (isUpdateSuccess) {
                BOOL isRoomDateUpdateSuccess = [db executeUpdate:[NSString stringWithFormat:@"update tbl_booking_room_dates set status='2' where booking_detail_id='%d'", [dict[@"detail_id"] intValue]]];
            }
        }
        
        
        if (_tableFiller.count == _pickedRoom.count) {
            BOOL isbookingUpdateSuccess = [db executeUpdate:[NSString stringWithFormat:@"update tbl_booking set status='2' where id = '%d'", _bookid]];
            if (isbookingUpdateSuccess) {
                [self JDStatusBarHidden:NO status:@"Successfully CHECK OUT all rooms." duration:3.0f];
            }
        }
        else [self JDStatusBarHidden:NO status:@"Successfully CHECK OUT your chosen rooms." duration:3.0f];
    }
    
    NSMutableArray* temparr = [_tableFiller mutableCopy];
    for (NSDictionary* dict in _pickedRoom) {
        
        for (NSDictionary* otherdict in _tableFiller) {
            if ([dict[@"detail_id"] isEqualToString:otherdict[@"detail_id"]]) {
                [temparr removeObject:otherdict];
                break;
            }
        }
        
    }
    _tableFiller = [temparr copy];
    [_tbview reloadData];
    [self resizetbview];
    
    if (_isCheckingIn) {
        CheckinSlipVC* nexvc = (CheckinSlipVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"CheckinSlipVC"];
        nexvc.tableFiller = _pickedRoom;
        nexvc.strVoucherno = _voucherno;
        
        [self presentViewController:nexvc animated:YES completion:nil];
    }
    
    
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

@end
