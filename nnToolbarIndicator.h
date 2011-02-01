//
//  nnToolbarIndicator.h
//
//  Created by Brice Tebbs on 6/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class nnToolbarIndicator;

@protocol nnToolbarIndicatorDelegate

-(void)indicatorChanged: (nnToolbarIndicator*) ti;
@end

@interface nnToolbarIndicator : UIBarButtonItem {
    BOOL isOn;
    id <nnToolbarIndicatorDelegate> delegate;
    NSString* name;
}

-(void)setup;
-(void)isClicked;


-(void)setState: (BOOL)s;

@property (nonatomic, assign) IBOutlet id <nnToolbarIndicatorDelegate> delegate;
@property (nonatomic, readonly) BOOL isOn;

@end
