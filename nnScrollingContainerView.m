//
//  nnScrollView.m
//
//  Created by Brice Tebbs on 6/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnScrollingContainerView.h"

@implementation nnScrollingContainerView

@synthesize viewToScroll;

- (void)dealloc 
{
    [viewToScroll release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)resetView
{
    [self setZoomScale: 1.0 animated: NO];
    [self setContentOffset:CGPointMake(0,0) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self.viewToScroll setNeedsDisplay];
}


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.viewToScroll;
}

@end
