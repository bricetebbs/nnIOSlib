//
//  nnMessageSystem.m
//
//  Created by Brice Tebbs on 4/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnMessageSystem.h"

@implementation nnMessageSystem

@synthesize handler;
@synthesize serializer;
@synthesize transportSystem;

- (void)dealloc {
    [serializer release];
    [transportSystem release];
    [super dealloc];
}
    
// Dummy Abstract methods;
-(void) setup {
    serializer = [[nnSerializer alloc] init];
    [transportSystem setup];
}


-(void) sendObject: (id <nnEncodable>) object
{   
    [serializer beginFrame];
    [serializer serializeObject: object];
    [transportSystem sendNSString: [serializer getStringBuffer] toPeer: nil];
}

-(void)parseObjectFromNSString: (NSString*) string
{
    id obj;
    [serializer prepareToRead: string];
    obj = [serializer allocAndDeserializeObject];
    [handler gotObject: obj];
    [obj release];
}

-(void) recievedNSData:( NSData*) data fromPeer:(NSString*)peer
{
    NSString *pstring =  [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
    [self parseObjectFromNSString: pstring];
    [pstring release];
}

- (void) peersConnected: (NSSet*)peers
{
    [handler numConnectedPeers: [peers count]];
}
- (void) peersAvailable: (NSSet*)peers {}

- (void) connectFailed: (NSString*) peer msgIs: (NSString*) msg {}
- (void) sendFailed: (NSString*) peer msgIs: (NSString*) msg {}

@end