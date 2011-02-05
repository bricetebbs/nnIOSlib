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


@end
