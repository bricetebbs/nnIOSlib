//
//  nnSceneObjectPart.h
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "nnDrawStyle.h"

// A scene is a list/array of nsSceneObject
// An nsSceneObject is made up of nnSceneObjectParts

@interface nnSceneObjectPart : NSObject{
    // We should have a bounds rect in here
    nnDrawStyle *drawStyle; // Each part has its own style.
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

@end
