//
//  nnGenericTransport.m
//  idrawer
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnGenericTransport.h"


@implementation nnGenericTransport



-(id)init
{
    self = [super init];
    if (self)
    {
        connectedPeers = [[NSMutableSet alloc] init];
        desiredPeers = [[NSMutableSet alloc] init];
    }
    return self;
}


- (void)dealloc {
    
    [localUser release];
    [localPassword release];
    [connectedPeers release];
    [desiredPeers release];
    
    [super dealloc];
}



-(void)sendNSData: (NSData*) data toPeer: (NSString*) peer {}
-(void)setup {}

-(void)setupLocalUser:(NSString *)user withPassword: (NSString*)password
{
    
    NSLog(@"Setting up local user");
    
    localUser = [user copy];
    localPassword = [password copy];    

}

-(void)setPeerAvailability: (nnPeerAvailability) state
{
    peerAvailability = state;
}

-(void)setTransportDelegate: ( id <nnTransportDelegate>) delegate
{
    handler = delegate;
}


-(void)sendNSString: (NSString*) string toPeer: (NSString*) peer
{
    NSData* data = [string dataUsingEncoding: NSASCIIStringEncoding];
    
    [self sendNSData: data toPeer: peer];
}

@end
