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

static sqlite3 *database;

#import <CoreLocation/CoreLocation.h>

@implementation ZMFMDBSQLiteHelper

- (NSString *) getDatabasePath
{
//    NSString*databaseName = @"MODAdb.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"MODAdb.sqlite"];
    //NSString *pathToEncryptedDB = [documentDir stringByAppendingPathComponent:@"EStreetMyanmar.sqlite"];
    BOOL success;
    NSFileManager*fm=[NSFileManager defaultManager];
    success=[fm fileExistsAtPath:databasePath];
    if(success) NSLog(@"Already present");
    else {
        //Copy from bundle to DocumentsDirectory on first run. Where DB won't be available in DocumentsDirectory.
//        NSString*bundlePath=[[NSBundle mainBundle] pathForResource:@"EStreetMyanmar" ofType:@"sqlite"];
//        NSError*error;
//        success=[fm copyItemAtPath:bundlePath toPath:databasePath error:&error];
//        if(success) NSLog(@"Created successfully");
        
        NSString*bundlePath=[[NSBundle mainBundle] pathForResource:@"MODAdb" ofType:@"sqlite"];
        NSError*error;
        success=[fm copyItemAtPath:bundlePath toPath:databasePath error:&error];
        if(success) NSLog(@"Created successfully");

        
    }
//    NSString *sql;
//    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
//        sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '2DD29CA851E7B56E4697B0E1F08507293D761A05CE4D1B628663F411A8086D99'", pathToEncryptedDB];
//        if (sqlite3_exec(database, (const char*) [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
//            NSLog(@"attach successful");
//            sql = [NSString stringWithFormat:@"SELECT sqlcipher_export('encrypted')"];
//            if (sqlite3_exec(database, (const char*) [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
//                NSLog(@"Success!");
//            }
//            else {
//                NSLog(@"export failed error: %s", sqlite3_errmsg(database));
//            }
//        } else {
//            NSLog(@"attach failed error: %s", sqlite3_errmsg(database));
//        }
//    }
//    if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
//        
//         NSLog(@"DB initialized successfully");
//        //return TRUE;
//    } else {
//         NSLog(@"Init DB Error: %s",sqlite3_errmsg(database));
//        //return FALSE;
//    }

    return databasePath;
}

- (BOOL) executeUpdate:(NSString *)query
{    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
    //[db setKey:KEY];
    BOOL success = [db executeUpdate:query];
    [db close];
    return success;
}

- (BOOL) executeUpdate:(NSString *)query withArgumentsInArray:(NSArray *)arguments
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
//    [db setKey:KEY];
    BOOL success = [db executeUpdate:query withArgumentsInArray:arguments];
    [db close];
    return success;
}

- (BOOL) executeUpdate:(NSString *)query withParameterDictionary:(NSDictionary *)arguments
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
//    [db setKey:KEY];
    BOOL success = [db executeUpdate:query withParameterDictionary:arguments];
    [db close];
    return success;
}

- (NSMutableArray *) executeDistanceFunction:(float)lat lng:(float)lng catid:(NSString *)catid radius:(double)radius offset:(int)offset city:(NSString*)city
{
    NSMutableArray *resultQuery = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
//    [db setKey:KEY];
    [db makeFunctionNamed:@"distanceFunction" maximumArguments:4 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
        // check that we have four arguments (lat1, lon1, lat2, lon2)
        assert(argc == 4);
        // check that all four arguments are non-null
        if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
            sqlite3_result_null(context);
            return;
        }
        // get the four argument values
        double lat1 = sqlite3_value_double(argv[0]);
        double lon1 = sqlite3_value_double(argv[1]);
        double lat2 = sqlite3_value_double(argv[2]);
        double lon2 = sqlite3_value_double(argv[3]);
        // convert lat1 and lat2 into radians now, to avoid doing it twice below
        double lat1rad = DEG2RAD(lat1);
        double lat2rad = DEG2RAD(lat2);
        // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
        // 6378.1 is the approximate radius of the earth in kilometres
        sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
    }];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select *, distanceFunction (latitude, longitude, %f, %f) as distance from Search where catid = '%@' and city = '%@' order by distance limit 10 offset %d", lat, lng, catid, city, offset]];
    while ([results next]) [resultQuery addObject:[results resultDictionary]];
    [db close];
    //return resultQuery;
    //SMT
//    NSArray* results = [NSArray array];
//    results = [self executeQuery:[NSString stringWithFormat:@"select * from Search where catid = '%@' and city = '%@'", catid, city]];
    //while ([results next]) [resultQuery addObject:[results resultDictionary]];
    
//    [db close];
//    NSMutableArray *nearByPlaces = [[NSMutableArray alloc] init];
//    CLLocationCoordinate2D userCoor = CLLocationCoordinate2DMake(lat, lng);
//    double rediusMeter = radius * 1000;
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:userCoor radius:rediusMeter identifier:@"Amsterdam"];
//    for (NSDictionary* placeDict in resultQuery) {
//        float placelat = [[placeDict objectForKey:@"latitude"] floatValue];
//        float placelongi = [[placeDict objectForKey:@"longitude"] floatValue];
//        CLLocationCoordinate2D placeCoor = CLLocationCoordinate2DMake(placelat, placelongi);
//        if ([region containsCoordinate:placeCoor]) {
//            [nearByPlaces addObject:placeDict];
//        }
//    }
    return resultQuery;
    
}

- (NSMutableArray *) executeQuery:(NSString *)query
{
    NSMutableArray *resultOfQuery = [[NSMutableArray alloc] init];    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    [db open];
   // [db rekey:KEY];
//    [db setKey:KEY];
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
 //   [db rekey:KEY];
//    [db setKey:KEY];
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
//    [db setKey:KEY];
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
