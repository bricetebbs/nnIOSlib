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

// A subclass of UIScrollView which keeps track of matrices for world map and view transforms

@interface nnScrollingCGView : UIScrollView <UIScrollViewDelegate> 
{
    
    // Dummy view to scroll. We aren't going to draw anything here we are just using this view to grab the scale gestures

    UIView* zoomDummy; 
    
    
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
// Fullsize here means the size of the total map. ie the limit of how far you can pan or scroll
-(void)setupScollingCGViewWithMapSize: (CGRect)fullSize;

// Set options (what kind of scroll/zoom do we respect)
-(void)setScrollZoomOptions: (NSInteger) options;

// Set the range of allowed zoom
-(void)setZoomMin: (CGFloat) min andMax: (CGFloat) max;


// Scale the view so the entire map fits into the screen
-(IBAction) fitView;

// Look at the middle of the view
-(IBAction) centerView;

// Double the current scale (zoomIn)
-(IBAction) zoomView;  

// Call this when you change the world coordinate system
-(void)updateWorldToMap: (CGAffineTransform)w2d;


@end
