//
//  SellFormVC.m
//  AutoMobile
//
//  Created by Zune Moe on 29/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "SellFormVC.h"
#import "automobileAPIClient.h"
#import "MeCarList.h"
#import "BuyCarListVC.h"

// models
#import "Car.h"
#import "CarBrand.h"
#import "CarModel.h"
#import "CarAssociation.h"
#import "MyCar.h"

// categories
#import "UIFont+ZawgyiOne.h"

// vendors
#import "JDStatusBarNotification.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Reachability.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface SellFormVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
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
    NSString* previousCarBrand;
    NSNumber *selectedEngPower;
    NSNumber *selectedLicenseIndex;
    NSNumber *selectedslipIndex;
    NSNumber *selectedNegoIndex;
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
@property (strong, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UITextField *slip;
@property (weak, nonatomic) IBOutlet UITextField *negotiate;
@property (weak, nonatomic) IBOutlet UITextField *numberRorB;
@property (weak, nonatomic) IBOutlet UITextField *ownerbook;
@property (weak, nonatomic) IBOutlet UITextField *seater;
@property (weak, nonatomic) IBOutlet UITextField *seatrow;
@property (weak, nonatomic) IBOutlet UITextField *license;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSlip;
@property (weak, nonatomic) IBOutlet UILabel *lblNego;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberRorB;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnerBook;
@property (weak, nonatomic) IBOutlet UILabel *lblCarno;
@property (weak, nonatomic) IBOutlet UILabel *lblCarbrand;
@property (weak, nonatomic) IBOutlet UILabel *lblCarmodel;
@property (weak, nonatomic) IBOutlet UILabel *lblbodytype;
@property (weak, nonatomic) IBOutlet UILabel *lblManuYear;
@property (weak, nonatomic) IBOutlet UILabel *lblTranGear;
@property (weak, nonatomic) IBOutlet UILabel *lblHandDrive;
@property (weak, nonatomic) IBOutlet UILabel *lblEngPower;
@property (weak, nonatomic) IBOutlet UILabel *lblFuel;
@property (weak, nonatomic) IBOutlet UILabel *lblMileage;
@property (weak, nonatomic) IBOutlet UILabel *lblCarCondition;
@property (weak, nonatomic) IBOutlet UILabel *lblCarColor;
@property (weak, nonatomic) IBOutlet UILabel *lblSeater;
@property (weak, nonatomic) IBOutlet UILabel *lblSeatrow;
@property (weak, nonatomic) IBOutlet UILabel *lblLicense;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblEquipment;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

- (IBAction)SubmitCar:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewSlip;
@property (weak, nonatomic) IBOutlet UIButton *btnSlip;
- (IBAction)onBtnSlipClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewNego;
- (IBAction)onBtnNegoClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewNumRorB;
- (IBAction)onBtnNumberRorBClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewOwnerbook;
- (IBAction)onBtnOwnerBookClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBrand;
- (IBAction)onBtnBrandClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewModel;
- (IBAction)onBtnModelClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBodyType;
@property (weak, nonatomic) IBOutlet UIButton *onBtnBodytypeClicked;
- (IBAction)onBtnBTypeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewManuyear;
- (IBAction)onBtnManuYearClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTran;
- (IBAction)onBtnTranClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewDrive;
- (IBAction)onBtnDriveClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewEngPow;
- (IBAction)onBtnEngPowClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewFuel;
- (IBAction)onFuelClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewCon;
- (IBAction)onBtnConClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewColor;
- (IBAction)onBtnColorClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewSeater;
- (IBAction)onBtnSeaterClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewSeatrow;
- (IBAction)onBtnSeatrowclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewLicense;
- (IBAction)onBtnLicenseClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewCountry;
- (IBAction)onBtnCountryClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewEquip;
- (IBAction)onBtnEquipClicked:(id)sender;

@property (strong, nonatomic) UIPickerView *slipPicker;
@property (strong, nonatomic) NSArray *slipPickerArray;
@property (strong, nonatomic) UIPickerView *negoPicker;
@property (strong, nonatomic) NSArray *negoPickerArray;
@property (strong, nonatomic) UIPickerView *numberRorBPicker;
@property (strong, nonatomic) NSArray *numberRorBPickerArray;
@property (strong, nonatomic) UIPickerView *ownerbookPicker;
@property (strong, nonatomic) NSArray *ownerbookPickerArray;
@property (strong, nonatomic) UIPickerView *seaterPicker;
@property (strong, nonatomic) NSArray *seaterPickerArray;
@property (strong, nonatomic) UIPickerView *seatrowPicker;
@property (strong, nonatomic) NSArray *seatrowPickerArray;
@property (strong, nonatomic) UIPickerView *enginepowerPicker;
@property (strong, nonatomic) NSArray *enginepowerArray;
@property (strong, nonatomic) UIPickerView *licensePicker;
@property (strong, nonatomic) NSArray *licensePickerArray;
@property (strong, nonatomic) UIPickerView *manuYearPicker;
@property (strong, nonatomic) NSArray *manuYearPickerArray;

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
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@end

@implementation SellFormVC

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
    
    [self setBackBtn];
    
    ZMFMDBSQLiteHelper *db = [[ZMFMDBSQLiteHelper alloc] init];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    self.carImage.image = [UIImage imageNamed:@"placeholder"];
    [self.carImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCarImage)]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCar)];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    keyboardToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 15;
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Next"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    [keyboardToolbar setItems:@[previousButton, fixedSpace, nextButton, flexibleSpace, doneButton]];
    
    _viewSlip.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewSlip.layer.borderWidth = 1.5f;
    _viewSlip.layer.cornerRadius = 5;
    
    _viewNego.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewNego.layer.borderWidth = 1.5f;
    _viewNego.layer.cornerRadius = 5;
    
    _viewNumRorB.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewNumRorB.layer.borderWidth = 1.5f;
    _viewNumRorB.layer.cornerRadius = 5;

    _viewOwnerbook.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewOwnerbook.layer.borderWidth = 1.5f;
    _viewOwnerbook.layer.cornerRadius = 5;
    
    _viewBodyType.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewBodyType.layer.borderWidth = 1.5f;
    _viewBodyType.layer.cornerRadius = 5;
    
    _viewBrand.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewBrand.layer.borderWidth = 1.5f;
    _viewBrand.layer.cornerRadius = 5;
    
    _viewCon.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewCon.layer.borderWidth = 1.5f;
    _viewCon.layer.cornerRadius = 5;
    
    _viewDrive.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewDrive.layer.borderWidth = 1.5f;
    _viewDrive.layer.cornerRadius = 5;
    
    _viewEngPow.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewEngPow.layer.borderWidth = 1.5f;
    _viewEngPow.layer.cornerRadius = 5;
    
    _viewFuel.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewFuel.layer.borderWidth = 1.5f;
    _viewFuel.layer.cornerRadius = 5;
    
    _viewManuyear.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewManuyear.layer.borderWidth = 1.5f;
    _viewManuyear.layer.cornerRadius = 5;
    
    _viewModel.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewModel.layer.borderWidth = 1.5f;
    _viewModel.layer.cornerRadius = 5;
    
    _viewTran.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewTran.layer.borderWidth = 1.5f;
    _viewTran.layer.cornerRadius = 5;
    
    _viewColor.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewColor.layer.borderWidth = 1.5f;
    _viewColor.layer.cornerRadius = 5;
    
    _viewCountry.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewCountry.layer.borderWidth = 1.5f;
    _viewCountry.layer.cornerRadius = 5;
    
    _viewEquip.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewEquip.layer.borderWidth = 1.5f;
    _viewEquip.layer.cornerRadius = 5;
    
    _viewLicense.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewLicense.layer.borderWidth = 1.5f;
    _viewLicense.layer.cornerRadius = 5;
    
    _viewSeater.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewSeater.layer.borderWidth = 1.5f;
    _viewSeater.layer.cornerRadius = 5;
    
    _viewSeatrow.layer.borderColor = [[UIColor orangeColor] CGColor];
    _viewSeatrow.layer.borderWidth = 1.5f;
    _viewSeatrow.layer.cornerRadius = 5;
    
    _price.layer.borderColor = [[UIColor orangeColor] CGColor];
    _price.layer.borderWidth = 1.5f;
    _price.layer.cornerRadius = 5;
    
    _vincode.layer.borderColor = [[UIColor orangeColor] CGColor];
    _vincode.layer.borderWidth = 1.5f;
    _vincode.layer.cornerRadius = 5;
    
    _milage.layer.borderColor = [[UIColor orangeColor] CGColor];
    _milage.layer.borderWidth = 1.5f;
    _milage.layer.cornerRadius = 5;
    
    _btnSubmit.layer.cornerRadius = 5;
    
    [_btnSlip setImage:[UIImage imageNamed:@"dropdown_selected_btn.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [_btnSlip setImage:[UIImage imageNamed:@"dropdown_unselected_btn.png"] forState:UIControlStateNormal];
    
    _lblPrice.font = [UIFont ayarFontWithSize:13.0f];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Price*"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(5, 1)];
    [_lblPrice setAttributedText: text];
    
    _lblSlip.font = [UIFont ayarFontWithSize:13.0f];
    _lblSlip.text = @"စလစ်";
    
    _lblNego.font = [UIFont ayarFontWithSize:13.0f];
    _lblNego.text = @"ညိှနုှိင်း";
    _lblNumberRorB.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"နံပါတ်*"];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(6, 1)];
    [_lblNumberRorB setAttributedText: text];
    
    _lblOwnerBook.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Owner Book*"];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(10, 1)];
    [_lblOwnerBook setAttributedText: text];
    
    _lblCarno.font = [UIFont ayarFontWithSize:13.0f];
    _lblCarno.text = @"နံပါတ်(အက္ခရာ)";
    _lblCarbrand.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"ကားအၝတ်တံဆိပ် (Make)*"];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(20, 1)];
    [_lblCarbrand setAttributedText: text];
    
    _lblCarmodel.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"ကားအမျုိးအစား(Model)*"];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(20, 1)];
    [_lblCarmodel setAttributedText: text];
    
    _lblbodytype.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"ကားေဘာ်ဒီ အမျုိးအစား (Body Type)*"];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(32, 1)];
    [_lblbodytype setAttributedText: text];
    
    _lblManuYear.font = [UIFont ayarFontWithSize:13.0f];
    text = [[NSMutableAttributedString alloc] initWithString:@"Year (made)*"];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(11, 1)];
    [_lblManuYear setAttributedText: text];
    
    _lblTranGear.font = [UIFont ayarFontWithSize:13.0f];
    _lblTranGear.text = @"Transmission (ဂီယာ)";
    _lblHandDrive.font = [UIFont ayarFontWithSize:13.0f];
    _lblHandDrive.text = @"Hand Drive";
    _lblEngPower.font = [UIFont ayarFontWithSize:13.0f];
    _lblEngPower.text = @"Engine Power";
    _lblFuel.font = [UIFont ayarFontWithSize:13.0f];
    _lblFuel.text = @"Fuel (ေလာင်စာ)";
    _lblMileage.font = [UIFont ayarFontWithSize:13.0f];
    _lblMileage.text = @"Mileage (ေမာင်းနှင်ြပီးကီလုိ)";
    _lblCarCondition.font = [UIFont ayarFontWithSize:13.0f];
    _lblCarCondition.text = @"Condition (ကားအေြခအေန)";
    _lblCarColor.font = [UIFont ayarFontWithSize:13.0f];
    _lblCarColor.text = @"Color";
    _lblSeater.font = [UIFont ayarFontWithSize:13.0f];
    _lblSeater.text = @"Seater";
    _lblSeatrow.font = [UIFont ayarFontWithSize:13.0f];
    _lblSeatrow.text = @"Seat Row";
    _lblLicense.font = [UIFont ayarFontWithSize:13.0f];
    _lblLicense.text = @"က.ည.န လုိင်စင် (တိုင်း/ြပည်နယ်)";
    _lblCountry.font = [UIFont ayarFontWithSize:13.0f];
    _lblCountry.text = @"Country";
    _lblEquipment.font = [UIFont ayarFontWithSize:13.0f];
    _lblEquipment.text = @"ပါဝင်ေသာ ပစ္စည်းများ";
    
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
    self.slip.delegate = self;
    self.negotiate.delegate = self;
    self.numberRorB.delegate = self;
    self.ownerbook.delegate = self;
    self.seater.delegate = self;
    self.seatrow.delegate = self;
    self.license.delegate = self;
    
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
    self.slip.inputAccessoryView = keyboardToolbar;
    self.negotiate.inputAccessoryView = keyboardToolbar;
    self.numberRorB.inputAccessoryView = keyboardToolbar;
    self.ownerbook.inputAccessoryView = keyboardToolbar;
    self.seater.inputAccessoryView = keyboardToolbar;
    self.seatrow.inputAccessoryView = keyboardToolbar;
    self.license.inputAccessoryView = keyboardToolbar;
    
    if (_mycarinfo) {
        _price.text = _mycarinfo.price;
        _vincode.text = _mycarinfo.carno;
        _milage.text = _mycarinfo.mileage;
        [_carImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://automobile.com.mm/%@",_mycarinfo.image]]];
        _lblMsg.hidden= YES;
    }
    
    self.slipPicker = [[UIPickerView alloc] init];
    self.slipPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.slipPicker.delegate = self;
    self.slipPicker.dataSource = self;
    self.slipPicker.showsSelectionIndicator = YES;
    self.slip.inputView = self.slipPicker;
    self.slipPickerArray = @[@{@"name": @"ပါျပီး", @"id": @"1"},@{@"name": @"မပါ", @"id": @"0"}];
    self.slip.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        if ([_mycarinfo.slip isEqualToString:@"1"]) {
            self.slip.text = self.slipPickerArray[0][@"name"];
            selectedslipIndex = self.slipPickerArray[0][@"id"];
        } else {
            self.slip.text = self.slipPickerArray[1][@"name"];
            selectedslipIndex = self.slipPickerArray[1][@"id"];
        }
        
    } else {
        self.slip.text = self.slipPickerArray[0][@"name"];
        selectedslipIndex = self.slipPickerArray[0][@"id"];
    }
    
    self.negoPicker = [[UIPickerView alloc] init];
    self.negoPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.negoPicker.delegate = self;
    self.negoPicker.dataSource = self;
    self.negoPicker.showsSelectionIndicator = YES;
    self.negotiate.inputView = self.negoPicker;
    self.negoPickerArray = @[@{@"name": @"ရ", @"id": @"1"},@{@"name": @"မရ", @"id": @"0"}];
    self.negotiate.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        if ([_mycarinfo.negotiate isEqualToString:@"1"]) {
            self.negotiate.text = self.slipPickerArray[0][@"name"];
            selectedNegoIndex = self.slipPickerArray[0][@"id"];
        } else {
            self.negotiate.text = self.slipPickerArray[1][@"name"];
            selectedNegoIndex = self.slipPickerArray[1][@"id"];
        }
        
    } else {
        self.negotiate.text = self.negoPickerArray[0][@"name"];
        selectedNegoIndex = self.negoPickerArray[0][@"id"];
    }

    self.numberRorBPicker = [[UIPickerView alloc] init];
    self.numberRorBPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberRorBPicker.delegate = self;
    self.numberRorBPicker.dataSource = self;
    self.numberRorBPicker.showsSelectionIndicator = YES;
    self.numberRorB.inputView = self.numberRorBPicker;
    self.numberRorBPickerArray = @[@"အနီ",@"အနက္"];
    self.numberRorB.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        if ([_mycarinfo.licenseno isEqualToString:@"red"]) {
            self.numberRorB.text = @"အနီ";
        } else {
            self.numberRorB.text = @"အနက္";
        }
        
    } else {
        self.numberRorB.text = @"အနီ";
    }
    
    self.ownerbookPicker = [[UIPickerView alloc] init];
    self.ownerbookPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.ownerbookPicker.delegate = self;
    self.ownerbookPicker.dataSource = self;
    self.ownerbookPicker.showsSelectionIndicator = YES;
    self.ownerbook.inputView = self.ownerbookPicker;
    self.ownerbookPickerArray = @[@"ထြက္ျပီး",@"မျပီးေသး"];
    self.ownerbook.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        if ([_mycarinfo.ownerbook isEqualToString:@"unfinish"]) {
            self.ownerbook.text = @"မျပီးေသး";
        } else {
            self.ownerbook.text = @"ထြက္ျပီး";
        }
        
    } else {
        self.ownerbook.text = @"ထြက္ျပီး";
    }

    self.manuYearPicker = [[UIPickerView alloc] init];
    self.manuYearPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.manuYearPicker.delegate = self;
    self.manuYearPicker.dataSource = self;
    self.manuYearPicker.showsSelectionIndicator = YES;
    self.manufacturedYear.inputView = self.manuYearPicker;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    int endyear = [yearString intValue];
    endyear++;
    NSMutableArray* muArr = [NSMutableArray new];
    for (int startyear=1988; startyear <= endyear; startyear++) {
        [muArr addObject:[NSString stringWithFormat:@"%d",startyear]];
    }
    self.manuYearPickerArray = [muArr copy];
    self.manufacturedYear.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        self.manufacturedYear.text = _mycarinfo.year;
        
    } else {
        self.manufacturedYear.text = @"1988";
    }
    
    self.licensePicker = [[UIPickerView alloc] init];
    self.licensePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.licensePicker.delegate = self;
    self.licensePicker.dataSource = self;
    self.licensePicker.showsSelectionIndicator = YES;
    self.license.inputView = self.licensePicker;
    self.licensePickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    self.license.font = [UIFont zawgyiOneFontWithSize:13.0f];
    
    self.seaterPicker = [[UIPickerView alloc] init];
    self.seaterPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.seaterPicker.delegate = self;
    self.seaterPicker.dataSource = self;
    self.seaterPicker.showsSelectionIndicator = YES;
    self.seater.inputView = self.seaterPicker;
    self.seaterPickerArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",];
    self.seater.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        self.seater.text = _mycarinfo.seater;
        
    } else {
        self.seater.text = self.seaterPickerArray[0];
    }
    
    self.seatrowPicker = [[UIPickerView alloc] init];
    self.seatrowPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.seatrowPicker.delegate = self;
    self.seatrowPicker.dataSource = self;
    self.seatrowPicker.showsSelectionIndicator = YES;
    self.seatrow.inputView = self.seatrowPicker;
    self.seatrowPickerArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",];
    self.seatrow.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) {
        self.seatrow.text = _mycarinfo.seatrow;
        
    } else {
        self.seatrow.text = self.seatrowPickerArray[0];
    }
    
    self.enginepowerPicker = [[UIPickerView alloc] init];
    self.enginepowerPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.enginepowerPicker.delegate = self;
    self.enginepowerPicker.dataSource = self;
    self.enginepowerPicker.showsSelectionIndicator = YES;
    self.enginePower.inputView = self.enginepowerPicker;
    self.enginepowerArray =  @[@{@"name": @"No Data", @"id": @"0"}];
    self.enginePower.font = [UIFont zawgyiOneFontWithSize:13.0f];
    
    self.brandPicker = [[UIPickerView alloc] init];
    self.brandPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.brandPicker.delegate = self;
    self.brandPicker.dataSource = self;
    self.brandPicker.showsSelectionIndicator = YES;
    self.brand.inputView = self.brandPicker;
    self.brandPickerArray = [db executeQuery:[NSString stringWithFormat:@"select * from CarBrand where catid = '%@' order by name asc", self.selectedCategory[@"id"]]];
    if(self.brandPickerArray.count == 0) self.brandPickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    [self reloadCarBrandWithCatId:[self.selectedCategory[@"id"] intValue]];
    
    self.modelPickerView = [[UIPickerView alloc] init];
    self.modelPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modelPickerView.delegate = self;
    self.modelPickerView.dataSource = self;
    self.modelPickerView.showsSelectionIndicator = YES;
    self.model.inputView = self.modelPickerView;
    self.modelArray = [db executeQuery:@"select * from CarModel"];
    int count = self.modelArray.count;
    if(self.modelArray.count == 0) self.modelArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.bodyTypePicker = [[UIPickerView alloc] init];
    self.bodyTypePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyTypePicker.delegate = self;
    self.bodyTypePicker.dataSource = self;
    self.bodyTypePicker.showsSelectionIndicator = YES;
    self.bodyType.inputView = self.bodyTypePicker;
    self.bodyTypePickerArray = [db executeQuery:@"select * from CarBodyType"];
    if(self.bodyTypePickerArray.count == 0) self.bodyTypePickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.gearPicker = [[UIPickerView alloc] init];
    self.gearPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.gearPicker.delegate = self;
    self.gearPicker.dataSource = self;
    self.gearPicker.showsSelectionIndicator = YES;
    self.gearType.inputView = self.gearPicker;
    self.gearPickerArray = [db executeQuery:@"select * from CarGearType"];
    if(self.gearPickerArray.count == 0) self.gearPickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.petrolPicker = [[UIPickerView alloc] init];
    self.petrolPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.petrolPicker.delegate = self;
    self.petrolPicker.dataSource = self;
    self.petrolPicker.showsSelectionIndicator = YES;
    self.petrolType.inputAccessoryView = keyboardToolbar;
    self.petrolType.inputView = self.petrolPicker;
    self.petrolPickerArray = [db executeQuery:@"select * from CarFuel"];
    if(self.petrolPickerArray.count == 0) self.petrolPickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.conditionPicker = [[UIPickerView alloc] init];
    self.conditionPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.conditionPicker.delegate = self;
    self.conditionPicker.dataSource = self;
    self.conditionPicker.showsSelectionIndicator = YES;
    self.condition.inputView = self.conditionPicker;
    self.conditionPickerArray = [db executeQuery:@"select * from CarCondition"];
    if(self.conditionPickerArray.count == 0) self.conditionPickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.colorPicker = [[UIPickerView alloc] init];
    self.colorPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.colorPicker.delegate = self;
    self.colorPicker.dataSource = self;
    self.colorPicker.showsSelectionIndicator = YES;
    self.color.inputView = self.colorPicker;
    self.colorPickerArray = [db executeQuery:@"select * from CarColor"];
    if(self.colorPickerArray.count == 0) self.colorPickerArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.drivePickerView = [[UIPickerView alloc] init];
    self.drivePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.drivePickerView.delegate = self;
    self.drivePickerView.dataSource = self;
    self.drivePickerView.showsSelectionIndicator = YES;
    self.drive.inputView = self.drivePickerView;
    self.driveArray = @[@"left",@"right"];
    self.drive.font = [UIFont zawgyiOneFontWithSize:13.0f];
    if (_mycarinfo) self.drive.text = _mycarinfo.handdrive;
    else self.drive.text = @"left";
    
    //[db executeQuery:@"select * from CarDrive"];
