//
//  ReportWeeklyMonthlyVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/18/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ReportWeeklyMonthlyVC.h"
#import "MultiLineSegmentedControl.h"
#import "ReportColcell.h"
#import "ZMFMDBSQLiteHelper.h"

@interface ReportWeeklyMonthlyVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) MultiLineSegmentedControl* multiSegCon;
@property (assign, nonatomic) int selectedBld;
@property (strong, nonatomic) MultiLineSegmentedControl* segControl;
@property (assign, nonatomic) int selectedFloor;
@property (strong, nonatomic) MultiLineSegmentedControl* weekmonthsegcontrol;
@property (assign, nonatomic) int selectedtype;
@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (assign, nonatomic) int selectedmonth;
@property (assign, nonatomic) int currentweek;
@property (assign, nonatomic) int firstweek;
@property (assign, nonatomic) int lastweek;
@property (strong, nonatomic) NSArray* weekstartenddate;
@property (strong, nonatomic) NSArray* datafiller;
@property (strong, nonatomic) NSArray* thisweekDATE;
@property (assign, nonatomic) int currentyear;
@property (assign, nonatomic) int numofdaysinmonth;
@property (strong, nonatomic) NSDate* firstday;
@property (strong, nonatomic) NSDate* lastday;
@property (assign, nonatomic) BOOL isReportWeekly;
@property (strong, nonatomic) NSMutableArray* imageArray;
@property (strong, nonatomic) NSString* documentDirectoryFilename;

@property (weak, nonatomic) IBOutlet UIView *viewBgBld;
@property (weak, nonatomic) IBOutlet UIView *viewBgFloor;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *viewbgWeekMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblFromToDate;
@property (weak, nonatomic) IBOutlet UICollectionView *collview;
@property (weak, nonatomic) IBOutlet UIButton *btnDismiss;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collviewheight;
@property (weak, nonatomic) IBOutlet UILabel *lbldate1;
@property (weak, nonatomic) IBOutlet UILabel *lbldate2;
@property (weak, nonatomic) IBOutlet UILabel *lbldate3;
@property (weak, nonatomic) IBOutlet UILabel *lbldate4;
@property (weak, nonatomic) IBOutlet UILabel *lbldate5;
@property (weak, nonatomic) IBOutlet UILabel *lbldate6;
@property (weak, nonatomic) IBOutlet UILabel *lbldate7;
@property (weak, nonatomic) IBOutlet UIView *monthTitleBar;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIView *viewweek;
@property (weak, nonatomic) IBOutlet UIScrollView *upperScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnNex;
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthTitle;
@property (weak, nonatomic) IBOutlet UIView *viewMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;

- (IBAction)DismissThisView:(id)sender;
- (IBAction)GoToPreviousWeek:(id)sender;
- (IBAction)GoToNextWeek:(id)sender;
- (IBAction)PrintReport:(id)sender;

@end

