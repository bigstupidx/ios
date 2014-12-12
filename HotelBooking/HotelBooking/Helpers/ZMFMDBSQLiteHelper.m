//
//  ZMFMDBSQLiteHelper.m
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#define KEY @"2DD29CA851E7B56E4697B0E1F08507293D761A05CE4D1B628663F411A8086D99"
#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

#import "ZMFMDBSQLiteHelper.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

#import <CoreLocation/CoreLocation.h>

@implementation ZMFMDBSQLiteHelper

- (NSString *) getDatabasePath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"HotelBooking.sqlite"];

    BOOL success;
    NSFileManager*fm=[NSFileManager defaultManager];
    success=[fm fileExistsAtPath:databasePath];
    if(success) NSLog(@"Already present");
    else {
        
        NSString*bundlePath=[[NSBundle mainBundle] pathForResource:@"HotelBooking" ofType:@"sqlite"];
        NSError*error;
        success=[fm copyItemAtPath:bundlePath toPath:databasePath error:&error];
        if(success) NSLog(@"Created successfully");
        
        
    }
    
    return databasePath;

}

- (BOOL) executeUpdate:(NSString *)query
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    db.logsErrors = YES;
    [db open];
    BOOL success = [db executeUpdate:query];
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

//- (void) createTable:(NSString *)table pfObject:(NSDictionary *)object
//{
//    NSMutableString *create_query = [NSMutableString stringWithFormat:@"create table if not exists %@ (objectId primary key, ", table];
//    for (int i = 0; i < object.allKeys.count - 1; i++)
//        [create_query appendFormat:@"%@, ", [object.allKeys objectAtIndex:i]];
//    [create_query appendFormat:@"%@)", object.allKeys.lastObject];
//    
//    [self executeUpdate:create_query];
//}
//
//- (void) insertIntoTable:(NSString *)table pfObject:(NSDictionary *)object
//{
//    NSMutableString *insert_query = [NSMutableString stringWithFormat:@"insert into %@ (objectId, ", table];
//    for (int i = 0; i < object.allKeys.count - 1; i++)
//        [insert_query appendFormat:@"%@, ", [object.allKeys objectAtIndex:i]];
//    [insert_query appendFormat:@"%@) values ('%@', ", object.allKeys.lastObject, object.objectId];
//    
//    for (int i = 0; i < object.allKeys.count - 1; i++)
//        [insert_query appendFormat:@"'%@', ", [object valueForKey:[object.allKeys objectAtIndex:i]]];
//    [insert_query appendFormat:@"'%@')", [object valueForKey:object.allKeys.lastObject]];
//    [self executeUpdate:insert_query];
//}
//
//- (void) updateTable:(NSString *)table pfObject:(NSDictionary *)object
//{
//    NSMutableString *update_query = [NSMutableString stringWithFormat:@"update %@ set ", table];
//    for (int i = 0; i < object.allKeys.count; i++)
//        [update_query appendFormat:@"%@ = '%@', ", [object.allKeys objectAtIndex:i], [object valueForKey:[object.allKeys objectAtIndex:i]]];
//    [update_query appendFormat:@"where objectId = '%@'", object.objectId];
//    
//    [self executeUpdate:update_query];
//}

@end
