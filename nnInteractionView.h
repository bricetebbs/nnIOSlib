//
//  nnInteractionView.h
//  wardap
//
//  Created by Brice Tebbs on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
