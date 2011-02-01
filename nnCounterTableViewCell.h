//
//  nnCounterTableViewCell.h
//
//  Created by Brice Tebbs on 7/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "nnCustomTableViewCell.h"

@interface nnCounterTableViewCell : nnCustomTableViewCell {
    UIButton *bumpButton;
}

-(IBAction)bumpCount;
@property (nonatomic, retain) IBOutlet UIButton *bumpButton;

@end
