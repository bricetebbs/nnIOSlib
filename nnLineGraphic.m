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
    drawPoints = [NSArray arrayWithArray: points];
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
    [drawPoints release];
    [super dealloc];
}

-(Class) class
{
    return [nnLineGraphic class];
}

-(void)encodeData: (id <nnCoder>)coder
{
    [coder serializeObject: drawStyle];
    [coder encodeInt: [drawPoints count]];
     for (NSValue *sobj in drawPoints) 
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
}           
        

-(void)animate: (CFTimeInterval) seconds
{
}


@end
