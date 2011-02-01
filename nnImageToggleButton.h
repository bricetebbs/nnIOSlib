//
//  nnImageToggleButton.h
//  
//  A two state button/indicator which toggles on touches
//
//  Created by Brice Tebbs on 7/29/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class nnImageToggleButton;
@protocol nnImageToggleButtonDelegate

-(void)stateUpdated: (nnImageToggleButton*) indicator isNow:(BOOL)state;

@end

@interface nnImageToggleButton : UIImageView {
    id<nnImageToggleButtonDelegate> delegate;
}

-(void)setState:(BOOL)state;

@property (nonatomic,assign) id<nnImageToggleButtonDelegate> delegate;

@end
