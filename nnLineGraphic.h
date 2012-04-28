//
//  nnLineGraphic.h
//
//  Created by Brice Tebbs on 4/9/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnSceneObjectPart.h"
#import "nnCoder.h"

@interface nnLineGraphic : nnSceneObjectPart <nnEncodable> {
    NSArray *drawPoints; // Just a pointer to dragPoints or animPoints depending on if we are animating.      
}

-(void)setupWithPoints: (NSArray*) points;

-(id)initWithPoints:(NSArray*) points;
-(id)init;

-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform) xform;
-(void)animate: (CFTimeInterval) seconds;

@end
