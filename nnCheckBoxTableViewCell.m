//
//  nnCheckBoxTableViewCell.m
//
//  Created by Brice Tebbs on 5/10/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCheckBoxTableViewCell.h"


@implementation nnCheckBoxTableViewCell
@synthesize handler;
@synthesize index;
@synthesize cellLabel;
@synthesize checkButton;
@synthesize moreButton;

- (void)dealloc {
    [cellLabel release];
    [checkButton release];
    [moreButton release];
    [super dealloc];
}

-(void) setChecked: (BOOL) checked;
{   
    isChecked = checked;
    UIImage *image;
    if (isChecked)
    {
        image = [UIImage imageNamed:@"checkbox_checked.png"];
    }
    else {
        image = [UIImage imageNamed:@"checkbox_unchecked.png"];
    }

    [checkButton setBackgroundImage:image  forState: UIControlStateNormal];
    [checkButton setBackgroundImage:image  forState: UIControlStateSelected];
    [checkButton setBackgroundImage:image  forState: UIControlStateHighlighted];
  
}

-(IBAction)checkClicked
{
    BOOL newValue = !isChecked;
    [self setChecked: newValue];
    [handler checkChanged: newValue forCell: self];
    
}
-(IBAction)moreClicked
{
    [handler moreClickedforCell: self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}




@end
