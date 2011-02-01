//
//  nnGameKitMessageSystem.h
//
//  Created by Brice Tebbs on 4/19/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

#import "nnMessageSystem.h"


@interface nnGameKitMessageSystem : nnMessageSystem <GKPeerPickerControllerDelegate, GKSessionDelegate> {
    GKSession	 *gameSession;
    NSString	 *gamePeerId;
    

    UIAlertView *connectionAlert;
}


@property(nonatomic, retain) GKSession	 *gameSession;
@property(nonatomic, copy)	 NSString	 *gamePeerId;

@property(nonatomic, retain) UIAlertView *connectionAlert;
@end
