//
//  nnSceneObjectPart.m
//
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSceneObjectPart.h"
#import "nnLineGraphic.h"


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
    int keep = NO;
    for(int i = 0; i < pcount; i++)
    {
        CGPoint point =  [[points objectAtIndex: i] CGPointValue];
        keep = NO;
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
    return outpoints;
}

//
// Class method works as a factory to create wiggle parts
//
+(nnSceneObjectPart*) createWithPoints: (NSArray *)points
{
    
    CGPoint start;
    CGPoint end;
    CGPoint dir;
    
    start =[[points objectAtIndex: 0] CGPointValue];
    end = [[points lastObject] CGPointValue];
    dir.x = (start.x-end.x);
    dir.y = (start.y-end.y);
    
    
    CGPoint min, max;
    min = max = start;
    
    for (NSValue *nspt in points) {
        
        CGPoint pt = [nspt CGPointValue];
        if (pt.x > max.x)
            max.x = pt.x;
        
        if (pt.y > max.y)
            max.y = pt.y;
        
        if (pt.x < min.x)
            min.x = pt.x;
        
        if (pt.y < min.y)
            min.y = pt.y;
    }
    
    NSMutableArray *filteredPoints = [nnLineGraphic filterPoints: points];
    
    nnSceneObjectPart* rval =[[nnLineGraphic alloc] initWithPoints: filteredPoints];
    
    [filteredPoints release];
    
    return rval;
    
}



@end
