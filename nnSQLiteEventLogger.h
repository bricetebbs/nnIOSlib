//
//  nnSQLiteEventLogger.h
//  metime
//
//  Created by Brice Tebbs on 7/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnSQLiteDBManager.h"
#import "nnEventLoggerProtocol.h"

@interface nnSQLiteEventLogger : NSObject <nnEventLoggerProtocol> {
    id <nnSQLDBProtocol> db_delegate;
}

-(nnErrorCode)setupSQLiteEventLogger: (id <nnSQLDBProtocol>) del;
@end
