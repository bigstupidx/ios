//
//  EditBookinglistVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/11/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "EditBookinglistVC.h"
#import "BookListCell.h"
#import "BookDateEditVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "JDStatusBarNotification.h"
#import "ViewController.h"

@interface EditBookinglistVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblroomno;
@property (weak, nonatomic) IBOutlet UILabel *lblroomtype;
@property (weak, nonatomic) IBOutlet UILabel *lbldays;

@property (weak, nonatomic) IBOutlet UITableView *tbRoomlist;
@property (weak, nonatomic) IBOutlet UIButton *btnDismiss;

- (IBAction)Dismiss:(id)sender;
- (IBAction)addROOM:(id)sender;

@end

@implementation EditBookinglistVC

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
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimg.jpg"]];
//    
//    _bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    
    _lblroomno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblroomno.text = @"အခန္းနံပါတ္";
    
    _lblroomtype.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblroomtype.text = @"အမ်ိဴးအစား";
    
    _lbldays.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lbldays.text = @"ေန ့ရက္ေပါင္း";
    
    _btnDismiss.layer.cornerRadius = 10;
    _btnDismiss.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnDismiss.layer.borderWidth = 1.5f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterAddingRooms) name:@"refreshDataAfterAddingRooms" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataAfterAddingRooms
{
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    NSArray* dateNroom = [db executeQuery:[NSString stringWithFormat:@"select book_date, tbl_room_plan.room_no, tbl_room_type.type, tbl_room.price, tbl_booking_detail.id as detail_id from tbl_booking_room_dates join tbl_booking_detail on tbl_booking_detail.id=tbl_booking_room_dates.booking_detail_id join tbl_booking on tbl_booking.id=tbl_booking_detail.booking_id join tbl_room on tbl_room.id=tbl_booking_detail.room_id join tbl_room_plan on tbl_room_plan.id=tbl_room.room_plan_id join tbl_room_type on tbl_room_type.id=tbl_room.room_type_id where tbl_booking.id = '%d' and tbl_booking_detail.status!='%@' and tbl_booking_detail.status!='2'",_bookid, @"1"]];
    
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
    
    _tableFiller = [muEditArr copy];
    [_tbRoomlist reloadData];

}

- (void)refreshData
{
    NSMutableArray* muArr = [[NSMutableArray alloc] initWithArray:_tableFiller];
    for (NSDictionary* dict in _tableFiller) {
        NSArray* datearr = dict[@"date"];
        if (datearr.count == 0) {
            [muArr removeObject:dict];
            break;
        }
    }
    _tableFiller = [muArr copy];
    [_tbRoomlist reloadData];
}

- (void)showEditDays:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSDictionary* dict = _tableFiller[btn.tag];
    BookDateEditVC* nexvc = (BookDateEditVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"BookDateEditVC"];
    nexvc.bookdates = dict[@"date"];
    nexvc.roomid = _roomid;
    nexvc.roomdetailid = _roomdetailid;
    nexvc.paidStatus = _paidStatus;
    nexvc.bookid = _bookid;
    [self presentViewController:nexvc animated:YES completion:nil];

}

- (void)deletedays:(id)sender
{
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    BOOL isDeleteSuccess = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking_room_dates where booking_detail_id='%d' and roomid='%d'",_roomdetailid, _roomid]];
    if (isDeleteSuccess) {
        BOOL deleteBookingDetail = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking_detail where id='%d' and roomid='%d'", _roomdetailid, _roomid]];
        if (deleteBookingDetail) {
            NSArray* bookdetailArr = [db executeQuery:[NSString stringWithFormat:@"select booking_id from tbl_booking_detail where booking_id='%d'",_bookid]];
            if (bookdetailArr.count == 0) {
                BOOL isDeleteBookingidSuccess = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking where id='%d'", _bookid]];
                
            }
        }
        [self JDStatusBarHidden:NO status:@"Successfully deleted." duration:3.0];
        UIButton* btn = (UIButton*)sender;
        NSMutableArray* muArr = [[NSMutableArray alloc] initWithArray:_tableFiller];
        [muArr removeObject:_tableFiller[btn.tag]];
        _tableFiller = [muArr copy];
        [_tbRoomlist reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"reservedroom";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* bookdict = _tableFiller[indexPath.row];

    cell.cellnrc.text = [NSString stringWithFormat:@"%d", ((NSArray*)bookdict[@"date"]).count];

    cell.cellroomno.text = bookdict[@"roomno"];
    cell.cellroomtype.text = [NSString stringWithFormat:@"%@",bookdict[@"type"]];

    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.viewDays.frame.size.width, cell.viewDays.frame.size.height);
    btnCell.backgroundColor = [UIColor blueColor];
    [btnCell setTitle:@"Edit" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(showEditDays:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.viewDays addSubview:btnCell];
    
    UIButton *btnDeleteCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDeleteCell.frame = CGRectMake(0.0f, 0.0f, cell.viewDays.frame.size.width, cell.viewDays.frame.size.height);
    btnDeleteCell.backgroundColor = [UIColor redColor];
    [btnDeleteCell setTitle:@"Delete" forState:UIControlStateNormal];
    [btnDeleteCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDeleteCell addTarget:self action:@selector(deletedays:) forControlEvents:UIControlEventTouchUpInside];
    
    btnDeleteCell.tag = indexPath.row;
    [cell.viewTwo addSubview:btnDeleteCell];
    return cell;
}


- (IBAction)Dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addROOM:(id)sender {
    ViewController* vc = (ViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.isRoomAdding = YES;
    vc.bookingid = _bookid;
    [self presentViewController:vc animated:YES completion:nil];
}
    
@end
