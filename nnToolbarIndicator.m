//
//  nnToolbarIndicator.m
//
//  Created by Brice Tebbs on 6/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnToolbarIndicator.h"


@implementation nnToolbarIndicator
@synthesize delegate;
@synthesize isOn;

-(void)dealloc
{
    [name release];
    [super dealloc];
}

-(void)setup
{
    [name release];
    name = [[self title] copy];
}

-(void)setState: (BOOL)s
{
    
    // Need something like
    // image = [UIImage imageNamed:@"checkbox_checked.png"];

    isOn = s;
    NSString *newTitle;
    
    if(isOn)
    {
        newTitle =  [NSString stringWithFormat:@"%@ On", name];
    }
    else 
    {
        newTitle =  [NSString stringWithFormat:@"%@ Off", name];  
    }
    
    [self setTitle: newTitle];
    
    [delegate indicatorChanged: self];
}




-(void)isClicked
{
    [self setState: !isOn];
}

@end
