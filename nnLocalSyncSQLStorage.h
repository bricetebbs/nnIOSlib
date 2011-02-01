//
//  nnLocalSyncSQLStorage.h
//
//  Created by Brice Tebbs on 6/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnSQLiteDBManager.h"
#import "nnRemoteSyncManager.h"


@interface nnLocalSyncSQLStorage :  NSObject <nnLocalSyncTrackingInfoDelegate>
{
    id <nnSQLDBProtocol> db_delegate;
    NSInteger localCurrentSeqNum;
    
}

-(nnErrorCode)setupLocalSyncStorage: (id <nnSQLDBProtocol>) db_delegate;

@end
