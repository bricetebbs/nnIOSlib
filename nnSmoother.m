//
//  nnSmoother.m
//  
//
//  Created by Brice Tebbs on 8/22/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSmoother.h"


@implementation nnSmoother

@synthesize current;


-(id)initWithWindowSize: (NSInteger) size;
{
    
    self = [self init];
    windowSize = size;
    buffer = malloc(sizeof(double)*size);
    return self;
}

-(void)reset
{
    current = 0.0;
    runningTotal = 0.0;
    count = 0;

}
-(void)addValue:(double) value
{
    buffer[(count++) % windowSize] = value;
    
    int num_samples = MIN(windowSize, count);
    
    double t = 0.0;
    for (int i = 0; i < num_samples; i++)
    {
        t += buffer[i];
    }
    
    current = t/num_samples;
    runningTotal += current;
    

}

-(NSNumber*)asNSNumber
{
    return [NSNumber numberWithDouble: self.current];
}

-(double) getAvg
{
    if(count)
        return runningTotal/count;
    return 0.0;
}
@end
