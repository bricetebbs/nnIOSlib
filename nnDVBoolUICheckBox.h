//
//  nnDBBoolUICheckBox.h
//  formulate
//
//  Created by Brice Tebbs on 2/7/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnDV.h"

@interface nnDVBoolUICheckBox : UIButton <nnDVUIBaseProtocol>{
    nnDVBase *dvInfo;
    BOOL isChecked;
}
@end
