//
//  nnDrawStyle.m
//
//  Created by Brice Tebbs on 4/1/10.
//  Copyright 2010 northNitch Studios, Inc.. All rights reserved.
//

#import "nnDrawStyle.h"


@implementation nnDrawStyle

@synthesize mode;
@synthesize strokeWidth;

-(id)init
{
    self = [super init];
    if (self)
    {
        mode = kCGPathStroke;
        strokeWidth= 1.0;
        strokeColor[3] = 1.0;
    }
    return self;
}


-(void)setupGC: (CGContextRef) cr
{
    CGContextSetRGBStrokeColor(cr, strokeColor[0], strokeColor[1], strokeColor[2], strokeColor[3]);
    CGContextSetRGBFillColor(cr, fillColor[0], fillColor[1], fillColor[2], fillColor[3]);
    CGContextSetLineWidth(cr, strokeWidth);
}


-(void)setStrokeRGB: (CGFloat [4])colors
{
    for (int i = 0; i < 4; i++)
        strokeColor[i] = colors[i];
}

-(void)setFillRGB: (CGFloat [4])colors
{
    for (int i = 0; i < 4; i++)
        fillColor[i] = colors[i];
}

-(Class) class
{
    return [nnDrawStyle class];
}


-(void)encodeData: (id <nnCoder>)coder
{
    int i;
    [coder encodeFloat: strokeWidth];
    for (i=0; i<4; i++) {
        [coder encodeFloat: strokeColor[i]];
    }
    for (i=0; i<4; i++) {
        [coder encodeFloat: fillColor[i]];
    }
    [coder encodeInt: mode];
}

-(void)decodeData: (id <nnCoder>)coder
{
    int i;
    
    strokeWidth = [coder decodeFloat];
    for (i=0; i<4; i++) {
        strokeColor[i] = [coder decodeFloat];
    };    
    for (i=0; i<4; i++) {
        fillColor[i] = [coder decodeFloat];
    };
    mode = (CGPathDrawingMode)[coder decodeInt];
}




@end
