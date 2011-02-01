//
//  nnScrollView.h//
//  Created by Brice Tebbs on 6/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface nnScrollingContainerView   : UIScrollView <UIScrollViewDelegate> {
    UIView *viewToScroll;
    
}


@property  (nonatomic, retain) IBOutlet UIView* viewToScroll;

-(IBAction) resetView;

@end
