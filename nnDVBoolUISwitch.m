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
    [self setOn: [self.dvInfo getBool]];
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
    return [self.dvInfo getBool] != self.on;
}


-(void)setupDvInfo: (NSObject*) tag handler: (id <nnDVStoreProtocol>) handler delegate: (id <nnDVChangedProtocol>) delegate
{
    nnDVBool *b = [ [nnDVBool alloc] init: tag withHandler: handler];
    self.dvInfo = b;
    self.dvInfo.dvChangedDelegate = delegate;
    [b release];
}

@end
