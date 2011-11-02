//
//  nnSQLLiteDBManager.m
//  cloudlist
//
//  Created by Brice Tebbs on 5/30/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSQLiteDBManager.h"

NSString* DB_FILE_NAME = @"dbmgr004.sqlite";

@interface nnSQLQuery () 
-(void)setupWithStatement: (sqlite3_stmt*)s;
@end

@implementation nnSQLiteDBManager
-(void)dealloc
{
    if(database)
    {
        sqlite3_close(database);
    }
    
    [super dealloc];
}

-(nnErrorCode)setupSqlLite
{
    if (database)
    {
        return nnkNoError;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:DB_FILE_NAME];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) 
    {
        nnDebugLog(@"Sqlite DB open file=%@",path);
        return nnkNoError;
    }
    else 
    {
        sqlite3_close(database);
        return nnkSQLiteDBOpenError;
    }
}

-(nnErrorCode)checkTable:(NSString*)tableName
{
    nnErrorCode error = nnkNoError;
    NSString* sql = @"SELECT * from sqlite_master where name=?;";
    BOOL found = NO;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [tableName UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            found = YES;
            break;
        }
    }
    else{
        error = nnkSQLiteSQLStmtError;
    }
    sqlite3_finalize(statement);
    if (!found) {
        error = nnkSQLiteTableMissing;
    }
    return error;
}


-(nnErrorCode)createTable:(NSString *)tableName withFields:(NSArray *)fieldList
{
    nnErrorCode error = nnkNoError;
 
    NSString* fieldString = [NSString stringWithFormat:@"pk INTEGER PRIMARY KEY AUTOINCREMENT"];
    for (nnSQLiteFieldInfo* fi in fieldList)
    {
        fieldString = [fieldString stringByAppendingFormat:@", %@ %@",fi.label, fi.type];
    }
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@);",tableName, fieldString];

    nnDebugLog(@"SQL:%@",sql);
    sqlite3_stmt *statement;

    int err = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    if (err == SQLITE_OK) 
    {
        sqlite3_step(statement);
    }
    else
    {
        nnLog(@"SQL Error %s",sqlite3_errmsg(database));
        error = nnkSQLiteSQLStmtError;
    }
    sqlite3_finalize(statement);
    
    return error;
}

-(nnErrorCode)createQuery:(NSString*) sql saveIn: (nnSQLQuery*)query
{
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        [query setupWithStatement:statement];
    }
    else {
        nnLog(@"SQL Error %s",sqlite3_errmsg(database));
        return nnkSQLiteSQLStmtError;
    }
    return nnkNoError;
}

-(nnErrorCode)runSQLCommand:(NSString *)sql withParams:(NSArray *)params
{
    nnErrorCode error;
    nnSQLQuery* q = [[nnSQLQuery alloc]init];
    error = [self createQuery: sql saveIn:q];
    if (error) {
        [q release];
        return error;
    }
    [q bindParameters: params];
    error = [q execute];
    [q release];
    return error;
}

-(NSInteger)lastRow
{
    return sqlite3_last_insert_rowid(database);
}

@end

@implementation nnSQLQuery

-(void)dealloc
{
    sqlite3_finalize(statement);
    [super dealloc];
}


-(void)setupWithStatement:(sqlite3_stmt *)s
{
    statement = s;
    currentColumn = 1;
    numParams = 0;
}
-(nnErrorCode)bindInteger: (NSInteger)i
{
    sqlite3_bind_int(statement, currentColumn, i);
    numParams++;
    currentColumn++;
    return nnkNoError;
}

-(nnErrorCode)bindString: (NSString*)s
{
    sqlite3_bind_text(statement, currentColumn, [s UTF8String], -1, SQLITE_TRANSIENT);
    numParams++;
    currentColumn++;
    
    return nnkNoError;
}

-(nnErrorCode)bindDouble: (double)f
{
    sqlite3_bind_double(statement, currentColumn, f);
    numParams++;
    currentColumn++;
    return nnkNoError;

}

-(nnErrorCode)bindParameters: (NSArray*)params
{
    nnErrorCode error = nnkNoError;
    
    for (NSObject *object in params)
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *str = (NSString*)object;
            error = [self bindString: str];
         }
        if([object isKindOfClass:[NSNumber class]])
        {
            NSNumber* num = (NSNumber*)object;
            if ([num longValue] == (int) [num doubleValue]) {
                error = [self bindInteger: [num longValue]];
            }
            else
            {
                error = [self bindDouble: [num doubleValue]];
            }
        }
        if (error)
            break;
    }
    
    return error;
}
-(nnErrorCode)step
{
    NSInteger code;
    currentColumn = 0;
    code = sqlite3_step(statement);
    if (code == SQLITE_ROW) {
        return nnkNoError;
    }
    if (code == SQLITE_DONE) {
        return nnkSQLiteQueryComplete;
    }
    return nnkSQLiteQueryError;
}


-(nnErrorCode)execute
{
    NSInteger code;
    currentColumn = 0;
    code = sqlite3_step(statement);
    if (code == SQLITE_ROW || code == SQLITE_DONE) {
        return nnkNoError;
    }
    return nnkSQLiteQueryError;
}


-(NSInteger)integerValue
{
    return sqlite3_column_int(statement,currentColumn++);
}


-(double)doubleValue
{
    return sqlite3_column_double(statement,currentColumn++);
}

-(NSString*)stringValue
{
    const unsigned char *c = sqlite3_column_text(statement, currentColumn++);
    if (c) 
    {
        return [NSString stringWithUTF8String: (const char*)c];
    }
    
    else {
        return @"";
    }

}

@end



@implementation nnSQLiteFieldInfo

@synthesize type;
@synthesize label;

+(nnSQLiteFieldInfo*)initWithLabel: (NSString*) label andType: (NSString*)type
{
    nnSQLiteFieldInfo* info = [[nnSQLiteFieldInfo alloc] init];
    info.label = label;
    info.type = type;
    return info;
}

@end

