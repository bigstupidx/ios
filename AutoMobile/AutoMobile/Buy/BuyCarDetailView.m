//
//  BuyCarDetailView.m
//  AutoMobile
//
//  Created by Zune Moe on 27/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "BuyCarDetailView.h"
#import "UIFont+ZawgyiOne.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "Reachability.h"
#import "ZMFMDBSQLiteHelper.h"

@interface BuyCarDetailView ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIImageView *carStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *fuel;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UILabel *transmission;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *equipment;
@property (weak, nonatomic) IBOutlet UILabel *hits;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL reachable;
@end

@implementation BuyCarDetailView

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    [self setupLabelsFont];
    
    // notify internet reachability
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    ZMFMDBSQLiteHelper *db = [ZMFMDBSQLiteHelper new];
    if (self.reachable) {
        [User getUserWithId:self.selectedCar.user bloc:^(User *user, NSError *error) {
            NSDictionary *userDictionary = [user toDictionary];
            [db createTable:@"User" object:userDictionary];
            [db executeUpdate:[NSString stringWithFormat:@"Delete from User where id = '%d'", user.id]];
            [db insertIntoTable:@"User" object:userDictionary];
            [self setupUserData:user];
        }];
    } else {
        NSDictionary *userDictionary = [db executeQuery:[NSString stringWithFormat:@"select * from User where id = '%d'", self.selectedCar.user]].firstObject;
        User *user = [[User alloc] initWithDictionary:userDictionary error:nil];
        [self setupUserData:user];
    }
    
    if ([self.selectedCar.condition isEqualToString:@"New"]) {
        self.carStatusImageView.image = [UIImage imageNamed:@"new_icon.png"];
    } else {
        self.carStatusImageView.image = [UIImage imageNamed:@"used_icon.png"];
    }
    [self.carImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageBaseURL, self.selectedCar.imgmain]]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.year.text = [NSString stringWithFormat:@"Year: %d", self.selectedCar.year];
    self.fuel.text = [NSString stringWithFormat:@"Fuel: %@", self.selectedCar.fuel];
    self.color.text = [NSString stringWithFormat:@"Color: %@", self.selectedCar.color];
    self.body.text = [NSString stringWithFormat:@"Body: %@", self.selectedCar.bodytype];
    self.transmission.text = [NSString stringWithFormat:@"Transmission: %@", self.selectedCar.trans];
    self.country.text = [NSString stringWithFormat:@"Location: %@", self.selectedCar.country];
    
    NSMutableString *equipment = [NSMutableString stringWithString:@"Equipments: \n\n"];
    for (NSString *eq in self.selectedCar.equipment) {
        [equipment appendFormat:@"- %@ \n\n", eq];
    }
    self.equipment.text = equipment;
    self.hits.text = [NSString stringWithFormat:@"Hits: %d", self.selectedCar.hits];
}

- (void) setupLabelsFont
{
    self.year.font = [UIFont zawgyiOneFontWithSize:14];
    self.fuel.font = [UIFont zawgyiOneFontWithSize:14];
    self.color.font = [UIFont zawgyiOneFontWithSize:14];
    self.body.font = [UIFont zawgyiOneFontWithSize:14];
    self.transmission.font = [UIFont zawgyiOneFontWithSize:14];
    self.country.font = [UIFont zawgyiOneFontWithSize:14];
    
    self.equipment.font = [UIFont zawgyiOneFontWithSize:14];
    self.hits.font = [UIFont zawgyiOneFontWithSize:14];
    
    self.name.font = [UIFont zawgyiOneFontWithSize:14];
    self.username.font = [UIFont zawgyiOneFontWithSize:14];
    self.company.font = [UIFont zawgyiOneFontWithSize:14];
    self.phone.font = [UIFont zawgyiOneFontWithSize:14];
    self.email.font = [UIFont zawgyiOneFontWithSize:14];
    self.city.font = [UIFont zawgyiOneFontWithSize:14];
}

- (void) setupUserData:(User *)user
{
    self.name.text = [NSString stringWithFormat:@"Name: %@ %@", user.firstname, user.lastname];
    self.username.text = [NSString stringWithFormat:@"Username: %@", user.name];
    self.company.text = [NSString stringWithFormat:@"Company: %@", user.company];
    self.phone.text = [NSString stringWithFormat:@"Phone: %@", user.phone];
    self.email.text = [NSString stringWithFormat:@"Email: %@", user.email];
    self.city.text = [NSString stringWithFormat:@"City: %@", user.country];
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

@end
