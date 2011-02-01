//
//  nnStatusIndicator.m
//  Created by Brice Tebbs on 7/29/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnStatusIndicator.h"


@implementation nnStatusIndicator
@synthesize delegate;



- (void)dealloc {
    [super dealloc];
}


-(void)setState:(NSInteger)state
{
    _state = state;
    [delegate stateUpdated:self isNow:state];
    
    UIImage *image = nil;
    if (state == 0) 
    {
        image = [UIImage imageNamed:@"indicator_bad.png"];
    }
    else if (state == 1)
    {
        image = [UIImage imageNamed:@"indicator_yellow.png"];
    }
    else if (state == 2)
    {
        image = [UIImage imageNamed:@"indicator_good.png"];
    }
    self.image = image;
    
}


@end
