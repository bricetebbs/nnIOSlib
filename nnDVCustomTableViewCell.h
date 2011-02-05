//
//  nnDVCustomTableViewCell.h
//  metime
//
//  Created by Brice Tebbs on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "nnDV.h"

@interface nnDVCustomTableViewCell : UITableViewCell {
    UILabel *cellLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *cellLabel;

// Things subclasses need to do
//
-(void)populate; // Show the data in your cell based on your dvInfo

@end
