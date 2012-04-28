//
//  nnInteractionView.m
//  wardap
//
//  Created by Brice Tebbs on 2/12/11.
//  Copyright 2011 northNitch Studios Inc. All rights reserved.
//

#import "nnInteractionView.h"

NSInteger TOUCH_LINE_WIDTH = 10; // How wide should the touch line interaction Ghost be

@implementation nnInteractionView

#pragma mark Properties
@synthesize dragPoints;
@synthesize interactDelegate;

#pragma mark Lifetime


- (void)dealloc {
    [dragPoints release];
    [super dealloc];
}


-(void)clearDragPoints
{    
    // Nuke the dragPoints if they exist. But keep an array around
    // or make a new one if there isn't one yet.
    if (dragPoints)
        [dragPoints removeAllObjects];
    else 
        dragPoints = [[NSMutableArray alloc] init];
    
    showPoints = YES;
}

#pragma mark Drawing

// Draw the view
// Here we are just going to show the touches as an interaction ghost

- (void)drawRect:(CGRect)rect {
    
    int i;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    
    
    // Set style for the interaction ghost
    CGContextSetLineWidth(context, TOUCH_LINE_WIDTH);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 1.0, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGPoint point;
    
    if(showPoints)
    {
        // Just draw out the array of touches
        for(i = 0; i < [self.dragPoints count]; i++)
        {
            point = [[self.dragPoints objectAtIndex: i] CGPointValue];
            if (i == 0)
                CGContextMoveToPoint(context, point.x, point.y);
            else
                CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);    
}

#pragma mark Utilities
// Create a rect centered on x,y that is w x w in size
CGRect getBloatedRect(CGFloat x, CGFloat y, CGFloat w)
{
    return CGRectMake(x - w/2.0, y-w/2.0, w, w);
}

//
//  Add the touches to the drawPoint array and keep track of a dirty rect
//
-(void)addToTouchArray:(NSSet *)touches outRect:(CGRect*)dirtyRect 
{
    CGPoint p;
    
    p = [[touches anyObject] locationInView:self];
    
    // Set dirty as this new point
    *dirtyRect = getBloatedRect(p.x, p.y, TOUCH_LINE_WIDTH);

    // If we have something in the list already we are going to merge dirty rect with the 
    // last item
    if ([self.dragPoints count] > 0)
    {
        CGPoint lastP = [[self.dragPoints lastObject] CGPointValue];
        CGRect r2 = getBloatedRect(lastP.x, lastP.y, TOUCH_LINE_WIDTH);
        *dirtyRect = CGRectUnion(*dirtyRect, r2);
    }
    
    // Add the new point into the list
    [self.dragPoints addObject: [NSValue valueWithCGPoint: p]];
 
    // Just redraw what we need to.
    [self setNeedsDisplayInRect: *dirtyRect];
}

#pragma mark Touch Handling code

// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    CGRect dirtyRect;
    [self clearDragPoints];
    [self addToTouchArray: touches outRect:  &dirtyRect];
}


// We are done touching add the point and fire the delegate
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect dirtyRect;
    
    
    [self addToTouchArray: touches outRect: &dirtyRect];
    [self.interactDelegate touchUpPoints: self.dragPoints];
    showPoints = NO;
    
    // Need to redraw the screen now to clear the interaction view
    [self setNeedsDisplay];
    
}

// Add another point to touchArray every time the touch moves
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
    CGRect dirtyRect;
    [self addToTouchArray: touches outRect: &dirtyRect];    
}


@end
