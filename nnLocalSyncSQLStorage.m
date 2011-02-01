//
//  nnLocalSyncSQLStorage.m
//
//  Created by Brice Tebbs on 6/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnLocalSyncSQLStorage.h"
#import "nnSQLiteDBManager.h"



@implementation nnLocalSyncSQLStorage


NSString* DB_RSYNC_TABLE_NAME = @"syncinfo";

-(nnErrorCode)setupLocalSyncStorage: (id <nnSQLDBProtocol>) del
{
    nnErrorCode error = nnkNoError;
   
    db_delegate = del;
    
    error = [db_delegate checkTable:DB_RSYNC_TABLE_NAME];
    if(error)
    {
        NSArray* fieldList = [NSArray arrayWithObjects:
                              [nnSQLiteFieldInfo initWithLabel:@"item_pk" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"item_tag" andType:@"TEXT"], 
                              [nnSQLiteFieldInfo initWithLabel:@"l_c_seq" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"l_s_seq" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"r_s_seq" andType:@"INTEGER"], 
                              
// These two are for future use
                              [nnSQLiteFieldInfo initWithLabel:@"remote_source" andType:@"INTEGER"], 
                              [nnSQLiteFieldInfo initWithLabel:@"deleted" andType:@"INTEGER"], 
                              nil];
        [db_delegate createTable:DB_RSYNC_TABLE_NAME withFields:fieldList];
    }
    return error;
}


-(nnErrorCode)removeTrackingInfoForPKIfNoTag: (NSInteger)pk
{
    return nnkNoError;
    nnErrorCode error = [db_delegate runSQLCommand:@"delete from syncinfo where item_pk=? and item_tag='';" withParams: [NSArray arrayWithObjects:
                                                                                 [NSNumber numberWithInt: pk],
                                                                       nil]];

 
    
    return error;
                                                                
}

-(nnErrorCode)removeTrackingInfoForTag: (NSString*)tag
{
    nnErrorCode error = [db_delegate runSQLCommand:@"delete from syncinfo where  item_tag=?;" withParams: [NSArray arrayWithObjects:
                                                                                                                            tag,
                                                                                                                            nil]];
    
    
    
    return error;
    
}



-(nnErrorCode)createDataForPK: (NSInteger)pk
{
    
    nnErrorCode error = [db_delegate runSQLCommand: @"insert into syncinfo (item_pk, item_tag, l_c_seq, l_s_seq, r_s_seq) values (?,?,?,?,?)" 
                                        withParams: [NSArray arrayWithObjects:
                                                        [NSNumber numberWithInt: pk],
                                                        @"",
                                                        [NSNumber numberWithLong: 0],
                                                        [NSNumber numberWithLong: 0],
                                                        [NSNumber numberWithLong: 0],
                                                        nil]];
    return error;

}

-(nnErrorCode)writeDataForPK: (NSInteger)pk with: (nnLocalSyncTrackingInfo*)ti
{
    
    nnErrorCode error = [db_delegate runSQLCommand: @"update syncinfo set item_pk=?, item_tag=?, l_c_seq=?, l_s_seq=?, r_s_seq=? where item_pk=?" 
                                        withParams: [NSArray arrayWithObjects:
                                                     [NSNumber numberWithInt: ti.pk],
                                                     ti.tag,
                                                     [NSNumber numberWithLong: ti.localCurrentSeq],
                                                     [NSNumber numberWithLong: ti.localSyncedSeq],
                                                     [NSNumber numberWithLong: ti.remoteSyncedSeq],
                                                     [NSNumber numberWithInt: ti.pk],
                                                     nil]];
    return error;
    
}

-(nnErrorCode)readDataForPK: (NSInteger)pk as:  (nnLocalSyncTrackingInfo*)ti
{
    nnSQLQuery *q  = [[[nnSQLQuery alloc]init] autorelease];
    
    nnErrorCode error = [db_delegate createQuery:@"select item_pk, item_tag, l_c_seq, l_s_seq,  r_s_seq from syncinfo where item_pk=?;" 
                       saveIn: q];
    
    if (error)
    {
        return error;
    }
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: pk], nil]];
    if(error)
    {
        return error;
    }
    
    error = [q execute];
    if (error)
        return error;
    
    ti.pk = [q integerValue];
    ti.tag = [q stringValue];
    ti.localCurrentSeq = [q integerValue];
    ti.localSyncedSeq = [q integerValue];
    ti.remoteSyncedSeq  = [q integerValue];
    
    return error;
    
}

-(nnErrorCode)insurePkExists:(NSInteger) pk

{
    nnSQLQuery *q  = [[[nnSQLQuery alloc]init] autorelease];
    
    nnErrorCode error = [db_delegate createQuery:@"select item_pk from syncinfo where item_pk=?;" 
                                          saveIn: q];
    
    if (error)
    {
        return error;
    }
    error = [q bindParameters: [NSArray arrayWithObjects: [NSNumber numberWithInt: pk], nil]];
    if(error)
    {
        return error;
    }
    
    error = [q step];

    if (error) {
        error = [self createDataForPK: pk];
        if (error)
            return error;
    }
    return error;
}


-(nnErrorCode)getTrackingInfoForPK: (NSInteger)pk as: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error =  [self insurePkExists: pk];
    
    if (error)
        return error;
    
    error = [self readDataForPK: pk as: ti];
    
    return error;
}   



-(nnErrorCode)getTrackingInfoForTag: (NSString*)tag as: (nnLocalSyncTrackingInfo*)ti
{
    
    nnSQLQuery *q  = [[[nnSQLQuery alloc]init] autorelease];
        
    nnErrorCode error = [db_delegate createQuery:@"select item_pk, item_tag, l_c_seq, l_s_seq,  r_s_seq from syncinfo where item_tag=?;" 
                                              saveIn: q];
        
    if (error)
    {
        return error;
    }
    error = [q bindParameters: [NSArray arrayWithObjects: tag, nil]];
    if(error)
    {
        return error;
    }
    
    error = [q execute];
    if (error)
    {
        ti.pk = 0;
        ti.tag = tag;
        ti.localCurrentSeq = 0;
        ti.localSyncedSeq = 0;
        ti.remoteSyncedSeq  = 0;
    }
    else
    {
        ti.pk = [q integerValue];
        ti.tag = [q stringValue];
        ti.localCurrentSeq = [q integerValue];
        ti.localSyncedSeq = [q integerValue];
        ti.remoteSyncedSeq  = [q integerValue];
    }
    
    return nnkNoError;
    
}


-(nnErrorCode)saveTrackingInfo: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error =  [self insurePkExists: ti.pk];
    if (error)
        return error;
    
    error = [self writeDataForPK:ti.pk with:ti];

    return error;
    
}

-(void)setLocalCurrentSeq:(NSInteger)seq
{
    localCurrentSeqNum = seq;
}


-(nnErrorCode)setModifiedTimeForPK: (NSInteger)pk
{
    nnErrorCode error = [self insurePkExists: pk];
    if(error)
        return error;
        
    
    error = [db_delegate runSQLCommand:@"update syncinfo set l_c_seq=? where item_pk=?;" withParams: [NSArray arrayWithObjects:
                                                                                           [NSNumber numberWithLong: localCurrentSeqNum],
                                                                                           [NSNumber numberWithInt: pk],
                                                                                           nil]];
    return error;
}

@end
