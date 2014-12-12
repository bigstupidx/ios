//
//  ViewController.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ViewController.h"
#import "ZMFMDBSQLiteHelper.h"
#import "RoomCell.h"
#import "MultiLineSegmentedControl.h"
#import "RoomInfoVC.h"
#import "TransitionDelegate.h"
#import "BookingListVC.h"

@interface ViewController ()

@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (assign, nonatomic) int numCol;
@property (assign, nonatomic) int numRow;
@property (strong, nonatomic) NSArray* roomLayout;
@property (strong, nonatomic) NSMutableArray* roommainlayout;
@property (assign, nonatomic) int selectedBuildingid;
@property (assign, nonatomic) int selectedFloorid;
@property (strong, nonatomic) MultiLineSegmentedControl* multiSegCon;
@property (strong, nonatomic) TransitionDelegate* transitionController;
@property (assign, nonatomic) BOOL isChoosingFromDate;
@property (strong, nonatomic) NSMutableArray* muStatusArr;

@property (weak, nonatomic) IBOutlet UIView *bgViewSegControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collView;
@property (weak, nonatomic) IBOutlet UIButton *btnBuilding;
@property (weak, nonatomic) IBOutlet UIView *bgViewFloorSeg;
@property (strong, nonatomic) MultiLineSegmentedControl* segControl;
@property (weak, nonatomic) IBOutlet UIView *viewLoneChin;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckinlist;
@property (weak, nonatomic) IBOutlet UIButton *btnBookingList;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

- (IBAction)onBtnFromDateClicked:(id)sender;
- (IBAction)onBtnToDateClicked:(id)sender;
- (IBAction)SearchRoomByDate:(id)sender;
- (IBAction)DismissThisView:(id)sender;

@end

@implementation ViewController
@synthesize transitionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupMMFont];
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
//    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE dd-MM-yyyy"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimg.jpg"]];
    
    _scrollview.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    
//    _bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    
    self.transitionController = [[TransitionDelegate alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBuilding:) name:@"didSelectBuilding" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDatefromHome:) name:@"didSelectDatefromHome" object:nil];
    
    _collView.hidden = YES;
    _segControl.hidden = YES;
    _viewLoneChin.hidden = YES;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strtdydate = [dateFormatter stringFromDate:[NSDate date]];
    [_btnFromDate setTitle:strtdydate forState:UIControlStateNormal];
    [_btnToDate setTitle:strtdydate forState:UIControlStateNormal];
    
    NSArray* muArr = @[@"၂ထပ္တုုိက္ အမွတ္(၁)", @"၂ထပ္တိုုက္ အမွတ္(၂)", @"လံုုးခ်င္း"];
    
    _multiSegCon = [[MultiLineSegmentedControl alloc] initWithItems:muArr];
    
    [_multiSegCon setTintColor:[UIColor whiteColor]];
     [_multiSegCon setBackgroundColor:[UIColor blackColor]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Zawgyi-One" size:17], NSFontAttributeName, nil];
    [_multiSegCon setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _multiSegCon.frame = CGRectMake(0, 0, _bgViewSegControl.frame.size.width, _multiSegCon.frame.size.height * 2.5);
    
    [_multiSegCon addTarget:self action:@selector(pickBuilding) forControlEvents:UIControlEventValueChanged];
    
    [_bgViewSegControl addSubview:_multiSegCon];
    _multiSegCon.center = [_bgViewSegControl convertPoint:_bgViewSegControl.center fromView:_bgViewSegControl.superview];
    
    _multiSegCon.selectedSegmentIndex = 0; //To see Full lbl in segContl
    _selectedBuildingid = 1;
    _selectedFloorid = 1;
    
    [self pickBuilding];
    [self SearchRoomAvailability:1 withfloorid:1];
    
    _segControl = [[MultiLineSegmentedControl alloc] initWithItems:@[@"အေပၚထပ္", @"ေအာက္ထပ္"]];
    
    [_segControl setTintColor:[UIColor whiteColor]];
    [_segControl setBackgroundColor:[UIColor blackColor]];
    [_segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    _segControl.frame = CGRectMake(0, 0, _bgViewFloorSeg.frame.size.width, _segControl.frame.size.height * 2.5);
    
    [_segControl addTarget:self action:@selector(segmentcontrolIndexChanged) forControlEvents:UIControlEventValueChanged];
    
    [_bgViewFloorSeg addSubview:_segControl];
    _segControl.center = [_bgViewFloorSeg convertPoint:_bgViewFloorSeg.center fromView:_bgViewFloorSeg.superview];
    
    _segControl.selectedSegmentIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoomLayout) name:@"reloadRoomLayout" object:nil];
    
    if (_isRoomAdding) {
        _btnBookingList.hidden = YES;
        _btnCheckinlist.hidden = YES;
        _btnReport.hidden = YES;
        _btnCancel.hidden = NO;
        
    } else {
        _btnBookingList.hidden = NO;
        _btnCheckinlist.hidden = NO;
        _btnReport.hidden = NO;
        _btnCancel.hidden = YES;

    }
}

