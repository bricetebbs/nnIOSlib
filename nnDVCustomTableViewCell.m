//
//  nnDVCustomTableViewCell.m
//  metime
//
//  Created by Brice Tebbs on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "nnDVCustomTableViewCell.h"


@implementation nnDVCustomTableViewCell
@synthesize cellLabel;
@synthesize colorSwatch;

- (void)dealloc
{
    [cellLabel release];
    [colorSwatch release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)populate
{
}

-(void)setColorRed:(double)red green:(double)green blue:(double)blue
{
    [colorSwatch setBackgroundColor: [UIColor colorWithRed:red green:green blue:blue alpha:1.0]];   
}

@end
