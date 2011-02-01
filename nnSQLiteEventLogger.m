//
//  nnSQLiteEventLogger.m
//  metime
//
//  Created by Brice Tebbs on 7/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSQLiteEventLogger.h"

@implementation nnSQLiteEventLogger

NSString* DB_LOG_TABLE_NAME = @"log";



-(nnErrorCode)logEvent: (NSInteger)kind forKey:(NSInteger)key value:(NSInteger)value
{
   
    double timestamp;
    NSInteger hours, minutes, seconds, dayOfWeek;
    
    nnGetDateInfo(&timestamp, &hours, &minutes, &seconds, &dayOfWeek);
    
    NSInteger timeOfDay = hours * 3600 + minutes * 60 + seconds;
    
    nnErrorCode error = [db_delegate runSQLCommand:@"insert into log (key, kind, value, dayOfWeek, timeOfDay, timestamp) values (?,?,?,?,?,?);"
                                        withParams:[NSArray arrayWithObjects: 
                                                    [NSNumber numberWithInt: key],
                                                    [NSNumber numberWithInt: kind],
                                                    [NSNumber numberWithInt: value],
                                                    [NSNumber numberWithInt: dayOfWeek],
                                                    [NSNumber numberWithInt: timeOfDay],
                                                    [NSNumber numberWithDouble: timestamp],
                                                    nil]
                         ];
    
    nnDebugLog(@"Logging for %d at %f error=%d",key, timestamp, error);
    return error;
    
}


-(nnErrorCode)countEvents: (NSInteger)kind forKey:(NSInteger)key storeIn:(NSInteger*)count
{
    nnSQLQuery *q = [[[nnSQLQuery alloc] init] autorelease];
    
    NSInteger error = [db_delegate createQuery:@"SELECT count(*) from log where kind=? and key=?;"
                                        saveIn: q];
    
    if (error)
        return error;
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: kind], nil]];
    if (error)
        return error;
    
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: key], nil]];
    if (error)
        return error;
    
    error = [q step];
    if(error)
        return error;
    
    *count = [q integerValue];
    
    return nnkNoError;
}


-(nnErrorCode)fetchEvents: (NSInteger)kind storeIn: (NSMutableArray*)results
{
    nnSQLQuery *q = [[[nnSQLQuery alloc] init] autorelease];
    
    NSInteger error = [db_delegate createQuery:@"SELECT key, kind, value, dayOfWeek, timeOfDay, resourceId, timestamp, latitude, longitude from log where kind=?;"
                                        saveIn: q];
    
    if (error)
        return error;
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: kind], nil]];
    if (error)
        return error;
    
    while (!(error=[q step]))
    {
        nnLoggedEvent *le = [[nnLoggedEvent alloc] init];
        
        le.key = [q integerValue];
        le.kind =  [q integerValue];
        le.value =  [q integerValue];
        le.dayOfWeek = [q integerValue];
        le.timeOfDay = [q integerValue];
        le.resourceId = [q integerValue];
        le.timestamp =  [q doubleValue];
        le.latitude =  [q doubleValue];
        le.longitude =  [q doubleValue];
    
        [results addObject: le];
        [le release];
    }
    
    return nnkNoError;
    
}

-(nnErrorCode)setupSQLiteEventLogger:(id <nnSQLDBProtocol>) del; 
{
    nnErrorCode error = nnkNoError;
    db_delegate = del;
    
    
    error = [db_delegate checkTable:DB_LOG_TABLE_NAME];
    if(error)
    {
        
        
        NSArray* fieldList = [NSArray arrayWithObjects:
                              [nnSQLiteFieldInfo initWithLabel:@"key" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"kind" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"value" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"dayOfWeek" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"timeOfDay" andType:@"INTEGER"],
                              [nnSQLiteFieldInfo initWithLabel:@"resourceId" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"timestamp" andType:@"REAL"], 
                              [nnSQLiteFieldInfo initWithLabel:@"latitude" andType:@"REAL"], 
                              [nnSQLiteFieldInfo initWithLabel:@"longitude" andType:@"REAL"],
                              // For future use
                              [nnSQLiteFieldInfo initWithLabel:@"flags" andType:@"INTEGER"],
                              nil];
        
        [db_delegate createTable:DB_LOG_TABLE_NAME withFields:fieldList];
    }
    
    return error;
}
@end
