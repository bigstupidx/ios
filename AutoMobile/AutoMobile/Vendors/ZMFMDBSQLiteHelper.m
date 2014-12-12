//
//  ZMFMDBSQLiteHelper.m
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#import "ZMFMDBSQLiteHelper.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#import <sqlite3.h>

#define isResultLogged YES
@implementation ZMFMDBSQLiteHelper

- (NSString *) getDatabasePath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"database.db"];
    
    return databasePath;
}

- (BOOL) executeUpdate:(NSString *)query
{    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    db.logsErrors = YES;
    [db open];
    BOOL success = [db executeUpdate:query];
    NSLog(@"SUCCESS : %hhd",success);
    [db close];
    return success;
}

- (BOOL) executeUpdate:(NSString *)query withArgumentsInArray:(NSArray *)arguments
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    BOOL success = [db executeUpdate:query withArgumentsInArray:arguments];
    [db close];
    return success;
}

- (BOOL) executeUpdate:(NSString *)query withParameterDictionary:(NSDictionary *)arguments
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    BOOL success = [db executeUpdate:query withParameterDictionary:arguments];
    [db close];
    return success;
}

- (NSMutableArray *) executeQuery:(NSString *)query
{
    NSMutableArray *resultOfQuery = [[NSMutableArray alloc] init];    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) [resultOfQuery addObject:[results resultDictionary]];
    [db close];
	return resultOfQuery;
}

- (NSMutableArray *) executeQuery: (NSString *)query withArgumentsInArray:(NSArray *)arguments
{
    NSMutableArray *resultOfQuery = [[NSMutableArray alloc] init];    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:query withArgumentsInArray:arguments];
    while ([results next]) [resultOfQuery addObject:[results resultDictionary]];
    [db close];
    return resultOfQuery;
}

- (NSMutableArray *) executeQuery:(NSString *)query withParameterDictionary:(NSDictionary *)arguments
{
    NSMutableArray *resultOfQuery = [[NSMutableArray alloc] init];    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:query withParameterDictionary:arguments];
    while ([results next]) [resultOfQuery addObject:[results resultDictionary]];
    [db close];
    return resultOfQuery;
}

- (NSInteger) getTotalNumberOfRowsOfTable:(NSString *)tableName
{
    NSString *query = [NSString stringWithFormat:@"SELECT count() as rowCount FROM %@",tableName];
    NSMutableArray *resultArray = [self executeQuery:query];
    
    if(resultArray.count > 0)
        return [[[resultArray objectAtIndex:0] objectForKey:@"rowCount"] integerValue];
    else
        return 0;
}

- (void) createTable:(NSString *)table object:(NSDictionary *)object
{
    NSMutableString *create_query = [NSMutableString stringWithFormat:@"create table if not exists %@ (", table];
    for (int i = 0; i < object.allKeys.count - 1; i++)
        [create_query appendFormat:@"%@, ", [object.allKeys objectAtIndex:i]];
    [create_query appendFormat:@"%@)", object.allKeys.lastObject];
    
    [self executeUpdate:create_query];
}

- (void) insertIntoTable:(NSString *)table object:(NSDictionary *)object
{
    NSMutableString *insert_query = [NSMutableString stringWithFormat:@"insert into %@ (", table];
    for (int i = 0; i < object.allKeys.count - 1; i++)
        [insert_query appendFormat:@"%@, ", [object.allKeys objectAtIndex:i]];
    [insert_query appendFormat:@"%@) values (", object.allKeys.lastObject];
    
    for (int i = 0; i < object.allKeys.count - 1; i++)
        [insert_query appendFormat:@"'%@', ", [object valueForKey:[object.allKeys objectAtIndex:i]]];
    [insert_query appendFormat:@"'%@')", [object valueForKey:object.allKeys.lastObject]];
    
    [self executeUpdate:insert_query];
}

