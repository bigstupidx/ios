//
//  MeCarDetailsVC.m
//  AutoMobile
//
//  Created by Zune Moe on 2/17/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "MeCarDetailsVC.h"
#import "CarAssociation.h"

#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface MeCarDetailsVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CGPoint scrollViewOffset;
    NSNumber *selectedBrandIndex;
    NSNumber *selectedModelIndex;
    NSNumber *selectedBodyIndex;
    NSNumber *selectedColorIndex;
    NSNumber *selectedFuelIndex;
    NSNumber *selectedConditionIndex;
    NSNumber *selectedTransIndex;
    NSNumber *selectedDriveIndex;
    NSNumber *selectedCountryIndex;
    NSMutableArray *selectedEquipment;
    NSMutableArray *selectedEquipmentId;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *vincode;
@property (weak, nonatomic) IBOutlet UITextField *brand;
@property (weak, nonatomic) IBOutlet UITextField *model;
@property (weak, nonatomic) IBOutlet UITextField *bodyType;
@property (weak, nonatomic) IBOutlet UITextField *gearType;
@property (weak, nonatomic) IBOutlet UITextField *enginePower;
@property (weak, nonatomic) IBOutlet UITextField *petrolType;
@property (weak, nonatomic) IBOutlet UITextField *milage;
@property (weak, nonatomic) IBOutlet UITextField *condition;
@property (weak, nonatomic) IBOutlet UITextField *color;
@property (weak, nonatomic) IBOutlet UITextField *manufacturedYear;
@property (weak, nonatomic) IBOutlet UITextField *otherInfos; // equipment
@property (weak, nonatomic) IBOutlet UITextField *drive;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (strong, nonatomic) UIPickerView *bodyTypePicker;
@property (strong, nonatomic) NSArray *bodyTypePickerArray;
@property (strong, nonatomic) UIPickerView *colorPicker;
@property (strong, nonatomic) NSArray *colorPickerArray;
@property (strong, nonatomic) UIPickerView *brandPicker;
@property (strong, nonatomic) NSArray *brandPickerArray;
@property (strong, nonatomic) UIPickerView *gearPicker;
@property (strong, nonatomic) NSArray *gearPickerArray;
@property (strong, nonatomic) UIPickerView *conditionPicker;
@property (strong, nonatomic) NSArray *conditionPickerArray;
@property (strong, nonatomic) UIPickerView *petrolPicker;
@property (strong, nonatomic) NSArray *petrolPickerArray;
@property (strong, nonatomic) UIPickerView *modelPickerView;
@property (strong, nonatomic) NSArray *modelArray;
@property (strong, nonatomic) UIPickerView *drivePickerView;
@property (strong, nonatomic) NSArray *driveArray;
@property (strong, nonatomic) UIPickerView *countryPickerView;
@property (strong, nonatomic) NSArray *countryArray;
@property (strong, nonatomic) UIView *equipmentContainer;
@property (strong, nonatomic) UITableView *equipmentTableView;
@property (strong, nonatomic) NSArray *equipmentArray;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@end

@implementation MeCarDetailsVC

- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    NSLog(@"car: %@", self.car);
    [self.carImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageBaseURL, self.car.imgmain]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.carImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCarImage)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateCar)];
    
	UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    keyboardToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    [keyboardToolbar setItems:@[flexibleSpace, doneButton]];
    
    self.price.delegate = self;
    self.vincode.delegate = self;
    self.brand.delegate = self;
    self.model.delegate = self;
    self.bodyType.delegate = self;
    self.gearType.delegate = self;
    self.enginePower.delegate = self;
    self.petrolType.delegate = self;
    self.milage.delegate = self;
    self.condition.delegate = self;
    self.color.delegate = self;
    self.manufacturedYear.delegate = self;
    self.otherInfos.delegate = self;
    self.drive.delegate = self;
    self.country.delegate = self;
    
    self.price.inputAccessoryView = keyboardToolbar;
    self.vincode.inputAccessoryView = keyboardToolbar;
    self.brand.inputAccessoryView = keyboardToolbar;
    self.model.inputAccessoryView = keyboardToolbar;
    self.bodyType.inputAccessoryView = keyboardToolbar;
    self.gearType.inputAccessoryView = keyboardToolbar;
    self.enginePower.inputAccessoryView = keyboardToolbar;
    self.petrolType.inputAccessoryView = keyboardToolbar;
    self.milage.inputAccessoryView = keyboardToolbar;
    self.condition.inputAccessoryView = keyboardToolbar;
    self.color.inputAccessoryView = keyboardToolbar;
    self.manufacturedYear.inputAccessoryView = keyboardToolbar;
    self.otherInfos.inputAccessoryView = keyboardToolbar;
    self.drive.inputAccessoryView = keyboardToolbar;
    self.country.inputAccessoryView = keyboardToolbar;
    
    selectedBrandIndex = @(self.car.makeid);
    selectedModelIndex = @(self.car.modelid);
    selectedBodyIndex = @(self.car.bodytypeid);
    selectedTransIndex = @(self.car.transid);
    selectedFuelIndex = @(self.car.fuelid);
    selectedConditionIndex = @(self.car.conditionid);
    selectedColorIndex = @(self.car.colorid);
    selectedEquipment = [NSMutableArray arrayWithArray:self.car.equipment];
    selectedEquipmentId = [NSMutableArray arrayWithArray:self.car.equipmentid];
    selectedDriveIndex = @(self.car.driveid);
    selectedCountryIndex = @(self.car.countryid);
    
    self.price.text = [NSString stringWithFormat:@"%d", self.car.price];
    self.vincode.text = self.car.vincode;
    self.brand.text = self.car.makename;
    self.model.text = self.car.modelname;
    self.bodyType.text = self.car.bodytype;
    self.gearType.text = self.car.trans;
    self.enginePower.text = self.car.engine;
    self.petrolType.text = self.car.fuel;
    self.milage.text = [NSString stringWithFormat:@"%d", self.car.mileage];
    self.condition.text = self.car.condition;
    self.color.text = self.car.color;
    self.manufacturedYear.text = [NSString stringWithFormat:@"%d", self.car.year];
    NSMutableString *equipments = [NSMutableString string];
    for (NSString *equipment in self.car.equipment) {
        [equipments appendFormat:@"%@, ", equipment];
    }
    self.otherInfos.text = equipments;
    self.drive.text = self.car.drive;
    self.country.text = self.car.country;
    
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    
    self.brandPicker = [[UIPickerView alloc] init];
    self.brandPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.brandPicker.delegate = self;
    self.brandPicker.dataSource = self;
    self.brandPicker.showsSelectionIndicator = YES;
    self.brand.inputView = self.brandPicker;
    self.brandPickerArray = [db executeQuery:[NSString stringWithFormat:@"select * from CarBrand where catid = '%d' order by name asc", self.car.catid]];
    [self reloadCarBrandWithCatId:self.car.catid];
    
    self.modelPickerView = [[UIPickerView alloc] init];
    self.modelPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modelPickerView.delegate = self;
    self.modelPickerView.dataSource = self;
    self.modelPickerView.showsSelectionIndicator = YES;
    self.model.inputView = self.modelPickerView;
    self.modelArray = [db executeQuery:@"select * from CarModel"];
    
    self.bodyTypePicker = [[UIPickerView alloc] init];
    self.bodyTypePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyTypePicker.delegate = self;
    self.bodyTypePicker.dataSource = self;
    self.bodyTypePicker.showsSelectionIndicator = YES;
    self.bodyType.inputView = self.bodyTypePicker;
    self.bodyTypePickerArray = [db executeQuery:@"select * from CarBodyType"];
    
    self.gearPicker = [[UIPickerView alloc] init];
    self.gearPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.gearPicker.delegate = self;
    self.gearPicker.dataSource = self;
    self.gearPicker.showsSelectionIndicator = YES;
    self.gearType.inputView = self.gearPicker;
    self.gearPickerArray = [db executeQuery:@"select * from CarGearType"];
    
    self.petrolPicker = [[UIPickerView alloc] init];
    self.petrolPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.petrolPicker.delegate = self;
    self.petrolPicker.dataSource = self;
    self.petrolPicker.showsSelectionIndicator = YES;
    self.petrolType.inputAccessoryView = keyboardToolbar;
    self.petrolType.inputView = self.petrolPicker;
    self.petrolPickerArray = [db executeQuery:@"select * from CarFuel"];
    
    self.conditionPicker = [[UIPickerView alloc] init];
    self.conditionPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.conditionPicker.delegate = self;
    self.conditionPicker.dataSource = self;
    self.conditionPicker.showsSelectionIndicator = YES;
    self.condition.inputView = self.conditionPicker;
    self.conditionPickerArray = [db executeQuery:@"select * from CarCondition"];
    
    self.colorPicker = [[UIPickerView alloc] init];
    self.colorPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.colorPicker.delegate = self;
    self.colorPicker.dataSource = self;
    self.colorPicker.showsSelectionIndicator = YES;
    self.color.inputView = self.colorPicker;
    self.colorPickerArray = [db executeQuery:@"select * from CarColor"];
    
    self.drivePickerView = [[UIPickerView alloc] init];
    self.drivePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.drivePickerView.delegate = self;
    self.drivePickerView.dataSource = self;
    self.drivePickerView.showsSelectionIndicator = YES;
    self.drive.inputView = self.drivePickerView;
    self.driveArray = [db executeQuery:@"select * from CarDrive"];
    
    self.countryPickerView = [[UIPickerView alloc] init];
    self.countryPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryPickerView.delegate = self;
    self.countryPickerView.dataSource = self;
    self.countryPickerView.showsSelectionIndicator = YES;
    self.country.inputView = self.countryPickerView;
    self.countryArray = [db executeQuery:@"select * from CarCountry"];
    
    self.equipmentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 230)];
    self.equipmentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.equipmentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.equipmentContainer.bounds.size.width, self.equipmentContainer.bounds.size.height) style:UITableViewStylePlain];
    self.equipmentTableView.delegate = self;
    self.equipmentTableView.dataSource = self;
    self.equipmentTableView.allowsMultipleSelection = YES;
    if ([self.equipmentTableView respondsToSelector:@selector(separatorInset)]) {
        self.equipmentTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.equipmentContainer addSubview:self.equipmentTableView];
    self.otherInfos.inputView = self.equipmentContainer;
    self.equipmentArray = [db executeQuery:@"select * from CarEquipment"];
    
    if (self.reachable) {
        [CarAssociation getCarAssociation:^(CarAssociation *association, NSError *error) {
            if (!error) {
                [self setupTable:@"CarCountry" object:association.country];
                self.countryArray = [self retrieveFromTable:@"CarCountry"];
                [self.countryPickerView reloadAllComponents];
                [self.country reloadInputViews];
                
                [self setupTable:@"CarCondition" object:association.condition];
                self.conditionPickerArray = [self retrieveFromTable:@"CarCondition"];
                [self.conditionPicker reloadAllComponents];
                [self.condition reloadInputViews];
                
                [self setupTable:@"CarBodyType" object:association.bodytype];
                self.bodyTypePickerArray = [self retrieveFromTable:@"CarBodyType"];
                [self.bodyTypePicker reloadAllComponents];
                [self.bodyType reloadInputViews];
                
                [self setupTable:@"CarFuel" object:association.fuel];
                self.petrolPickerArray = [self retrieveFromTable:@"CarFuel"];
                [self.petrolPicker reloadAllComponents];
                [self.petrolType reloadInputViews];
                
                [self setupTable:@"CarGearType" object:association.trans];
                self.gearPickerArray = [self retrieveFromTable:@"CarGearType"];
                [self.gearPicker reloadAllComponents];
                [self.gearType reloadInputViews];
                
                [self setupTable:@"CarEquipment" object:association.equipment];
                self.equipmentArray = [self retrieveFromTable:@"CarEquipment"];
                [self.equipmentTableView reloadData];
                [self.otherInfos reloadInputViews];
                
                [self setupTable:@"CarColor" object:association.color];
                self.colorPickerArray = [self retrieveFromTable:@"CarColor"];
                [self.colorPicker reloadAllComponents];
                [self.color reloadInputViews];
            }
        }];
    } else {
        [self retrieveCarBrandsFromDatabaseWithCatId:self.car.catid];
        CarBrand *brand = self.brandPickerArray.firstObject;
        [self retrieveCarModelsFromDatabaseWithMakeId:brand.id];
    }
}

