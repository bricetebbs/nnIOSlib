//
//  nnDVCounterTableViewCell.h
//  metime
//
//  Created by Brice Tebbs on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnDVCustomTableViewCell.h"
#import "nnDVIntUIBumpButton.h"

@interface nnDVCounterTableViewCell : nnDVCustomTableViewCell {
    nnDVIntUIBumpButton* bumpButton;
}

@property (nonatomic, retain) IBOutlet nnDVIntUIBumpButton *bumpButton;

@end
