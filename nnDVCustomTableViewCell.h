//
//  nnDVCustomTableViewCell.h
//
//  Created by Brice Tebbs on 2/4/11.
//  Copyright 2011 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "nnDV.h"

@interface nnDVCustomTableViewCell : UITableViewCell {
    UILabel *cellLabel;
    UIView *colorSwatch;
}

@property (nonatomic, retain) IBOutlet UILabel *cellLabel;
@property (nonatomic, retain) IBOutlet UIView *colorSwatch;


-(void)setColorRed: (double) red green: (double)green blue: (double)blue;


// Things subclasses need to do
//
-(void)populate; // Show the data in your cell based on your dvInfo

@end