- (void) doneEditing
{
    if(self.price.isFirstResponder) [self.price resignFirstResponder];
    if(self.vincode.isFirstResponder) [self.vincode resignFirstResponder];
    if(self.brand.isFirstResponder ) {
        [self.brand resignFirstResponder];
        if([self.brand.text isEqualToString:@""]) {
            self.brand.text = [(CarBrand *)self.brandPickerArray[0] name];
            selectedBrandIndex = @([(CarBrand *)self.brandPickerArray[0] id]);
        }
        [self retrieveCarModelsFromDatabaseWithMakeId:selectedBrandIndex.intValue];
    }
    if(self.model.isFirstResponder) {
        [self.model resignFirstResponder];
    }
    if(self.bodyType.isFirstResponder) {
        [self.bodyType resignFirstResponder];
    }
    if(self.gearType.isFirstResponder) {
        [self.gearType resignFirstResponder];
    }
    if(self.enginePower.isFirstResponder) [self.enginePower resignFirstResponder];
    if(self.petrolType.isFirstResponder) {
        [self.petrolType resignFirstResponder];
    }
    if(self.milage.isFirstResponder) [self.milage resignFirstResponder];
    if(self.condition.isFirstResponder) {
        [self.condition resignFirstResponder];
    }
    if(self.color.isFirstResponder) {
        [self.color resignFirstResponder];
    }
    if(self.manufacturedYear.isFirstResponder) [self.manufacturedYear resignFirstResponder];
    if(self.otherInfos.isFirstResponder) [self.otherInfos resignFirstResponder];
    if(self.drive.isFirstResponder) {
        [self.drive resignFirstResponder];
    }
    if(self.country.isFirstResponder) {
        [self.country resignFirstResponder];
    }
    [self.scrollView setContentOffset:scrollViewOffset animated:YES];
}

