//
//  RoomInfoVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "RoomInfoVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "CKCalendarView.h"
#import "MainBookVC.h"
#import "JDStatusBarNotification.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RoomInfoVC () <CKCalendarDelegate>

@property (assign, nonatomic) BOOL isToDate;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (strong, nonatomic) NSArray* bookingdate;
@property (strong, nonatomic) NSArray* chkindate;
@property (strong, nonatomic) NSArray* dateInBookinglist;
@property (assign, nonatomic) BOOL isDateModified;
@property (assign, nonatomic) int selectedroomtypeid;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

- (IBAction)Close:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomno;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomtype;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblFacality;

@property (weak, nonatomic) IBOutlet CKCalendarView *calenderview;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* minimumDate;
@property (strong, nonatomic) NSMutableArray* muDateArr;
@property (weak, nonatomic) IBOutlet UIButton *btnClearRoom;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRoom;
@property (weak, nonatomic) IBOutlet UIButton *btnBook;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckin;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRoomBook;
@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UITextField *txtRoomNo;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnRoomType;


@property (weak, nonatomic) IBOutlet UILabel *lblTitleroomno;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleroomtype;
@property (weak, nonatomic) IBOutlet UILabel *lblTitlePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleFacility;
@property (weak, nonatomic) IBOutlet UIButton *btnEditroom;

- (IBAction)BookRoom:(id)sender;
- (IBAction)AddToRoomArray:(id)sender;
- (IBAction)CheckinRoom:(id)sender;
- (IBAction)ClearRoomList:(id)sender;
- (IBAction)BookAddRoom:(id)sender;
- (IBAction)EditThisRoom:(id)sender;
- (IBAction)DismissUpperView:(id)sender;
- (IBAction)SaveRoomInfo:(id)sender;

@end

@implementation RoomInfoVC

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
    
    _lblTitleroomno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleroomno.text = @"အခန္းနံပါတ္ :";
    
    _lblTitleroomtype.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleroomtype.text = @"အမ်ိဴးအစား :";
    
    _lblTitlePrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitlePrice.text = @"အခန္းခ :";
    
    _lblTitleFacility.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleFacility.text = @"၀န္ေဆာင္မႈ :";
    
    _btnEditroom.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnEditroom setTitle:@"အခန္းအခ်က္အလက္ ျပင္ပါ" forState:UIControlStateNormal];
    
    _btnClearRoom.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnClearRoom setTitle:@"ယူမည့္အခန္းမ်ားဖ်က္ပါ" forState:UIControlStateNormal];
    
    _btnAddRoom.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnAddRoom setTitle:@"ယူမည့္အခန္းစာရင္းထဲသိုု ့ထဲ့ပါ" forState:UIControlStateNormal];
    
    _btnBook.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnBook setTitle:@"ဘုုိကင္လုုပ္ပါ" forState:UIControlStateNormal];
    
    _btnCheckin.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnCheckin setTitle:@"Check-in လုုပ္ပါ" forState:UIControlStateNormal];
    
    _lblRoomno.text = _strRoomno;
    _lblRoomtype.text = _roomInfoDict[@"type"];
    _lblRoomPrice.text = [NSString stringWithFormat:@"%@ Ks",_roomInfoDict[@"price"]];
    _lblFacality.text = _strRoomFacility;
    
    _btnRoomType.layer.borderColor = [[UIColor grayColor] CGColor];
    _btnRoomType.layer.borderWidth = 1.5f;
    
    _calenderview.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-09-20"];
    
    _calenderview.onlyShowCurrentMonth = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDate:) name:@"didSelectDate" object:nil];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@" status MATCHES[cd] %@", @"0"];
    NSArray * match = [_occupydateWithStatus filteredArrayUsingPredicate:predicate];
    _bookingdate = [match valueForKey:@"book_date"];
    
    predicate = [NSPredicate predicateWithFormat:@" status MATCHES[cd] %@", @"1"];
    match = [_occupydateWithStatus filteredArrayUsingPredicate:predicate];
    _chkindate = [match valueForKey:@"book_date"];
    
    NSArray* roomarr = [[NSUserDefaults standardUserDefaults] objectForKey:@"roomlist"];
    for (NSDictionary* dict in roomarr) {
        if ([_roomInfoDict[@"room_id"] intValue] == [dict[@"roomid"] intValue]) {
            _dateInBookinglist = [dict[@"date"] copy];
        }
    }
    
    NSLog(@"_dateInBookingList : %@",_dateInBookinglist);
    
    _isDateModified = NO;
    
    if (_dateInBookinglist.count > 0) {
         _muDateArr = [[NSMutableArray alloc] initWithArray:_dateInBookinglist];
    }
    else _muDateArr = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissRoomInfoView) name:@"dismissRoomInfoView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectRoomType:) name:@"didSelectRoomType" object:nil];
    
    if (_isRoomAdding) {
        _btnCheckin.hidden = YES;
        _btnClearRoom.hidden = YES;
        _btnAddRoom.hidden = YES;
        _btnBook.hidden = YES;
        _btnAddRoomBook.hidden = NO;
    } else {
        _btnCheckin.hidden = NO;
        _btnClearRoom.hidden = NO;
        _btnAddRoom.hidden = NO;
        _btnBook.hidden = NO;
        _btnAddRoomBook.hidden = YES;
    }
    
    _viewUpper.hidden = YES;
    _viewUpper.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    [self.view setFrame:CGRectMake(-80,0,self.view.frame.size.width,self.view.frame.size.height)];
    //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (void)dismissRoomInfoView
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRoomLayout" object:nil];
    }];
}

