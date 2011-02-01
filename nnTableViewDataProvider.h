//
//  nnTableViewDataProvider.h
//  cloudlist
//
//  Created by Brice Tebbs on 5/10/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnCheckBoxTableViewCell.h"
#import "nnAddItemTableViewCell.h"

#import "nnListItem.h"


@class nnTableViewDataProvider;


// Provides Persistence (via sqllite coredata etc)

@protocol nnLocalDataSourceDelegate
//
// CRUD Stuff for items
//
-(nnErrorCode)itemCreated: (nnListItem*)item;
-(nnErrorCode)itemDeleted: (nnListItem*)item;
-(nnErrorCode)itemUpdated: (nnListItem*)item;   // We could make this more verbose to be more efficient

-(nnErrorCode)priorityUpdated: (nnListItem*)item;  

-(nnErrorCode)emptyGroup: (NSInteger)groupKey;
-(nnErrorCode)getDataForGroupKey: (NSInteger)groupKey intoArray: (NSMutableArray*)items;
-(nnErrorCode)getItemForPK: (NSInteger) pk into: (nnListItem*)item;

@end


@interface nnTableViewDataProvider : NSObject <nnAddItemTableViewCellDelegate>
{
    
    NSMutableArray* itemArray;
    NSInteger groupKey;
    
    id <nnLocalDataSourceDelegate> delegate;
    id extraInfo;
    BOOL isSetup;
}


@property (nonatomic, assign) NSInteger groupKey;
@property (nonatomic, assign) id <nnLocalDataSourceDelegate> delegate;
@property (nonatomic, retain) id extraInfo;


// Config
-(nnErrorCode)setupDataProvider;
-(nnErrorCode)makeDirty;


// Editing
-(nnErrorCode)addItemUsingString: (NSString*)name;

-(nnErrorCode)deleteItemAtIndex: (NSInteger) idx;
-(nnErrorCode)setCheckedForIndex: (NSInteger) idx as: (BOOL) checked;

-(nnErrorCode)setLabelForIndex: (NSInteger) idx as: (NSString*) label;

-(nnErrorCode)setStateForIndex: (NSInteger) idx as: (NSInteger) state;
-(nnErrorCode)moveFrom: (NSInteger) fromitem to: (NSInteger) toitem;

-(nnErrorCode)sortByStatus;

-(nnErrorCode)sortByStatusDescending;


//Read from memory
-(NSInteger)getNumItems;
-(NSString*)getLabelForIndex: (NSInteger) item;
-(BOOL)getCheckedForIndex: (NSInteger) item;

-(NSInteger)getStateForIndex: (NSInteger) item;
-(id)getStringDataForItem: (NSInteger) item;
-(NSInteger)getPKAtIndex:(NSInteger) idx;



@end