@implementation ReportWeeklyMonthlyVC

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
    _lblViewTitle.text = @"ေန ့အလိုုက္အေရာင္း စာရင္း";
    
    _btnDismiss.layer.cornerRadius = 10;
    _btnDismiss.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnDismiss.layer.borderWidth = 1.5f;
    
    _btnMonth.layer.cornerRadius = 5.0f;
    _btnMonth.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btnMonth.layer.borderWidth = 1.0f;
    
    _btnPrint.layer.cornerRadius = 5.0f;
    _btnPrint.layer.borderColor = [[UIColor blueColor] CGColor];
    _btnPrint.layer.borderWidth = 1.0f;
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter* daystrFormatter = [[NSDateFormatter alloc] init];
    [daystrFormatter setDateFormat:@"EEEE"];
    
    NSDateFormatter* monthformatter = [[NSDateFormatter alloc] init];
    [daystrFormatter setDateFormat:@"MMMM"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year = [components year];
    _currentyear = year;
    int month = [components month];
    int day = [components day];
    int week = [components weekOfYear];
    _currentweek = week;
    NSLog(@"year : %d month : %d day : %d week : %d", year, month, day, week);
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    // Set your month here
    [comps setMonth:month];
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    _numofdaysinmonth = range.length;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    _firstday = [df dateFromString:[NSString stringWithFormat:@"%d-%d-01",year,month]];
    _lastday = [df dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,_numofdaysinmonth]];
    
    NSArray* weeksofmonth = [self weeksOfMonth:month inYear:year];
    NSLog(@"weeks of this month : %@", weeksofmonth);
    NSMutableArray* muarr = [[NSMutableArray alloc] initWithCapacity:weeksofmonth.count];
    for (NSNumber* num in weeksofmonth) {
        int weeknum = [num intValue];
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comp = [gregorian components:NSYearCalendarUnit fromDate:now];
        [comp setWeekday:1];
        [comp setWeek: weeknum];
        NSDate *resultDate = [gregorian dateFromComponents:comp];
        NSLog(@"result day of week : %@", [theDateFormatter stringFromDate:resultDate]);
        NSDate* startOfTheWeek;
        NSTimeInterval interval;
        [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&startOfTheWeek interval:&interval forDate:resultDate];
        NSDate* enddateOfweek = [startOfTheWeek dateByAddingTimeInterval:interval - 1];
        NSLog(@"end day of week : %@", [theDateFormatter stringFromDate:enddateOfweek]);
        
        [muarr addObject:@{@"week": @(weeknum), @"start": [theDateFormatter stringFromDate:resultDate], @"end": [theDateFormatter stringFromDate:enddateOfweek]}];
        
    }
    
    _weekstartenddate = [muarr copy];
    
    _firstweek = [_weekstartenddate[0][@"week"] intValue];
    NSDictionary* lastdict = _weekstartenddate.lastObject;
    _lastweek = [lastdict[@"week"] intValue];
    
    NSDateFormatter *monthformat = [[NSDateFormatter alloc] init];
    NSString *monthname = [[monthformat monthSymbols] objectAtIndex:(month-1)];
    
    [_btnMonth setTitle:monthname forState:UIControlStateNormal];
    _lblMonthTitle.text = monthname;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"week = %d", week];
    NSArray * match = [_weekstartenddate filteredArrayUsingPredicate:predicate];
    
    NSString* startday = match[0][@"start"];
    NSString* endday = match[0][@"end"];
    
    _lblFromToDate.text = [NSString stringWithFormat:@"%@ From: %@ To: %@", monthname, startday, endday];
    _lblFromToDate.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimg.jpg"]];
    
    _scrollview.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    
    NSArray* muArr = @[@"၂ထပ္တုုိက္ အမွတ္(၁)", @"၂ထပ္တိုုက္ အမွတ္(၂)", @"လံုုးခ်င္း"];
    
    _multiSegCon = [[MultiLineSegmentedControl alloc] initWithItems:muArr];
    
    [_multiSegCon setTintColor:[UIColor whiteColor]];
    [_multiSegCon setBackgroundColor:[UIColor blackColor]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Zawgyi-One" size:17], NSFontAttributeName, nil];
    [_multiSegCon setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _multiSegCon.frame = CGRectMake(0, 0, _viewBgBld.frame.size.width, _multiSegCon.frame.size.height * 2.5);
    
    [_multiSegCon addTarget:self action:@selector(pickBuilding) forControlEvents:UIControlEventValueChanged];
    
    [_viewBgBld addSubview:_multiSegCon];
    _multiSegCon.center = [_viewBgBld convertPoint:_viewBgBld.center fromView:_viewBgBld.superview];
    
    _multiSegCon.selectedSegmentIndex = 0; //To see Full lbl in segCont
    _selectedBld = 1;
    
    _weekmonthsegcontrol = [[MultiLineSegmentedControl alloc] initWithItems:@[@"အပတ္စဥ္ Report", @"လစဥ္ Report"]];
    
    [_weekmonthsegcontrol setTintColor:[UIColor whiteColor]];
    [_weekmonthsegcontrol setBackgroundColor:[UIColor blackColor]];
    [_weekmonthsegcontrol setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _weekmonthsegcontrol.frame = CGRectMake(0, 0, _viewbgWeekMonth.frame.size.width, _weekmonthsegcontrol.frame.size.height * 2.5);
    
    [_weekmonthsegcontrol addTarget:self action:@selector(reporttypeChanged) forControlEvents:UIControlEventValueChanged];
    
    [_viewbgWeekMonth addSubview:_weekmonthsegcontrol];
    _weekmonthsegcontrol.center = [_viewbgWeekMonth convertPoint:_viewbgWeekMonth.center fromView:_viewbgWeekMonth.superview];
    
    _weekmonthsegcontrol.selectedSegmentIndex = 0;
    _selectedtype = 1;
    
    _segControl = [[MultiLineSegmentedControl alloc] initWithItems:@[@"အေပၚထပ္", @"ေအာက္ထပ္"]];
    
    [_segControl setTintColor:[UIColor whiteColor]];
    [_segControl setBackgroundColor:[UIColor blackColor]];
    [_segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _segControl.frame = CGRectMake(0, 0, _viewBgFloor.frame.size.width, _segControl.frame.size.height * 2.5);
    
    [_segControl addTarget:self action:@selector(floorChanged) forControlEvents:UIControlEventValueChanged];
    
    [_viewBgFloor addSubview:_segControl];
    _segControl.center = [_viewBgFloor convertPoint:_viewBgFloor.center fromView:_viewBgFloor.superview];
    
    _segControl.selectedSegmentIndex = 0;
    _selectedFloor = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didselectmonth:) name:@"didselectmonth" object:nil];
    
    _isReportWeekly = YES;
    _monthTitleBar.hidden = YES;
    [self SearchRoomAvailability:1 withfloorid:1];
    
    _imageArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resizeCollectionView
{
    float colviewheight;
    if (_isReportWeekly) {
        colviewheight = 74 * _datafiller.count;
        _collviewheight.constant = colviewheight + 10;

    }
    else {
        colviewheight = 55 * _datafiller.count;
        _collviewheight.constant = colviewheight + 10;
    }
    
    _upperScrollView.contentSize = CGSizeMake(_upperScrollView.frame.size.width, _upperScrollView.frame.size.height+colviewheight+10);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
}

- (NSArray *)weeksOfMonth:(int)month inYear:(int)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:month];
    [components setYear:year];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit:NSMonthCalendarUnit
                                  forDate:[calendar dateFromComponents:components]];
    
    calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableSet *weeks = [[NSMutableSet alloc] init ];
    
    for(int i = 0; i < range.length; i++)
    {
        NSString *temp = [NSString stringWithFormat:@"%4d-%2d-%2u",year,month,range.location+i];
        NSDate *date = [dateFormatter dateFromString:temp ];
        int week = [[calendar components: NSWeekOfYearCalendarUnit fromDate:date] weekOfYear];
        [weeks addObject:[NSNumber numberWithInt:week]];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
    return [weeks sortedArrayUsingDescriptors:descriptors];
}

