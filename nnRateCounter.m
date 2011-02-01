//
//  nnRateCounter.m
//
//  Created by Brice Tebbs on 3/29/10.
//  Copyright 2010 northNitch Studios, Inc.. All rights reserved.
//

#import "nnRateCounter.h"

@implementation nnRateCounter

-(float)getRate
{
    int i;
    int idx, n_idx;
    float delta_sum, tdelta;
    
    if (count < NUM_TIMES)
        return 0.0;
    else
    {
        idx = nextInsert;
        delta_sum = 0.0;
        for(i = 0; i < NUM_TIMES; i++)
        {
            idx = (idx + i) % NUM_TIMES;
            n_idx = (idx + 1) % NUM_TIMES;
            tdelta = recentTimes[n_idx] - recentTimes[idx];
            delta_sum += tdelta;
        }
        return NUM_TIMES/delta_sum;
    }
}

-(void)sample
{
    recentTimes[nextInsert] = CFAbsoluteTimeGetCurrent();
    nextInsert = (nextInsert + 1) % NUM_TIMES;
    count += 1;
}
@end
