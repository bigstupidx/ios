//
//  BuyVC.m
//  AutoMobile
//
//  Created by Zune Moe on 23/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "BuyVC.h"
#import "BuyCarListVC.h"
#import "BuyCell.h"

// models
#import "Car.h"
#import "CarBrand.h"
#import "CarModel.h"
#import "MyCar.h"

// categories
#import "UIFont+ZawgyiOne.h"

// vendors
#import "JDStatusBarNotification.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Reachability.h"

@interface BuyVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *pickerViewDoneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewContainerBottomConstraint;
@property (strong, nonatomic) NSArray *pickerArray;
@property (strong, nonatomic) NSArray *carBuyingOptionArray;
@property (strong, nonatomic) NSArray *modelArray;
@property (strong, nonatomic) NSArray *brandArray;
@property (strong, nonatomic) NSDictionary *buyOption;
@property (strong, nonatomic) CarModel *model;
@property (strong, nonatomic) CarBrand *brand;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@end

@implementation BuyVC
{
    int selectedSection;
}
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.carBuyingOptionArray = @[@{@"name": @"ျမန္မာျပည္တြင္ေရာက္ရွိေနသည့္ကားမ်ား", @"id": @"1"},
                                  @{@"name": @"ဆိပ္ကမ္းေရာက္ တန္ဖုုိးျဖင့္ေရာင္းမည့္ကားမ်ား", @"id": @"2"},
                                  @{@"name": @"စလစ္မ်ား", @"id": @"3"},
                                  @{@"name": @"အပ္ႏွံရမည့္ ယာဥ္အိုယာဥ္ေဟာင္းမ်ား", @"id": @"4"}];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    self.buyOption = self.carBuyingOptionArray[0];
    if (self.reachable) { // have internet connection
        [self reloadCarBrandWithCatId:[self.buyOption[@"id"] intValue]];
    } else { // no internet connection
        [self retrieveCarBrandsFromDatabaseWithCatId:[self.buyOption[@"id"] intValue]];
        [self retrieveCarModelsFromDatabaseWithMakeId:self.brand.id];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _pickerView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
//    self.pickerViewContainerBottomConstraint.constant = -230;
    self.navigationController.topViewController.title = @"Buy";
}

- (void) reloadCarBrandWithCatId:(int)catid
{
    [self JDStatusBarHidden:NO status:@"Fetching car brands..." duration:0];
    __weak typeof(self) weakSelf = self;
    [CarBrand getAvailableCarBrandsWithCatId:catid block:^(NSArray *brands, NSError *error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if(!error && brands.count > 0) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                CarBrand *brand = brands.firstObject;
                ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
                [db createCarBrandTable:brand];
                [db executeUpdate:[NSString stringWithFormat:@"delete from CarBrand where catid = '%d'", catid]];
                for (CarBrand *brand in brands) {
                    [db insertCarBrandIntoTable:brand];
                }
            });
            if (brands.count > 0) {
                strongSelf.brandArray = brands;
                strongSelf.brand = self.brandArray.firstObject;
                [strongSelf.tableView reloadData];
                [strongSelf JDStatusBarHidden:NO status:@"Car brand data was updated!" duration:1.0];
                [strongSelf reloadCarModelWithMakeId:strongSelf.brand.id];
            }
        }
        else if (brands.count == 0) {
            strongSelf.brandArray = brands;
            strongSelf.modelArray = brands;
        }
        [strongSelf JDStatusBarHidden:YES status:nil duration:0];
        
    }];
}

- (void) reloadCarModelWithMakeId:(int)makeid
{
    [self JDStatusBarHidden:NO status:@"Fetching car models..." duration:0];
    __weak typeof(self) weakSelf = self;
    [CarModel getAvailableCarModelsWithMakeId:makeid block:^(NSArray *models, NSError *error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (!error && models.count > 0) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                CarModel *model = models.firstObject;
                ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
                [db createCarModelTable:model];
                [db executeUpdate:[NSString stringWithFormat:@"delete from CarModel where makeid = '%d'", makeid]];
                for (CarModel *model in models) {
                    [db insertCarModelIntoTable:model];
                }
            });
        }
        if (models.count > 0) {
            self.modelArray = models;
            self.model = self.modelArray.firstObject;
            [self.tableView reloadData];
            [strongSelf JDStatusBarHidden:NO status:@"Car model data was updated!" duration:1.0];
        }
        else {
            self.modelArray = models;
        }
        
    }];
}

