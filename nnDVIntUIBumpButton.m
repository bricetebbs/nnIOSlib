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

-(void)setup
{
}

-(void)populate
{
    [self setTitle: [NSString stringWithFormat:@"%d", 
                     [self.dvInfo.dvStoreHandler integerForKey: self.dvInfo.dvVarName] ] forState:UIControlStateNormal];
}

-(void)save
{
    [self.dvInfo.dvStoreHandler sampleKey: self.dvInfo.dvVarName];
    [self.dvInfo.dvChangedDelegate valueUpdated: self.dvInfo];
}


@end
