//
//  BookingListVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "BookingListVC.h"
#import "BookListCell.h"
#import "ZMFMDBSQLiteHelper.h"
#import "EditBookinglistVC.h"
#import "CheckinReservedroomVC.h"

@interface BookingListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* editArr;
@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) NSArray* tableFiller;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tbBookList;
@property (weak, nonatomic) IBOutlet UIButton *btnX;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNrc;
@property (weak, nonatomic) IBOutlet UILabel *lblbookdate;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomno;
@property (weak, nonatomic) IBOutlet UILabel *lblpaidamt;
@property (weak, nonatomic) IBOutlet UILabel *lbldays;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;


- (IBAction)Dismiss:(id)sender;


@end

@implementation BookingListVC

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
    
    _lblViewTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    
    
    _lblName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblName.text = @"၀ယ္သူ";
    
    _lblNrc.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblNrc.text = @"မွတ္ပံုုတင္နံပါတ္";
    
    _lblbookdate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblbookdate.text = @"ဘုုိကင္ေန ့စြဲ";
    
    _lblRoomno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblRoomno.text = @"အခန္းနံပါတ္";
    
    _lblpaidamt.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblpaidamt.text = @"လက္ခံရရွိေသာေငြ";
    
    _lbldays.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbldays.text = @"ေန ့ရက္ေပါင္း";
    
    _btnX.layer.cornerRadius = 10;
    _btnX.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnX.layer.borderWidth = 1.5f;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimg.jpg"]];
    
    _bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"isCheckingBookinglist = %hhd", _isCheckingBookingList);
    
    NSString* bookingstatus;
    NSString* bookdetailstatus;
    if (_isCheckingBookingList) {
        bookingstatus = @"0";
        bookdetailstatus = @"1";
        _lblViewTitle.text = @"ဘိုုကင္ စာရင္း";
    } else {
        bookingstatus = @"1";
        bookdetailstatus = @"0";
        _lblViewTitle.text = @"Check-in စာရင္း";
    }
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    _dataFiller = [db executeQuery:[NSString stringWithFormat:@"SELECT tbl_booking.booking_date, COUNT (tbl_booking_room_dates.book_date) as room_date, tbl_booking_room_dates.roomid,  tbl_booking.id, tbl_booking.total_amount, tbl_booking.status as paid, tbl_room_plan.room_no, tbl_room_type.type, tbl_customer.name, tbl_customer.nrc_no, tbl_customer.phone, tbl_booking_detail.id as detail_id  FROM tbl_booking JOIN tbl_booking_detail ON tbl_booking_detail.booking_id=tbl_booking.id JOIN tbl_booking_room_dates ON tbl_booking_room_dates.booking_detail_id=tbl_booking_detail.id JOIN tbl_room ON tbl_room.id=tbl_booking_detail.room_id JOIN tbl_room_plan ON tbl_room_plan.id=tbl_room.room_plan_id JOIN tbl_room_type ON tbl_room_type.id=tbl_room.room_type_id JOIN tbl_customer ON tbl_customer.id=tbl_booking.customer_id where tbl_booking_detail.status!='%@' and tbl_booking_detail.status!='2' group by tbl_booking.id", bookdetailstatus]];
    
    NSArray* bookidArr = [_dataFiller valueForKey:@"id"];
    NSMutableArray* muArr = [[NSMutableArray alloc] initWithCapacity:bookidArr.count];
    NSMutableArray* muDate = [NSMutableArray new];
    NSMutableArray* muEdit = [NSMutableArray new];
    for (int i=0; i<bookidArr.count; i++) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id = %d", [bookidArr[i] intValue]];
        NSArray * match = [_dataFiller filteredArrayUsingPredicate:predicate];
        
        NSArray* dateNroom = [db executeQuery:[NSString stringWithFormat:@"select book_date, tbl_room_plan.room_no, tbl_room_type.type, tbl_room.price, tbl_booking_detail.id as detail_id from tbl_booking_room_dates join tbl_booking_detail on tbl_booking_detail.id=tbl_booking_room_dates.booking_detail_id join tbl_booking on tbl_booking.id=tbl_booking_detail.booking_id join tbl_room on tbl_room.id=tbl_booking_detail.room_id join tbl_room_plan on tbl_room_plan.id=tbl_room.room_plan_id join tbl_room_type on tbl_room_type.id=tbl_room.room_type_id where tbl_booking.id = '%d' and tbl_booking_detail.status!='%@' and tbl_booking_detail.status!='2'",[bookidArr[i] intValue], bookdetailstatus]];
        
        NSArray* dateArr = [dateNroom valueForKey:@"book_date"];
        NSArray *cleanedArray = [[NSSet setWithArray:dateArr] allObjects];
        NSString* strDateCount = [NSString stringWithFormat:@"%d",cleanedArray.count];
        NSArray* roomArr = [dateNroom valueForKey:@"room_no"];
        NSArray* roomCleanArr = [[NSSet setWithArray:roomArr] allObjects];
        
       NSMutableArray* muEditArr = [NSMutableArray new];
        NSMutableString* muStr = [NSMutableString new];
        for (NSString* str in roomCleanArr) {
            [muStr appendString:[NSString stringWithFormat:@"%@, ",str]];
            NSString* strRoomtype;
            NSString* strRoomPrice;
            NSString* strBookDetailid;
            NSMutableArray* muDateArr = [NSMutableArray new];
            for (NSDictionary* dict in dateNroom) {
                if ([dict[@"room_no"] isEqualToString:str]) {
                    [muDateArr addObject:dict[@"book_date"]];
                    strRoomtype = dict[@"type"];
                    strRoomPrice = dict[@"price"];
                    strBookDetailid = [NSString stringWithFormat:@"%@",dict[@"detail_id"]];
                }
            }
            [muEditArr addObject:@{@"roomno": str, @"date": muDateArr, @"type": strRoomtype, @"price": strRoomPrice, @"detail_id": strBookDetailid}];
        }
        
        if (muEditArr.count > 0) {
            [muEdit addObject:muEditArr];
        }
        
        [muArr addObject:@{@"name": match[0][@"name"], @"nrc": match[0][@"nrc_no"], @"book_date": match[0][@"booking_date"], @"roomno": muStr, @"days": strDateCount, @"amt": @"-", @"detailid": match[0][@"detail_id"], @"roomid": match[0][@"roomid"], @"status": match[0][@"paid"], @"id": match[0][@"id"]}]; //@"amt": match[0][@"total_amount"]
        
        
    }
    
    if (muEdit.count > 0) {
        _editArr = [muEdit copy];
    }
    
    _tableFiller = [muArr copy];
    
    [_tbBookList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)showDays:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    NSDictionary* editdict = _tableFiller[btn.tag];
    EditBookinglistVC* nexvc = (EditBookinglistVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"EditBookinglistVC"];
    nexvc.tableFiller = [_editArr[btn.tag] copy];
    nexvc.roomid = [editdict[@"roomid"] intValue];
    nexvc.roomdetailid = [editdict[@"detailid"] intValue];
    nexvc.paidStatus = editdict[@"status"];
    nexvc.bookid = [editdict[@"id"] intValue];

    [self presentViewController:nexvc animated:YES completion:nil];
    
}