//    if(self.driveArray.count == 0) self.driveArray = @[@{@"name": @"No Data", @"id": @"0"}];
    
    self.countryPickerView = [[UIPickerView alloc] init];
    self.countryPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryPickerView.delegate = self;
    self.countryPickerView.dataSource = self;
    self.countryPickerView.showsSelectionIndicator = YES;
    self.country.inputView = self.countryPickerView;
    self.countryArray = @[@"Myanmar"];
    self.country.text = @"Myanmar";
    
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
    if(self.equipmentArray.count == 0) self.equipmentArray = @[@{@"name": @"No Data", @"id": @"0"}];
    selectedEquipment = [NSMutableArray array];
    
    if (self.reachable) {
        [CarAssociation getCarAssociation:^(CarAssociation *association, NSError *error)
        {
            if (!error) {
//                [self setupTable:@"CarCountry" object:association.country];
//                self.countryArray = [self retrieveFromTable:@"CarCountry"];
//                [self.countryPickerView reloadAllComponents];
//                [self.country reloadInputViews];
                
//                [self setupTable:@"CarCondition" object:association.condition];
                self.conditionPickerArray = association.condition;
                if (_mycarinfo) {
                    _condition.text = _mycarinfo.condition;
                    selectedConditionIndex = @([_mycarinfo.conditionid integerValue]);
                } else {
                    _condition.text = self.conditionPickerArray[0][@"name"];
                    selectedConditionIndex = self.conditionPickerArray[0][@"id"];
                }
                [self.conditionPicker reloadAllComponents];
                [self.condition reloadInputViews];
                
//                [self setupTable:@"CarBodyType" object:association.bodytype];
                self.bodyTypePickerArray = association.bodytype;
                if (_mycarinfo) {
                    _bodyType.text = _mycarinfo.bodytype;
                    selectedBodyIndex = @([_mycarinfo.bodyid integerValue]);
                } else {
                    _bodyType.text = self.bodyTypePickerArray[0][@"name"];
                    selectedBodyIndex = self.bodyTypePickerArray[0][@"id"];
                }
                [self.bodyTypePicker reloadAllComponents];
                [self.bodyType reloadInputViews];
                
//                [self setupTable:@"CarFuel" object:association.fuel];
                self.petrolPickerArray = association.fuel;
                if (_mycarinfo) {
                    _petrolType.text = _mycarinfo.fuel;
                    selectedFuelIndex = @([_mycarinfo.fuelid integerValue]);
                } else {
                    _petrolType.text = self.petrolPickerArray[0][@"name"];
                    selectedFuelIndex = self.petrolPickerArray[0][@"id"];
                }
                [self.petrolPicker reloadAllComponents];
                [self.petrolType reloadInputViews];
                
//                [self setupTable:@"CarGearType" object:association.trans];
                self.gearPickerArray = association.trans;
                if (_mycarinfo) {
                    _gearType.text = _mycarinfo.transmission;
                    selectedTransIndex = @([_mycarinfo.transmissionid integerValue]);
                } else {
                    _gearType.text = self.gearPickerArray[0][@"name"];
                    selectedTransIndex = self.gearPickerArray[0][@"id"];
                }
                [self.gearPicker reloadAllComponents];
                [self.gearType reloadInputViews];
                
//                [self setupTable:@"CarEquipment" object:association.equipment];
                self.equipmentArray = association.equipment;
                if (_mycarinfo) {
                    for (NSDictionary* equipdict in _mycarinfo.equipments) {
                        [selectedEquipment addObject:equipdict];
                    }
                    NSMutableString *equipments = [NSMutableString string];
                    for (NSDictionary *equipment in selectedEquipment) {
                        [equipments appendFormat:@"%@, ", equipment[@"name"]];
                    }
                    self.otherInfos.text = equipments;
                }
                [self.equipmentTableView reloadData];
                [self.otherInfos reloadInputViews];
                
                self.licensePickerArray = association.country;
                if (_mycarinfo) {
                    _license.text = _mycarinfo.city;
                    selectedLicenseIndex = @([_mycarinfo.cityid integerValue]);
                } else {
                    _license.text = self.licensePickerArray[0][@"name"];
                    selectedLicenseIndex = self.licensePickerArray[0][@"id"];
                }
                [self.licensePicker reloadAllComponents];
                [self.license reloadInputViews];
                
//                [self setupTable:@"CarColor" object:association.color];
                self.colorPickerArray = association.color;
                if (_mycarinfo) {
                    _color.text = _mycarinfo.color;
                    selectedColorIndex = @([_mycarinfo.colorid integerValue]);
                } else {
                    _color.text = self.colorPickerArray[0][@"name"];
                    selectedColorIndex = self.colorPickerArray[0][@"id"];
                }
                [self.colorPicker reloadAllComponents];
                [self.color reloadInputViews];
            }            
        }];
        
        [CarAssociation getEnginePower:^(NSArray *brands, NSError *error) {
            self.enginepowerArray = brands;
            if (_mycarinfo) {
                self.enginePower.text = _mycarinfo.enginepower;
                selectedEngPower = @([_mycarinfo.enginepower_id integerValue]);
            } else {
                self.enginePower.text = self.enginepowerArray[0][@"name"];
                selectedEngPower = self.enginepowerArray[0][@"id"];
            }
            [self.enginepowerPicker reloadAllComponents];
            [self.enginePower reloadInputViews];
        }];
    } else {
        [self retrieveCarBrandsFromDatabaseWithCatId:[self.selectedCategory[@"id"] intValue]];
        if ([self.brandPickerArray.firstObject isKindOfClass:[CarBrand class]]) {
            CarBrand *brand = self.brandPickerArray.firstObject;
            [self retrieveCarModelsFromDatabaseWithMakeId:brand.id];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Car Upload";

}

- (void)setBackBtn
{
    self.navigationItem.backBarButtonItem = nil;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back_unselected.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateSelected];
    button.adjustsImageWhenDisabled = NO;
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)dismissThisView
{
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)setupBackButton
//{
//    self.tabBarController.navigationItem.hidesBackButton = YES;
//    UIImage *buttonImage = [UIImage imageNamed:@"back_unselected.png"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"back_selected.png"] forState:UIControlStateHighlighted];
//    button.adjustsImageWhenDisabled = NO;
//    button.frame = CGRectMake(0, 0, 30, 30);
//    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.tabBarController.navigationItem.leftBarButtonItem = customBarItem;
//}

