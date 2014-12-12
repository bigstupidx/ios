//
//  BuyCarListCell.m
//  AutoMobile
//
//  Created by Zune Moe on 24/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "BuyCarListCell.h"
#import "UIImageView+WebCache.h"
#import "UIFont+ZawgyiOne.h"

//static NSString *imageBaseURL = @"http://192.168.1.123/media/com_expautospro/images/middle/";

@implementation BuyCarListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setupCell:(MyCar *)car
{
    self.carImageView.layer.borderColor = [UIColor colorWithRed:246.0/255.0 green:97.0/255.0 blue:3.0/255.0 alpha:1.0].CGColor;
    self.carImageView.layer.borderWidth = 2;
    self.carImageView.layer.masksToBounds = YES;
    self.carPrice.layer.cornerRadius = 3;
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.currencySymbol = @"K";
    
    self.carTitle.font = [UIFont zawgyiOneFontWithSize:13.0f];
    self.carYear.font = [UIFont zawgyiOneFontWithSize:11.0f];
    self.carPrice.font = [UIFont zawgyiOneFontWithSize:11.0f];
    
    self.carTitle.text = [NSString stringWithFormat:@"%@, %@", car.make, car.model];
    self.carYear.text = [NSString stringWithFormat:@"Year: %@", car.year];
    NSString* pricestr;
    if ([car.negotiate isEqualToString:@"1"]) {
        pricestr = [NSString stringWithFormat:@"Price: %@ သိန္း(ညိွႏႈိင္း)", car.price];
    } else pricestr = [NSString stringWithFormat:@"Price: %@ သိန္း", car.price];
    self.carPrice.text = pricestr;
    [self.carImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://www.automobile.com.mm/", car.image]]
                                          placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    if (car.special == 1) {
//        self.carSpecialImageView.image = [UIImage imageNamed:@"special_s.png"];
//    }
}

//- (void)setupCellFromDict:(NSDictionary*)dict
//{
//    self.carImageView.layer.borderColor = [UIColor colorWithRed:246.0/255.0 green:97.0/255.0 blue:3.0/255.0 alpha:1.0].CGColor;
//    self.carImageView.layer.borderWidth = 2;
//    self.carImageView.layer.masksToBounds = YES;
//    self.carPrice.layer.cornerRadius = 3;
//    
//    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
//    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
//    numberFormatter.currencySymbol = @"K";
//    
//    self.carTitle.font = [UIFont zawgyiOneFontWithSize:13.0f];
//    self.carYear.font = [UIFont zawgyiOneFontWithSize:11.0f];
//    self.carPrice.font = [UIFont zawgyiOneFontWithSize:11.0f];
//    
//    self.carTitle.text = [NSString stringWithFormat:@"%@, %@", dict[@"makename"], dict[@"modelname"]];
//    self.carYear.text = [NSString stringWithFormat:@"Year: %@", dict[@"year"]];
//    NSString* pricestr;
//    if ([car.negotiate isEqualToString:@"1"]) {
//        pricestr = [NSString stringWithFormat:@"Price: %@ သိန္း(ညိွႏႈိင္း)", car.price];
//    } else pricestr = [NSString stringWithFormat:@"Price: %@ သိန္း", car.price];
//    self.carPrice.text = pricestr;
//    [self.carImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://www.automobile.com.mm/", car.image]]
//                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
