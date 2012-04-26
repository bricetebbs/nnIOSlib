//
//  nnRateCounter.h
//
//  Created by Brice Tebbs on 3/29/10.
//  Copyright 2010 northNitch Studios, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUM_TIMES 10

// Just a simple frame rate counter

@interface nnRateCounter : NSObject {
    int nextInsert;
    int count;
    CFTimeInterval recentTimes[NUM_TIMES];
}

-(float)getRate;
-(void)sample;
@end
