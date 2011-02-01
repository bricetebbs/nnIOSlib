//
//  nnLineGraphic.m
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#include <math.h>
#import "nnLineGraphic.h"


@implementation nnLineGraphic


-(void)setupWithPoints: (NSArray*) points
{
    [dragPoints release];
    [animPoints release];
    
    dragPoints = [NSArray arrayWithArray: points];
    [dragPoints retain];
    drawPoints = dragPoints;
    animPoints = [[NSMutableArray alloc] initWithArray:points copyItems:YES];
}


-(id)init
{
    self = [super init]; 
    if (self)
    {
    }
    return self;
}


-(id)initWithPoints: (NSArray*) points
{
    self = [self init];
    if (self)
    {
        [self setupWithPoints: points];
    }
    return self;
}


- (void)dealloc {
    [animPoints release];
    [animVectors release];
    [dragPoints release];
    [super dealloc];
}

-(Class) class
{
    return [nnLineGraphic class];
}

-(void)encodeData: (id <nnCoder>)coder
{
    [coder serializeObject: drawStyle];
    [coder encodeInt: [dragPoints count]];
     for (NSValue *sobj in dragPoints) 
     {
         CGPoint pt = [sobj CGPointValue];
         [coder encodeCGPoint: &pt];
     }
}

-(void)decodeData: (id <nnCoder>)coder
{
    int count;
    int i;
    
    drawStyle = [coder allocAndDeserializeObject];

    count = [coder decodeInt];
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (i = 0 ; i < count ; i++)
    {
        CGPoint pt;
        pt = [coder decodeCGPoint];
        [points addObject: [NSValue valueWithCGPoint: pt]];
    }
    
    [self setupWithPoints: points];
    [points release];
 
    
}



-(void)drawAsPoints: (CGContextRef)context
{   
    int i;
    CGPoint point;
    
    int pcount = [drawPoints count];
    CGRect *rects = (CGRect*)malloc(sizeof(CGRect) * pcount);
 
    for(i = 0; i < pcount; i++)
    {
        point = [[drawPoints objectAtIndex: i] CGPointValue];
 
        rects[i].origin.x = point.x-2;
        rects[i].origin.y = point.y-2;
        rects[i].size.width = 4;
        rects[i].size.height = 4;
    }
    CGContextSetRGBFillColor(context, 1,1,0,1.0);
    CGContextFillRects(context, rects, pcount);
 
    free(rects);
}
/*

-(void)draw: (CGContextRef)context  withTransform: (CGAffineTransform)xform
{
    CGPoint point;
    int i;
    int pcount = [drawPoints count];
       
    [drawStyle setupGC: context];
    
    
    for(i = 0; i < pcount; i++)
    {
        point = [[drawPoints objectAtIndex: i] CGPointValue];
        point = CGPointApplyAffineTransform(point, xform);
        
        if (i == 0)
            CGContextMoveToPoint(context, point.x, point.y);
        else
            CGContextAddLineToPoint(context, point.x, point.y);
    }
    
    if (drawStyle)
        CGContextDrawPath(context, drawStyle.mode);
    else 
        CGContextStrokePath(context);

    
 //   [self drawAsPoints: context];
   
}

*/

-(void)draw: (CGContextRef)context  withTransform: (CGAffineTransform)xform
{
    CGPoint point;
    int i;
    int pcount = [drawPoints count];
    
    [drawStyle setupGC: context];
    
    double foo[3000];
    int fc = 0;
    
    for(i = 0; i < pcount; i++)
    {
        point = [[drawPoints objectAtIndex: i] CGPointValue];
        point = CGPointApplyAffineTransform(point, xform);
        
        if (i == 0)
        {
            CGContextMoveToPoint(context, point.x, point.y);
            foo[fc++]= point.x;
            foo[fc++]= point.y;

        }
        else
        {
            foo[fc++] = point.x;
            foo[fc++] = point.y;
        }
    }
    
 //   FitCurve(foo, fc/2, 10.0);
    
    if (drawStyle)
        CGContextDrawPath(context, drawStyle.mode);
    else 
        CGContextStrokePath(context);
    
    
    //   [self drawAsPoints: context];
    
}
                         
        

-(void)animate: (CFTimeInterval) seconds
{
    CGFloat t;
    CGPoint basePoint;
    CGPoint newPoint;    
    CGFloat elapsed_seconds;
    NSValue *obj;
    CGFloat off;
    int i;


    if(seconds == 0.0)
    {
        drawPoints = dragPoints;
        return;
    }

    elapsed_seconds = seconds;
    t = sin((elapsed_seconds/period) * 2 * M_PI);
    
    off = (t + 1.0);
    
    for(i = 0; i < [dragPoints count]; i++)
    {
        CGPoint aVector;
        basePoint = [[dragPoints objectAtIndex: i] CGPointValue ];
        
        aVector = [[animVectors objectAtIndex:i]  CGPointValue];
        newPoint.x = basePoint.x +aVector.x * off;
        newPoint.y = basePoint.y +aVector.y * off;
        
        obj = [NSValue valueWithCGPoint: newPoint];
        [animPoints replaceObjectAtIndex:i withObject: obj];
        
    }
    drawPoints = animPoints;
}


@end
