//
//  nnCounterTableViewCell.m
//
//  Created by Brice Tebbs on 7/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCounterTableViewCell.h"


@implementation nnCounterTableViewCell
@synthesize bumpButton;

- (void)dealloc {
    [bumpButton release];
    [super dealloc];
}


-(IBAction)bumpCount
{
    
    [delegate newValue: 1.0 forCell: self];
    
}

@end