- (void)setupMMFont
{
    _btnBookingList.layer.cornerRadius = 5.0f;
    _btnBookingList.layer.borderWidth = 1.0f;
    _btnBookingList.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnCheckinlist.layer.cornerRadius = 5.0f;
    _btnCheckinlist.layer.borderWidth = 1.0f;
    _btnCheckinlist.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnCancel.layer.cornerRadius = 5.0f;
    _btnCancel.layer.borderWidth = 1.0f;
    _btnCancel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnFromDate.layer.cornerRadius = 5.0f;
    _btnFromDate.layer.borderWidth = 1.0f;
    _btnFromDate.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnToDate.layer.cornerRadius = 5.0f;
    _btnToDate.layer.borderWidth = 1.0f;
    _btnToDate.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnReport.layer.cornerRadius = 5.0f;
    _btnReport.layer.borderWidth = 1.0f;
    _btnReport.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnSearch.layer.cornerRadius = 5.0f;
    _btnSearch.layer.borderWidth = 1.0f;
    _btnSearch.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _btnSearch.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    [_btnSearch setTitle:@"ရွာပါ" forState:UIControlStateNormal];
    
    _btnBookingList.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    [_btnBookingList setTitle:@"ဘိုုကင္ စာရင္း" forState:UIControlStateNormal];
    
    _btnCheckinlist.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    [_btnCheckinlist setTitle:@"Check-in စာရင္း" forState:UIControlStateNormal];
    
    _btnReport.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    [_btnReport setTitle:@"စာရင္းမ်ား" forState:UIControlStateNormal];
}

- (NSDate*)firstDayOfWeek
{
    NSCalendar* cal = [[NSCalendar currentCalendar] copy];
    [cal setFirstWeekday:2]; //Override locale to make week start on Monday
    NSDate* startOfTheWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&startOfTheWeek interval:&interval forDate:[NSDate date]];
    return startOfTheWeek;
}

- (NSDate*)lastDayOfWeek
{
    NSCalendar* cal = [[NSCalendar currentCalendar] copy];
    [cal setFirstWeekday:2]; //Override locale to make week start on Monday
    NSDate* startOfTheWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&startOfTheWeek interval:&interval forDate:[NSDate date]];
    return [startOfTheWeek dateByAddingTimeInterval:interval - 1];
}


- (void)reloadRoomLayout
{
    [self SearchRoomAvailability:_selectedBuildingid withfloorid:_selectedFloorid];
}

