//
//  nnDrawView.h
//
//  Created by Brice Tebbs on 3/5/10.
//  Copyright northNitch Studios Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "northNitch.h"
#import "nnSceneObject.h"
#import "nnRateCounter.h"

@protocol nnDrawViewInteractionDelegate
- (void)touchUpPoints:(NSArray *)points; // Should have a better name
@optional
- (void)touchIsAt:(CGPoint) p;
@end

@interface nnDrawView : UIView {
    NSMutableArray *dragPoints;
    CFTimeInterval startTime;
    BOOL inTouches;
    
    // Actual data objects to create/draw
    nnSceneObject *currentSceneObject;
    nnRateCounter *frameRate;
    
    NSMutableArray *scene; // Array of scene objects
    
    id <nnDrawViewInteractionDelegate> interactDelegate;
    
    CFDataRef backData;
    }

-(void) setup;
-(void) dealloc;

-(IBAction)createBackData;
-(UInt32)pixelAtPoint:(CGPoint)p;
-(void)loadKernelOfWidth:(NSInteger)width into: (UInt32*)key at: (CGPoint)p;


-(void)drawOverlaysInContext: (CGContextRef)context;

-(void) addSceneObjectPart: (nnSceneObjectPart*) part;
-(IBAction)clearSceneInfo;
-(IBAction)renderToImage;


@property (nonatomic, assign) id <nnDrawViewInteractionDelegate> interactDelegate;
@property (nonatomic, retain) NSMutableArray *dragPoints;


@property CFTimeInterval startTime;


@end