- (void)turnBackToMeCarListVC{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[MeCarList class]]) {
            
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
        else if ([controller isKindOfClass:[BuyCarListVC class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
    
}

- (void) saveCar
{
    if (!(_lblMsg.hidden && (_price.text.length > 0))) {
        NSLog(@"No Photo or Price");
        return;
    }
    NSString* licensetxt;
    if ([_license.text isEqualToString:@"အနီ"]) {
        licensetxt = @"Red";
    } else licensetxt = @"Black";
    
    NSString* ownerbook;
    if ([_ownerbook.text isEqualToString:@"ထြက္ျပီး"]) {
        ownerbook = @"Finish";
    } else ownerbook = @"Unfinish";
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    self.parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       self.selectedCategory[@"id"] , @"catid",
                      _price.text,@"price",
                       selectedslipIndex,@"slip",
                       selectedNegoIndex,@"negotiate",
                       licensetxt,@"licenseno",
                       userInfo[@"userid"],@"user",
                       ownerbook,@"ownerbook",
                       _vincode.text,@"carno",
                       selectedBrandIndex,@"make",
                       selectedModelIndex,@"model",
                       selectedBodyIndex,@"bodytype",
                       _manufacturedYear.text,@"year",
                       selectedTransIndex,@"trans",
                       _drive.text,@"handdrive",
                       selectedEngPower,@"engine",
                       selectedFuelIndex,@"fuel",
                       _milage.text,@"mileage",
                       selectedConditionIndex,@"condition",
                       selectedColorIndex,@"color",
                       _seater.text,@"seater",
                       _seatrow.text,@"seatrow",
                       selectedLicenseIndex,@"city",
                       _country.text,@"country",
                       @"",@"eqiupments",
                       @"",@"attachfile",
                       @"",@"description",
                       nil];
//    if (selectedBrandIndex != 0) {
//        self.parameters[@"make"] = selectedBrandIndex;
//    }
//    if (selectedModelIndex != 0) {
//        self.parameters[@"model"] = selectedModelIndex;
//    }
//    if (selectedCountryIndex != 0) {
//        self.parameters[@"country"] = selectedCountryIndex;
//    }
//    if (selectedConditionIndex != 0) {
//        self.parameters[@"condition"] = selectedConditionIndex;
//    }
    // add user
//    if (selectedBodyIndex != 0) {
//        self.parameters[@"bodytype"] = selectedBodyIndex;
//    }
//    if (selectedDriveIndex != 0) {
//        self.parameters[@"drive"] = selectedDriveIndex;
//    }
//    if (selectedFuelIndex != 0) {
//        self.parameters[@"fuel"] = selectedFuelIndex;
//    }
//    if (selectedTransIndex != 0) {
//        self.parameters[@"trans"] = selectedTransIndex;
//    }
    if (selectedEquipment.count > 0) {
        NSMutableString *equipments = [NSMutableString string];
        for (int i =0; i<selectedEquipment.count;i++) {
            NSDictionary *equipment = selectedEquipment[i];
            if (i == selectedEquipment.count-1) {
                [equipments appendFormat:@"%d", [equipment[@"id"] intValue]];
            }
            else [equipments appendFormat:@"%d, ", [equipment[@"id"] intValue]];
        }
        self.parameters[@"eqiupments"] = equipments;
    }
//    if (![self.manufacturedYear.text isEqualToString:@""]) {
//        self.parameters[@"year"] = self.manufacturedYear.text;
//    }
//    if (![self.vincode.text isEqualToString:@""]) {
//        self.parameters[@"vincode"] = self.vincode.text;
//    }
//    if (![self.milage.text isEqualToString:@""]) {
//        self.parameters[@"mileage"] = self.milage.text;
//    }
//    if (![self.price.text isEqualToString:@""]) {
//        self.parameters[@"price"] = self.price.text;
//    }
//    if (selectedColorIndex != 0) {
//        self.parameters[@"extcolor"] = selectedColorIndex;
//    }
//    if (![self.enginePower.text isEqualToString:@""]) {
//        self.parameters[@"engine"] = self.enginePower.text;
//    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]) {
        if (_mycarinfo) {
            [self JDStatusBarHidden:NO status:@"Updating..." duration:0];
            [self uploadImage:^(NSString *photoname, NSError *error) {
                if (!error) {
                    self.parameters[@"attachfile"] = photoname;
                    [Car updateMyCar:self.parameters withcarid:_mycarinfo.id block:^(NSDictionary *status, NSError *error) {
                        if (!error) {
                            //                        [self.navigationController popViewControllerAnimated:YES];
//                            [self gotoMyCarListView];
//                            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                            MeCarList *vc = [sb instantiateViewControllerWithIdentifier:@"MeCarList"];
//
//                            [self.navigationController popToViewController:vc animated:YES];
                            
//                            NSArray *array = [self.navigationController viewControllers];
//                            
//                            [self.navigationController popToViewController:[array objectAtIndex:3] animated:YES];
                            
                            [self turnBackToMeCarListVC];
                        }
                        [self JDStatusBarHidden:YES status:@"" duration:0];
                    }];
                }
            }];

        } else {
            [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
            [self uploadImage:^(NSString *photoname, NSError *error) {
                if (!error) {
                    self.parameters[@"attachfile"] = photoname;
                    [Car postCarWithParameters:self.parameters block:^(NSError *error) {
                        if (!error) {
                            //                        [self.navigationController popViewControllerAnimated:YES];
                            [self gotoMyCarListView];
                        }
                        [self JDStatusBarHidden:YES status:@"" duration:0];
                    }];
                }
            }];
        }
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
        
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://automobile.com.mm/"]];
        
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
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Upload image" message:@"Please upload an image of the car." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self JDStatusBarHidden:YES status:@"" duration:0];
    }
}

- (void) reloadCarBrandWithCatId:(int)catid
{
    [self JDStatusBarHidden:NO status:@"Fetching car brands..." duration:0];
    [self retrieveCarBrandsFromDatabaseWithCatId:catid];
    __weak typeof(self) weakSelf = self;
    [CarBrand getCarBrandsWithCatId:catid block:^(NSArray *brands, NSError *error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if(!error && brands.count > 0) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                CarBrand *brand = brands.firstObject;
                ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
                [db createCarBrandTable:brand];
                [db executeUpdate:[NSString stringWithFormat:@"delete from CarBrand where id = '%d'", brand.id]];
                for (CarBrand *brand in brands) {
                    [db insertCarBrandIntoTable:brand];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [strongSelf retrieveCarBrandsFromDatabaseWithCatId:catid];
                });
                [strongSelf JDStatusBarHidden:NO status:@"Car brand data was updated!" duration:1.0];
//                if (_modelArray.count == 0) {
                    [strongSelf reloadCarModelWithMakeId:brand.id];
//                }
                
            });
        }
        [strongSelf JDStatusBarHidden:YES status:nil duration:0];
    }];
}