- (void)didSelectBuilding:(NSNotification*)noti
{
    NSDictionary* building = (NSDictionary*)noti.object;
    [_btnBuilding setTitle:building[@"building_no"] forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
    
    _selectedBuildingid = [building[@"id"] intValue];
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    NSDictionary* floorcount = [db executeQuery:[NSString stringWithFormat:@"SELECT count(DISTINCT floor_id) as count FROM tbl_room_plan where building_id='%d'",_selectedBuildingid]].firstObject;
    int count = [floorcount[@"count"] intValue];
    if (count == 2) {
        _segControl.hidden = NO;
    } else _segControl.hidden = YES;
    
    _roomLayout = [db executeQuery:[NSString stringWithFormat:@"SELECT tbl_room_layout.row, tbl_room_layout.column, room_no,tbl_room_plan.id from tbl_room_plan join tbl_room_layout on tbl_room_plan.layout_id = tbl_room_layout.id where building_id = '%d' and floor_id = '1'",_selectedBuildingid]];
    
    if (_roomLayout.count > 0) {
        _numCol = [_roomLayout[0][@"column"] intValue];
        _numRow = [_roomLayout[0][@"row"] intValue];
        
        _roommainlayout = [[NSMutableArray alloc] initWithCapacity:_numRow];
        int counter = 0;
        for (int i = 0; i < _numRow; i++) {
            NSMutableArray* rowArr = [[NSMutableArray alloc] initWithCapacity:_numCol];
            for (int j = 0; j < _numCol; j++) {
                [rowArr addObject:_roomLayout[counter]];
                counter++;
            }
            [_roommainlayout addObject:rowArr];
        }
        
        _collView.hidden = NO;
        [_collView reloadData];
        CGFloat cellHeight = _collView.frame.size.width/_numCol;
        CGFloat resultheight = cellHeight*_numRow;
        
        _collViewHeight.constant = resultheight;
        
        _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, resultheight+200);
    }
    else {
        _collView.hidden = YES;
        _segControl.hidden = YES;
    }
    
    
}

- (void)pickBuilding
{
    _selectedBuildingid = _multiSegCon.selectedSegmentIndex+1;
    if (_selectedBuildingid == 3) {
        _selectedFloorid = 1;
    }
    
//    if (_selectedBuildingid == 3) {
//        _viewLoneChin.hidden = NO;
//        _segControl.hidden = YES;
//        _collView.hidden = YES;
//        return;
//    }
    _collView.hidden = NO;
    _viewLoneChin.hidden = YES;
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    NSDictionary* floorcount = [db executeQuery:[NSString stringWithFormat:@"SELECT count(DISTINCT floor_id) as count FROM tbl_room_plan where building_id='%d'",_selectedBuildingid]].firstObject;
    int count = [floorcount[@"count"] intValue];
    if (count == 2) {
        _segControl.hidden = NO;
    } else _segControl.hidden = YES;
    
    _roomLayout = [db executeQuery:[NSString stringWithFormat:@"SELECT tbl_room_layout.row, tbl_room_layout.column, room_no,tbl_room_plan.id from tbl_room_plan join tbl_room_layout on tbl_room_plan.layout_id = tbl_room_layout.id where building_id = '%d' and floor_id = '1'",_selectedBuildingid]];
    
    if (_roomLayout.count > 0) {
        _numCol = [_roomLayout[0][@"column"] intValue];
        _numRow = [_roomLayout[0][@"row"] intValue];
        
        _roommainlayout = [[NSMutableArray alloc] initWithCapacity:_numRow];
        int counter = 0;
        for (int i = 0; i < _numRow; i++) {
            NSMutableArray* rowArr = [[NSMutableArray alloc] initWithCapacity:_numCol];
            for (int j = 0; j < _numCol; j++) {
                [rowArr addObject:_roomLayout[counter]];
                counter++;
            }
            [_roommainlayout addObject:rowArr];
        }
        
        _collView.hidden = NO;
//        [_collView reloadData];
//        CGFloat cellHeight = _collView.frame.size.width/_numCol;
//        CGFloat resultheight = cellHeight*_numRow;
//        
//        _collViewHeight.constant = resultheight;
//        
//        _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, resultheight+100);
        [self SearchRoomAvailability:_selectedBuildingid withfloorid:1];
        _segControl.selectedSegmentIndex = 0;
    }
    else {
        _collView.hidden = YES;
        _segControl.hidden = YES;
    }

}


