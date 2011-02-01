//
//  nnRemoteSyncManager.m
//
//  Created by Brice Tebbs on 5/30/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnRemoteSyncManager.h"


@implementation nnRemoteSyncManager
@synthesize localSource;
@synthesize remoteSource;
@synthesize localTrack;
@synthesize remoteTrack;
@synthesize notification;
@synthesize errorItem;


-(void)dealloc
{   
    [errorItem release];
    [groups release];
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        groups = [[NSMutableArray alloc] init];
    }
    return self;
}


enum SyncTypes
{
    NoRecord = -1,
    NoNewStuff = 0,
    HasNewStuff = 1
};

-(void)getStatesFromInfo: (nnLocalSyncTrackingInfo*)ti: (NSInteger*)localState : (NSInteger*) remoteState
{
    if (ti.pk == 0) {
        *localState = NoRecord;
    }
    else if(ti.localCurrentSeq > ti.localSyncedSeq)
    {
        *localState = HasNewStuff;
    }
    else {
        *localState = NoNewStuff;
    }
    if (ti.remoteCurrentSeq < 0)
    {
        // If the remote has never been synced then even if we have not changed since last since we are still new
        if ([ti.tag length] < 1 )  
            *localState = HasNewStuff;
        
        *remoteState = NoRecord;
    }
    else if(ti.remoteCurrentSeq > ti.remoteSyncedSeq)
    {
        *remoteState = HasNewStuff;
    }
    else {
        *remoteState = NoNewStuff;
    }
}

-(nnListItem*)getGroupForKey: (NSInteger)key
{
    for (nnListItem *l in groups) {
        if (l.pk == key)
            return l;
    }
    return nil;
            
}

-(nnErrorCode)writeListLocally: (NSMutableArray*)items: (NSString*)header: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error = nnkNoError;
    
    nnListItem* group;
       
    group = [self getGroupForKey: ti.pk];
    if (group)
    {
        [group setStringData:header];
        [group setLabel: ti.label];
        error = [localSource emptyGroup: ti.pk];
        if (error) return error;
        
        error = [localSource itemUpdated:group];
    }
    else
    {   
        group = [[[nnListItem alloc] init] autorelease];
        group.label = ti.label;
        [group setStringData:header];
        
        error =[localSource itemCreated: group];
        ti.pk = group.pk;
    }
    if (error) 
    {
        return error;
    }
    
    NSInteger priority = 0;
    for (nnListItem* item in items)
    {
        item.groupKey = ti.pk;
        item.priority = priority++;
        error = [localSource itemCreated: item];
    }
    
    return error;
}


-(nnErrorCode)writeListRemotely:(NSMutableArray *)items : (NSString*)header: (nnLocalSyncTrackingInfo *)ti
{
    nnErrorCode error= nnkNoError;
    nnListItem* group= [self getGroupForKey:ti.pk];
    if(group)
    {
        if (!ti.tag || ([ti.tag length] < 1))  // If we don't already have a GUID for this note
        {
            NSString *tag;
            error = [remoteSource createNewGroupWithTitle: group.label setTag: &tag];
            if(error)
                return error;
            ti.tag=tag;
            [tag release];
        }
        ti.label = group.label;
        error = [remoteSource writeItems:items andHeader: header withTracking: ti];
        if (error) {
            return error;
        }
    }
    return error;
}

-(nnErrorCode)pushLocalToServer: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error = nnkNoError;
    
    nnDebugLog(@"Pushing %@ to server PK=%d Tag=%@",ti.label,ti.pk, ti.tag);

    
    nnListItem *group =[self getGroupForKey: ti.pk];
    
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    error =[localSource getDataForGroupKey: ti.pk intoArray: items];
    if(error)
        return error;
   
    error = [self writeListRemotely :items: [group getStringData]: ti];
    return error;
}


-(nnErrorCode)pullFromServer: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error= nnkNoError;
    nnDebugLog(@"Pulling %@ from server PK=%d Tag=%@",ti.label,ti.pk, ti.tag);
    
    NSMutableArray* items  = [[[NSMutableArray alloc] init] autorelease];
    NSString* header;
    error = [remoteSource readItems: items andHeader:&header withTracking: ti];
    [header autorelease];
    if(error)
        return error;
    
    error = [self writeListLocally: items : header : ti];
    return error;
}


