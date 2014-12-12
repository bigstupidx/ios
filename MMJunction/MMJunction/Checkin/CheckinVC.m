//
//  CheckinVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

@import CoreLocation;
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "CheckinVC.h"
#import "Reachability.h"
#import "Place.h"
#import "PlacesCell.h"
#import "Event.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "TWMessageBarManager.h"
#import "User.h"

@interface CheckinVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkinImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventPlaceSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *loadingViewContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *checkinLoadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *checkinLoadingIndicator;
@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) NSArray *placesArray;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) NSMutableDictionary *checkinParameters;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@end

@implementation CheckinVC
{
    CLLocationManager *locationManager;
    CLLocation *location_mark;
    NSInteger selectedSegmentIndex;
    BOOL imageTaken;
}

- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

- (NSMutableDictionary *)checkinParameters
{
    if (!_checkinParameters) {
        _checkinParameters = [NSMutableDictionary dictionary];
    }
    return _checkinParameters;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageTaken = NO;
    selectedSegmentIndex = 0;
    self.parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0.2", @"radius",
                       @"", @"lat",
                       @"", @"lng",
                       @"", @"cat_id",
                       @"", @"subcat_id", nil];
    
    self.checkinParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"eventid",
                              @"", @"locationid",
                              @"", @"picture",
                              @"", @"userid", nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (self.reachable) {
        [self reloadTodayEvents];
    }
    
    //self.checkinImage.layer.cornerRadius = 31;
    self.checkinLoadingView.layer.cornerRadius = 31;
    
	[self.cameraImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraImageViewTapped)]];
    [self.checkinImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkinImageViewTapped)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Checkin View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)checkinImageViewTapped
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        self.checkinParameters[@"userid"] = userInfo[@"userid"];
        [self checkinLoadingIndicatorHidden:NO];
        if (imageTaken) {
            [User userCheckinUploadPhoto:self.cameraImageView.image block:^(NSString *photoname, NSError *error) {
                self.checkinParameters[@"picture"] = photoname;
                [self checkinToMMJunction];
            }];
        } else {
            [self checkinToMMJunction];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Please login first before checkin" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)checkinLoadingIndicatorHidden:(BOOL)hidden
{
    self.checkinLoadingView.hidden = hidden;
    if (hidden) {
        [self.checkinLoadingIndicator stopAnimating];
    } else {
        [self.checkinLoadingIndicator startAnimating];
    }
}

- (void)checkinToMMJunction
{
    NSLog(@"ck param: %@", self.checkinParameters);
    [User userCheckin:self.checkinParameters block:^(NSDictionary *status, NSError *error)
    {
        NSLog(@"STATUS : %@",status);
        if (error) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Failed to check in. Please try again." type:TWMessageBarMessageTypeError duration:2];
            [self checkinLoadingIndicatorHidden:YES];
        }
        if ([status[@"status"] isEqualToNumber:@1]) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Check in successful." type:TWMessageBarMessageTypeSuccess duration:2];
        } else {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Failed to check in. Please try again." type:TWMessageBarMessageTypeError duration:2];
        }
        [self checkinLoadingIndicatorHidden:YES];
    }];
}

- (void) uploadImage:(void(^)(NSString *photoname, NSError *error))callback
{
    NSData *imageToUpload = UIImageJPEGRepresentation(self.cameraImageView.image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:keyParameter, @"keyName", nil];
        
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:MMJunctionBaseURL]];
        
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"checkin/picture" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData: imageToUpload name:@"Picture" fileName:@"iOSUpload.jpeg" mimeType:@"image/jpeg"];
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
             if (callback) {
                 callback(json[@"photoname"], nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (callback) {
                 callback([NSString string], error);
             }
         }];
        [operation start];
    }
}

- (void)cameraImageViewTapped
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)eventPlaceSwitched:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    if (selectedSegmentIndex == 0) {
        [self reloadTodayEvents];
    } else {
        [self updateCurrentLocation];
    }
}

- (void)hideIndicator:(BOOL)hidden text:(NSString *)string
{    
    self.loadingViewContainer.hidden = hidden;
    if (hidden) {
        [self.loadingIndicator stopAnimating];
    } else {
        [self.loadingIndicator startAnimating];
        self.placesArray = nil;
        self.eventsArray = nil;
    }
    self.loadingLabel.text = string;
}

- (void)updateCurrentLocation
{
    if (locationManager == nil) locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)reloadNearbyPlaces
{
    [self hideIndicator:NO text:@"Finding nearby places..."];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [Place getNearbyPlaces:self.parameters block:^(NSArray *places, NSError *error) {
            self.placesArray = places;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
                [self hideIndicator:YES text:nil];
            });
        }];
    });
}

- (void)reloadTodayEvents
{
    [self hideIndicator:NO text:@"Finding nearby events..."];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [Event getTodayEvents:^(NSArray *events, NSError *error) {
            self.eventsArray = events;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
                [self hideIndicator:YES text:nil];
            });
        }];
    });
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get current location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location_mark = [locations lastObject];
    CLLocation *loc = [locations lastObject];
    [self.parameters setValue:[NSString stringWithFormat:@"%f",loc.coordinate.latitude] forKey:@"lat"];
    [self.parameters setValue:[NSString stringWithFormat:@"%f",loc.coordinate.longitude] forKey:@"lng"];
    [locationManager stopUpdatingLocation];
    [self reloadNearbyPlaces];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    imageTaken = YES;
    self.cameraImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cameraImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectedSegmentIndex == 0 ? self.eventsArray.count : self.placesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PlacesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PlacesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (selectedSegmentIndex == 0) {
        [cell setupEvent:self.eventsArray[indexPath.row]];
    } else {
        Place *place = self.placesArray[indexPath.row];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[place.latitude doubleValue]
                                                          longitude:[place.longitude doubleValue]];
        CLLocationDistance dist = [location_mark distanceFromLocation:location];
        NSString *distance = [NSString stringWithFormat:@"%.2f", dist];
        [cell setupCell:place distance:distance];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedSegmentIndex == 0) {
        Event *event = self.eventsArray[self.tableView.indexPathForSelectedRow.row];
        self.checkinParameters[@"eventid"] = @(event.id);
    } else {
        Place *place = self.placesArray[self.tableView.indexPathForSelectedRow.row];
        self.checkinParameters[@"locationid"] = @(place.locationid);
    }
}

@end
