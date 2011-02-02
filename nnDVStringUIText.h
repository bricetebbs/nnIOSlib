//
//  nnDVStringUIText.h
//  glogger
//
//  Created by Brice Tebbs on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "nnDV.h"

@interface nnDVStringUIText : UITextField  <nnDVUIBaseProtocol>
{
    nnDVBase* dvInfo;
}

@property (nonatomic, retain) nnDVBase* dvInfo;

@end


