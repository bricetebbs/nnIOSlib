//
//  nnTableViewController.h
//
//  Created by Brice Tebbs on 5/24/10.
//  Copyright northNitch Studios, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnTableViewDataProvider.h"


@protocol nnTableViewControllerDelegate
-(void)setCurrentProvider: (nnTableViewDataProvider*) dp;
@end

@interface nnTableViewController : UITableViewController {
    nnTableViewDataProvider *dataProvider;
    id <nnTableViewControllerDelegate> delegate;
    NSInteger numFunctionRows;
}

@property (nonatomic, retain) nnTableViewDataProvider *dataProvider;
@property (nonatomic, assign) id<nnTableViewControllerDelegate> delegate;

-(NSInteger)dataRowForIndexPath:(NSIndexPath*)ip;
@end
