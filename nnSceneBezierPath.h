//
//  nnSceneBezierPath.h
//
//  Created by Brice Tebbs on 12/24/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnSceneObjectPart.h"

// A Bezier path object. The key feature is that it creates a bezier path
// via a curvefit from a list of points

@interface nnSceneBezierPath : nnSceneObjectPart {
    CGMutablePathRef cgPath;
}

// Make a bezier path from the list of points
-(void)setupWithPoints: (NSArray*) points;

// Draw the path
-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform) xform;
-(void)animate: (CFTimeInterval) seconds;   

@end
