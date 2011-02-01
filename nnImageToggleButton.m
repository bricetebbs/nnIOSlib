//
//  nnImageToggleButton.m
//
//  Created by Brice Tebbs on 7/29/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnImageToggleButton.h"


@implementation nnImageToggleButton
@synthesize delegate;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setState:(BOOL)state
{
    self.highlighted = state;
    [delegate stateUpdated:self isNow:state];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = !self.highlighted;
    [delegate stateUpdated: self isNow:self.highlighted];
}


- (void)dealloc {
    [super dealloc];
}


@end