- (void)changeMONTH
{
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSArray* weeksofmonth = [self weeksOfMonth:_selectedmonth inYear:_currentyear];
    NSLog(@"weeks of this month : %@", weeksofmonth);
    NSMutableArray* muarr = [[NSMutableArray alloc] initWithCapacity:weeksofmonth.count];
    for (NSNumber* num in weeksofmonth) {
        int weeknum = [num intValue];
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comp = [gregorian components:NSYearCalendarUnit fromDate:now];
        [comp setWeekday:1];
        [comp setWeek: weeknum];
        NSDate *resultDate = [gregorian dateFromComponents:comp];
        NSLog(@"result day of week : %@", [theDateFormatter stringFromDate:resultDate]);
        NSDate* startOfTheWeek;
        NSTimeInterval interval;
        [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&startOfTheWeek interval:&interval forDate:resultDate];
        NSDate* enddateOfweek = [startOfTheWeek dateByAddingTimeInterval:interval - 1];
        NSLog(@"end day of week : %@", [theDateFormatter stringFromDate:enddateOfweek]);
        
        [muarr addObject:@{@"week": @(weeknum), @"start": [theDateFormatter stringFromDate:resultDate], @"end": [theDateFormatter stringFromDate:enddateOfweek]}];
        
    }
    
    _weekstartenddate = [muarr copy];
    
    _currentweek = [_weekstartenddate[0][@"week"] intValue];
    _firstweek = [_weekstartenddate[0][@"week"] intValue];
    NSDictionary* lastdict = _weekstartenddate.lastObject;
    _lastweek = [lastdict[@"week"] intValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthname = [[df monthSymbols] objectAtIndex:(_selectedmonth-1)];
    
    //    NSString* monthname = [monthformatter stringFromDate:[NSDate date]];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"week = %d", _currentweek];
    NSArray * match = [_weekstartenddate filteredArrayUsingPredicate:predicate];
    
    NSString* startday = match[0][@"start"];
    NSString* endday = match[0][@"end"];
    
    _lblFromToDate.text = [NSString stringWithFormat:@"%@ From: %@ To: %@", monthname, startday, endday];
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"yyyy-MM-dd"];
    _firstday = [dformat dateFromString:[NSString stringWithFormat:@"%d-%d-01",_currentyear,_selectedmonth]];
    _lastday = [dformat dateFromString:[NSString stringWithFormat:@"%d-%d-%d",_currentyear,_selectedmonth,_numofdaysinmonth]];
    
    [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
}

- (void)changeMonthForMonthlyReport:(int)month
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    // Set your month here
    [comps setMonth:month];
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    _numofdaysinmonth = range.length;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    _firstday = [df dateFromString:[NSString stringWithFormat:@"%d-%d-01",_currentyear,month]];
    _lastday = [df dateFromString:[NSString stringWithFormat:@"%d-%d-%d",_currentyear,month,_numofdaysinmonth]];
    
    [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
}


- (void)pickBuilding
{
    _selectedBld = _multiSegCon.selectedSegmentIndex+1;
    if (_selectedBld == 3) {
        _viewBgFloor.hidden = YES;
    } else _viewBgFloor.hidden = NO;
//    [self searchTotalByCheckindate];
    [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
}

- (void)floorChanged
{
    _selectedFloor = _segControl.selectedSegmentIndex+1;
//    [self searchTotalByCheckindate];
    [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
}

- (void)reporttypeChanged
{
    if (_weekmonthsegcontrol.selectedSegmentIndex == 0) {
        _isReportWeekly = YES;
        
        _btnPrevious.hidden = NO;
        _btnNex.hidden = NO;
        _viewweek.hidden = NO;
    }
    else {
        _isReportWeekly = NO;
        
        _btnPrevious.hidden = YES;
        _btnNex.hidden = YES;
        _viewweek.hidden = YES;
    }
    [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
}

- (void)didselectmonth:(NSNotification*)noti
{
    NSDictionary* dict = (NSDictionary*)noti.object;
    
    [_btnMonth setTitle:dict[@"month"] forState:UIControlStateNormal];
    _selectedmonth = [dict[@"id"] intValue];
    [_myPopoverController dismissPopoverAnimated:YES];
    _lblMonthTitle.text = dict[@"month"];
    
    if (_isReportWeekly) [self changeMONTH];
    else [self changeMonthForMonthlyReport:_selectedmonth];
    
    
}

- (void)SearchRoomAvailability:(int)build_id withfloorid:(int)floor_id
{
    NSString* strFromDate;
    NSString* strToDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    if (_isReportWeekly) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"week = %d", _currentweek];
        NSArray * match = [_weekstartenddate filteredArrayUsingPredicate:predicate];
        
        NSString* startday = match[0][@"start"];
        NSString* endday = match[0][@"end"];
        
        
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate* fromdate = [dateFormatter dateFromString:startday];
        NSDate* todate = [dateFormatter dateFromString:endday];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        strFromDate = [dateFormatter stringFromDate:fromdate];
        strToDate = [dateFormatter stringFromDate:todate];
        
        NSDate* date2 = [fromdate dateByAddingTimeInterval:60*60*24*1];
        NSDate* date3 = [fromdate dateByAddingTimeInterval:60*60*24*2];
        NSDate* date4 = [fromdate dateByAddingTimeInterval:60*60*24*3];
        NSDate* date5 = [fromdate dateByAddingTimeInterval:60*60*24*4];
        NSDate* date6 = [fromdate dateByAddingTimeInterval:60*60*24*5];
        NSDate* date7 = [fromdate dateByAddingTimeInterval:60*60*24*6];
        
        _thisweekDATE = @[fromdate, date2, date3, date4, date5, date6, date7];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        strFromDate = [dateFormatter stringFromDate:_firstday];
        strToDate = [dateFormatter stringFromDate:_lastday];
    }
    
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    NSArray* roomIDArr = [db executeQuery:[NSString stringWithFormat:@"SELECT room_no,tbl_room_plan.id as plan_id, tbl_room.id as room_id, tbl_room_plan.room_no from tbl_room_plan join tbl_room_layout on tbl_room_plan.layout_id = tbl_room_layout.id join tbl_room on tbl_room.room_plan_id=tbl_room_plan.id where building_id = '%d' and floor_id = '%d'",build_id,floor_id]];

    NSMutableArray* tempdata = [NSMutableArray new];
    if (!_isReportWeekly) {
        [tempdata addObject:@{@"room": @"", @"status": @[@"1",@"2",@"3", @"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16", @"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31"]}];
    }
    for (int i = 0; i<roomIDArr.count;i++) {
        NSString* room_no = roomIDArr[i][@"room_no"];
        int roomid = [roomIDArr[i][@"room_id"] intValue];
        NSArray* bookingdateArr = [db executeQuery:[NSString stringWithFormat:@"SELECT * from tbl_booking_room_dates where roomid='%d' and status!='2' and book_date BETWEEN '%@' and '%@'",roomid, strFromDate, strToDate]];
        NSMutableArray* muArr = [NSMutableArray new];
        
        if (_isReportWeekly) {
            for (NSDate* eachdate in _thisweekDATE) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString* dateSTR = [dateFormatter stringFromDate:eachdate];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"book_date MATCHES[cd] %@", dateSTR];
                NSArray * match = [bookingdateArr filteredArrayUsingPredicate:predicate];
                if (match.count == 0) {
                    [muArr addObject:@"0"];
                }
                else {
                    if ([match[0][@"status"] isEqualToString:@"0"]) {
                        [muArr addObject:@"1"];
                    }
                    else [muArr addObject:@"2"];
                }
            }

        } else {
            
            NSDate* dayofmonth = _firstday;
            while (([dayofmonth compare:_lastday] == NSOrderedAscending) || ([dayofmonth compare:_lastday] == NSOrderedSame)) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString* dateSTR = [dateFormatter stringFromDate:dayofmonth];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"book_date MATCHES[cd] %@", dateSTR];
                NSArray * match = [bookingdateArr filteredArrayUsingPredicate:predicate];
                if (match.count == 0) {
                    [muArr addObject:@"0"];
                }
                else {
                    if ([match[0][@"status"] isEqualToString:@"0"]) {
                        [muArr addObject:@"1"];
                    }
                    else [muArr addObject:@"2"];
                }
                
                //
                dayofmonth = [dayofmonth dateByAddingTimeInterval:60*60*24*1];
            }

            
        }
                //
        NSArray* temparr = [muArr copy];
        [tempdata addObject:@{@"room": room_no, @"status": temparr}];
    }
    _datafiller = [tempdata copy];
    [_collview reloadData];
    [self resizeCollectionView];
    [self setDATE];
}