-(nnErrorCode)removeFromLocal: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error= nnkNoError;
    
    nnListItem *group =[self getGroupForKey: ti.pk];
    if (group) {
        nnLog(@"Deleting Local is %@",ti.label);
        error = [localSource itemDeleted: group];
    }
    return error;
    
}
-(nnErrorCode)removeFromServer: (nnLocalSyncTrackingInfo*)ti
{
    nnLog(@"Removing  Remote is %@",ti.label);

    nnErrorCode error = [remoteSource removeGroupTag: ti.tag];
    if(!error)
        error = [localTrack removeTrackingInfoForTag: ti.tag];
    return error;
        
}

-(nnListItem*)findMatch: (nnListItem*)li: (NSArray*)mergedItems
{
    for (nnListItem *si in mergedItems)
    {
        if ([si.label isEqualToString: li.label])
        {
            return si;
        }
    }
    return nil;
}

-(nnErrorCode)mergeItems: (nnLocalSyncTrackingInfo*)ti
{
    nnErrorCode error = nnkNoError;
    
    nnLog(@"Merging  Label is %@",ti.label);
    
    NSMutableArray *localItems = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *remoteItems = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *mergedItems = [[[NSMutableArray alloc] init] autorelease];

    NSString* header;
    error = [localSource getDataForGroupKey: ti.pk intoArray: localItems];
    if(error) return error;
    error = [remoteSource readItems: remoteItems andHeader: &header withTracking: ti];
    [header autorelease];
    
    if(error) return error;

    //
    // Merge Items
    //
    NSMutableArray *master,*slave;
    
    if( [localItems count] >= [remoteItems count])
    {
        master = localItems;
        slave = remoteItems;
    }
    else {
        master = remoteItems;
        slave = localItems;
    }

    for(nnListItem *li in master)
    {
        [mergedItems addObject: li];
    }
    for(nnListItem *li in slave)
    {
        nnListItem *match = [self findMatch: li: mergedItems];
        if(match)
        {
            match.state = match.state || li.state;
        }
        else
        {
            [mergedItems addObject:li];
        }
    }
    //
    // Stored Merged Items
    //
    error = [self writeListLocally: mergedItems : header: ti];
    if(error) return error;
    
    error = [self writeListRemotely: mergedItems : header: ti];
    

    return error;
}


