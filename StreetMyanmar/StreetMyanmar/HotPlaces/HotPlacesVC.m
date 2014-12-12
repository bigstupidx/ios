//
//  HotPlacesVC.m
//  StreetMyanmar
//
//  Created by Zune Moe on 3/12/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "HotPlacesVC.h"
#import "DirectoryCell.h"
#import "DirectoryDetailsVC.h"

// models
#import "Directory.h"

// vendors

@interface HotPlacesVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *directoriesArray;
@end

@implementation HotPlacesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"10", @"limit",
                                       @"1", @"offset",
                                       @"", @"categoryid",
                                       @"", @"subcategoryid",
                                       @"yangon", @"city",
                                       @"all", @"township",
                                       @"0", @"promotion",
                                       @"", @"keywords",
                                       nil];
    [Directory getDirectory:parameters block:^(NSArray *directories, NSError *error) {
        self.directoriesArray = directories;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.directoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DirectoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCell:self.directoriesArray[indexPath.row]];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DirectoryDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryDetailsVC"];
//    vc.directory = self.directoriesArray[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end
