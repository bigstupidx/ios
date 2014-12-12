//
//  BuildingPopoverVC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "BuildingPopoverVC.h"
#import "BuildingListCell.h"
#import "ZMFMDBSQLiteHelper.h"

@interface BuildingPopoverVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* bulidinglist;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation BuildingPopoverVC

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
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    _bulidinglist = [db executeQuery:@"select * from tbl_building"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadViewHeight];
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

-(void) reloadViewHeight
{
    float currentTotal = 0;
    
    //Need to total each section
    for (int i = 0; i < [self.tableview numberOfSections]; i++)
    {
        CGRect sectionRect = [self.tableview rectForSection:i];
        currentTotal += sectionRect.size.height;
    }
    
    if (currentTotal > 528.0f)
    {
        currentTotal = 528.0f;
    }
    //Set the contentSizeForViewInPopover
    self.preferredContentSize = CGSizeMake(self.tableview.frame.size.width, currentTotal);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"buildingcell";
    BuildingListCell* cell = (BuildingListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    NSDictionary* dict = _bulidinglist[indexPath.row];
    cell.cellLbl.text = dict[@"building_no"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = _bulidinglist[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectBuilding" object:dict];
}

@end
