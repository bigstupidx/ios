//
//  MainBookVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "MainBookVC.h"
#import "ZMFMDBSQLiteHelper.h"

@interface MainBookVC ()

@property (weak, nonatomic) IBOutlet UITextField *txtname;
@property (weak, nonatomic) IBOutlet UITextField *txtnrc;
@property (weak, nonatomic) IBOutlet UITextField *txtdob;
@property (weak, nonatomic) IBOutlet UITextField *txtph;
@property (weak, nonatomic) IBOutlet UITextField *txtcarno;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnBookChkIn;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNrc;
@property (weak, nonatomic) IBOutlet UILabel *lblDob;
@property (weak, nonatomic) IBOutlet UILabel *lblPh;
@property (weak, nonatomic) IBOutlet UILabel *lblCarno;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

- (IBAction)BookOrCheckin:(id)sender;
- (IBAction)Cancel:(id)sender;

@end

@implementation MainBookVC

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
    
    _txtAddress.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _txtAddress.layer.borderWidth = 1.5f;
    
    _lblName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblName.text = @"နာမည္ :";
    
    _lblNrc.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblNrc.text = @"NRC :";
    
    _lblDob.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDob.text = @"ေမြးရက္ :";
    
    _lblPh.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblPh.text = @"ဖုုန္း :";
    
    _lblCarno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblCarno.text = @"ကားနံပါတ္ :";
    
    _lblAddress.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblAddress.text = @"လိပ္စာ :";
    
    _btnBookChkIn.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnBookChkIn setTitle:@"Check-in/ဘိုုကင္လုုပ္ပါ" forState:UIControlStateNormal];
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

- (IBAction)BookOrCheckin:(id)sender {
    
    int totalamt = 0;
    NSArray* roomarr = [[NSUserDefaults standardUserDefaults] objectForKey:@"roomlist"];
    for (NSDictionary* dict in roomarr) {
        totalamt += [dict[@"price"] intValue];
    }
    
    NSString* bookOrChkin;
    if (_isBooking) bookOrChkin = @"0";
    else bookOrChkin = @"1";
    
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
        BOOL success = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_customer (name, address, phone, nrc_no, dob, car_no) values ('%@', '%@', '%@', '%@', '%@', '%@')", _txtname.text, _txtAddress.text, _txtph.text, _txtnrc.text, _txtdob.text, _txtcarno.text]];
        if (success) {
            NSDictionary* lastcusid = [db executeQuery:@" SELECT MAX (id) AS LastID FROM tbl_customer"].firstObject;
            
            NSString* strtdy = [dateFormatter stringFromDate:[NSDate date]];
            
            BOOL bookSuccess = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking (booking_date, customer_id, total_amount, status) values ('%@', '%@', '%d', '%@')", strtdy, lastcusid[@"LastID"], totalamt, bookOrChkin]];
            if (bookSuccess) {
                NSDictionary* lastbookid = [db executeQuery:@" SELECT MAX (id) AS LastID FROM tbl_booking"].firstObject;
                
                for (NSDictionary* dict in roomarr) {
                    BOOL bookdetailSuccess;
                    if (_isBooking) {
                        bookdetailSuccess = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking_detail (booking_id, room_id, arrival_date, departure_date, status) values ('%d', '%d', '%@', '%@', '%@')", [lastbookid[@"LastID"] intValue], [dict[@"roomid"] intValue], @"",@"", bookOrChkin]];
                    } else {
                        //CHECK IN
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd"];
                        NSString* checkindate = [dateFormat stringFromDate:[NSDate date]];
                        
                        [dateFormat setDateFormat:@"yyyyMMdd:hh:mm"];
                        NSString* strChkinNUM = [dateFormat stringFromDate:[NSDate date]];
                        
                        unsigned long totalamt = [dict[@"price"] intValue] * ((NSArray*)dict[@"date"]).count;
                        
                        bookdetailSuccess = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking_detail (booking_id, room_id, arrival_date, departure_date, status, check_in_no, total_amt) values ('%d', '%d', '%@', '%@', '%@', '%@', '%lu')", [lastbookid[@"LastID"] intValue], [dict[@"roomid"] intValue], checkindate,@"", bookOrChkin, strChkinNUM, totalamt]];
                    }
                    
                    if (bookdetailSuccess) {
                        NSDictionary* lastbookdetailid = [db executeQuery:@" SELECT MAX (id) AS LastID FROM tbl_booking_detail"].firstObject;
                        NSArray* dateArr = dict[@"date"];
                        for (NSString* strDate in dateArr) {
                            BOOL bookRoomWithdate = [db executeUpdate:[NSString stringWithFormat:@"insert into tbl_booking_room_dates (booking_detail_id, book_date, roomid, status) values ('%d', '%@', '%d', '%@')", [lastbookdetailid[@"LastID"] intValue], strDate, [dict[@"roomid"] intValue], bookOrChkin]];
                        }
                        
                    }
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"roomlist"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                if (bookdetailSuccess) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissRoomInfoView" object:nil];
                    }];
//                }
            }
            
        }
//    }

}

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