- (void) retrieveCarBrandsFromDatabaseWithCatId:(int)catid
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    NSArray *brandList = [db executeQuery:[NSString stringWithFormat:@"select * from CarBrand where catid = '%d' order by name asc", catid]];
    NSMutableArray *brands = [NSMutableArray array];
    for (NSDictionary *dict in brandList) {
        CarBrand *brand = [[CarBrand alloc] initWithDictionary:dict error:nil];
        [brands addObject:brand];
    }
    if (brands.count > 0) {
        self.brandArray = brands;
        self.brand = self.brandArray.firstObject;
        [self.tableView reloadData];
    }
    else {
        self.brandArray = brands;
        self.modelArray = brands;
    }
   
}

- (void) retrieveCarModelsFromDatabaseWithMakeId:(int)makeid
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    NSArray *modelList = [db executeQuery:[NSString stringWithFormat:@"select * from CarModel where makeid = '%d' order by name asc", makeid]];
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in modelList) {
        CarModel *model = [[CarModel alloc] initWithDictionary:dict error:nil];
        [models addObject:model];
    }
    if (models.count > 0) {
        self.modelArray = models;
        self.model = self.modelArray.firstObject;
        [self.tableView reloadData];
    }
    
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

- (NSString *) getPlistPathWithFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath:path error:nil]; //6
    }
    return path;
}

#pragma mark - IBAction

