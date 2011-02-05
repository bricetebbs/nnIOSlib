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

-(BOOL)isChanged
{
    return [self.dvInfo getDouble] != self.value;
}

-(void)setup
{
    [self addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
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
        [self.dvInfo handleChangeDouble: self.value];
    }
}


@end