- (void) reloadCarModelWithMakeId:(int)makeid
{
    [self JDStatusBarHidden:NO status:@"Fetching car models..." duration:0];
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
//                [db executeUpdate:@"delete from CarModel"];
                for (CarModel *model in models) {
                    [db executeUpdate:[NSString stringWithFormat:@"delete from CarModel where id = '%d'", model.id]];
                    [db insertCarModelIntoTable:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
//                    [strongSelf retrieveCarModelsFromDatabaseWithMakeId:selectedBrandIndex.intValue];
                });
            });
        }
//        [self hideHud];
        if (models.count > 0) {
//             [strongSelf retrieveCarModelsFromDatabaseWithMakeId:selectedBrandIndex.intValue];
            [strongSelf JDStatusBarHidden:NO status:@"Car model data was updated!" duration:1.0];
        }
        else self.modelArray = @[@{@"name": @"No Data", @"id": @"0"}];
    }];
}

- (void) retrieveCarBrandsFromDatabaseWithCatId:(int)catid
{
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    NSArray *brandList = [db executeQuery:[NSString stringWithFormat:@"select * from CarBrand order by name asc"]];
    NSMutableArray *brands = [NSMutableArray array];
    for (NSDictionary *dict in brandList) {
        CarBrand *brand = [[CarBrand alloc] initWithDictionary:dict error:nil];
        [brands addObject:brand];
    }
    if (brands.count > 0) {
        self.brandPickerArray = brands;
        CarBrand* brand = self.brandPickerArray[0];
        if (_mycarinfo) {
            self.brand.text = _mycarinfo.make;
            selectedBrandIndex = @([_mycarinfo.makeid integerValue]);
        } else {
            self.brand.text = brand.name;
            selectedBrandIndex = @(brand.id);
        }
        [self.brandPicker reloadAllComponents];
        [self.brandPicker reloadInputViews];
        
        [self retrieveCarModelsFromDatabaseWithMakeId:selectedBrandIndex.intValue];
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
        
        if (_mycarinfo) {
            self.model.text = _mycarinfo.model;
            selectedModelIndex = @([_mycarinfo.modelid integerValue]);
        } else {
            self.model.text = self.modelArray[0][@"name"];
            NSLog(@"Car model = %@",self.model.text);
            selectedModelIndex = self.modelArray[0][@"id"];
        }
        [self.modelPickerView reloadAllComponents];
        [self.model reloadInputViews];
    }
    else {
        self.modelArray = @[@{@"name": @"No Data", @"id": @"0"}];
        [self.modelPickerView reloadAllComponents];
        [self.model reloadInputViews];

    }
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

- (void) showHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}

