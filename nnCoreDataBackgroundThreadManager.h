//
//  nnCoreDataBackgroundThreadManager.h
//
//  Experimental. Helper for making CoreData background threads
//
//
//  Created by Brice Tebbs on 8/3/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnCoreDataManager.h"

@interface nnCoreDataBackgroundThreadManager : NSObject {
    NSAutoreleasePool* pool;
    NSManagedObjectContext *backgroundManagedObjectContext_;
    nnCoreDataManager *coreDataManager;
    
    BOOL inputBlocking;
}

-(id)initWithCoreDataManager: (nnCoreDataManager*)cd blockInput: (BOOL) pp;
@property (readonly,retain) NSManagedObjectContext* backgroundManagedObjectContext;

@end
