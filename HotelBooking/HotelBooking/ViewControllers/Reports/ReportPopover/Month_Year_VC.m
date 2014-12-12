//
//  Month_Year_VC.m
//  HotelBooking
//
//  Created by Macbook Pro on 9/18/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "Month_Year_VC.h"
#import "BookListCell.h"

@interface Month_Year_VC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* tablefiller;

@end

@implementation Month_Year_VC

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
    
    _tablefiller = @[@{@"month":@"January", @"id":@"1"}, @{@"month":@"February", @"id":@"2"}, @{@"month":@"March", @"id":@"3"}, @{@"month":@"April", @"id":@"4"}, @{@"month":@"May", @"id":@"5"}, @{@"month":@"June", @"id":@"6"}, @{@"month":@"July", @"id":@"7"}, @{@"month":@"August", @"id":@"8"}, @{@"month":@"September", @"id":@"9"}, @{@"month":@"October", @"id":@"10"}, @{@"month":@"November", @"id":@"11"}, @{@"month":@"December", @"id":@"12"}];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tablefiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"monthyearcell";
    BookListCell* cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    NSDictionary* dict = _tablefiller[indexPath.row];
    cell.cellname.text = dict[@"month"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = _tablefiller[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didselectmonth" object:dict];
}

@end