- (void)segmentcontrolIndexChanged
{
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    _roomLayout = [db executeQuery:[NSString stringWithFormat:@"SELECT tbl_room_layout.row, tbl_room_layout.column, room_no,tbl_room_plan.id from tbl_room_plan join tbl_room_layout on tbl_room_plan.layout_id = tbl_room_layout.id where building_id = '%d' and floor_id = '%d'",_selectedBuildingid,_segControl.selectedSegmentIndex+1]];
    
    _selectedFloorid = _segControl.selectedSegmentIndex+1;
    
    _numCol = [_roomLayout[0][@"column"] intValue];
    _numRow = [_roomLayout[0][@"row"] intValue];
    
    _roommainlayout = [[NSMutableArray alloc] initWithCapacity:_numRow];
    int counter = 0;
    for (int i = 0; i < _numRow; i++) {
        NSMutableArray* rowArr = [[NSMutableArray alloc] initWithCapacity:_numCol];
        for (int j = 0; j < _numCol; j++) {
            [rowArr addObject:_roomLayout[counter]];
            counter++;
        }
        [_roommainlayout addObject:rowArr];
    }
    
    _collView.hidden = NO;
    [self SearchRoomAvailability:_selectedBuildingid withfloorid:_selectedFloorid];

    

}

- (void)didSelectDatefromHome:(NSNotification*)noti
{
    NSString* strDate = (NSString*)noti.object;
    if (_isChoosingFromDate) [_btnFromDate setTitle:strDate forState:UIControlStateNormal];
    else [_btnToDate setTitle:strDate forState:UIControlStateNormal];
    
    [_myPopoverController dismissPopoverAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showbookinglistSegue"]) {
        BookingListVC* nexvc = (BookingListVC*)[segue destinationViewController];
        nexvc.isCheckingBookingList = YES;
        return;
    }
    if ([segue.identifier isEqualToString:@"checkinlist"]) {
        BookingListVC* nexvc = (BookingListVC*)[segue destinationViewController];
        nexvc.isCheckingBookingList = NO;
        return;
    }
    
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"home" forKey:@"currentvc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UICollectionview Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _numCol;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    
    return _numRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"roomcell";
    RoomCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.cellImg.hidden = YES;
    NSArray* rowArr = _roommainlayout[indexPath.section];
    NSString* room_no = rowArr[indexPath.item][@"room_no"];
    if ([room_no isEqualToString:@"xxx"]) {
        cell.cellImg.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.layer.borderWidth = 1;
        cell.cellLblTilte.text = @"";
    }
    else {
        cell.cellLblTilte.text = rowArr[indexPath.item][@"room_no"];
        if (_muStatusArr.count > 0) {
            NSString* strplanid = [NSString stringWithFormat:@"%@",rowArr[indexPath.item][@"id"]];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@" plan_id MATCHES[cd] %@", strplanid];
            NSArray * matches = [_muStatusArr filteredArrayUsingPredicate:predicate];
            if (matches > 0) {
                NSDictionary* dict = matches.firstObject;
                if ([dict[@"status"] isEqualToString:@"0"]) {
                    cell.backgroundColor = [UIColor greenColor];
                }
                else if ([dict[@"status"] isEqualToString:@"1"]) {
                    cell.backgroundColor = [UIColor redColor];
                } else cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
                
                NSDictionary* onerecord = matches.firstObject;
                if ([onerecord[@"full"] isEqualToString:@"notfull"]) {
                    cell.cellImg.hidden = NO;
                }else cell.cellImg.hidden = YES;
            }
            
            
            
        }
        else {
            
            cell.backgroundColor = [UIColor colorWithRed:47.0/255 green:113.0/255 blue:203.0/255 alpha:1];
        }
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1;

    }
    
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = _collView.frame.size.width/_numCol;
    CGFloat cellheight;
    if (_selectedBuildingid == 2) {
        cellheight = cellWidth-50;
    } else cellheight = cellWidth;
    return CGSizeMake(cellWidth, cellheight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* rowArr = _roommainlayout[indexPath.section];
    int rowid = [rowArr[indexPath.item][@"id"] intValue];
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    NSDictionary* roomdict = [db executeQuery:[NSString stringWithFormat:@"select tbl_room.id as room_id, tbl_room.price, tbl_room_type.type, tbl_room.room_type_id as room_type_id from tbl_room join tbl_room_type on tbl_room.room_type_id = tbl_room_type.id where room_plan_id = '%d'",rowid]].firstObject;
    
    NSString* query = [NSString stringWithFormat:@"SELECT tbl_facality.name, tbl_facality.description  FROM tbl_room_facility join tbl_facality on tbl_room_facility.facality_id = tbl_facality.id where tbl_room_facility.room_type_id='%d'",[roomdict[@"room_type_id"] intValue]];
    
    NSDictionary* roomfacility = [db executeQuery:query].firstObject;
    
    NSArray* occupiedDate = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tbl_booking_room_dates where  roomid = '%d'",[roomdict[@"room_id"] intValue]]];
    
    RoomInfoVC* vc = (RoomInfoVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"RoomInfoVC"];
    vc.room_plan_id = rowid;
    vc.isRoomAdding = _isRoomAdding;
    vc.bookingid = _bookingid;
    vc.occupydateWithStatus = [occupiedDate copy];
    vc.roomInfoDict = roomdict;
    vc.strRoomno = rowArr[indexPath.item][@"room_no"];
    vc.strRoomFacility = roomfacility[@"name"];
    vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    [vc setTransitioningDelegate:transitionController];
    vc.modalPresentationStyle= UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnFromDateClicked:(id)sender {
    _isChoosingFromDate = YES;
}

- (IBAction)onBtnToDateClicked:(id)sender {
    _isChoosingFromDate = NO;
}

- (IBAction)SearchRoomByDate:(id)sender {
    
    [self SearchRoomAvailability:_selectedBuildingid withfloorid:_selectedFloorid];

    
}

- (IBAction)DismissThisView:(id)sender {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataAfterAddingRooms" object:nil];
        }];
}

