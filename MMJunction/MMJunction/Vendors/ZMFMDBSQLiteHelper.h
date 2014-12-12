//
//  ZMFMDBSQLiteHelper.h
//  MMFreelancer
//
//  Created by Zune Moe on 18/9/13.
//  Copyright (c) 2013 Wizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

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

- (void)createHotEventTable;
- (void)insertIntoHotEventTable:(Event *)event;
- (void)createEventTable;
- (void)insertIntoEventTable:(Event *)event;
- (NSArray *)retrieveFromEventTable:(NSString *)query;

- (void)createAttendTable;
- (void)insertAttendIntoTable:(int)eventId;
@end
