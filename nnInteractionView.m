//
//  nnInteractionView.m
//  wardap
//
//  Created by Brice Tebbs on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "nnInteractionView.h"

NSInteger TOUCH_LINE_WIDTH = 10;


@implementation nnInteractionView
@synthesize dragPoints;
@synthesize interactDelegate;

- (void)dealloc {
    [dragPoints release];
    [super dealloc];
}


-(void)clearDragPoints
{    
    if (dragPoints)
        [dragPoints removeAllObjects];
    else 
        dragPoints = [[NSMutableArray alloc] init];
}

- (void)drawRect:(CGRect)rect {
    
    int i;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, TOUCH_LINE_WIDTH);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGPoint point;
    
    for(i = 0; i < [self.dragPoints count]; i++)
    {
        point = [[self.dragPoints objectAtIndex: i] CGPointValue];
        if (i == 0)
            CGContextMoveToPoint(context, point.x, point.y);
        else
            CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);    
}


-(void)addToTouchArray:(NSSet *)touches outRect:(CGRect*)rect 
{
    CGPoint p;
    p = [[touches anyObject] locationInView:self];
    
    
    *rect = CGRectMake(p.x - TOUCH_LINE_WIDTH/2.0,
                       p.y - TOUCH_LINE_WIDTH/2.0,
                       TOUCH_LINE_WIDTH,
                       TOUCH_LINE_WIDTH);
    
    if ([self.dragPoints count] > 0)
    {
        CGPoint lastP = [[self.dragPoints lastObject] CGPointValue];
        CGRect r2 = CGRectMake(lastP.x - TOUCH_LINE_WIDTH/2.0,
                               lastP.y- TOUCH_LINE_WIDTH/2.0,
                               TOUCH_LINE_WIDTH,
                               TOUCH_LINE_WIDTH);
        *rect = CGRectUnion(*rect, r2);
    }
    
    [self.dragPoints addObject: [NSValue valueWithCGPoint: p]];
    [self setNeedsDisplay];
}



// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    
    CGRect dirtyRect;
    
    [self clearDragPoints];
    [self addToTouchArray: touches outRect:  &dirtyRect];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect dirtyRect;
    
    
    [self addToTouchArray: touches outRect: &dirtyRect];
    
    [self.interactDelegate touchUpPoints: self.dragPoints];
    [self clearDragPoints];
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
    CGRect dirtyRect;
    
    [self addToTouchArray: touches outRect: &dirtyRect];    
}


@end
