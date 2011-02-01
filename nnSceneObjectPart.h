    //
//  nnSceneObjectPart.h
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "nnDrawStyle.h"



@interface nnSceneObjectPart : NSObject {
    // We should have a bounds rect in here
    
    nnDrawStyle *drawStyle;
}

-(id)init;

//
// Actions
//
-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform) xform;
-(void)animate: (CFTimeInterval) seconds;   

//
// Accessors
//
@property (nonatomic, retain) nnDrawStyle *drawStyle;

//
// Utitily func to create objects from a list of points
//
+(nnSceneObjectPart*) createWithPoints: (NSArray *)points;


@end
