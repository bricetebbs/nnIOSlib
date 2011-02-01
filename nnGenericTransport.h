//
//  nnGenericTransport.h
//  idrawer
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnTransport.h"

@interface nnGenericTransport : NSObject {

    nnPeerAvailability peerAvailability;
    NSMutableSet *connectedPeers;
    NSMutableSet *desiredPeers;
    
    
    id <nnTransportDelegate> handler;
    
    NSString *localUser;
    NSString *localPassword;
    
}

// Abstract
-(void)sendNSData: (NSData*) data toPeer: (NSString*) peer; 
-(void)setup;

// Working
-(void)setPeerAvailability: (nnPeerAvailability) state;
-(void)setTransportDelegate: ( id <nnTransportDelegate>) delegate;

-(void)setupLocalUser: (NSString*) user withPassword: (NSString*)password;



// Helper
-(void)sendNSString: (NSString*) string toPeer: (NSString*) peer; 
@end