- (void)createCarBrandTable:(CarBrand *)brand
{
    NSMutableString *create_query = [NSMutableString stringWithString:@"create table if not exists CarBrand ("];
    [create_query appendString:@"id primary key, catid, name)"];
    [self executeUpdate:create_query];
}

- (void)insertCarBrandIntoTable:(CarBrand *)brand
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into CarBrand ("];
    [insert_query appendString:@"id, catid, name) values ("];
    [insert_query appendFormat:@"'%d', '%d', '%@')", brand.id, brand.catid, brand.name];
    [self executeUpdate:insert_query];
}

- (void)createCarModelTable:(CarModel *)model
{
    NSMutableString *create_query = [NSMutableString stringWithString:@"create table if not exists CarModel ("];
    [create_query appendString:@"id primary key, makeid, name)"];
    [self executeUpdate:create_query];
}

- (void)insertCarModelIntoTable:(CarModel *)model
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into CarModel ("];
    [insert_query appendString:@"id, makeid, name) values ("];
    [insert_query appendFormat:@"'%d', '%d', '%@')", model.id, model.makeid, model.name];
    [self executeUpdate:insert_query];
}

- (void)createNewsTable:(News *)news
{
    NSMutableString *create_query = [NSMutableString stringWithString:@"create table if not exists News ("];
    [create_query appendString:@"id primary key, title, introtext text null, fulltext text null, catename, hits, created, image text null)"];
    [self executeUpdate:create_query];
}

- (void)insertNewsIntoTable:(News *)news
{
    BOOL success;
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into News ("];
    [insert_query appendString:@"id, title, introtext, fulltext, catename, hits, created, image) values ("];
    [insert_query appendFormat:@"'%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", news.id, news.title, news.introtext, news.fulltext, news.catename, news.hits, news.created, news.image];
    success = [self executeUpdate:insert_query];
    if (success) {
        NSLog(@"insert success");
    } else {
        NSLog(@"insert failed");
        //NSLog(@"query : %@", insert_query);
    }
}

- (void)createDirectoriesTable
{
    NSMutableString *create_query = [NSMutableString stringWithString:@"create table if not exists Directory ("];
    [create_query appendString:@"id primary key, name, buildingno text null, street text null, roomno text null, buildingname text null, township text null, city text null, zipcode text null, phone text null, photoname text null, directoryid text null, locationid text null, quarter text null, country text null, latitude text null, longitude text null, email text null, website text null, openinghr text null, closinghr text null, closingdate text null, description text null, feature text null, catid text null, catname text null, subcat, promotion text null)"];
    [self executeUpdate:create_query];
}

- (void)insertDirectoriesIntoTable:(NSArray *)places
{
    for (NearbyPlace* place in places) {
        NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into Directory ("];
        [insert_query appendString:@"id, name, buildingno, street, roomno, buildingname, township, city, zipcode, phone, photoname, directoryid, locationid, quarter, country, latitude, longitude, email, website, openinghr, closinghr, closingdate, description, feature, catid, catname, subcat, promotion) values ("];
        [insert_query appendFormat:@"'%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', %@, '%@')", place.id, place.name, place.buildingname, place.street, place.roomno, place.buildingname, place.township, place.city, place.zipcode, place.phone, place.photoname, place.directoryid, place.locationid, place.quarter, place.country, place.latitude, place.longitude, place.email, place.website, place.openinghr, place.closinghr, place.closingdate, place.description, place.feature, place.catid, place.catname, place.subcat, place.promotion];
        [self executeUpdate:insert_query];

    }
}

- (NSArray*)getDirectories
{
    NSArray* resultarr = [self executeQuery:@"select * from Directory"];
    
    NSMutableArray* muArr = [[NSMutableArray alloc] initWithCapacity:resultarr.count];
    for (NSDictionary* dict in resultarr) {
        NearbyPlace* place = [[NearbyPlace alloc] initWithDictionary:dict error:nil];
        [muArr addObject:place];
    }
    return muArr;
}

@end