#pragma mark - UITextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [self.scrollView setContentOffset:pt animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.scrollView setContentOffset:scrollViewOffset animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)updateCar
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    self.parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @(self.car.id) , @"id",
                       @(self.car.catid) , @"catid",
                       @"", @"make",
                       @"", @"model",
                       @"", @"country",
                       @"", @"condition",
                       userInfo[@"userid"], @"user",
                       @"", @"bodytype",
                       @"", @"drive",
                       @"", @"fuel",
                       @"", @"trans",
                       @"", @"equipment",
                       @"", @"year",
                       @"", @"month",
                       @"", @"vincode",
                       @"", @"mileage",
                       @"", @"price",
                       @"", @"bprice",
                       @"", @"extcolor",
                       @"", @"intcolor",
                       @"", @"doors",
                       @"", @"seats",
                       @"", @"engine",
                       @"", @"creatdate",
                       @"", @"expirdate",
                       @"", @"embedcode",
                       @"", @"fcommercial",
                       @"", @"ffeatured",
                       @"", @"ftop",
                       @"", @"special",
                       @"", @"fauction",
                       @"", @"state",
                       @"", @"expemail",
                       @"", @"otherinfo",
                       @"", @"unweight",
                       @"", @"grweight",
                       @"", @"length",
                       @"", @"width",
                       @"", @"displacement",
                       @"", @"metalliccolor",
                       @"", @"specificcolor",
                       @"", @"specificmodel",
                       @"", @"specifictrans",
                       @"", @"expprice",
                       @"", @"fconsumcity",
                       @"", @"fconsumfreeway",
                       @"", @"fconsumcombined",
                       @"", @"adacceleration",
                       @"", @"maxspeed",
                       @"", @"solid",
                       @"", @"co",
                       @"", @"params",
                       @"", @"language",
                       @"", @"access",
                       @"", @"extrafield1",
                       @"", @"extrafield2",
                       @"", @"extrafield3",
                       @"", @"city",
                       @"", @"vattext",
                       @"", @"stocknum",
                       @"", @"expstate",
                       @"", @"expreserved",
                       @"", @"street",
                       @"", @"latitude",
                       @"", @"longitude",
                       @"", @"zipcode",
                       @"", @"imgmain",
                       @"", @"imgcount",
                       @"", @"emailstyle",
                       nil];
    
    if (selectedBrandIndex != 0) {
        self.parameters[@"make"] = selectedBrandIndex;
    }
    if (selectedModelIndex != 0) {
        self.parameters[@"model"] = selectedModelIndex;
    }
    if (selectedCountryIndex != 0) {
        self.parameters[@"country"] = selectedCountryIndex;
    }
    if (selectedConditionIndex != 0) {
        self.parameters[@"condition"] = selectedConditionIndex;
    }
    // add user
    if (selectedBodyIndex != 0) {
        self.parameters[@"bodytype"] = selectedBodyIndex;
    }
    if (selectedDriveIndex != 0) {
        self.parameters[@"drive"] = selectedDriveIndex;
    }
    if (selectedFuelIndex != 0) {
        self.parameters[@"fuel"] = selectedFuelIndex;
    }
    if (selectedTransIndex != 0) {
        self.parameters[@"trans"] = selectedTransIndex;
    }
    if (selectedEquipmentId.count > 0) {
        NSMutableString *equipments = [NSMutableString string];
        for (NSString *equipment in selectedEquipmentId) {
            [equipments appendFormat:@"%@,", equipment];
        }
        self.parameters[@"equipment"] = equipments;
        NSLog(@"equ: %@", equipments);
    }
    if (![self.manufacturedYear.text isEqualToString:@""]) {
        self.parameters[@"year"] = self.manufacturedYear.text;
    }
    if (![self.vincode.text isEqualToString:@""]) {
        self.parameters[@"vincode"] = self.vincode.text;
    }
    if (![self.milage.text isEqualToString:@""]) {
        self.parameters[@"mileage"] = self.milage.text;
    }
    if (![self.price.text isEqualToString:@""]) {
        self.parameters[@"price"] = self.price.text;
    }
    if (selectedColorIndex != 0) {
        self.parameters[@"extcolor"] = selectedColorIndex;
    }
    if (![self.enginePower.text isEqualToString:@""]) {
        self.parameters[@"engine"] = self.enginePower.text;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        [self uploadImage:^(NSString *photoname, NSError *error) {
            if (!error) {
                self.parameters[@"imgmain"] = photoname;
//                [Car updateMyCar:self.parameters block:^(NSDictionary *status, NSError *error) {
//                    if (!error && [status[@"status"] isEqualToNumber:@1]) {
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                }];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login?" message:@"Please login first before you post something" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) uploadImage:(void(^)(NSString *photoname, NSError *error))callback
{
    NSData *imageToUpload = UIImageJPEGRepresentation(self.carImage.image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:keyParameter, @"keyName", nil];
        
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:autoMobileBaseURL]];
        
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"upload/car" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData: imageToUpload name:@"Picture" fileName:@"iOSUpload.jpeg" mimeType:@"image/jpeg"];
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
             if (callback) {
                 callback(json[@"photoname"], nil);
             }
         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (callback) {
                 callback([NSString string], error);
             }
         }];
        
        [operation start];
    }
}

