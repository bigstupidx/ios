//
//  BookDateEditVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "BookDateEditVC.h"
#import "CKCalendarView.h"
#import "ZMFMDBSQLiteHelper.h"
#import "JDStatusBarNotification.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BookDateEditVC () <CKCalendarDelegate>

@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* minimumDate;
@property (weak, nonatomic) IBOutlet CKCalendarView *calenderview;
- (IBAction)Save:(id)sender;
- (IBAction)Cancel:(id)sender;

@end

@implementation BookDateEditVC

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
    
    _calenderview.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-09-20"];
    
    _calenderview.onlyShowCurrentMonth = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    for (NSString* eachdate in _bookdates) {
        if ([eachdate isEqualToString:strDate]) {
            dateItem.backgroundColor = UIColorFromRGB(0x88B6DB);
            dateItem.textColor = UIColorFromRGB(0xF2F2F2);
            
            break;
        }
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    // TODO: play with the coloring if we want to...
    return YES;//![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
//    _isDateModified = YES;
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    BOOL isFound = NO;
    NSMutableArray* muArr = [_bookdates mutableCopy];
    for (NSString* eachdate in muArr) {
        if ([eachdate isEqualToString:strDate]) {
            [_bookdates removeObject:eachdate];
            isFound = YES;
            break;
        }
    }
    if (!isFound) {
        [_bookdates addObject:strDate];
    }
    
    NSLog(@"Selected dates : %@",_bookdates);
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


- (IBAction)Save:(id)sender {
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    if (_bookdates.count == 0) {
        BOOL isDeleteSuccess = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking_room_dates where booking_detail_id='%d' and roomid='%d'",_roomdetailid, _roomid]];
        if (isDeleteSuccess) {
            BOOL deleteBookingDetail = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking_detail where id='%d' and roomid='%d'", _roomdetailid, _roomid]];
            if (deleteBookingDetail) {
                NSArray* bookdetailArr = [db executeQuery:[NSString stringWithFormat:@"select booking_id from tbl_booking_detail where booking_id='%d'",_bookid]];
                if (bookdetailArr.count == 0) {
                    BOOL isDeleteBookingidSuccess = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking where id='%d'", _bookid]];
                    
                }
            }
            [self JDStatusBarHidden:NO status:@"Successfully saved." duration:3.0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        BOOL isDeleteSuccess = [db executeUpdate:[NSString stringWithFormat:@"delete from tbl_booking_room_dates where booking_detail_id='%d' and roomid='%d'",_roomdetailid, _roomid]];
        if (isDeleteSuccess) {
            for (NSString* eachdate in _bookdates) {
                [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking_room_dates (booking_detail_id,book_date,roomid,status) values ('%d', '%@', '%d', '%@')",_roomdetailid, eachdate, _roomid, _paidStatus]];
            }
            [self JDStatusBarHidden:NO status:@"Successfully saved." duration:3.0f];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
