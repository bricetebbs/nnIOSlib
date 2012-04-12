//
//  nnDVStringUIText.m
//
//  Created by Brice Tebbs on 1/29/11.
//  Copyright 2011 northNitch Studios, Inc. All rights reserved.
//


#import "nnDVStringUIText.h"

@implementation nnDVStringUIText

@synthesize dvInfo;

- (void)dealloc {
    [dvInfo release];
    [super dealloc];
}

-(BOOL)isChanged
{
    return [self.dvInfo getString] != self.text;
}

-(void)textChanged
{
    [self.dvInfo handleChangeString: self.text];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

-(void)populate
{
    [self setText: [self.dvInfo getString]];
}

-(void)save
{
    if ([self isChanged])
    {
        [self.dvInfo storeString: self.text];
    }
}


-(void)setupDvInfo: (NSObject*) tag handler: (id <nnDVStoreProtocol>) handler delegate: (id <nnDVChangedProtocol>) delegate
{
    nnDVString *s = [ [nnDVString alloc] init: tag withHandler: handler];
    self.dvInfo = s;
    self.dvInfo.dvChangedDelegate = delegate;
    [s release];
}


@end
