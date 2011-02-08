//
//  nnCoreDataManager.m
//  metime
//
//  Created by Brice Tebbs on 7/28/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCoreDataManager.h"


@interface nnCoreDataManager ()
@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* dataModel;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation nnCoreDataManager
@synthesize filePath;
@synthesize dataModel;

-(void)dealloc
{
    [filePath release];
    [dataModel release];
    [managedObjectModel_ release];
    [managedObjectContext_ release];
    [persistentStoreCoordinator_ release];
    [super dealloc];
    
}

-(nnErrorCode)setupCoreDataManager:(NSString *)filename model:(NSString *)modelName
{
    self.filePath = filename;
    self.dataModel = modelName;
    return nnkNoError;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:self.dataModel ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: self.filePath]];
	
	NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator_;
}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSEntityDescription*)getEntityDescription: (NSString*)entityName
{
    return [NSEntityDescription entityForName:entityName
                                          inManagedObjectContext:self.managedObjectContext];
}

-(id)newObject: (NSString*) entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext: self.managedObjectContext];
}


-(id) findObject: (NSString*) entityName withPredicate: (NSPredicate*)predicate andSort: (NSArray*)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];

    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate: predicate];
    [fetchRequest setEntity: [self getEntityDescription: entityName]];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    if ([results count])
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

-(void)deleteObject: (id) objectToDelete
{
    [self.managedObjectContext deleteObject: objectToDelete];
}

-(NSError*)saveContext
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) 
    {   
        [self handleError: error];
    }
    return error;
}

-(void)handleAppTermination
{

    NSError *error = nil;
    if (managedObjectContext_ != nil) 
    {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
            
            [self handleError: error];
        } 
    }
}


-(void)handleError: (NSError*) error;
{
/*
 Replace this implementation with code to handle the error appropriately.
*/
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
}

@end