- (void) hideHud
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

- (void) previousTextField
{
    if(self.price.isFirstResponder) [self.price resignFirstResponder];
    else if(self.slip.isFirstResponder) [self.price becomeFirstResponder];
    else if(self.negotiate.isFirstResponder) [self.slip becomeFirstResponder];
    else if(self.numberRorB.isFirstResponder) [self.negotiate becomeFirstResponder];
    else if(self.ownerbook.isFirstResponder) [self.numberRorB becomeFirstResponder];
    else if(self.vincode.isFirstResponder) [self.ownerbook becomeFirstResponder];
    else if(self.brand.isFirstResponder) [self.vincode becomeFirstResponder];
    else if(self.model.isFirstResponder) [self.brand becomeFirstResponder];
    else if(self.bodyType.isFirstResponder) [self.model becomeFirstResponder];
    else if(self.manufacturedYear.isFirstResponder) [self.bodyType becomeFirstResponder];
    else if(self.gearType.isFirstResponder) [self.manufacturedYear becomeFirstResponder];
    else if(self.drive.isFirstResponder) [self.gearType becomeFirstResponder];
    else if(self.enginePower.isFirstResponder) [self.drive becomeFirstResponder];
    else if(self.petrolType.isFirstResponder) [self.enginePower becomeFirstResponder];
    else if(self.milage.isFirstResponder) [self.petrolType becomeFirstResponder];
    else if(self.condition.isFirstResponder) [self.milage becomeFirstResponder];
    else if(self.color.isFirstResponder) [self.condition becomeFirstResponder];
    else if(self.seater.isFirstResponder) [self.color becomeFirstResponder];
    else if(self.seatrow.isFirstResponder) [self.seater becomeFirstResponder];
    else if(self.license.isFirstResponder) [self.seatrow becomeFirstResponder];
    else if(self.country.isFirstResponder) [self.license becomeFirstResponder];
    else if(self.otherInfos.isFirstResponder) [self.country becomeFirstResponder];
}

