//
//  ZMFMDBSQLiteHelper.h
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMFMDBSQLiteHelper : NSObject
- (BOOL) executeUpdate:(NSString *)query;
- (BOOL) executeUpdate:(NSString *)query withArgumentsInArray:(NSArray *)arguments;
- (BOOL) executeUpdate:(NSString *)query withParameterDictionary:(NSDictionary *)arguments;
- (NSMutableArray *) executeQuery:(NSString *)query;
- (NSMutableArray *) executeQuery: (NSString *)query withArgumentsInArray:(NSArray *)arguments;
- (NSMutableArray *) executeQuery:(NSString *)query withParameterDictionary:(NSDictionary *)arguments;
- (NSMutableArray *) executeDistanceFunction:(float)lat lng:(float)lng catid:(NSString *)catid radius:(double)radius offset:(int)offset city:(NSString*)city;
- (NSInteger) getTotalNumberOfRowsOfTable:(NSString *)tableName;
- (void) createTable:(NSString *)table pfObject:(NSDictionary *)object;
- (void) insertIntoTable:(NSString *)table pfObject:(NSDictionary *)object;
- (void) updateTable:(NSString *)table pfObject:(NSDictionary *)object;
@end
