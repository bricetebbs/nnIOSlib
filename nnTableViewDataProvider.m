//
//  nnTableViewDataProvider.m
//
//  Created by Brice Tebbs on 5/10/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnTableViewDataProvider.h"

@implementation nnTableViewDataProvider

@synthesize delegate;
@synthesize groupKey;
@synthesize extraInfo;


- (void)dealloc {
    [extraInfo release];
    [itemArray release];
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        itemArray = [[NSMutableArray alloc] init];
        isSetup = NO;
    }
    return self;
}

-(nnErrorCode)makeDirty
{
    isSetup= NO;
    return nnkNoError;
}


-(nnErrorCode)setupDataProvider
{
    if (isSetup)
        return nnkNoError;
	nnErrorCode n = [delegate getDataForGroupKey: groupKey intoArray: itemArray];
    if (!n)
        isSetup = YES;
    return n;
}


-(nnErrorCode)saveAllToProvider
{
    int i =0;
    nnErrorCode error = nnkNoError;
    for (nnListItem *item in itemArray) {
        item.priority = i++;
        error = [delegate itemUpdated: item];
        if (error)
            return error;
    }
    return nnkNoError;
}

-(BOOL)hasExtraAtIndex:(NSInteger)item
{
    NSString *a = [self getLabelForIndex: item];
    NSString *b = [[self getStringDataForItem: item] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    b = [b stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    b = [b stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    b = [b stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    b = [b stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    b = [b stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    b = [b stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    b = [b stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    b = [b stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    b = [b stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return ![a isEqualToString:b];
}

-(nnErrorCode)addItemUsingString: (NSString*)name;
{
    nnListItem *t = [[nnListItem alloc] init];
    t.label = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    t.groupKey = self.groupKey;
    t.priority = 0;
    t.state = NO;
    if(t.groupKey)
    {
        [t setStringData: [NSString stringWithFormat: @"&nbsp;%@<br/>",nnEscapeForXML(name)]];
    }
  
    [delegate itemCreated: t];
    
    [itemArray insertObject: t atIndex:0];
    
    [t release];
    
    [self saveAllToProvider];
    return nnkNoError;
}


-(nnErrorCode)deleteItemAtIndex: (NSInteger) item
{
    [delegate itemDeleted: [itemArray objectAtIndex: item]];
    [itemArray removeObjectAtIndex:item];
    return nnkNoError;
}


-(nnErrorCode)moveFrom: (NSInteger) fromitem to: (NSInteger) toitem
{
    
    nnErrorCode error = nnkNoError;
    NSObject *mover = [[itemArray objectAtIndex: fromitem] retain];
    [itemArray removeObjectAtIndex:fromitem];
	[itemArray insertObject:mover atIndex:toitem];

    [mover release];
    
    error = [self saveAllToProvider];
    
    return error;
}

-(NSInteger)getNumItems 
{ 
    return [itemArray count];
}

-(BOOL) getCheckedForIndex: (NSInteger) item
{
    nnListItem* ti =  (nnListItem*)[itemArray objectAtIndex: item] ;
    return (BOOL)[ti state];
}


-(NSInteger) getStateForIndex: (NSInteger) item
{
    nnListItem* ti =  (nnListItem*)[itemArray objectAtIndex: item] ;
    return [ti state];
}


-(NSInteger)getPKAtIndex:(NSInteger) idx
{
    return [[itemArray objectAtIndex: idx] pk];
}

-(NSString*) getStringDataForItem: (NSInteger) item
{
    nnListItem* ti =  (nnListItem*)[itemArray objectAtIndex: item] ;
    return [ti getStringData];
}

-(NSString*)getLabelForIndex: (NSInteger) item
{
    nnListItem* ti =  (nnListItem*)[itemArray objectAtIndex: item] ;
    return [ti label];
}

-(NSString*)getLabelForGroup:(NSInteger)group   
{
    NSString *string = nil;
    [delegate getNameForGroupKey:group intoString: &string];
    if (string)
        return string;
    return [NSString stringWithString:@""];
}

-(nnErrorCode)setCheckedForIndex:(NSInteger)idx as:(BOOL)checked
{
    nnErrorCode error = nnkNoError;
    nnListItem  *item = [itemArray objectAtIndex: idx];
    [item setState: checked];
    error = [delegate itemUpdated: item];
    return error;
}


-(nnErrorCode)setLabelForIndex:(NSInteger)idx as:(NSString*)label
{
    nnErrorCode error = nnkNoError;
    nnListItem  *item = [itemArray objectAtIndex: idx];
    [item setLabel: label];
    error = [delegate itemUpdated: item];
    return error;
}



-(nnErrorCode)setStateForIndex:(NSInteger)idx as:(NSInteger)state
{
    nnErrorCode error = nnkNoError;
    nnListItem  *item = [itemArray objectAtIndex: idx];
    [item setState: state];
    error = [delegate itemUpdated: item];
    return error;
}




-(nnErrorCode)updateOrder
{
    int i =0;
    nnErrorCode error = nnkNoError;
    for (nnListItem *item in itemArray) {
        if (i != item.priority)
        {
            item.priority = i;
            error = [delegate priorityUpdated: item];
            if (error)
                return error;
        }
        i++;
    }
    return nnkNoError;
}

-(nnErrorCode)sortByStatus
{
    NSMutableArray *unchecked = [[NSMutableArray alloc] init];
    NSMutableArray *checked = [[NSMutableArray alloc] init];
    
    for (nnListItem *item in itemArray)
    { 
        if (item.state == 0)
        {
            [unchecked addObject: item];
        }
        else {
            [checked addObject: item];
        }
    }
    
    [itemArray removeAllObjects];
    for (nnListItem *item in unchecked)
    {
        [itemArray addObject: item];
    }
    for (nnListItem *item in checked)
    {
        [itemArray addObject: item];
    }
    
    [unchecked release];
    [checked release];
    
    return [self updateOrder];
}

            
-(nnErrorCode)sortByStatusDescending
{
    [itemArray sortUsingSelector:@selector(compareByStatusReverse:)];
    return [self updateOrder];
}


@end

