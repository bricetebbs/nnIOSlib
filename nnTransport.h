//
//  nnTransport.h
//  idrawer
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


enum nnPeerAvailability
{
	kPeerAvailabilityOffline = 1,  // Unavailable to connect
	kPeerAvailabilityOnline  = 2, 	// Avialable to connect
};

typedef enum nnPeerAvailability nnPeerAvailability;

@protocol nnTransportDelegate
- (void) recievedNSData: (NSData*) data fromPeer:(NSString*) peer;
- (void) peersConnected: (NSSet*)peers;
- (void) peersAvailable: (NSSet*)peers;
 
- (void) connectFailed: (NSString*) peer msgIs: (NSString*) msg;
- (void) sendFailed: (NSString*) peer msgIs: (NSString*) msg;
@end


@protocol nnTransport <NSObject>

-(void)setup;

-(NSSet*)getAvailablePeers;
-(NSString*)getLocalPeerID;

-(void)setupLocalUser: (NSString*) user withPassword: (NSString*) password;


-(void)sendNSData: (NSData*) data toPeer: (NSString*) peer; // Nil if to all connected

-(void)disconnectPeer: (NSString*) peer;
-(void)disconnectAllPeers;

-(void)connectToPeer: (NSString*) peer; // Nil if use Picker

// Provided by nnGenericTransport
-(void)setPeerAvailability: (nnPeerAvailability) state;
-(void)setTransportDelegate: (id <nnTransportDelegate>) delegate;
-(void)sendNSString: (NSString*) string toPeer: (NSString*) peer; // Nil if to all connected

@end
