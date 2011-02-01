//
//  nnColorPicker.m
//
//  Created by Brice Tebbs on 7/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnColorPicker.h"

NSInteger GRID_X_SIZE = 3;
NSInteger GRID_Y_SIZE = 3;
NSInteger LEGEND_HEIGHT = 45;

float COLORS [] =
{ 
    0.0, 0.0, 0.0,
    0.5, 0.5, 0.5,
    1.0, 1.0, 1.0,
    
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 0.0,
    0.0, 1.0, 1.0,
    1.0, 0.0, 1.0
};

@implementation nnColorPicker
@synthesize delegate;


- (void)dealloc {
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
  
    NSInteger cidx = 0;
    CGFloat xo,yo;
    CGFloat xs = self.bounds.size.width/GRID_X_SIZE;
    CGFloat ys = (self.bounds.size.height-LEGEND_HEIGHT)/GRID_Y_SIZE;
    
    for (NSInteger x = 0; x < GRID_X_SIZE; x++) 
    {
        xo = x* xs;
        for(NSInteger y = 0; y < GRID_Y_SIZE; y++)
        {
            yo = y * ys + LEGEND_HEIGHT;
            CGContextSetRGBFillColor(context,COLORS[cidx*3], COLORS[cidx*3+1], COLORS[cidx*3+2], 1.0);
            CGContextFillRect(context, CGRectMake(xo,yo,xs,ys));
            cidx++;
        }
    }
    
    CGContextSetRGBFillColor(context,currentRed, currentGreen, currentBlue, 1.0);
    CGContextFillRect(context, CGRectMake(0,0,self.bounds.size.width,LEGEND_HEIGHT));
    
    CGContextRestoreGState(context);
}

-(void) colorChanged
{
    [delegate colorChanged:currentRed :currentGreen :currentBlue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: self];
    point.y = point.y - LEGEND_HEIGHT;
    
    CGFloat xs = self.bounds.size.width/GRID_X_SIZE;
    CGFloat ys = (self.bounds.size.height-LEGEND_HEIGHT)/GRID_Y_SIZE;
    
    if (point.y > 0.0)
    {
        NSInteger xg = point.x / xs;
        NSInteger yg = point.y / ys;
        NSInteger cidx = (xg*GRID_X_SIZE + yg)*3;
        
        currentRed = COLORS[cidx];
        currentGreen = COLORS[cidx+1];
        currentBlue = COLORS[cidx+2];
        
        [self colorChanged];
    }
    [self setNeedsDisplay];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan: touches withEvent: event];
}

-(void)initCurrentColor:(CGFloat)red :(CGFloat)green :(CGFloat)blue
{
    currentRed = red;
    currentGreen = green;
    currentBlue = blue;
}


@end