- (void)checkinBooking:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    CheckinReservedroomVC* nexvc = (CheckinReservedroomVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinReservedroomVC"];
    nexvc.tableFiller = [_editArr[btn.tag] copy];
    NSDictionary* editdict = _tableFiller[btn.tag];
    nexvc.bookid = [editdict[@"id"] intValue];
    if (_isCheckingBookingList) nexvc.isCheckingIn = YES;
    else nexvc.isCheckingIn = NO;
    [self presentViewController:nexvc animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"booklistcell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* bookdict = _tableFiller[indexPath.row];
    cell.cellname.text = bookdict[@"name"];
    cell.cellnrc.text = bookdict[@"nrc"];
    cell.cellbookdate.text = bookdict[@"book_date"];
    cell.cellroomno.text = bookdict[@"roomno"];
    cell.cellroomtype.text = [NSString stringWithFormat:@"%@",bookdict[@"amt"]];
    cell.cellamt.text = [NSString stringWithFormat:@"%@",bookdict[@"days"]];
    NSString* btnTitle = @"Check in";
    if (_isCheckingBookingList) {
        UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCell.frame = CGRectMake(0.0f, 0.0f, cell.viewDays.frame.size.width, cell.viewDays.frame.size.height);
        btnCell.backgroundColor = [UIColor grayColor];
        [btnCell setTitle:@"Edit" forState:UIControlStateNormal];
        [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCell addTarget:self action:@selector(showDays:) forControlEvents:UIControlEventTouchUpInside];
        
        btnCell.tag = indexPath.row;
        [cell.viewDays addSubview:btnCell];

    }
    else btnTitle = @"Check out";
    
    UIButton *btnCkIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCkIn.frame = CGRectMake(0.0f, 0.0f, cell.viewDays.frame.size.width, cell.viewDays.frame.size.height);
    btnCkIn.backgroundColor = [UIColor blueColor];
    [btnCkIn setTitle:btnTitle forState:UIControlStateNormal];
    [btnCkIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCkIn addTarget:self action:@selector(checkinBooking:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCkIn.tag = indexPath.row;
    [cell.viewTwo addSubview:btnCkIn];
    return cell;
}

- (IBAction)Dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
