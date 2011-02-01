//
//  nnAddItemTableViewCell.m
//  cloudlist
//
//  Created by Brice Tebbs on 6/4/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnAddItemTableViewCell.h"


@implementation nnAddItemTableViewCell
@synthesize addButton;
@synthesize addName;
@synthesize delegate;

- (void)dealloc {
    [addButton release];
    [addName release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField { 
    [addName resignFirstResponder];
    [delegate addItemUsingString: self.addName.text];
    self.addName.text = @"";
    return YES; 
} 

-(void)closeKeyboard: (UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self performSelector: @selector(closeKeyboard:) withObject: textField afterDelay: 0.1];
    return YES;
}

-(void)AddIt
{
    [addName resignFirstResponder];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
