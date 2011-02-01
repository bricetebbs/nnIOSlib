//
//  nnRemoteSyncManager.h
//
//  Created by Brice Tebbs on 5/30/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//


#import "nnTableViewDataProvider.h"

@interface nnLocalSyncTrackingInfo : NSObject
{
    NSInteger pk;  
    NSString *tag;
    NSString *label;
    
    NSInteger localCurrentSeq;
    NSInteger localSyncedSeq;
    
    NSInteger remoteCurrentSeq;  // Not stored in local DB
    NSInteger remoteSyncedSeq;
}

@property (nonatomic, assign)  NSInteger pk; 
@property (nonatomic, copy) NSString* tag;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, assign) NSInteger localCurrentSeq;
@property (nonatomic, assign) NSInteger localSyncedSeq;
@property (nonatomic, assign) NSInteger remoteCurrentSeq;
@property (nonatomic, assign) NSInteger remoteSyncedSeq;
@end

@interface nnRemoteSyncTrackingInfo : NSObject
{ 
    NSString *tag;
    NSString *label;
    NSInteger remoteCurrentSeq;
   
}
@property (nonatomic, copy) NSString* tag;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, assign) NSInteger remoteCurrentSeq;
@end


@protocol nnLocalSyncTrackingInfoDelegate  // Could talk to mysql or core data
// Used during tracking
-(nnErrorCode)removeTrackingInfoForPKIfNoTag: (NSInteger)pk;
-(nnErrorCode)removeTrackingInfoForTag: (NSString*)tag;
-(nnErrorCode)setModifiedTimeForPK: (NSInteger)pk;

-(void)setLocalCurrentSeq:(NSInteger) seq;
// Used By Sync
-(nnErrorCode)getTrackingInfoForPK: (NSInteger)pk as: (nnLocalSyncTrackingInfo*)ti;
-(nnErrorCode)getTrackingInfoForTag: (NSString*)tag as: (nnLocalSyncTrackingInfo*)ti;
-(nnErrorCode)saveTrackingInfo: (nnLocalSyncTrackingInfo*)ti;
@end

@protocol nnRemoteSyncTrackingInfoDelegate  // Currently talks to Evernote
-(nnErrorCode)getAllTrackingInfo: (NSMutableArray*)rti;
@end

@protocol nnRemoteDataSourceDelegate // Also implemented as evernote
-(nnErrorCode)writeItems: (NSArray*) items andHeader: (NSString*) header withTracking:(nnLocalSyncTrackingInfo*)ti;
-(nnErrorCode)readItems: (NSMutableArray*) items andHeader: (NSString**) header withTracking:(nnLocalSyncTrackingInfo*)ti;

-(nnErrorCode)createNewGroupWithTitle: (NSString*)title setTag:(NSString**)tag;
-(nnErrorCode)removeGroupTag: (NSString*)tag;
@end

@protocol nnSyncNotificationDelegate
-(void)updateSyncState:(NSString*)mode;
@end


@interface nnRemoteSyncManager : NSObject {

    id <nnRemoteDataSourceDelegate> remoteSource;
    id <nnLocalDataSourceDelegate> localSource;
    id <nnLocalSyncTrackingInfoDelegate> localTrack;
    id <nnRemoteSyncTrackingInfoDelegate> remoteTrack;
    id <nnSyncNotificationDelegate> notification;
    NSString *errorItem;
    NSMutableArray* groups;
    
}


@property (nonatomic, copy) NSString* errorItem;
@property (nonatomic, assign) id <nnRemoteDataSourceDelegate> remoteSource;
@property (nonatomic, assign) id <nnLocalDataSourceDelegate> localSource;
@property (nonatomic, assign) id <nnLocalSyncTrackingInfoDelegate> localTrack;
@property (nonatomic, assign) id <nnRemoteSyncTrackingInfoDelegate> remoteTrack;
@property (nonatomic, assign) id <nnSyncNotificationDelegate> notification;


-(nnErrorCode)syncItems;

@end

