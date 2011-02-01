//
//  nnSQLLiteDBManager.h
//  cloudlist
//
//  Created by Brice Tebbs on 5/30/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "northNitch.h"


@interface nnSQLiteFieldInfo : NSObject
{
    NSString* type;
    NSString* label;
    BOOL isKey;
}
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* label;
+(nnSQLiteFieldInfo*)initWithLabel: (NSString*) label andType: (NSString*)type;
@end


@interface nnSQLQuery : NSObject
{
    sqlite3_stmt *statement;
    NSInteger currentColumn;
    NSInteger numParams;
}

-(nnErrorCode)bindParameters: (NSArray*)params;
-(nnErrorCode)execute;
-(nnErrorCode)step;

-(NSInteger)integerValue;

-(double)doubleValue;
-(NSString*)stringValue;

@end

@protocol nnSQLDBProtocol
-(nnErrorCode)checkTable:(NSString*)tableName;
-(nnErrorCode)createTable:(NSString*)tableName withFields:(NSArray*)fieldList;
-(nnErrorCode)runSQLCommand:(NSString*) sql withParams:(NSArray*)params;
-(nnErrorCode)createQuery:(NSString*) sql saveIn: (nnSQLQuery*)query;
-(NSInteger)lastRow;
@end


@interface nnSQLiteDBManager : NSObject <nnSQLDBProtocol>{
    sqlite3 *database;
    NSMutableDictionary *tables;
}

-(nnErrorCode)setupSqlLite;

@end

