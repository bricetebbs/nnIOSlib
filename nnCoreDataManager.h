//
//  nnCoreDataManager.h
//
//  Keeps track of the stuff you need to talk to Core data.
//
//  Created by Brice Tebbs on 7/28/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "northNitch.h"


@interface nnCoreDataManager : NSObject {
    
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    
    NSString *filePath;
    NSString *dataModel;
}


//
// Configuration / Setup
//
-(nnErrorCode)setupCoreDataManager: (NSString*)filePath model: (NSString*) modelName;
- (NSString *)applicationDocumentsDirectory;


// Dealing with Context

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

// Create a new object in the context
-(id) newObject: (NSString*) entityName;
// Delete the specified object
-(void)deleteObject: (id)objectToDelete;
// Save the context
-(NSError*)saveContext;

// Search the context for the first occurance of the object
-(id)findObject:(NSString*)entityName withPredicate: (NSPredicate*)predicate andSort: (NSArray*)sortDescriptors;


-(NSEntityDescription*)getEntityDescription: (NSString*)entityName;

// Errors and other exceptions
-(void)handleError: (NSError*) error;
-(void)handleAppTermination;


@end
