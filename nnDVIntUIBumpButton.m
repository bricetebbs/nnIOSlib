//
//  nnDVIntUIBumpButton.m
//  metime
//
//  Created by Brice Tebbs on 2/3/11.
//  Copyright 2011 northNitch Studios Inc. All rights reserved.
//

#import "nnDVIntUIBumpButton.h"


@implementation nnDVIntUIBumpButton
@synthesize dvInfo;

- (void)dealloc {
    [dvInfo release];
    [super dealloc];
}

-(BOOL)isChanged
{
    return [self.dvInfo getInteger] != count;
}

-(void)buttonPressed: (UIButton*) button
{
    [self.dvInfo handleChangeBool: YES];
}

-(void)setup
{
    count = [self.dvInfo getNumSamples];
    
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)populate
{
    count = [self.dvInfo getNumSamples];
    [self setTitle: [NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
}

-(void)save
{
    [self.dvInfo handleChangeBool: YES];
}

@end
