//
//  nnCoreDataBackgroundThreadManager.m

//
//  Created by Brice Tebbs on 8/3/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCoreDataBackgroundThreadManager.h"

@interface nnCoreDataBackgroundThreadManager ()

@property (nonatomic, retain) nnCoreDataManager *coreDataManager;
@property (nonatomic, assign) NSAutoreleasePool *pool;
@end


@implementation nnCoreDataBackgroundThreadManager
@synthesize coreDataManager;
@synthesize pool;

-(id)retain
{
    return [super retain];
}
-(void)dealloc
{
    if(inputBlocking)
        [ [UIApplication sharedApplication] endIgnoringInteractionEvents];

    [backgroundManagedObjectContext_ release];
    [coreDataManager release];
    [pool release];
    [super dealloc];
}

-(id)initWithCoreDataManager:(nnCoreDataManager *)cd blockInput: (BOOL)block
{
    self = [super init];
    if (self) {
        self.coreDataManager = cd;
        self.pool = [[NSAutoreleasePool alloc] init];
        if(backgroundManagedObjectContext_ != nil)
            backgroundManagedObjectContext_ = nil;
        
        inputBlocking = block;
        if(inputBlocking)
            [ [UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    return self;
}


- (NSManagedObjectContext *) backgroundManagedObjectContext {
	
    if (backgroundManagedObjectContext_ != nil) {
        return backgroundManagedObjectContext_;
    }
	backgroundManagedObjectContext_ = [[NSManagedObjectContext alloc] init];
    [backgroundManagedObjectContext_ setPersistentStoreCoordinator:coreDataManager.persistentStoreCoordinator];
    return backgroundManagedObjectContext_;
}

@end
