//
//  nnPreferenceManager.h
//
//  an implementation of nnDVStoreProtocol which uses NSUserDefaults for its implementation
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnDV.h"


@interface nnPreferenceManager : NSObject <nnDVStoreProtocol> {
// The methods are all defined by the protocol
}

-(void) registerDefaults: (NSDictionary*) def;

@end