- (void)setDATE
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM"];
    
    NSDate* tempdate = _thisweekDATE[0];
    _lbldate1.text = [dateFormatter stringFromDate:tempdate];
    
    tempdate = _thisweekDATE[1];
    _lbldate2.text = [dateFormatter stringFromDate:tempdate];
    
    tempdate = _thisweekDATE[2];
    _lbldate3.text = [dateFormatter stringFromDate:tempdate];
    
    tempdate = _thisweekDATE[3];
    _lbldate4.text = [dateFormatter stringFromDate:tempdate];
    
    tempdate = _thisweekDATE[4];
    _lbldate5.text = [dateFormatter stringFromDate:tempdate];
    
    tempdate = _thisweekDATE[5];
    _lbldate6.text = [dateFormatter stringFromDate:tempdate];
    
    tempdate = _thisweekDATE[6];
    _lbldate7.text = [dateFormatter stringFromDate:tempdate];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _datafiller.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isReportWeekly) return 8;
    else return _numofdaysinmonth+1;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"statuscell";
    ReportColcell* cell = (ReportColcell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    //data fill // start point
    NSDictionary* dict = _datafiller[indexPath.section];

        if (indexPath.row == 0) {
            cell.celllbl.hidden = NO;
            cell.celllbl.text = dict[@"room"];
            cell.backgroundColor = [UIColor clearColor];
            cell.layer.borderColor = [[UIColor clearColor] CGColor];
            cell.layer.borderWidth = 1;
            
        }else if (indexPath.section == 0) {
            if (!_isReportWeekly) {
                cell.celllbl.hidden = NO;
                NSArray* statusArr = dict[@"status"];
                cell.celllbl.text = statusArr[indexPath.row - 1];
                cell.backgroundColor = [UIColor clearColor];
                cell.layer.borderColor = [[UIColor clearColor] CGColor];
                cell.layer.borderWidth = 1;
            }
            else {
                NSArray* statusArr = dict[@"status"];
                NSString* strstatus = statusArr[indexPath.row - 1];
                if ([strstatus isEqualToString:@"0"]) {
                    cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1.0f];
                    
                } else if ([strstatus isEqualToString:@"1"]) {
                    cell.backgroundColor = [UIColor greenColor];
                }
                else cell.backgroundColor = [UIColor redColor];
                cell.celllbl.hidden = YES;
                cell.layer.borderColor = [[UIColor blackColor] CGColor];
                cell.layer.borderWidth = 1;
            }

        } else {
            NSArray* statusArr = dict[@"status"];
            NSString* strstatus = statusArr[indexPath.row - 1];
            if ([strstatus isEqualToString:@"0"]) {
                cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1.0f];
                
            } else if ([strstatus isEqualToString:@"1"]) {
                cell.backgroundColor = [UIColor greenColor];
            }
            else cell.backgroundColor = [UIColor redColor];
            cell.celllbl.hidden = YES;
            cell.layer.borderColor = [[UIColor blackColor] CGColor];
            cell.layer.borderWidth = 1;
        }

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isReportWeekly) {
        CGFloat cellWidth = _collview.frame.size.width/_numofdaysinmonth+1;
        //    CGFloat cellHeight = _collviewSeatPlan.frame.size.height/_numRow;
        return CGSizeMake(cellWidth-3, 55);
    }
    else return CGSizeMake(74, 73);
}

