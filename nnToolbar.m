//
//  nnToolbar.m
//  audioeye
//
//  Created by Brice Tebbs on 6/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnToolbar.h"
#import "nnToolbarIndicator.h"
@implementation nnToolbar

-(IBAction)toolBarIndicatorClicked: (id) sender
{
    nnToolbarIndicator* tbi = (nnToolbarIndicator*)sender;
    [tbi isClicked];
}
@end