-(nnErrorCode)syncItems
{
    NSInteger idx;
    
    //
    // Presync local items are written with he current value. Say 3. If 
    
    // if(ti.localCurrentSeq > ti.localSyncedSeq) 
    // This would mean there was a change since last sync.
    // After sync we set localSynced to localCurrent.
    // and but the track number to 4
    //

    
    NSMutableArray* localSyncInfo = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* remoteSyncInfo = [[[NSMutableArray alloc] init] autorelease];
    nnErrorCode error;
    nnLocalSyncTrackingInfo* ti;
    
    //
    // Get Local Info
    //
    [localSource getDataForGroupKey: 0 intoArray: groups];
    
    //
    // Get server info
    // 
    [notification updateSyncState:@"Getting Remote Info"];
    
    error = [remoteTrack getAllTrackingInfo: remoteSyncInfo];
    for (nnRemoteSyncTrackingInfo* rs in remoteSyncInfo)
    {
        nnDebugLog(@"REMOTE Label=%@ tag=%@ seq=%d",rs.label, rs.tag, rs.remoteCurrentSeq);
    }
    if (error)
    {
        return error;
    }

    [notification updateSyncState:@"Checking against Local Info"];
    

    for (idx = 0; idx < [groups count]; idx++)
    {
        NSInteger pk;
        pk = [[groups objectAtIndex: idx] pk];
        ti = [[nnLocalSyncTrackingInfo alloc] init];
        [localTrack getTrackingInfoForPK:pk as: ti];
        ti.label = [[groups objectAtIndex: idx] label];
        
        
        BOOL found = NO;
        for (nnRemoteSyncTrackingInfo *rsti in remoteSyncInfo)
        {
            if (rsti.tag && ![rsti.tag isEqualToString:@""] && [rsti.tag isEqualToString: ti.tag])
            {
                ti.remoteCurrentSeq = rsti.remoteCurrentSeq;
                ti.label = rsti.label; // Remote always wins
                rsti.tag = nil;
                found = YES;
            }
        }
        if(!found)
        {
            
            nnDebugLog(@"Not found on server");
            ti.remoteCurrentSeq = ti.remoteSyncedSeq = -1; 
        }
        [localSyncInfo addObject: ti];
        [ti release];
    }
    for (nnRemoteSyncTrackingInfo *rsti in remoteSyncInfo) 
    {
        if (rsti.tag != nil) // We didn't match this one so make a fresh record
        {
            nnLocalSyncTrackingInfo* newTi = [[nnLocalSyncTrackingInfo alloc] init];
            
            [localTrack getTrackingInfoForTag:rsti.tag as: newTi];
            newTi.pk = 0;
            newTi.tag = rsti.tag;
            newTi.label = rsti.label;
            newTi.remoteCurrentSeq = rsti.remoteCurrentSeq;
            newTi.localSyncedSeq = 0;
            newTi.localCurrentSeq = 0;
            [localSyncInfo addObject: newTi];
            [newTi release];
        }
    }
    
    
    [notification updateSyncState:@"Performing updates"];
    
    //
    // Handle each note
    //
    for(ti in localSyncInfo)
    {
        NSInteger localState, remoteState;
        
        nnLog(@"PK=%d label=%@ Tag=%@ Local C, S[%d,%d]  Remote C,S [%d,%d]",ti.pk, ti.label, ti.tag, ti.localCurrentSeq,
              ti.localSyncedSeq, ti.remoteCurrentSeq, ti.remoteSyncedSeq);
        
        [self getStatesFromInfo: ti: &localState: &remoteState];
        nnLog(@"LS=%d RS=%d",localState, remoteState);
        
        if (localState == HasNewStuff && remoteState != HasNewStuff)
            error = [self pushLocalToServer: ti];
     
        else if(remoteState == HasNewStuff && localState != HasNewStuff)
            error =[self pullFromServer: ti];
        
        
        else if(remoteState == NoRecord && localState == NoNewStuff)
            error =[self removeFromLocal: ti];
        
        
        else if(localState == NoRecord && remoteState == NoNewStuff)
            error =[self removeFromServer: ti];
    
        else if(localState == HasNewStuff && remoteState == HasNewStuff)
            error = [self mergeItems: ti];
        
        if (error) 
        {
            self.errorItem = ti.label;
            return error;
        }
    
        ti.remoteSyncedSeq = ti.remoteCurrentSeq;
        ti.localSyncedSeq = ti.localCurrentSeq;
        [localTrack saveTrackingInfo: ti];
    }
    
    [localSyncInfo removeAllObjects];
    [remoteSyncInfo removeAllObjects];    
    NSInteger currentSeq = [[NSUserDefaults standardUserDefaults] integerForKey: @"localSyncSeq"];
    currentSeq += 1;
    [self.localTrack setLocalCurrentSeq: currentSeq];
  
    
    [[NSUserDefaults standardUserDefaults] setInteger: currentSeq forKey: @"localSyncSeq"];

    return nnkNoError;
}

@end

@implementation nnLocalSyncTrackingInfo
@synthesize pk;
@synthesize tag;
@synthesize label;
@synthesize localCurrentSeq;
@synthesize remoteCurrentSeq;
@synthesize localSyncedSeq;
@synthesize remoteSyncedSeq;

-(void)dealloc
{
    [tag release];
    [label release];
    [super dealloc];
}
@end


@implementation nnRemoteSyncTrackingInfo
@synthesize tag;
@synthesize label;
@synthesize remoteCurrentSeq;

-(void)dealloc
{
    [tag release];
    [label release];
    [super dealloc];
}
@end



