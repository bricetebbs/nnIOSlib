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

- (void)dealloc
{
    [cellLabel release];
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


@end
