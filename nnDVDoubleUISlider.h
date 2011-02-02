//
//  nnDVDoubleUISlider.h
//  glogger
//
//  Created by Brice Tebbs on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "nnDV.h"

@interface nnDVDoubleUISlider : UISlider  <nnDVUIBaseProtocol>
{
    UILabel *dvSliderTextLabel;
    nnDVBase* dvInfo;
    
    NSString *labelFormat;
    double labelScale;
}


@property (nonatomic, retain) nnDVBase* dvInfo;

@property (nonatomic, retain) IBOutlet UILabel *dvSliderTextLabel;
@property (nonatomic, retain) NSString *labelFormat;
@property (nonatomic, assign) double labelScale;


@end
