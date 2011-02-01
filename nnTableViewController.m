//
//  RootViewController.m
//  cloudlist
//
//  Created by Brice Tebbs on 5/10/10.
//  Copyright northNitch Studios, Inc. 2010. All rights reserved.
//

#import "nnTableViewController.h"

@implementation nnTableViewController

@synthesize dataProvider;
@synthesize delegate;
#pragma mark -
#pragma mark View lifecycle

- (void)dealloc {
    [dataProvider release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [delegate setCurrentProvider: dataProvider];
    [dataProvider setupDataProvider];
    [self.tableView reloadData];
}



// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row >= numFunctionRows;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row >= numFunctionRows;
}


-(NSInteger)dataRowForIndexPath:(NSIndexPath*)ip
{
    return ip.row - numFunctionRows;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataProvider getNumItems] + numFunctionRows;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end

