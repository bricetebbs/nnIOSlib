//
//  nnSQLiteDataProviderDelegate.m

//  Created by Brice Tebbs on 5/28/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSQLiteDataProviderDelegate.h"

@implementation nnSQLiteDataProviderDelegate
@synthesize tracking_delegate;
@synthesize db_delegate;

NSString* DB_ITEM_TABLE_NAME = @"items";

-(nnErrorCode)setupSqlDataProvider: (id <nnSQLDBProtocol>) del;
{
    nnErrorCode error = nnkNoError;
    db_delegate = del;
    
    
    error = [db_delegate checkTable:DB_ITEM_TABLE_NAME];
    if(error)
    {
        NSArray* fieldList = [NSArray arrayWithObjects:
                              [nnSQLiteFieldInfo initWithLabel:@"group_key" andType:@"INTEGER"], 
                               [nnSQLiteFieldInfo initWithLabel:@"priority" andType:@"INTEGER"], 
                               [nnSQLiteFieldInfo initWithLabel:@"state" andType:@"INTEGER"], 
                               [nnSQLiteFieldInfo initWithLabel:@"label" andType:@"TEXT"], 
                               [nnSQLiteFieldInfo initWithLabel:@"buffer" andType:@"TEXT"], 
// For future use               
                               [nnSQLiteFieldInfo initWithLabel:@"flags" andType:@"INTEGER"], 
                              nil];
        [db_delegate createTable:DB_ITEM_TABLE_NAME withFields:fieldList];
    }
    
    return error;
}

#pragma mark -
#pragma mark TableViewProvider Delegate


-(nnErrorCode)itemCreated: (nnListItem*)item
{
    
    nnErrorCode error = [db_delegate runSQLCommand:@"insert into items (group_key, priority, state, label, buffer) values (?,?,?,?,?);"
                    withParams:[NSArray arrayWithObjects: 
                                [NSNumber numberWithInt: item.groupKey],
                                [NSNumber numberWithInt: item.priority],
                                [NSNumber numberWithInt: item.state],
                                item.label,
                                [item getStringData],
                                nil]
                         ];
                                                    
    
    if(!error)
        item.pk = [db_delegate lastRow];
        
    if (item.groupKey)
        [tracking_delegate setModifiedTimeForPK: item.groupKey];
    
    return error;
}


-(nnErrorCode)emptyGroup:(NSInteger)groupKey
{
    nnErrorCode error = [db_delegate runSQLCommand:@"delete from items where group_key=?;"
                                        withParams:[NSArray arrayWithObjects: 
                                                    [NSNumber numberWithInt: groupKey],
                                                    nil]
                         ];
    return error;
    
}

-(nnErrorCode)itemDeleted: (nnListItem*)item
{
    
    nnErrorCode error = [db_delegate runSQLCommand:@"delete from items where pk=? or group_key=?;"
                                        withParams:[NSArray arrayWithObjects: 
                                                    [NSNumber numberWithInt: item.pk],
                                                    [NSNumber numberWithInt: item.pk],
                                                    nil]
                         ];
    if (error) 
    {
        return error;
    }
    if (!item.groupKey)  // We have a top level item
    {
        [tracking_delegate removeTrackingInfoForPKIfNoTag: item.pk];
    }
    else
    {
        [tracking_delegate setModifiedTimeForPK: item.groupKey];
    }
    return error;
}

-(nnErrorCode)itemUpdated: (nnListItem*)item;  
{
    nnErrorCode error = [db_delegate runSQLCommand:@"update items set group_key=?, priority=?, state=?, label=?, buffer=? where pk=?;"
                                        withParams:[NSArray arrayWithObjects: 
                                                    [NSNumber numberWithInt: item.groupKey],
                                                    [NSNumber numberWithInt: item.priority],
                                                    [NSNumber numberWithInt: item.state],
                                                    item.label,
                                                    [item getStringData],
                                                    [NSNumber numberWithInt: item.pk],
                                                    nil]];
    
    if (item.groupKey && ! error) 
        [tracking_delegate setModifiedTimeForPK: item.groupKey];
                         
    
    nnDebugLog(@"Updating %@",item.label);
    return error;
}

-(nnErrorCode)priorityUpdated: (nnListItem*)item;  
{
    
    nnErrorCode error = [db_delegate runSQLCommand:@"update items set  priority=? where pk=?;"
                                        withParams:[NSArray arrayWithObjects: 
                                                    [NSNumber numberWithInt: item.priority],
                                                    [NSNumber numberWithInt: item.pk],
                                                    nil]];
    
    nnDebugLog(@"Updating Order for %@",item.label);
    return error;
}

-(nnErrorCode)getItemForPK: (NSInteger) pk into: (nnListItem*)item
{
    
    nnSQLQuery *q = [[[nnSQLQuery alloc] init] autorelease];
    
    NSInteger error = [db_delegate createQuery:@"SELECT pk, group_key, priority, state, label, buffer from items where pk=?;"
                                        saveIn: q];
    
    if (error)
        return error;
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: pk], nil]];
    if (error)
        return error;
    
    error = [q execute];
    if (error)
        return error;

    item.pk = [q integerValue];
    item.groupKey =  [q integerValue];
    item.priority=  [q integerValue];
    item.state =  [q integerValue];
    item.label =  [q stringValue];
    [item setStringData: [q stringValue]];
           
    return nnkNoError;
}


-(nnErrorCode)getNameForGroupKey: (NSInteger) groupKey intoString:(NSString **)string
{
    
    nnSQLQuery *q = [[[nnSQLQuery alloc] init] autorelease];
    
    NSInteger error = [db_delegate createQuery:@"SELECT label from items where pk=? order by priority;"
                                        saveIn: q];
    
    if (error)
        return error;
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: groupKey], nil]];
    if (error)
        return error;

    error=[q step];
    if (error)
        return error;
    {
        *string = [[q stringValue] retain];
    }
    
    return nnkNoError;
}


-(nnErrorCode)getDataForGroupKey: (NSInteger) groupKey intoArray: (NSMutableArray*)items
{
    
    nnSQLQuery *q = [[[nnSQLQuery alloc] init] autorelease];
    
    NSInteger error = [db_delegate createQuery:@"SELECT pk, group_key, priority, state, label, buffer from items where group_key=? order by priority;"
                                        saveIn: q];
    
    if (error)
        return error;
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: groupKey], nil]];
    if (error)
        return error;
    
    [items removeAllObjects];
    while (!(error=[q step]))
    {
        nnListItem *td = [[nnListItem alloc] init];
          
        td.pk = [q integerValue];
        td.groupKey =  [q integerValue];
        td.priority=  [q integerValue];
        td.state =  [q integerValue];
        td.label =  [q stringValue];
        [td setStringData: [q stringValue]];
        
        [items addObject: td];
    
        [td release];
    }
   
    return nnkNoError;
}

@end