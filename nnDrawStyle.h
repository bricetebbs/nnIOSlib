//
//  nnDrawStyle.h
//
//  Created by Brice Tebbs on 4/1/10.
//  Copyright 2010 northNitch Studios, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "nnCoder.h"

@interface nnDrawStyle : NSObject <nnEncodable> {
    CGFloat strokeWidth;
    CGFloat strokeColor[4];
    CGFloat fillColor[4];
    
    CGPathDrawingMode mode;
}

-(void)setupGC: (CGContextRef) cr;
-(void)setStrokeRGB: (CGFloat [4])colors;
-(void)setFillRGB: (CGFloat [4])colors;

@property CGPathDrawingMode mode;
@property CGFloat strokeWidth;
@end
