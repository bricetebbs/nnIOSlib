//
//  nnGameKitTransport.m
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnGameKitTransport.h"


@implementation nnGameKitTransport

- (void)dealloc {   
    gameSession = nil;   
    gamePeerId = nil;
    [super dealloc];
}

-(void)setup 
{
    [gameSession release];
    gameSession = [[GKSession alloc] initWithSessionID:nil displayName:nil sessionMode:GKSessionModePeer]; 
    gameSession.delegate = self;
}

-(NSSet*)getAvailablePeers
{
    return [NSSet setWithArray:[gameSession peersWithConnectionState:GKPeerStateAvailable]];
}

-(NSString*)getLocalPeerID
{
    return [gameSession peerID];
}

-(void)sendNSData: (NSData*) data toPeer: (NSString*) peer
{
    if(!peer)
        [gameSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
    else 
        [gameSession sendData:data toPeers:[NSArray arrayWithObject: peer] withDataMode:GKSendDataReliable error:nil];
}


- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context 
{ 
    [handler recievedNSData:data fromPeer:peer];
}


-(void)disconnectPeer: (NSString*) peer
{
    [gameSession disconnectPeerFromAllPeers: peer];
}

-(void)disconnectAllPeers
{
    [gameSession disconnectFromAllPeers];
}

-(void)connectToPeer: (NSString*) peer
{
    if (peer == nil)
    {
        GKPeerPickerController*	picker;
        picker = [[GKPeerPickerController alloc] init];
        picker.delegate = self;
        picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby ;
        [picker show];
    }
    
    else {
        [gameSession connectToPeer: peer withTimeout:2.0];
    }
}


- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker 
{ 
	picker.delegate = nil;
    [picker autorelease]; 
} 


- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type 
{ 
	return gameSession;
}    

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateConnected)
    {
        [connectedPeers addObject: peerID];
    }
    if (state == GKPeerStateDisconnected)
    {
        [connectedPeers minusSet: [NSSet setWithObject: peerID]];
    }
    
    [handler peersAvailable: [self getAvailablePeers]];
    [handler peersConnected: connectedPeers];
    
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session 
{ 
	
	[gameSession setDataReceiveHandler:self withContext:NULL];
	
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
} 


@end
