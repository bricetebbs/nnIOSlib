//
//  nnCustomTableViewCell.m
//  metime
//
//  Created by Brice Tebbs on 7/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnCustomTableViewCell.h"



@implementation nnCustomTableViewCell
@synthesize delegate;
@synthesize cellLabel;
@synthesize userData;


- (void)dealloc {
    [userData release];    
    [cellLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}



@end
