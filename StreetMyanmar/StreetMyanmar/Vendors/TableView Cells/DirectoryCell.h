//
//  DirectoryCell.h
//  StreetMyanmar
//
//  Created by Zune Moe on 3/11/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Directory.h"

@interface DirectoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *directoryCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *directoryName;
@property (weak, nonatomic) IBOutlet UIImageView *directoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *directoryDetail;

- (void)setupCell:(Directory *)directory;
@end
