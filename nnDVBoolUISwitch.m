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


-(void)switchChanged: (UISwitch*)sw
{
    [self.dvInfo handleChangeBool: sw.on];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

}

-(void)populate
{
    [self setOn: [self.dvInfo.dvStoreHandler boolForKey: self.dvInfo.dvVarName]];
}

-(void)save
{
    if ([self isChanged])
    {
        [self.dvInfo storeBool: self.on];
    }
}


-(BOOL)isChanged
{
    return [self.dvInfo.dvStoreHandler boolForKey: self.dvInfo.dvVarName] != self.on;
}

@end