- (void) nextTextField
{
    if(self.price.isFirstResponder) [self.slip becomeFirstResponder];
    else if(self.slip.isFirstResponder) [self.negotiate becomeFirstResponder];
    else if(self.negotiate.isFirstResponder) [self.numberRorB becomeFirstResponder];
    else if(self.numberRorB.isFirstResponder) [self.ownerbook becomeFirstResponder];
    else if(self.ownerbook.isFirstResponder) [self.vincode becomeFirstResponder];
    else if(self.vincode.isFirstResponder) [self.brand becomeFirstResponder];
    else if(self.brand.isFirstResponder) [self.model becomeFirstResponder];
    else if(self.model.isFirstResponder) [self.bodyType becomeFirstResponder];
    else if(self.bodyType.isFirstResponder) [self.manufacturedYear becomeFirstResponder];
    else if(self.manufacturedYear.isFirstResponder) [self.gearType becomeFirstResponder];
    else if(self.gearType.isFirstResponder) [self.drive becomeFirstResponder];
    else if(self.drive.isFirstResponder) [self.enginePower becomeFirstResponder];
    else if(self.enginePower.isFirstResponder) [self.petrolType becomeFirstResponder];
    else if(self.petrolType.isFirstResponder) [self.milage becomeFirstResponder];
    else if(self.milage.isFirstResponder) [self.condition becomeFirstResponder];
    else if(self.condition.isFirstResponder) [self.color becomeFirstResponder];
    else if(self.color.isFirstResponder) [self.seater becomeFirstResponder];
    else if(self.seater.isFirstResponder) [self.seatrow becomeFirstResponder];
    else if(self.seatrow.isFirstResponder) [self.license becomeFirstResponder];
    else if(self.license.isFirstResponder) [self.country becomeFirstResponder];
    else if(self.country.isFirstResponder) [self.otherInfos becomeFirstResponder];
    else if(self.otherInfos.isFirstResponder) [self.otherInfos resignFirstResponder];
    
}