- (IBAction)DismissThisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)GoToPreviousWeek:(id)sender {
    
    int weeknum = _currentweek;
    weeknum--;
    if (weeknum >= _firstweek) {
        _currentweek = weeknum;
        [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
    }
}

- (IBAction)GoToNextWeek:(id)sender {
    
    int weeknum = _currentweek;
    weeknum++;
    if (weeknum <= _lastweek) {
        _currentweek = weeknum;
        [self SearchRoomAvailability:_selectedBld withfloorid:_selectedFloor];
    }
}

- (IBAction)PrintReport:(id)sender {
    
    [self convertViewToImage];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

#pragma mark - PRINT METHODS

- (UIImage *)captureView:(UIView *)view withRect:(CGRect)cellRect
{
    UIGraphicsBeginImageContextWithOptions(cellRect.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)createPDF
{
    // A4
    int totalcount = _imageArray.count;
    float multiplier = totalcount/24.0f;
    if (!(fmodf(multiplier, 1.0) == 0.0)) {
        multiplier +=1;
    }
    int mulInt = (int)multiplier;
    // A4
    CGRect pdfPageBounds = CGRectMake(0, 0, 595, 700);//612,792 // 842
    int counter = 0;
    BOOL pageStart = YES;
    CGFloat ticketStartPoint = 0.0;
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
//        for (int outLoop = 0; outLoop < mulInt; outLoop++) {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            pageStart = YES;
            for (int i = 0; i < totalcount; i++) { //SMT: 2 TICKETS PER PAGE
                
                UIImage *gymLogo = self.imageArray[i];//[UIImage imageNamed:@"concrete_wall.png"];
                CGPoint drawingLogoOrgin;
                if (pageStart) {
                    drawingLogoOrgin = CGPointMake(5,5);
                    pageStart = NO;
                    ticketStartPoint = 5;
                }
                else
                {
                    UIImage* prevImg = self.imageArray[i-1];
                    ticketStartPoint += prevImg.size.height;
                    drawingLogoOrgin = CGPointMake(5, ticketStartPoint);
                }
                
                [gymLogo drawAtPoint:drawingLogoOrgin];
                if (counter < self.imageArray.count-1) {
                    counter++;
                    
                }
                else break;
                
            }
            
//        }
        
    } UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"WeeklyMonthlyReport.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
}



- (void)convertViewToImage
{
    [_imageArray removeAllObjects];
    
    if (_isReportWeekly) {
        UIImage *imgviewweek = [self captureView:_viewweek withRect:CGRectMake(0, 0, _viewweek.frame.size.width, _viewweek.frame.size.height)];
        
        UIImage* resizedViewWeek = [UIImage imageWithCGImage:[imgviewweek CGImage] scale:(imgviewweek.scale * 2.0) orientation:(imgviewweek.imageOrientation)];
        [_imageArray addObject:resizedViewWeek];

    }
    else {
        UIImage *imgviewweek = [self captureView:_viewMonth withRect:CGRectMake(0, 0, _viewMonth.frame.size.width, _viewMonth.frame.size.height)];
        
        UIImage* resizedViewWeek = [UIImage imageWithCGImage:[imgviewweek CGImage] scale:(imgviewweek.scale * 2.0) orientation:(imgviewweek.imageOrientation)];
        [_imageArray addObject:resizedViewWeek];
    }
    
    
    UIImage* imgcolview = [self captureView:_collview withRect:CGRectMake(0, 0, _collview.frame.size.width, _collview.frame.size.height)];
    UIImage* resizedcolview = [UIImage imageWithCGImage:[imgcolview CGImage] scale:(imgcolview.scale * 2.0) orientation:(imgcolview.imageOrientation)];
    [_imageArray addObject:resizedcolview];
    
    [self createPDF];
}

@end
