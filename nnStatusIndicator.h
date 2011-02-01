//
//  nnStatusIndicator.h
//
//  A simple multistate indicator control.
//
//  Created by Brice Tebbs on 7/29/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class nnStatusIndicator;
@protocol nnStatusIndicatorDelegate

-(void)stateUpdated: (nnStatusIndicator*) indicator isNow:(NSInteger)state;

@end

@interface nnStatusIndicator : UIImageView {
    id<nnStatusIndicatorDelegate> delegate;
    NSInteger _state;
}

-(void)setState:(NSInteger)state;

@property (nonatomic,assign) id<nnStatusIndicatorDelegate> delegate;

@end
