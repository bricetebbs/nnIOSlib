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

@protocol nnInteractionViewDelegate
-(void) touchUpPoints: (NSArray*) strokePoints; 
@end


@interface nnInteractionView : UIView {
    NSMutableArray *dragPoints;
    
    id <nnInteractionViewDelegate> interactDelegate;
}

-(void)clearDragPoints;
@property (nonatomic, readonly) NSMutableArray *dragPoints;
@property (nonatomic, assign) id <nnInteractionViewDelegate> interactDelegate;


@end
