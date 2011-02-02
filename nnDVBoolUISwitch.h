//
//  nnDVBoolUISwitch.h
//
//  A UI element for toggling a checkbox preference. Talks to the preference manager to initialize 
//  and save the results.
//
//  Created by Brice Tebbs on 8/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnDV.h"


@interface nnDVBoolUISwitch : UISwitch <nnDVUIBaseProtocol> {
    nnDVBase *dvInfo;
}
@end