- (void) doneEditing
{
    if(self.price.isFirstResponder) [self.price resignFirstResponder];
    if(self.vincode.isFirstResponder) [self.vincode resignFirstResponder];
    if(self.brand.isFirstResponder ) {
        [self.brand resignFirstResponder];
        
        NSString* strText = self.brand.text;
        if (![previousCarBrand isEqualToString:strText]) {
            self.model.text = @"";
            previousCarBrand = strText;
        }
        
        if([self.brand.text isEqualToString:@""]) {
            if ([self.brandPickerArray[0] isKindOfClass:[CarBrand class]]) {
                self.brand.text = [(CarBrand *)self.brandPickerArray[0] name];
                selectedBrandIndex = @([(CarBrand *)self.brandPickerArray[0] id]);

            }
            else {
                self.brand.text = self.brandPickerArray[0] [@"name"];
                selectedBrandIndex = self.brandPickerArray[0] [@"id"];
            }
        }
        
        
        [self retrieveCarModelsFromDatabaseWithMakeId:selectedBrandIndex.intValue];
//        [self reloadCarModelWithMakeId:selectedBrandIndex.intValue];
    }
    if(self.model.isFirstResponder) {
        [self.model resignFirstResponder];
        if([self.model.text isEqualToString:@""]) {
            self.model.text = self.modelArray[0][@"name"];
            selectedModelIndex = @([self.modelArray[0][@"id"] intValue]);
        }
    }
    if(self.bodyType.isFirstResponder) {
        [self.bodyType resignFirstResponder];
        if([self.bodyType.text isEqualToString:@""]) {
            self.bodyType.text = self.bodyTypePickerArray[0][@"name"];
            selectedBodyIndex = self.bodyTypePickerArray[0][@"id"];
        }
    }
    if(self.gearType.isFirstResponder) {
        [self.gearType resignFirstResponder];
        if([self.gearType.text isEqualToString:@""]) {
            self.gearType.text = self.gearPickerArray[0][@"name"];
            selectedTransIndex = self.gearPickerArray[0][@"id"];
        }
    }
    if(self.enginePower.isFirstResponder) {
        [self.enginePower resignFirstResponder];
//        if([self.enginePower.text isEqualToString:@""]) {
//            self.enginePower.text = self.gearPickerArray[0][@"name"];
//            selectedEngPower = self.gearPickerArray[0][@"id"];
//        }
    }
    if(self.petrolType.isFirstResponder) {
        [self.petrolType resignFirstResponder];
        if([self.petrolType.text isEqualToString:@""]) {
            self.petrolType.text = self.petrolPickerArray[0][@"name"];
            selectedFuelIndex = self.petrolPickerArray[0][@"id"];
        }
    }
    if(self.milage.isFirstResponder) [self.milage resignFirstResponder];
    if(self.condition.isFirstResponder) {
        [self.condition resignFirstResponder];
        if([self.condition.text isEqualToString:@""]) {
            self.condition.text = self.conditionPickerArray[0][@"name"];
            selectedConditionIndex = self.conditionPickerArray[0][@"id"];
        }
    }
    if(self.color.isFirstResponder) {
        [self.color resignFirstResponder];
        if([self.color.text isEqualToString:@""]) {
            self.color.text = self.colorPickerArray[0][@"name"];
            selectedColorIndex = self.colorPickerArray[0][@"id"];
        }
    }
    if(self.manufacturedYear.isFirstResponder) [self.manufacturedYear resignFirstResponder];
    if(self.otherInfos.isFirstResponder) [self.otherInfos resignFirstResponder];
    if(self.drive.isFirstResponder) {
        [self.drive resignFirstResponder];
//        if([self.drive.text isEqualToString:@""]) {
//            self.drive.text = self.driveArray[0][@"name"];
//            selectedDriveIndex = self.driveArray[0][@"id"];
//        }
    }
    if(self.country.isFirstResponder) {
        [self.country resignFirstResponder];
        if([self.country.text isEqualToString:@""]) {
//            self.country.text = self.countryArray[0][@"name"];
//            selectedCountryIndex = self.countryArray[0][@"id"];
            self.country.text = @"Myanmar";
        }
    }
    if (self.slip.isFirstResponder) {
        [self.slip resignFirstResponder];
    }
    if (self.negotiate.isFirstResponder) {
        [self.negotiate resignFirstResponder];
    }
    if (self.numberRorB.isFirstResponder) {
        [self.numberRorB resignFirstResponder];
    }
    if (self.ownerbook.isFirstResponder) {
        [self.ownerbook resignFirstResponder];
    }
    if (self.seater.isFirstResponder) {
        [self.seater resignFirstResponder];
    }
    if (self.seatrow.isFirstResponder) {
        [self.seatrow resignFirstResponder];
    }
    if (self.license.isFirstResponder) {
        [self.license resignFirstResponder];
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
    _lblMsg.hidden = YES;
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
    else if(pickerView == self.modelPickerView) count = self.modelArray.count;
    else if(pickerView == self.drivePickerView) count = self.driveArray.count;
    else if(pickerView == self.countryPickerView) count = self.countryArray.count;
    else if (pickerView == self.slipPicker) count = self.slipPickerArray.count;
    else if(pickerView == self.negoPicker) count = self.negoPickerArray.count;
    else if (pickerView == self.numberRorBPicker) count = self.numberRorBPickerArray.count;
    else if(pickerView == self.ownerbookPicker) count = self.ownerbookPickerArray.count;
    else if (pickerView == self.seaterPicker) count = self.seaterPickerArray.count;
    else if (pickerView == self.seatrowPicker) count = self.seatrowPickerArray.count;
    else if (pickerView == self.enginepowerPicker) count = self.enginepowerArray.count;
    else if (pickerView == self.licensePicker) count = self.licensePickerArray.count;
    else if (pickerView == self.manuYearPicker) count = self.manuYearPickerArray.count;
    return count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *title;
//    if(pickerView == self.bodyTypePicker) title = self.bodyTypePickerArray[row][@"name"];
//    else if(pickerView == self.colorPicker) title = self.colorPickerArray[row][@"name"];
//    else if(pickerView == self.brandPicker) {
//        if ([self.brandPickerArray[row] isKindOfClass:[CarBrand class]]) {
//            title = [(CarBrand *)self.brandPickerArray[row] name];
//        }
//        else {
//            title = self.brandPickerArray[row][@"name"];
//        }
//        //////SMT
//    }
//    else if(pickerView == self.gearPicker) title = self.gearPickerArray[row][@"name"];
//    else if(pickerView == self.conditionPicker) title = self.conditionPickerArray[row][@"name"];
//    else if(pickerView == self.petrolPicker) title = self.petrolPickerArray[row][@"name"];
//    else if(pickerView == self.modelPickerView) title = self.modelArray[row][@"name"];
////    {
////        NSDictionary *model = self.modelArray[row];
////        if (model) {
////            title = model[@"name"];
////        }
////        else title = @"NO DATA";
////        
////    }
//    else if(pickerView == self.drivePickerView) title = self.driveArray[row][@"name"];
//    else if(pickerView == self.countryPickerView) title = self.countryArray[row][@"name"];
////    else if (pickerView == self.slipPicker) {
////        title = self.slipPickerArray[row];
////        title.
////    }
//    return title;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont zawgyiOneFontWithSize:13.0f]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    
    if (pickerView == self.slipPicker) {
        tView.text = self.slipPickerArray[row][@"name"];
        
    }
    else if (pickerView == self.negoPicker) {
        tView.text = self.negoPickerArray[row][@"name"];
    }
    else if(pickerView == self.bodyTypePicker) tView.text = self.bodyTypePickerArray[row][@"name"];
    else if(pickerView == self.colorPicker) tView.text = self.colorPickerArray[row][@"name"];
    else if(pickerView == self.brandPicker) {
        if ([self.brandPickerArray[row] isKindOfClass:[CarBrand class]]) {
            tView.text = [(CarBrand *)self.brandPickerArray[row] name];
        }
        else {
            tView.text = self.brandPickerArray[row][@"name"];
        }
        //////SMT
    }
    else if(pickerView == self.gearPicker) tView.text = self.gearPickerArray[row][@"name"];
    else if(pickerView == self.conditionPicker) tView.text = self.conditionPickerArray[row][@"name"];
    else if(pickerView == self.petrolPicker) tView.text = self.petrolPickerArray[row][@"name"];
    else if(pickerView == self.modelPickerView) tView.text = self.modelArray[row][@"name"];
    //    {
    //        NSDictionary *model = self.modelArray[row];
    //        if (model) {
    //            title = model[@"name"];
    //        }
    //        else title = @"NO DATA";
    //
    //    }
    else if(pickerView == self.drivePickerView) tView.text = self.driveArray[row];
    else if(pickerView == self.countryPickerView) tView.text = self.countryArray[row];
    else if(pickerView == self.numberRorBPicker) tView.text = self.numberRorBPickerArray[row];
    else if (pickerView == self.ownerbookPicker) tView.text = self.ownerbookPickerArray[row];
    else if (pickerView == self.seaterPicker) tView.text = self.seaterPickerArray[row];
    else if (pickerView == self.seatrowPicker) tView.text = self.seatrowPickerArray[row];
    else if (pickerView == self.enginepowerPicker) tView.text = self.enginepowerArray[row][@"name"];
    else if (pickerView == self.licensePicker) tView.text = self.licensePickerArray[row][@"name"];
    else if (pickerView == self.manuYearPicker) tView.text = self.manuYearPickerArray[row];

    return tView;
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
        self.drive.text = self.driveArray[row];
//        selectedDriveIndex = self.driveArray[row][@"id"];
    } else if(pickerView == self.countryPickerView) {
        self.country.text = self.countryArray[row];
//        selectedCountryIndex = self.countryArray[row][@"id"];
    } else if (pickerView == self.slipPicker) {
        self.slip.text = self.slipPickerArray[row][@"name"];
        selectedslipIndex = self.slipPickerArray[row][@"id"];
    } else if (pickerView == self.negoPicker) {
        self.negotiate.text = self.negoPickerArray[row][@"name"];
        selectedNegoIndex = self.negoPickerArray[row][@"id"];
    } else if (pickerView == self.numberRorBPicker) {
        self.numberRorB.text = self.numberRorBPickerArray[row];
    } else if (pickerView == self.ownerbookPicker) {
        self.ownerbook.text = self.ownerbookPickerArray[row];
    } else if (pickerView == self.seaterPicker) {
        self.seater.text = self.seaterPickerArray[row];
    } else if (pickerView == self.seaterPicker) {
        self.seatrow.text = self.seatrowPickerArray[row];
    } else if(pickerView == self.enginepowerPicker) {
        self.enginePower.text = self.enginepowerArray[row][@"name"];
        selectedEngPower = self.enginepowerArray[row][@"id"];
    } else if(pickerView == self.licensePicker) {
        self.license.text = self.licensePickerArray[row][@"name"];
        selectedLicenseIndex = self.licensePickerArray[row][@"id"];
    } else if(pickerView == self.manuYearPicker) {
        self.manufacturedYear.text = self.manuYearPickerArray[row];
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
    cell.textLabel.text = self.equipmentArray[indexPath.row][@"name"];
    
    for (NSDictionary *equDict in selectedEquipment) {
        if ([self.equipmentArray[indexPath.row][@"name"] isEqualToString:equDict[@"name"]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedEquipment addObject:self.equipmentArray[indexPath.row]];
    NSMutableString *equipments = [NSMutableString string];
    for (NSDictionary *equipment in selectedEquipment) {
        [equipments appendFormat:@"%@, ", equipment[@"name"]];
    }
    self.otherInfos.text = equipments;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedEquipment removeObjectIdenticalTo:self.equipmentArray[indexPath.row]];
    NSMutableString *equipments = [NSMutableString string];
    for (NSDictionary *equipment in selectedEquipment) {
        [equipments appendFormat:@"%@, ", equipment[@"name"]];
    }
    self.otherInfos.text = equipments;
}

- (IBAction)SubmitCar:(id)sender {
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];

    if (self.reachable) {
        [self saveCar];
    } else [self JDStatusBarHidden:NO status:@"No internet connection." duration:3.0f];
    
}

- (void)gotoMyCarListView
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    NSDictionary *parameters = @{@"userid": userInfo[@"userid"],
                                 @"offset": @"1",
                                 @"limit": @1000000
                                 };
    [self JDStatusBarHidden:NO status:@"Fetching cars list..." duration:0];
    [MyCar getMyCarsList:parameters block:^(NSArray *cars, NSError *error) {
        if(!error && cars.count > 0) {
            [self JDStatusBarHidden:YES status:@"" duration:0];
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            MeCarList *vc = [sb instantiateViewControllerWithIdentifier:@"MeCarList"];
            vc.cars = cars.mutableCopy;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self JDStatusBarHidden:NO status:@"Error retrieving car list. Try again later." duration:2];
        }
    }];

}