- (void)didSelectDate:(NSNotification*)noti
{
    NSString* strDate = (NSString*)noti.object;
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectRoomType:(NSNotification*)noti
{
    NSDictionary* dict = (NSDictionary*)noti.object;
    [_btnRoomType setTitle:dict[@"type"] forState:UIControlStateNormal];
    _selectedroomtypeid = [dict[@"id"] intValue];
    [_myPopoverController dismissPopoverAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
//    editPopover.delegate = (id <UIPopoverControllerDelegate>)self;
    [[NSUserDefaults standardUserDefaults] setObject:@"roominfo" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)Close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BookRoom:(id)sender {
    
    if (_muDateArr.count > 0) {
        BOOL found = NO;
        NSMutableArray* roomarr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roomlist"] mutableCopy];
        
        if (!roomarr) {
            roomarr = [NSMutableArray new];
            [roomarr addObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
        }
        else {
            NSArray* roomIDs = [roomarr valueForKey:@"roomid"];
            
            for (int i =0; i < roomIDs.count; i++) {
                int eachid = [roomIDs[i] intValue];
                if (eachid == [_roomInfoDict[@"room_id"] intValue]) {
                    [roomarr replaceObjectAtIndex:i withObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
                    found = YES;
                    break;
                }
            }
            
            if (!found) {
                [roomarr addObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
            }
        }

        
        [[NSUserDefaults standardUserDefaults] setObject:roomarr forKey:@"roomlist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Selected ROOMs : %@",roomarr);
        
        MainBookVC* nexvc = (MainBookVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainBookVC"];
        nexvc.isBooking = YES; //THIS IS ONLY DIFF
        [self presentViewController:nexvc animated:YES completion:nil];
    }
    
    else [self JDStatusBarHidden:NO status:@"Please select date." duration:3.0f];
}


- (IBAction)AddToRoomArray:(id)sender {
    if (_muDateArr.count > 0) {
        BOOL found = NO;
        NSMutableArray* roomarr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roomlist"] mutableCopy];
        
        if (!roomarr) {
            roomarr = [NSMutableArray new];
            [roomarr addObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
        }
        else {

            NSArray* roomIDs = [roomarr valueForKey:@"roomid"];
            
            for (int i =0; i < roomIDs.count; i++) {
                int eachid = [roomIDs[i] intValue];
                if (eachid == [_roomInfoDict[@"room_id"] intValue]) {
                    [roomarr replaceObjectAtIndex:i withObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
                    
                    found = YES;
                    break;
                }
            }
            
            if (!found) {
                [roomarr addObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:roomarr forKey:@"roomlist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Selected ROOMs : %@",roomarr);
        
        [self JDStatusBarHidden:NO status:@"Successfully added." duration:3.0f];
    }
    else [self JDStatusBarHidden:NO status:@"Please select date." duration:3.0f];
    
}

- (IBAction)CheckinRoom:(id)sender {
    if (_muDateArr.count > 0) {
        BOOL found = NO;
        NSMutableArray* roomarr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roomlist"] mutableCopy];
        
        if (!roomarr) {
            roomarr = [NSMutableArray new];
            [roomarr addObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
        }
        else {
            NSArray* roomIDs = [roomarr valueForKey:@"roomid"];
            
            for (int i =0; i < roomIDs.count; i++) {
                int eachid = [roomIDs[i] intValue];
                if (eachid == [_roomInfoDict[@"room_id"] intValue]) {
                    [roomarr replaceObjectAtIndex:i withObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
                    found = YES;
                    break;
                }
            }
            
            if (!found) {
                [roomarr addObject:@{@"roomid": _roomInfoDict[@"room_id"], @"date": _muDateArr, @"price": _roomInfoDict[@"price"]}];
            }
        }
        
        
        [[NSUserDefaults standardUserDefaults] setObject:roomarr forKey:@"roomlist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Selected ROOMs : %@",roomarr);
        
        MainBookVC* nexvc = (MainBookVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainBookVC"];
        nexvc.isBooking = NO; //THIS IS ONLY DIFF
        [self presentViewController:nexvc animated:YES completion:nil];
    }
    
    else [self JDStatusBarHidden:NO status:@"Please select date." duration:3.0f];
}

- (IBAction)ClearRoomList:(id)sender {
    
    NSMutableArray* roomarr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roomlist"] mutableCopy];
    NSArray* temparr = [roomarr copy];
    for (NSDictionary* dict in temparr) {
        if ([dict[@"roomid"] isEqualToValue:_roomInfoDict[@"room_id"]]) {
            [_muDateArr removeAllObjects];
            [self.calenderview reloadDates:nil];
            break;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"roomlist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)BookAddRoom:(id)sender {
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    BOOL bookdetailSuccess = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking_detail (booking_id, room_id, arrival_date, departure_date, status) values ('%d', '%d', '%@', '%@', '%@')", _bookingid, [_roomInfoDict[@"room_id"] intValue], @"",@"", @"0"]];
    if (bookdetailSuccess) {
        NSDictionary* lastbookdetailid = [db executeQuery:@" SELECT MAX (id) AS LastID FROM tbl_booking_detail"].firstObject;
        NSArray* dateArr = _muDateArr;
        for (NSString* strDate in dateArr) {
            BOOL bookRoomWithdate = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking_room_dates (booking_detail_id, book_date, roomid, status) values ('%d', '%@', '%d', '%@')", [lastbookdetailid[@"LastID"] intValue], strDate, [_roomInfoDict[@"room_id"] intValue], @"0"]];
        }
        
        [self dismissRoomInfoView];
    }
    
}

- (IBAction)EditThisRoom:(id)sender {
    _viewUpper.hidden = NO;
    
    _txtRoomNo.text = _lblRoomno.text;
    _txtPrice.text = [NSString stringWithFormat:@"%@", _roomInfoDict[@"price"]];
    [_btnRoomType setTitle:_lblRoomtype.text forState:UIControlStateNormal];
    _selectedroomtypeid = [_roomInfoDict[@"room_type_id"] intValue];
}

- (IBAction)DismissUpperView:(id)sender {
    _viewUpper.hidden = YES;
}

- (IBAction)SaveRoomInfo:(id)sender {
    
    if (_txtRoomNo.text.length > 0 && _txtPrice.text.length > 0 && _selectedroomtypeid != 0) {
        ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
        BOOL updateroominfo = [db executeUpdate:[NSString stringWithFormat:@"update tbl_room set price='%@', room_type_id='%d' where id='%d'", _txtPrice.text, _selectedroomtypeid, [_roomInfoDict[@"room_id"] intValue]]];
        if (updateroominfo) {
            BOOL updateRoomno = [db executeUpdate:[NSString stringWithFormat:@"update tbl_room_plan set room_no='%@' where id='%d'", _txtRoomNo.text, _room_plan_id]];
            if (updateRoomno) {
                [self JDStatusBarHidden:NO status:@"Successfully saved!" duration:3.0f];
                NSDictionary* roomdict = [db executeQuery:[NSString stringWithFormat:@"select tbl_room.id as room_id, tbl_room.price, tbl_room_type.type, tbl_room.room_type_id as room_type_id from tbl_room join tbl_room_type on tbl_room.room_type_id = tbl_room_type.id where room_plan_id = '%d'",_room_plan_id]].firstObject;
                _roomInfoDict = roomdict;
                _lblRoomtype.text = roomdict[@"type"];
                _lblRoomPrice.text = [NSString stringWithFormat:@"%@ Ks",roomdict[@"price"]];
                
                NSString* query = [NSString stringWithFormat:@"SELECT tbl_facality.name, tbl_facality.description  FROM tbl_room_facility join tbl_facality on tbl_room_facility.facality_id = tbl_facality.id where tbl_room_facility.room_type_id='%d'",[roomdict[@"room_type_id"] intValue]];
                
                NSDictionary* roomfacility = [db executeQuery:query].firstObject;
                _lblFacality.text = roomfacility[@"name"];
                
                NSDictionary* roomnodict = [db executeQuery:[NSString stringWithFormat:@"select room_no from tbl_room_plan where id='%d'", _room_plan_id]].firstObject;
                _lblRoomno.text = roomnodict[@"room_no"];
                
                _viewUpper.hidden = YES;
                
            }
        }

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

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    
    // TODO: play with the coloring if we want to...
    for (NSString* eachdate in _chkindate) {
        if ([eachdate isEqualToString:strDate]) {
            dateItem.backgroundColor = [UIColor redColor];
            dateItem.textColor = [UIColor whiteColor];
            break;
        }
    }
    
    for (NSString* eachdate in _bookingdate) {
        if ([eachdate isEqualToString:strDate]) {
            dateItem.backgroundColor = [UIColor greenColor];
            dateItem.textColor = [UIColor whiteColor];
            break;
        }
    }
    if (!_isDateModified) {
        for (NSString* eachdate in _dateInBookinglist) {
            if ([eachdate isEqualToString:strDate]) {
                dateItem.backgroundColor = UIColorFromRGB(0x88B6DB);
                dateItem.textColor = UIColorFromRGB(0xF2F2F2);
                break;
            }
        }
    }
    
    
    BOOL isColoring = NO;
//    dateItem.backgroundColor = UIColorFromRGB(0xF2F2F2);
//    dateItem.textColor = UIColorFromRGB(0x393B40);
    for (NSString* eachdate in _muDateArr) {
        if ([eachdate isEqualToString:strDate]) {
            dateItem.backgroundColor = UIColorFromRGB(0x88B6DB);
            dateItem.textColor = UIColorFromRGB(0xF2F2F2);
            isColoring = YES;
            break;
        }
        
    }

    
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    // TODO: play with the coloring if we want to...
    for (NSString* eachdate in _chkindate) {
        if ([eachdate isEqualToString:strDate]) {
            return NO;
        }
    }
    
    for (NSString* eachdate in _bookingdate) {
        if ([eachdate isEqualToString:strDate]) {
            return NO;
        }
    }

    return YES;//![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    _isDateModified = YES;
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    BOOL isFound = NO;
    NSMutableArray* muArr = [_muDateArr mutableCopy];
    for (NSString* eachdate in muArr) {
        if ([eachdate isEqualToString:strDate]) {
            [_muDateArr removeObject:eachdate];
            isFound = YES;
            break;
        }
    }
    if (!isFound) {
        [_muDateArr addObject:strDate];
    }
    
    NSLog(@"Selected dates : %@",_muDateArr);
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        _calenderview.backgroundColor = [UIColor colorWithRed:19.0/255 green:62.0/255 blue:72.0/255 alpha:1];
        return YES;
    } else {
        _calenderview.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


@end
