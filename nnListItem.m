//
//  nnListItem.m
//  cloudlist
//
//  Created by Brice Tebbs on 5/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnListItem.h"


@implementation nnListItem

@synthesize state;
@synthesize label;
@synthesize pk;
@synthesize groupKey;
@synthesize priority;

-(void)dealloc
{
    [_buffer release];
    [label release];
    [super dealloc];
}
 
-(NSString*)getStringData
{
    return (NSString*)_buffer;
}
-(void)setStringData:(NSString *) data
{
    [_buffer release];
    _buffer = [data retain];
}

-(NSComparisonResult)compareByStatusReverse:(nnListItem *)other
{
    if(other.state < self.state)
        return NSOrderedAscending;
    if (other.state > self.state)
    {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

@end
