//
//  nnFullScreenFeedback.m
//  cloudlist
//
//  Created by Brice Tebbs on 6/3/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnFullScreenFeedback.h"

@implementation nnFullScreenFeedback
@synthesize statusInfo;
@synthesize spinner;
@synthesize freeRotate;

- (void)dealloc {
    [spinner release];
    [statusInfo release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}   

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return self.freeRotate;
}



@end