- (IBAction)hidePickerView:(id)sender {
    self.pickerArray = nil;
    self.pickerViewContainerBottomConstraint.constant = -230;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? 4 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == self.tableView ? 1 : self.pickerArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, tableView.frame.size.width, 18)];
    [label setFont:[UIFont ayarFontWithSize:14.0f]];
    NSString *string = @"";
    if (section == 0)
        string = @"Car Buying Option";
    else if (section == 1)
        string = @"Car Brand";
    else if (section == 2)
        string = @"Car Model";

        label.textColor = [UIColor orangeColor];
    [label setText:string];
    [view addSubview:label];
    return view;
    } else return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section != 3) {
            static NSString *CellIdentifier = @"Buy Cell";
            BuyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (cell == nil) cell = [[BuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.cellLbl.font = [UIFont fontWithName:@"Zawgyi-One" size:12.0];
            if (indexPath.section == 0)
                cell.cellLbl.text = self.buyOption[@"name"];
            else if (indexPath.section == 1)
                cell.cellLbl.text = self.brand.name;
            else if (indexPath.section == 2)
                cell.cellLbl.text = self.model.name;
            
            cell.cellBgView.layer.borderColor = [[UIColor orangeColor] CGColor];
            cell.cellBgView.layer.borderWidth = 1.5f;
            cell.cellBgView.layer.cornerRadius = 5;
            
            return cell;
        }
        else {
            NSString* cellid = @"searchcell";
            BuyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
            if (cell == nil) cell = [[BuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.cellLbl.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
            
            cell.cellBgView.layer.cornerRadius = 5;
            
            return cell;
        }
        
    } else if (tableView == self.pickerView) {
        static NSString *CellIdentifier = @"Picker Cell";
        UITableViewCell *cell = [self.pickerView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont zawgyiOneFontWithSize:14];
        if ([self.pickerArray[indexPath.row] isKindOfClass:[CarModel class]]) {
            cell.textLabel.text = [(CarModel *)self.pickerArray[indexPath.row] name];
        } else if ([self.pickerArray[indexPath.row] isKindOfClass:[CarBrand class]]) {
            cell.textLabel.text = [(CarBrand *)self.pickerArray[indexPath.row] name];
        } else {
            cell.textLabel.text = self.pickerArray[indexPath.row][@"name"];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if(indexPath.section != 3) {
            self.pickerView.dataSource = self;
            self.pickerView.delegate = self;
            if (indexPath.section == 0) {
                self.pickerArray = self.carBuyingOptionArray;
            } else if (indexPath.section == 1) {
                self.pickerArray = self.brandArray;
            } else if (indexPath.section == 2) {
                self.pickerArray = self.modelArray;
            }
            selectedSection = indexPath.section;
            self.pickerView.contentOffset = CGPointZero;
            [self.pickerView reloadData];
            self.pickerViewContainerBottomConstraint.constant = 1;
        } else {
            // do the searching of car
            if (!self.buyOption || !self.model || !self.brand) {
                [self JDStatusBarHidden:NO status:@"Please choose all three options" duration:1.5];
            } else {
                [self JDStatusBarHidden:NO status:@"Searching cars..." duration:0];
                NSDictionary *parameters = @{@"limit": @10,
                                             @"offset": @1,
                                             @"catid": self.buyOption[@"id"],
                                             @"makeid": @(self.brand.id),
                                             @"modelid": @(self.model.id)};
//                NSDictionary *parameters = @{@"limit": @1,
//                                             @"offset": @1,
//                                             @"catid": @8,
//                                             @"makeid": @1,
//                                             @"modelid": @1};
                
                self.reachable = [self.reachability currentReachabilityStatus];
                
                if (self.reachable) { // have internet connection
                    [Car getCarsWithParameters:parameters block:^(NSArray *cars, NSError *error) {
                        if (cars.count > 0) {
                            [self JDStatusBarHidden:YES status:nil duration:0];
                            
                            NSMutableArray *carArrayForPlist = [NSMutableArray arrayWithCapacity:cars.count];
                            for (MyCar *car in cars) {
                                NSDictionary *carDictionary = [car toDictionary];
                                [carArrayForPlist addObject:carDictionary];
                            }
                            [carArrayForPlist writeToFile:[self getPlistPathWithFileName:@"CarList"] atomically:YES];
                            
                            BuyCarListVC *carListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyCarListVC"];
                            carListVC.carArray = cars;
                            carListVC.parameters = [parameters mutableCopy];
                            carListVC.brand = self.brand.name;
                            carListVC.model = self.model.name;
                            [self.navigationController pushViewController:carListVC animated:YES];
                        } else {
                            [self JDStatusBarHidden:NO status:@"Cannot find cars matching the criteria you've selected" duration:2];
                        }
                    }];
                } else { // no internet connection
                    NSArray *cars = [NSArray arrayWithContentsOfFile:[self getPlistPathWithFileName:@"CarList"]];
                    NSMutableArray *carsList = [NSMutableArray array];
                    for (NSDictionary *dict in cars) {
//                        if ([dict[@"catid"] isEqualToNumber:@8] && [dict[@"makeid"] isEqualToNumber:@2] && [dict[@"modelid"] isEqualToNumber:@4]) {
//                            Car *carmodel = [[Car alloc] initWithDictionary:dict error:nil];
//                            [carsList addObject:carmodel];
//                        }
                        if ([dict[@"catid"] isEqualToString:self.buyOption[@"id"]] && [@([dict[@"makeid"] intValue]) isEqualToNumber:@(self.brand.id)] && [@([dict[@"modelid"] intValue]) isEqualToNumber:@(self.model.id)]) {
                            MyCar *carmodel = [[MyCar alloc] initWithDictionary:dict error:nil];
                            [carsList addObject:carmodel];
                        }
                    }
                    if (carsList.count > 0) {
                        [self JDStatusBarHidden:YES status:nil duration:0];
                        BuyCarListVC *carListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyCarListVC"];
                        carListVC.carArray = carsList;
                        carListVC.parameters = [parameters mutableCopy];
                        carListVC.brand = self.brand.name;
                        carListVC.model = self.model.name;
                        [self.navigationController pushViewController:carListVC animated:YES];
                    } else {
                        [self JDStatusBarHidden:NO status:@"Cannot find cars matching the criteria you've selected" duration:2];
                    }
                }
            }
        }
        
    } else if (tableView == self.pickerView) {
        self.reachable = [self.reachability currentReachabilityStatus];
        if (self.reachable) {
            if (selectedSection == 0) {
                self.buyOption = self.pickerArray[indexPath.row];
                self.brand = nil;
                self.model = nil;
                [self reloadCarBrandWithCatId:[self.buyOption[@"id"] intValue]];
            } else if (selectedSection == 1) {
                self.brand = self.pickerArray[indexPath.row];
                [self reloadCarModelWithMakeId:self.brand.id];
            } else if (selectedSection == 2) {
                self.model = self.pickerArray[indexPath.row];
            }
        } else {
            if (selectedSection == 0) {
                self.buyOption = self.pickerArray[indexPath.row];
                self.brand = nil;
                self.model = nil;
                [self retrieveCarBrandsFromDatabaseWithCatId:[self.buyOption[@"id"] intValue]];
            } else if (selectedSection == 1) {
                self.brand = self.pickerArray[indexPath.row];
                [self retrieveCarModelsFromDatabaseWithMakeId:self.brand.id];
            } else if (selectedSection == 2) {
                self.model = self.pickerArray[indexPath.row];
            }
        }
        
        [self.tableView reloadData];
        [self hidePickerView:nil];
    }
}

@end
