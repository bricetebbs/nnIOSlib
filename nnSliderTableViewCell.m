//
//  nnSliderTableViewCell.m
//  metime
//
//  Created by Brice Tebbs on 7/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSliderTableViewCell.h"


@implementation nnSliderTableViewCell
@synthesize slider;
- (void)dealloc {
    [slider release];
    [super dealloc];
}

- (void) adjustSliderValue: (UISlider *) sli
{    
    [delegate newValue: [sli value] forCell: self];
}

@end
