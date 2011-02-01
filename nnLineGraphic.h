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
    
    NSArray *dragPoints; // Maybe should rename this
    NSMutableArray *animPoints;   // Maybe should get rid of these
    NSArray *drawPoints; // Just a pointer to dragPoints or animPoints depending on if we are animating.  
    NSArray *animVectors;
    CGFloat period;
    
}

-(void)setupWithPoints: (NSArray*) points;

-(id)initWithPoints:(NSArray*) points;
-(id)init;

-(void)draw: (CGContextRef)context withTransform: (CGAffineTransform) xform;
-(void)animate: (CFTimeInterval) seconds;

@end
