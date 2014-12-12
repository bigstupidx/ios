//
//  InfoCell.h
//  MMJunction
//
//  Created by Zune Moe on 3/7/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *vendorName;
@property (weak, nonatomic) IBOutlet UILabel *vendorURL;
@property (weak, nonatomic) IBOutlet UILabel *vendorLicense;

- (void)setupCell:(NSDictionary *)dictionary;
@end
