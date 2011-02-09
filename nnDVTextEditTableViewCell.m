//
//  nnDVTextEditTableViewCell.m
//  formulate
//
//  Created by Brice Tebbs on 2/8/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import "nnDVTextEditTableViewCell.h"


@implementation nnDVTextEditTableViewCell

@synthesize text;

-(void)populate
{
    [text populate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField { 
    [theTextField resignFirstResponder];
    return YES; 
} 

@end
