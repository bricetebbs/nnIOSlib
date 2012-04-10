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
    count += 1;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)populate
{
    count = [self.dvInfo getNumSamples];
    [self setTitle: [NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
}

-(void)save
{
    if ([self isChanged])
    {
        [self.dvInfo handleChangeBool: YES];
    }
}

-(void)setupDvInfo: (NSObject*) tag handler: (id <nnDVStoreProtocol>) handler delegate: (id <nnDVChangedProtocol>) delegate
{
    nnDVBool *b = [ [nnDVBool alloc] init: tag withHandler: handler];
    self.dvInfo = b;
    self.dvInfo.dvChangedDelegate = delegate;
    [b release];
}

@end
