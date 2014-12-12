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

@end
