//
//  nnDVTextEditTableViewCell.h
//  formulate
//
//  Created by Brice Tebbs on 2/8/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnDVCustomTableViewCell.h"
#import "nnDVStringUIText.h"


@interface nnDVTextEditTableViewCell : nnDVCustomTableViewCell <UITextFieldDelegate>{
    nnDVStringUIText* text;
}
@property (nonatomic,retain) IBOutlet   nnDVStringUIText* text;
@end
