//
//  nnGameKitTransport.h
//  idrawer
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "nnGenericTransport.h"


@interface nnGameKitTransport : nnGenericTransport <nnTransport, GKPeerPickerControllerDelegate, GKSessionDelegate> {
    GKSession	 *gameSession;
    NSString	 *gamePeerId;
}




@end
