//
//  nnScrollingCGView.m
//  
//
//  Created by Brice Tebbs on 7/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnScrollingCGView.h"
#import "northNitch.h"
@interface nnScrollingCGView()
@property (nonatomic, retain)  UIView* zoomDummy;
@end

@implementation nnScrollingCGView
@synthesize zoomDummy;

- (void)dealloc {
    [zoomDummy release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


-(void)updateMatrices
{
    
    // This is the zoom and scale transform
    
    CGFloat zoomX = (nnkZoomHorizontal & scrollZoomOptions) ? zoomScale : 1.0;
    CGFloat zoomY = (nnkZoomVertical   & scrollZoomOptions) ? zoomScale : 1.0;
    
    CGFloat offsetX = (nnkScrollingHorizontal & scrollZoomOptions) ? - scrollOffset.x : 0.0;
    CGFloat offsetY = (nnkScrollingVertical   & scrollZoomOptions) ? - scrollOffset.y : 0.0;
    
    
    mapToViewTransform = CGAffineTransformMake(zoomX, 0.0, 0.0, zoomY, offsetX, offsetY);
    viewToMapTransform = CGAffineTransformInvert(mapToViewTransform);
    
    worldToViewTransform = CGAffineTransformConcat(worldToMapTransform, mapToViewTransform);
    viewToWorldTransform = CGAffineTransformConcat(viewToMapTransform, mapToWorldTransform);
}


-(void)setupScollingCGViewWithMapSize: (CGRect) rect
{
    if (self.zoomDummy)
    {
        [self.zoomDummy removeFromSuperview];
    }
    // Create dummy view to Zoom. This keeps the zooming values out of the CTM
    
    UIView *zd = [[UIView alloc] initWithFrame: rect];

    self.zoomDummy =  zd;
    self.zoomDummy.hidden = YES;
    [zd release];

    self.delegate = self;
    self.contentSize = CGSizeMake(rect.size.width, rect.size.height);
    
    [self addSubview: zoomDummy];
    
    worldToMapTransform = CGAffineTransformIdentity;
    mapToWorldTransform = CGAffineTransformIdentity;
    
    scrollZoomOptions = nnkZoomVertical | nnkZoomHorizontal | nnkScrollingVertical | nnkScrollingHorizontal;
    
    // Init zoom values
    zoomScale = 1.0;
    scrollOffset = CGPointMake(0,0);
    
    [self updateMatrices];
}

-(void)setScrollZoomOptions: (NSInteger) options
{
    scrollZoomOptions = options;
}


-(void)setupZoomMinMax
{
   self.minimumZoomScale = zoomMin;
   self.maximumZoomScale = zoomMax;
}

-(void)setZoomMin: (CGFloat) min andMax: (CGFloat) max
{
    zoomMin = min;
    zoomMax = max;
    
    [self setupZoomMinMax];
}

-(void)updateWorldToMap: (CGAffineTransform)w2d
{
    worldToMapTransform = w2d;
    mapToWorldTransform = CGAffineTransformInvert(worldToMapTransform);
    
    [self setNeedsDisplay];
    [self updateMatrices];
}
    
    
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    zoomScale = sv.zoomScale;
    scrollOffset = sv.contentOffset;
    [self updateMatrices];
    [self setNeedsDisplay];
}

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    zoomScale = sv.zoomScale;
    scrollOffset = sv.contentOffset;
    [self updateMatrices];
    [self setNeedsDisplay];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomDummy;
}

-(void)zoomView
{
    [self setZoomScale: self.zoomScale * 2.0];
}

-(void)fitView
{
    [self zoomToRect: zoomDummy.bounds animated: NO];
    
    [self updateMatrices];
}

-(void)centerView
{
    CGRect centerRect = CGRectMake(zoomDummy.bounds.size.width/2.0 - self.bounds.size.width/2.0,
                                   zoomDummy.bounds.size.height/2.0 - self.bounds.size.height/2.0, 
                                   self.bounds.size.width, 
                                   self.bounds.size.height);
    
    [self zoomToRect: centerRect animated: NO];
    
    [self updateMatrices];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setupZoomMinMax];
}


@end
