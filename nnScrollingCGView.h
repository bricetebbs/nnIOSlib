//
//  nnScrollingCGView.h
//  
//  This subclass of UIScrollView is for drawing charts or line art with CGContext where you want to use your
//  own transforms etc so you can control how things such as line width etc. scale.
//
//  Created by Brice Tebbs on 7/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


enum nnScrollingViewOptions
{
    nnkScrollingHorizontal   = 0x0001,
    nnkScrollingVertical     = 0x0002,
    nnkZoomHorizontal        = 0x0004,
    nnkZoomVertical          = 0x0008,
};


@interface nnScrollingCGView : UIScrollView <UIScrollViewDelegate> 
{
    UIView* zoomDummy; // Dummy view to scroll
    
    
    // Look at these in drawRect
    CGPoint scrollOffset;
    CGFloat zoomScale;
    
    
    // These are generally fixed
    CGAffineTransform worldToMapTransform;
    CGAffineTransform mapToWorldTransform;
    
    // These Change when zooming or scrolling
    CGAffineTransform mapToViewTransform;
    CGAffineTransform viewToMapTransform;
    
    // These change because they are made from mapToViewTransform and viewToMapTransform
    CGAffineTransform worldToViewTransform;
    CGAffineTransform viewToWorldTransform;
    
    
    NSInteger scrollZoomOptions;
    CGFloat zoomMin;
    CGFloat zoomMax;
    
}

-(void)setupScollingCGViewWithMapSize: (CGRect)fullSize;
-(void)setScrollZoomOptions: (NSInteger) options;
-(void)setZoomMin: (CGFloat) min andMax: (CGFloat) max;


-(IBAction) fitView;
-(IBAction) centerView;
-(IBAction) zoomView;

// Call this when you change the world coordinate system
-(void)updateWorldToMap: (CGAffineTransform)w2d;


@end
