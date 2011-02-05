//
//  nnSliderTableViewCell.h
//
//  Created by Brice Tebbs on 7/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnCustomTableViewCell.h"
#import "nnDVDoubleUISlider.h"

@interface nnSliderTableViewCell : nnCustomTableViewCell {
    nnDVDoubleUISlider *slider;
}
@property (nonatomic, retain) IBOutlet nnDVDoubleUISlider *slider;

- (IBAction) adjustSliderValue: (UISlider *) slider;

@end
