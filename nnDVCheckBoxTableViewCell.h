//
//  nnDVCheckBoxTableViewCell.h
//  formulate
//
//  Created by Brice Tebbs on 2/7/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnDVBoolUICheckBox.h"
#import "nnDVCustomTableViewCell.h"

@interface nnDVCheckBoxTableViewCell : nnDVCustomTableViewCell {
    nnDVBoolUICheckBox* checkbox;
}
@property (nonatomic,retain) IBOutlet nnDVBoolUICheckBox* checkbox;


@end
