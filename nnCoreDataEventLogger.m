//
//  nnCoreDataEventLogger.m
//  metime
//
//  Created by Brice Tebbs on 7/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCoreDataEventLogger.h"




@implementation nnCoreDataEventLogger
-(void)setupCoreDataEventLogger: (NSManagedObjectContext *)moc modelIs: (NSString*)en;
{
    managedObjectContext = moc;
    entityName = en;
}


-(nnErrorCode)logEvent: (NSInteger)eventId forKey:(NSInteger)pk value:(NSInteger)value;
{
    NSManagedObject *event = [NSEntityDescription
                             insertNewObjectForEntityForName:entityName 
                             inManagedObjectContext:managedObjectContext];
    
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    
    [event setValue: [NSNumber numberWithInt: pk ] forKey:@"key"];
    [event setValue: [NSNumber numberWithInt: eventId ] forKey:@"kind"];
    [event setValue: [NSNumber numberWithInt: value ] forKey:@"value"];
    [event setValue: [NSNumber numberWithDouble: timestamp] forKey:@"timestamp"];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }    
    return nnkNoError;
    
}
     
-(nnErrorCode)countEvents: (NSInteger)eventId forKey:(NSInteger)pk storeIn:(NSInteger*)count
{
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:entityName inManagedObjectContext:managedObjectContext];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"kind = %@ AND key = %@",
                              [NSNumber numberWithInt: eventId], 
                              [NSNumber numberWithInt:pk]
                              ];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    *count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if(error)
    { 
         NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } 
    
    [fetchRequest release];
    
    return nnkNoError;
}
     
     
-(nnErrorCode)fetchEvents: (NSInteger)eventId storeIn: (NSMutableArray*)results
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        nnLoggedEvent *le = [[nnLoggedEvent alloc] init];
        le.key = [[info valueForKey:@"key"] integerValue];
        le.kind = [[info valueForKey:@"kind"] integerValue];
        le.value = [[info  valueForKey:@"value"] integerValue];
        le.timestamp = [[info valueForKey:@"timestamp"] doubleValue];
        [results addObject: le];
        [le release];
    }        
    
    [fetchRequest release];
    
    return nnkNoError;
}

-(void)test
{
    NSManagedObject *test = [NSEntityDescription
                             insertNewObjectForEntityForName:entityName 
                             inManagedObjectContext:managedObjectContext];
    
    
    [test setValue: [NSNumber numberWithInt: 33 ] forKey:@"key"];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Key: %@", [info valueForKey:@"key"]);
    }        
    
    [fetchRequest release];

}
@end
