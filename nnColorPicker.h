//
//  nnColorPicker.h
//  metime
//
//  Created by Brice Tebbs on 7/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol nnColorPickerDelegate
-(void)colorChanged: (CGFloat)red : (CGFloat)green: (CGFloat)blue;
@end

@interface nnColorPicker : UIView {

    id <nnColorPickerDelegate> delegate;
    CGFloat currentRed;
    CGFloat currentGreen;
    CGFloat currentBlue;

}

-(void)initCurrentColor: (CGFloat)red : (CGFloat)green: (CGFloat)blue;
@property (nonatomic, assign) id <nnColorPickerDelegate> delegate;
@end
