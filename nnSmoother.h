//
//  nnSmoother.h
//  
//  Just a simple data smoother interface
//
//  Created by Brice Tebbs on 8/22/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface nnSmoother : NSObject {

    double* buffer;
    NSInteger windowSize;
    NSInteger count;
    double current;
    double runningTotal;
}

-(id)initWithWindowSize: (NSInteger) size;
-(void)addValue:(double) value;
-(double)getAvg;
-(NSNumber*)asNSNumber;

@property (readonly) double current;

-(void)reset;

@end
