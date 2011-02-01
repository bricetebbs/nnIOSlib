//
//  nnPreferenceUISwitch.h
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnPreferenceStoreProtocol.h"

@interface nnPreferenceUISwitch : UISwitch {
    NSString* preferenceName;
    BOOL _setupComplete;
    id <nnPreferenceStoreProtocol> delegate;
}

@property (nonatomic, retain) NSString* preferenceName;
@property (nonatomic, assign) id <nnPreferenceStoreProtocol> delegate;
-(void)setup;

@end
