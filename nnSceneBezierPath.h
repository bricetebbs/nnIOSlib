//
//  nnSceneBezierPath.h
//
//  Created by Brice Tebbs on 12/24/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnSceneObjectPart.h"

//CGPathMoveToPoint
@interface nnSceneBezierPath : nnSceneObjectPart {
    CGMutablePathRef cgPath;
}


-(void)setupWithPoints: (NSArray*) points;


-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform) xform;


@end