- (void) reloadCarBrandWithCatId:(int)catid
{
//    [self JDStatusBarHidden:NO status:@"Fetching car brands..." duration:0];
    [self retrieveCarBrandsFromDatabaseWithCatId:catid];
    __weak typeof(self) weakSelf = self;
    [CarBrand getCarBrandsWithCatId:catid block:^(NSArray *brands, NSError *error) {
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
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [strongSelf retrieveCarBrandsFromDatabaseWithCatId:catid];
                });
//                [strongSelf JDStatusBarHidden:NO status:@"Car brand data was updated!" duration:1.0];
                //                if (_modelArray.count == 0) {
                [strongSelf reloadCarModelWithMakeId:brand.id];
                //                }
                
            });
        }
//        [strongSelf JDStatusBarHidden:YES status:nil duration:0];
    }];
}

- (void) reloadCarModelWithMakeId:(int)makeid
{
//    [self JDStatusBarHidden:NO status:@"Fetching car models..." duration:0];
    //    [self showHud:@"Fetching car models..."];
    //    [self retrieveCarModelsFromDatabaseWithMakeId:makeid];
    __weak typeof(self) weakSelf = self;
    [CarModel getCarModelsWithMakeId:makeid block:^(NSArray *models, NSError *error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (!error && models.count > 0) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                CarModel *model = models.firstObject;
                ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
                [db createCarModelTable:model];
                //                [db executeUpdate:[NSString stringWithFormat:@"delete from CarModel where makeid = '%d'", makeid]];
                [db executeUpdate:@"delete from CarModel"];
                for (CarModel *model in models) {
                    [db insertCarModelIntoTable:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //                    [strongSelf retrieveCarModelsFromDatabaseWithMakeId:makeid];
                });
            });
        }
        //        [self hideHud];
        if (models.count > 0) {
//            [strongSelf JDStatusBarHidden:NO status:@"Car model data was updated!" duration:1.0];
        }
        else self.modelArray = @[@{@"name": @"No Data", @"id": @"0"}];
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
        self.brandPickerArray = brands;
        [self.brandPicker reloadAllComponents];
        [self.brandPicker reloadInputViews];
    }
}

