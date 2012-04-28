//
//  nnSceneObjectPart.m
//
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSceneObjectPart.h"

@implementation nnSceneObjectPart

@synthesize drawStyle;


-(id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)dealloc {

    [drawStyle release];
    [super dealloc];
}


-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform)xform
{
#ifdef NN_DEBUG
    NSLog(@"Draw called for abstract Scene Object Part");  
#endif
}


-(void)serialize: (CGContextRef)context
{
#ifdef NN_DEBUG
    NSLog(@"Serialize called for abstract Scene Object Part");  
#endif
}


-(void)animate: (CFTimeInterval) seconds
{
    
}


static void pointsToImplicitLine(CGPoint p1, CGPoint p2, 
                                 CGFloat *A, 
                                 CGFloat *B, 
                                 CGFloat *C)
{
    float a,b, len;
    a = -(p2.y-p1.y);
    b = (p2.x-p1.x); 
    len= sqrt(a*a + b*b);
    *A = a/len;
    *B = b/len;
    *C = -(p1.x * *A + p1.y * *B);
}

static BOOL keepPoint(CGPoint pp, CGPoint pn, CGPoint point)
{
    CGFloat A,B,C;
    CGFloat dist;
    
    pointsToImplicitLine(pp,pn, &A, &B, &C);
    
    dist = fabsf(A * point.x + B * point.y + C);
    
    return dist > 0.2;
}

+(NSMutableArray*) filterPoints: (NSArray *)points
{
    
    NSMutableArray* outpoints = [[NSMutableArray alloc] init];
    
    int pcount = [points count];
    int keep;
    for(int i = 0; i < pcount; i++)
    {
        CGPoint point =  [[points objectAtIndex: i] CGPointValue];
        if (i < 1 || i > pcount-2)
            keep = YES;
        else 
        {
            CGPoint pp =  [[points objectAtIndex: i-1] CGPointValue];
            CGPoint pn =  [[points objectAtIndex: i+1] CGPointValue];
            keep = keepPoint(pp, pn, point);
        }
        if (keep)
        {
            [outpoints addObject: [NSValue valueWithCGPoint: point]];
        }
    }
    [outpoints autorelease];
    return outpoints;
}




@end
