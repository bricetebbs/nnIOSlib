//
//  nnDVDoubleUISlider.m
//
//  Created by Brice Tebbs on 1/30/11.
//  Copyright 2011 northNitch Studios, Inc. All rights reserved.
//

#import "nnDVDoubleUISlider.h"


@implementation nnDVDoubleUISlider;
@synthesize dvSliderTextLabel;
@synthesize labelScale;
@synthesize labelFormat;
@synthesize dvInfo;

- (void)dealloc {
    [dvInfo release];
    [dvSliderTextLabel release];
    [labelFormat release];
    [super dealloc];
}

-(void)updateTextFromSlider
{    
    if (self.dvSliderTextLabel && self.labelFormat)
    {
        double sval = self.labelScale * self.value;
        self.dvSliderTextLabel.text = [NSString stringWithFormat:self.labelFormat, sval];
    }
}

-(void)sliderChanged:(UISlider *)slider
{
    [self updateTextFromSlider];
    [self.dvInfo handleChangeDouble: slider.value];
}

-(void)awakeFromNib
{
    self.labelScale= 1.0;
    self.labelFormat = @"%4.2f";
    [self addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}


-(BOOL)isChanged
{
    return [self.dvInfo getDouble] != self.value;
}

-(void)populate
{
    [self setValue: [self.dvInfo getDouble]];
    [self updateTextFromSlider];
}

-(void)save
{
    if ([self isChanged])
    {
        [self.dvInfo storeDouble: self.value];
    }
}

-(void)setupDvInfo: (NSObject*) tag handler: (id <nnDVStoreProtocol>) handler delegate: (id <nnDVChangedProtocol>) delegate
{
    nnDVDouble *d = [ [nnDVDouble alloc] init: tag withHandler: handler];
    self.dvInfo = d;
    self.dvInfo.dvChangedDelegate = delegate;
    [d release];
}


@end
