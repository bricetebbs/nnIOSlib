//
//  nnCoreDataTableViewController.h
//
//  Created by Brice Tebbs on 7/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "northNitch.h"
#import "nnCoreDataManager.h"

@interface nnCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    nnCoreDataManager *coreDataManager;	
}

// Called to setup the fetchedResultsController. Uses getFetchRequestForController.
-(nnErrorCode)prepareFetchResultsController;


// Accessors
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) nnCoreDataManager *coreDataManager;	


//
// Subclasses will want to override these
//

// Create a NSFetchRequest, set an entity and sort descriptors
-(NSFetchRequest *)getFetchRequestForController;  

// The object at the IndexPath has changed maybe you want to update the Cell display?
-(void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath; 

@end
