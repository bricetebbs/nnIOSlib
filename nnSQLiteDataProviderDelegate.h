//
//  nnSQLiteDataProviderDelegate.h
//  cloudlist
//
//  Created by Brice Tebbs on 5/28/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnTableViewDataProvider.h"
#import "nnSQLiteDBManager.h"
#import "nnRemoteSyncManager.h"

@interface nnSQLiteDataProviderDelegate : NSObject <nnLocalDataSourceDelegate>
{
    id <nnLocalSyncTrackingInfoDelegate>  tracking_delegate;
    id <nnSQLDBProtocol> db_delegate;
}

-(nnErrorCode)setupSqlDataProvider: (id <nnSQLDBProtocol>)del;

@property (nonatomic, assign) id <nnLocalSyncTrackingInfoDelegate>  tracking_delegate;
@property (nonatomic, assign) id <nnSQLDBProtocol> db_delegate;
@end
