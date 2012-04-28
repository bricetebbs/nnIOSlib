//
//  nnInteractionView.h
//
//  This class backs a view which gives feedback as the user interacts with the screen
//  Useful for drawing where you want to show the path traced and then on touchUpPoints a delegate is
//  Fired to create an object or whatever you like.
//
//  Created by Brice Tebbs on 2/12/11.
//  Copyright 2011 northNitch Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// This is how we notify a user of this class that an interaction has been completed.
// Once touches are done on the view we will send the saved points to the delegate
// The user must copy/retain the points right away if they want to keep them.
@protocol nnInteractionViewDelegate
-(void) touchUpPoints: (NSArray*) strokePoints; 
@end


@interface nnInteractionView : UIView {
    
    NSMutableArray *dragPoints; // A place to keep a list of the current touches
    
    id <nnInteractionViewDelegate> interactDelegate; // Who gets told that we are done touching.
    BOOL showPoints; // Do we show the points or not
}

-(void)clearDragPoints;

// In case we want to look at the points so far
@property (nonatomic, readonly) NSMutableArray *dragPoints;

// For setting the delegate
@property (nonatomic, assign) id <nnInteractionViewDelegate> interactDelegate;


@end
