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

- (void)createHotEventTable
{
    NSString *create_query = @"create table if not exists HotEvent (id primary key, name, starttime, endtime, startdate, enddate, rsvp, priority, banner, user_id, tags_id, tags, l_name, l_address, l_city, l_longitude, l_latitude, description)";
    BOOL success;
    success = [self executeUpdate:create_query];
    if (success) {
        NSLog(@"HotEvent table was successfully created");
    } else {
        NSLog(@"failed to create HotEvent table");
    }
}

- (void)insertIntoHotEventTable:(Event *)event
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into HotEvent (id, name, starttime, endtime, startdate, enddate, rsvp, priority, banner, user_id, tags_id, tags, l_name, l_address, l_city, l_longitude, l_latitude, description)"];
    [insert_query appendString:@" values "];
    [insert_query appendFormat:@"(%d, '%@', '%@', '%@', '%@', '%@', '%d', '%d', '%@', '%d', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", event.id, event.name, event.starttime, event.endtime, event.startdate, event.enddate, event.rsvp, event.priority, event.banner, event.user_id, event.tags_id, event.tags, event.l_name, event.l_address, event.l_city, event.l_longitude, event.l_latitude, event.event_description];
    BOOL success;
    success = [self executeUpdate:insert_query];
    if (success) {
        NSLog(@"hotevent was inserted successfully");
    } else {
        NSLog(@"failed to insert hotevent");
    }
}

- (void)createEventTable
{
    NSString *create_query = @"create table if not exists Event (id primary key, name, starttime, endtime, startdate, enddate, rsvp, priority, banner, user_id, tags_id, tags, l_name, l_address, l_city, l_longitude, l_latitude, description)";
    BOOL success;
    success = [self executeUpdate:create_query];
    if (success) {
        NSLog(@"Event table was successfully created");
    } else {
        NSLog(@"failed to create Event table");
    }
}

- (void)insertIntoEventTable:(Event *)event
{
    NSMutableString *insert_query = [NSMutableString stringWithString:@"insert into Event (id, name, starttime, endtime, startdate, enddate, rsvp, priority, banner, user_id, tags_id, tags, l_name, l_address, l_city, l_longitude, l_latitude, description)"];
    [insert_query appendString:@" values "];
    [insert_query appendFormat:@"(%d, '%@', '%@', '%@', '%@', '%@', '%d', '%d', '%@', '%d', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", event.id, event.name, event.starttime, event.endtime, event.startdate, event.enddate, event.rsvp, event.priority, event.banner, event.user_id, event.tags_id, event.tags, event.l_name, event.l_address, event.l_city, event.l_longitude, event.l_latitude, event.event_description];
    BOOL success;
    success = [self executeUpdate:insert_query];
    if (success) {
        NSLog(@"event was inserted successfully");
    } else {
        NSLog(@"failed to insert event");
    }
}

- (NSArray *)retrieveFromEventTable:(NSString *)query
{
    NSArray *eventsDictionary = [self executeQuery:query];
    NSMutableArray *events = [NSMutableArray arrayWithCapacity:eventsDictionary.count];
    for (NSDictionary *dict in eventsDictionary) {
        NSError *error = nil;
        Event *event = [[Event alloc] initWithDictionary:dict error:&error];
        [events addObject:event];
    }
    return events;
}

- (void)createAttendTable
{
    [self executeUpdate:@"create table if not exists Attend (eventid primary key)"];
}

- (void)insertAttendIntoTable:(int)eventId
{
    [self executeUpdate:[NSString stringWithFormat:@"insert into Attend (eventid) values ('%d')", eventId]];
}

@end
