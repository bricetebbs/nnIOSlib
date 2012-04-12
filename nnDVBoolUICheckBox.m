//
//  nnDVBoolUICheckBox.m
//  formulate
//
//  Created by Brice Tebbs on 2/7/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import "nnDVBoolUICheckBox.h"


@implementation nnDVBoolUICheckBox
@synthesize dvInfo;

- (void)dealloc {
    [dvInfo release];
    [super dealloc];
} 

-(void) setChecked: (BOOL) checked;
{   
    isChecked = checked;
    UIImage *image;
    if (isChecked)
    {
        image = [UIImage imageNamed:@"checkbox_checked.png"];
    }
    else {
        image = [UIImage imageNamed:@"checkbox_unchecked.png"];
    }
    
    [self setBackgroundImage:image  forState: UIControlStateNormal];
    [self setBackgroundImage:image  forState: UIControlStateSelected];
    [self setBackgroundImage:image  forState: UIControlStateHighlighted];
    
}


-(void)checkPressed: (UIButton*)sw
{
    
    BOOL newValue = !isChecked;
    [self setChecked: newValue];
    [self.dvInfo handleChangeBool: newValue];
    }

-(void)awakeFromNib
{
    [super awakeFromNib];
    isChecked = NO;
    [self addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)populate
{
    [self setChecked: [self.dvInfo getBool]];
}

-(void)save
{
    if ([self isChanged])
    {
        [self.dvInfo storeBool: isChecked];
    }
}


-(BOOL)isChanged
{
    return [self.dvInfo getBool] != isChecked;
}

-(void)setupDvInfo: (NSObject*) tag handler: (id <nnDVStoreProtocol>) handler delegate: (id <nnDVChangedProtocol>) delegate
{
    nnDVBool *b = [ [nnDVBool alloc] init: tag withHandler: handler];
    self.dvInfo = b;
    self.dvInfo.dvChangedDelegate = delegate;
    [b release];
}

@end
