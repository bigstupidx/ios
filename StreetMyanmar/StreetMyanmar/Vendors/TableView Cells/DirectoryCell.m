//
//  DirectoryCell.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/11/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "DirectoryCell.h"
#import "UIImageView+WebCache.h"

@implementation DirectoryCell

- (void)setupCell:(Directory *)directory
{
    NSMutableString *details = [NSMutableString string];
    if (![directory.buildingno isEqualToString:@""]) {
        [details appendFormat:@"%@, ", directory.buildingno];
    }
    if (![directory.buildingname isEqualToString:@""]) {
        [details appendFormat:@"%@, ", directory.buildingname];
    }
    if (![directory.street isEqualToString:@""]) {
        [details appendFormat:@"%@, ", directory.street];
    }
    if (![directory.roomno isEqualToString:@""]) {
        [details appendFormat:@"%@, ", directory.roomno];
    }
    if (![directory.township isEqualToString:@""]) {
        [details appendFormat:@"%@, ", directory.township];
    }
    if (![directory.city isEqualToString:@""]) {
        [details appendFormat:@"%@", directory.city];
    }
// zipcode is always 0 so temporarily remove from mutableString
//    if (![directory.zipcode isEqualToString:@""]) {
//        [details appendFormat:@"%@", directory.zipcode];
//    }
    self.directoryName.text = directory.name;
    self.directoryDetail.text = details;
    
    self.directoryCategoryImageView.image = [UIImage imageNamed:directory.catname];
    [self.directoryImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", StreetMyanmarDirectoryImageURL, directory.photoname]]
                            placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
