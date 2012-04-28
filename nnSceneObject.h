//
//  nnSceneObject.h
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnSceneObjectPart.h"

// A generic scene object that will be rendered in the DrawView
@interface nnSceneObject : NSObject {
    NSMutableArray *parts;
    CFTimeInterval startTime;
}


-(id)init;
-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform) xform;
-(void)animate: (CFTimeInterval) seconds;
-(void)addPart: (nnSceneObjectPart*)part;


@end
