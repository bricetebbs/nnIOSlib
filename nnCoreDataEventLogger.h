//
//  nnCoreDataEventLogger.h
//  metime
//
//  Created by Brice Tebbs on 7/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "nnEventLoggerProtocol.h"

@interface nnCoreDataEventLogger : NSObject <nnEventLoggerProtocol> {
    NSManagedObjectContext *managedObjectContext;	
    NSString *entityName;
    
}

-(void)setupCoreDataEventLogger: (NSManagedObjectContext *)managedObjectContext modelIs: (NSString*)entityName;
-(void)test;
@end
