//
//  nnDVDoubleUISlider.m
//  glogger
//
//  Created by Brice Tebbs on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
    double mph = self.labelScale * self.value;
    self.dvSliderTextLabel.text = [NSString stringWithFormat:self.labelFormat,mph];
}

-(void)sliderChanged:(UISlider *)slider
{
    [self updateTextFromSlider];
}

-(void)setup
{
    // So that text label wil be updated
    [self addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)populate
{
    [self setValue: [self.dvInfo.dvStoreHandler doubleForKey: self.dvInfo.dvVarName]];
    [self updateTextFromSlider];
}

-(void)save
{
    if ([self.dvInfo.dvStoreHandler doubleForKey: self.dvInfo.dvVarName] != self.value)
    {
        [self.dvInfo.dvChangedDelegate valueUpdated: self.dvInfo];
        [self.dvInfo.dvStoreHandler setDouble: self.value forKey:self.dvInfo.dvVarName];
    }
}


@end