- (void) retrieveCarModelsFromDatabaseWithMakeId:(int)makeid
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    NSArray *modelList = [db executeQuery:[NSString stringWithFormat:@"select * from CarModel where makeid = '%d' order by name asc", makeid]];
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in modelList) {
        //        CarModel *model = [[CarModel alloc] initWithDictionary:dict error:nil];
        [models addObject:dict];
    }
    if (models.count > 0) {
        self.modelArray = models;
        [self.modelPickerView reloadAllComponents];
        [self.model reloadInputViews];
    }
    else self.modelArray = @[@{@"name": @"No Data", @"id": @"0"}];
}

- (void) setupTable:(NSString *)table object:(NSArray *)objects
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    NSDictionary *object = objects.firstObject;
    [db createTable:table object:object];
    for (NSDictionary *obj in objects) {
        [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where id = '%@'", table, obj[@"id"]]];
        [db insertIntoTable:table object:obj];
    }
}

- (NSArray *) retrieveFromTable:(NSString *)table
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    return [db executeQuery:[NSString stringWithFormat:@"select * from %@", table]];
}

- (void) selectCarImage
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIGraphicsBeginImageContext(CGSizeMake(320, 250));
    [image drawInRect:CGRectMake(0,0,320, 250)];
    _carImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count = 0;
    if(pickerView == self.bodyTypePicker) count = self.bodyTypePickerArray.count;
    else if(pickerView == self.colorPicker) count = self.colorPickerArray.count;
    else if(pickerView == self.brandPicker) count = self.brandPickerArray.count;
    else if(pickerView == self.gearPicker) count = self.gearPickerArray.count;
    else if(pickerView == self.conditionPicker) count = self.conditionPickerArray.count;
    else if(pickerView == self.petrolPicker) count = self.petrolPickerArray.count;
    else if(pickerView == self.modelPickerView) {
        count = self.modelArray.count;
        NSLog(@"MODEl ARRAY COUNT = %d",count);
    }
    else if(pickerView == self.drivePickerView) count = self.driveArray.count;
    else if(pickerView == self.countryPickerView) count = self.countryArray.count;
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if(pickerView == self.bodyTypePicker) title = self.bodyTypePickerArray[row][@"name"];
    else if(pickerView == self.colorPicker) title = self.colorPickerArray[row][@"name"];
    else if(pickerView == self.brandPicker) title = [(CarBrand *)self.brandPickerArray[row] name];
    else if(pickerView == self.gearPicker) title = self.gearPickerArray[row][@"name"];
    else if(pickerView == self.conditionPicker) title = self.conditionPickerArray[row][@"name"];
    else if(pickerView == self.petrolPicker) title = self.petrolPickerArray[row][@"name"];
    else if(pickerView == self.modelPickerView) {
        NSDictionary *model = self.modelArray[row];
        if (model) {
            title = model[@"name"];
        }
        else title = @"NO DATA";
        
    }//title = [(CarModel *)self.modelArray[row] name];
    else if(pickerView == self.drivePickerView) title = self.driveArray[row][@"name"];
    else if(pickerView == self.countryPickerView) title = self.countryArray[row][@"name"];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == self.brandPicker) {
        self.brand.text = [(CarBrand *)self.brandPickerArray[row] name];
        selectedBrandIndex = @([(CarBrand *)self.brandPickerArray[row] id]);
    } else if(pickerView == self.modelPickerView) {
        self.model.text = self.modelArray[row][@"name"];
        selectedModelIndex = @([self.modelArray[row][@"id"] intValue]);
    } else if(pickerView == self.bodyTypePicker) {
        self.bodyType.text = self.bodyTypePickerArray[row][@"name"];
        selectedBodyIndex = self.bodyTypePickerArray[row][@"id"];
    } else if(pickerView == self.colorPicker) {
        self.color.text = self.colorPickerArray[row][@"name"];
        selectedColorIndex = self.colorPickerArray[row][@"id"];
    } else if(pickerView == self.petrolPicker) {
        self.petrolType.text = self.petrolPickerArray[row][@"name"];
        selectedFuelIndex = self.petrolPickerArray[row][@"id"];
    } else if(pickerView == self.conditionPicker) {
        self.condition.text = self.conditionPickerArray[row][@"name"];
        selectedConditionIndex = self.conditionPickerArray[row][@"id"];
    } else if(pickerView == self.gearPicker) {
        self.gearType.text = self.gearPickerArray[row][@"name"];
        selectedTransIndex = self.gearPickerArray[row][@"id"];
    } else if(pickerView == self.drivePickerView) {
        self.drive.text = self.driveArray[row][@"name"];
        selectedDriveIndex = self.driveArray[row][@"id"];
    } else if(pickerView == self.countryPickerView) {
        self.country.text = self.countryArray[row][@"name"];
        selectedCountryIndex = self.countryArray[row][@"id"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.equipmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont zawgyiOneFontWithSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    for (NSString *equipment in self.car.equipment) {
        if ([self.equipmentArray[indexPath.row][@"name"] isEqualToString:equipment]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    cell.textLabel.text = self.equipmentArray[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedEquipment addObject:self.equipmentArray[indexPath.row][@"name"]];
    [selectedEquipmentId addObject:self.equipmentArray[indexPath.row][@"id"]];
    NSMutableString *equipments = [NSMutableString string];
    for (NSString *equipment in selectedEquipment) {
        [equipments appendFormat:@"%@, ", equipment];
    }
    self.otherInfos.text = equipments;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedEquipment removeObject:self.equipmentArray[indexPath.row][@"name"]];
    [selectedEquipmentId removeObject:self.equipmentArray[indexPath.row][@"id"]];
    NSMutableString *equipments = [NSMutableString string];
    for (NSString *equipment in selectedEquipment) {
        [equipments appendFormat:@"%@, ", equipment];
    }
    self.otherInfos.text = equipments;
}

@end
