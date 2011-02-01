//
//  nnCoreDataTableViewController.m
//  metime
//
//  Created by Brice Tebbs on 7/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCoreDataTableViewController.h"


@implementation nnCoreDataTableViewController

@synthesize coreDataManager;
@synthesize fetchedResultsController;



- (void)dealloc {
    fetchedResultsController.delegate = nil;
    [fetchedResultsController release];
    [coreDataManager release];

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    if (!self.fetchedResultsController) {
        [self prepareFetchResultsController];
    }
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    NSInteger dataSections = [[fetchedResultsController sections] count];
    return dataSections;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}





- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
   // [self configureCell:cell atIndexPath:indexPath];
}



#pragma mark -
#pragma mark Fetched results controller



/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
    
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self updateCell: [tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}


// Overridden by subclass
-(NSFetchRequest *)getFetchRequestForController
{
    return nil;
}


- (nnErrorCode)prepareFetchResultsController
{

	self.fetchedResultsController =  [[NSFetchedResultsController alloc] 
                                 initWithFetchRequest: [self getFetchRequestForController] 
                                 managedObjectContext: self.coreDataManager.managedObjectContext
                                 sectionNameKeyPath:nil cacheName:nil];
	
	
    self.fetchedResultsController.delegate = self;
    
	
    return nnkNoError;
}    

@end