- (IBAction)onBtnSlipClicked:(id)sender {
    [_slip becomeFirstResponder];
}
- (IBAction)onBtnNegoClicked:(id)sender {
    [_negotiate becomeFirstResponder];
}
- (IBAction)onBtnNumberRorBClicked:(id)sender {
    [_numberRorB becomeFirstResponder];
}
- (IBAction)onBtnOwnerBookClicked:(id)sender {
    [_ownerbook becomeFirstResponder];
}
- (IBAction)onBtnBrandClicked:(id)sender {
    [_brand becomeFirstResponder];
}
- (IBAction)onBtnModelClicked:(id)sender {
    [_model becomeFirstResponder];
}
- (IBAction)onBtnBTypeClicked:(id)sender {
    [_bodyType becomeFirstResponder];
}
- (IBAction)onBtnManuYearClicked:(id)sender {
    [_manufacturedYear becomeFirstResponder];
}
- (IBAction)onBtnTranClicked:(id)sender {
    [_gearType becomeFirstResponder];
}
- (IBAction)onBtnDriveClicked:(id)sender {
    [_drive becomeFirstResponder];
}
- (IBAction)onBtnEngPowClicked:(id)sender {
    [_enginePower becomeFirstResponder];
}
- (IBAction)onFuelClicked:(id)sender {
    [_petrolType becomeFirstResponder];
}
- (IBAction)onBtnConClicked:(id)sender {
    [_condition becomeFirstResponder];
}
- (IBAction)onBtnColorClicked:(id)sender {
    [_color becomeFirstResponder];
}
- (IBAction)onBtnSeaterClicked:(id)sender {
    [_seater becomeFirstResponder];
}
- (IBAction)onBtnSeatrowclicked:(id)sender {
    [_seatrow becomeFirstResponder];
}
- (IBAction)onBtnLicenseClicked:(id)sender {
    [_license becomeFirstResponder];
}
- (IBAction)onBtnCountryClicked:(id)sender {
    [_country becomeFirstResponder];
}
- (IBAction)onBtnEquipClicked:(id)sender {
    [_otherInfos becomeFirstResponder];
}
@end
