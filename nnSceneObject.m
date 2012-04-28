//
//  nnSceneObject.m
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSceneObject.h"

@implementation nnSceneObject

- (void)dealloc {
	[parts removeAllObjects];
    [parts release];
    [super dealloc];
}


-(id)init
{
    self = [super init];
    if (self)
    {
        parts = [[NSMutableArray alloc] init];
        startTime = CFAbsoluteTimeGetCurrent();
    }
    return self;
}

-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform)xform
{
    for (nnSceneObjectPart *p in parts) {
        [p draw: context withTransform:xform];
    }
    
}

-(void)animate: (CFTimeInterval) seconds
{
    if (seconds)
        seconds = seconds - startTime;
    
    for (nnSceneObjectPart *p in parts) {
        [p animate: seconds];
    }
}

-(void)addPart: (nnSceneObjectPart*)part
{
    [parts addObject: part];
}


@end
