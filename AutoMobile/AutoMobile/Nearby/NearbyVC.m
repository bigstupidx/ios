//
//  NearbyVC.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NearbyVC.h"
#import "NearbyCell.h"
#import "NearbyDetailVC.h"

#import "NearbyPlace.h"
#import "Reachability.h"
#import "JDStatusBarNotification.h"
#import "ZMFMDBSQLiteHelper.h"

@interface NearbyVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *placesArray;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@end

@implementation NearbyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    [db createDirectoriesTable];
    self.placesArray = [db getDirectories];
    
    self.parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"999999", @"limit",
                       @"1", @"offset",
                       @"16", @"categoryid",
                       @"", @"subcategoryid",
                       @"all", @"city",
                       @"all", @"township",
                       @"false",@"promotion",
                       @"",@"keywords", nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (self.reachable) {
        [self refreshNearbyPlaces];
        } else {
        [self JDStatusBarHidden:NO status:@"No internet connection" duration:2.0];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.topViewController.title = @"Directory";
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
}

#pragma mark - Custom methods

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

- (void)refreshNearbyPlaces
{
    [self JDStatusBarHidden:NO status:@"Retrieving directories..." duration:0];
    [NearbyPlace getDirectories:self.parameters block:^(NSArray *places, NSError *error) {
        self.placesArray = places;
        ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
        if (_placesArray.count > 0) {
            [db executeUpdate:@"delete from Directory"];
        }
        [db insertDirectoriesIntoTable:self.placesArray];

        [self.tableView reloadData];
        [self JDStatusBarHidden:YES status:nil duration:0];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Nearby Detail Segue"]) {
        NearbyDetailVC *vc = segue.destinationViewController;
        vc.selectedPlace = self.placesArray[self.tableView.indexPathForSelectedRow.row];
    }
}

//#pragma mark - CLLocationManagerDelegate
//
//- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get current location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
//}
//
//- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    location_mark = [locations lastObject];
//    CLLocation *loc = [locations lastObject];
//    [self.parameters setValue:[NSString stringWithFormat:@"%f",loc.coordinate.latitude] forKey:@"lat"];
//    [self.parameters setValue:[NSString stringWithFormat:@"%f",loc.coordinate.longitude] forKey:@"lng"];
//    [locationManager stopUpdatingLocation];
//    [self refreshNearbyPlaces];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Nearby Cell";
    NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCell:self.placesArray[indexPath.row]];
    return cell;
}

@end
