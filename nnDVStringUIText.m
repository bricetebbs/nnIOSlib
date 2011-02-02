//
//  nnDVStringUIText.m
//  glogger
//
//  Created by Brice Tebbs on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "nnDVStringUIText.h"

@implementation nnDVStringUIText

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
    [self setText: [self.dvInfo.dvStoreHandler stringForKey: self.dvInfo.dvVarName]];
}

-(void)save
{
    if ([self.dvInfo.dvStoreHandler stringForKey: self.dvInfo.dvVarName] != self.text)
    {
        [self.dvInfo.dvChangedDelegate valueUpdated: self.dvInfo];
        [self.dvInfo.dvStoreHandler setString:  self.text forKey:self.dvInfo.dvVarName];
    }
}


@end