- (void)SearchRoomAvailability:(int)build_id withfloorid:(int)floor_id
{
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    NSArray* roomIDArr = [db executeQuery:[NSString stringWithFormat:@"SELECT room_no,tbl_room_plan.id as plan_id, tbl_room.id as room_id from tbl_room_plan join tbl_room_layout on tbl_room_plan.layout_id = tbl_room_layout.id join tbl_room on tbl_room.room_plan_id=tbl_room_plan.id where building_id = '%d' and floor_id = '%d'",build_id,floor_id]];
    _muStatusArr = [[NSMutableArray alloc] initWithCapacity:roomIDArr.count];
    for (int i = 0; i<roomIDArr.count;i++) {
        NSString* strplan_id = [NSString stringWithFormat:@"%@",roomIDArr[i][@"plan_id"]];
        int roomid = [roomIDArr[i][@"room_id"] intValue];
        NSArray* bookingdateArr = [db executeQuery:[NSString stringWithFormat:@"SELECT * from tbl_booking_room_dates where roomid='%d' and status!='2' and book_date BETWEEN '%@' and '%@'",roomid, _btnFromDate.titleLabel.text, _btnToDate.titleLabel.text]];
        if (bookingdateArr.count == 0) {
            [_muStatusArr addObject:@{@"plan_id": strplan_id, @"status":@"2", @"full":@"notfull"}]; // FREE
        } else {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate* startDate = [dateFormatter dateFromString:_btnFromDate.titleLabel.text];
            NSDate* endDate = [dateFormatter dateFromString:_btnToDate.titleLabel.text];
            
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:0];
            NSString* strNumDays;
            NSLog(@"Number of days : %d",components.day);
            if (components.day+1 == bookingdateArr.count) {
                strNumDays = @"full";
            } else strNumDays = @"notfull";
            
            [_muStatusArr addObject:@{@"plan_id": strplan_id, @"status":bookingdateArr[0][@"status"], @"full":strNumDays}];
            
        }
    }
    
    CGFloat cellHeight = _collView.frame.size.width/_numCol;
    
    if (_selectedBuildingid == 2) _collViewHeight.constant = (cellHeight-50) * _numRow;
    else _collViewHeight.constant = cellHeight * _numRow;
    
    CGFloat resultheight = _collViewHeight.constant;
    
    _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, resultheight+100);

    
    [_collView reloadData];
    
}
@end
