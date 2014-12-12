//
//  ZMFMDBSQLiteHelper.h
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CarBrand.h"
#import "CarModel.h"
#import "News.h"
#import "Car.h"
#import "NearbyPlace.h"

@interface ZMFMDBSQLiteHelper : NSObject
- (BOOL) executeUpdate:(NSString *)query;
- (BOOL) executeUpdate:(NSString *)query withArgumentsInArray:(NSArray *)arguments;
- (BOOL) executeUpdate:(NSString *)query withParameterDictionary:(NSDictionary *)arguments;
- (NSMutableArray *) executeQuery:(NSString *)query;
- (NSMutableArray *) executeQuery: (NSString *)query withArgumentsInArray:(NSArray *)arguments;
- (NSMutableArray *) executeQuery:(NSString *)query withParameterDictionary:(NSDictionary *)arguments;
- (NSInteger) getTotalNumberOfRowsOfTable:(NSString *)tableName;
- (void) createTable:(NSString *)table object:(NSDictionary *)object;
- (void) insertIntoTable:(NSString *)table object:(NSDictionary *)object;

- (void) createCarBrandTable:(CarBrand *)brand;
- (void) insertCarBrandIntoTable:(CarBrand *)brand;
- (void) createCarModelTable:(CarModel *)model;
- (void) insertCarModelIntoTable:(CarModel *)model;
- (void) createNewsTable:(News *)news;
- (void) insertNewsIntoTable:(News *)news;

- (void)createDirectoriesTable;
- (void)insertDirectoriesIntoTable:(NSArray *)places;
- (NSArray*)getDirectories;

@end
