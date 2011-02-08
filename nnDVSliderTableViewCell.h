//
//  nnDVSliderTableViewCell.h
//
//  Created by Brice Tebbs on 2/4/11.
//  Copyright 2011 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnDVCustomTableViewCell.h"
#import "nnDVDoubleUISlider.h"

@interface nnDVSliderTableViewCell : nnDVCustomTableViewCell{
    nnDVDoubleUISlider* slider;
}
@property (nonatomic,retain) IBOutlet nnDVDoubleUISlider* slider;

@end
