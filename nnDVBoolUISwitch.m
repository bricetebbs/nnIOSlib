//
//  nnDVBoolUISwitch.m

//
//  Created by Brice Tebbs on 8/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnDVBoolUISwitch.h"

@implementation nnDVBoolUISwitch
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
    [self setOn: [self.dvInfo.dvStoreHandler boolForKey: self.dvInfo.dvVarName]];
}

-(void)save
{
    if ([self.dvInfo.dvStoreHandler boolForKey: self.dvInfo.dvVarName] != self.on)
    {
        [self.dvInfo.dvChangedDelegate valueUpdated: self.dvInfo];
        [self.dvInfo.dvStoreHandler setBool: self.on forKey: self.dvInfo.dvVarName];
    }
}


@end
