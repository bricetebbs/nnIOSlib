//
//  nnXMPPTransport.m
//  idrawer
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnXMPPTransport.h"


#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import <CFNetwork/CFNetwork.h>


NSString *XMPP_HOST_NAME= @"talk.google.com";
NSString *XMPP_DOMAIN_NAME = @"@northnitch.com";
NSString *XMPP_RESOURCE_NAME = @"/iPhoneTest";  
NSInteger XMPP_HOST_PORT = 5222;


@implementation nnXMPPTransport


- (void)dealloc {
    [xmppStream removeDelegate:self];
    
    [xmppStream disconnect];
    [xmppStream release];    
    [localJID release];
    
    
    [super dealloc];
}


-(NSSet*)getAvailablePeers
{
    return availablePeers;
}

-(NSString*)getLocalPeerID
{
    return localJID;
}


-(void)disconnectPeer: (NSString*) peerID
{
    
   [desiredPeers minusSet: [NSSet setWithObject: peerID]];
   [connectedPeers minusSet: [NSSet setWithObject: peerID]];
    
}
-(void)disconnectAllPeers
{
    
    [desiredPeers removeAllObjects];
    [connectedPeers removeAllObjects];
}

-(void)connectToPeer: (NSString*) peerID
{
    [desiredPeers addObject: peerID];
    if ([availablePeers containsObject: peerID])
        [connectedPeers addObject: peerID];
}


-(NSString*) peerToJID: (NSString*) user
{
    return [NSString stringWithFormat:@"%@%@", user, XMPP_RESOURCE_NAME];
}


-(NSString*) JIDToPeer: (NSString*) JID
{
    NSRange range = [JID rangeOfString:@"/"];
    
    range.length = range.location;
    range.location = 0;
    return [JID substringWithRange:range];
}


-(void)sendNSData: (NSData*) data toPeer: (NSString*) peerID
{
    NSString *pstring =  [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
    
    XMPPMessage *response = [[XMPPMessage alloc] initWithName: @"message"];
    [response addAttributeWithName:@"stanza_type" stringValue:@"message"];
    [response addAttributeWithName:@"type" stringValue:@"chat"];
    [response addChild:[NSXMLElement elementWithName:@"body" stringValue:pstring]];
    
    if (peerID != nil)
    {
        [response addAttributeWithName:@"to" stringValue: [self peerToJID: peerID]];
        [xmppStream sendElement: response];
    }
    else 
    {
        for (NSString *cpeer in connectedPeers) 
        {
            [response addAttributeWithName:@"to" stringValue: [self peerToJID: cpeer]];
            [xmppStream sendElement: response];
        }
        
    }
    [pstring release];
    [response release];
    
}



-(void) setup
{
    [super setup];
    
    xmppStream = [[XMPPStream alloc] init];
	[xmppStream addDelegate:self];
    
    
	[xmppStream setHostName:XMPP_HOST_NAME];
    [xmppStream setHostPort:XMPP_HOST_PORT];
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = YES;
    
}
//


-(void)setupLocalUser:(NSString *)user withPassword:(NSString*) password
{
    [super setupLocalUser: user withPassword: password];

    if ([xmppStream isConnected])
    {
        [xmppStream disconnect];
    }
    
    localJID = [self peerToJID: user];
    [xmppStream setMyJID:[XMPPJID jidWithString:localJID]];
    
    [localJID retain];
    
	NSError *error = nil;
    if (![xmppStream connect:&error])
    {
        NSLog(@"Error connecting: %@", error);
    }
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Custom
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
// 
// In addition to this, the NSXMLElementAdditions class provides some very handy methods for working with XMPP.
// 
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
// 
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[xmppStream sendElement:presence];
}

- (void)goOffline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[xmppStream sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidSecure: ----------");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidConnect: ----------");
	
	isOpen = YES;
	
	NSError *error = nil;
	
	if (![ xmppStream authenticateWithPassword:localPassword error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
	
	return NO;
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSLog(@"---------- xmppStream:didReceiveMessage: ----------");
    if ( [message isChatMessageWithBody])
    {   
        
        NSString *from =[message fromStr];

        NSString *pstring = [[message elementForName:@"body"] stringValue];
        NSData* data = [pstring dataUsingEncoding: NSASCIIStringEncoding];
        [handler recievedNSData:data fromPeer:from];
    }
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"---------- xmppStream:didReceivePresence: ----------");
    
    NSString *from = [presence fromStr];
    NSString *type = [presence type];
    
    NSString *peer = [self JIDToPeer: from];
    
    if ([type isEqualToString: @"available"])
    {
        [availablePeers addObject: peer];
        if ([desiredPeers containsObject: peer])
           [connectedPeers addObject: peer];
        
    }
    else if ([type isEqualToString: @"unavailable"])
    {
        [availablePeers minusSet: [NSSet setWithObject: peer]];
        [connectedPeers minusSet: [NSSet setWithObject: peer]];
    }
    
    NSLog(@"Peer %@ is %@", peer, type);
    
    for (NSString *cpeer in connectedPeers) 
    {
        NSLog(@"%@ is Connected", cpeer);
    }
    
    [handler peersAvailable: [self getAvailablePeers]];
    [handler peersConnected: connectedPeers];

}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	NSLog(@"---------- xmppStream:didReceiveError: ----------");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	
	if (!isOpen)
	{
        [handler connectFailed:[[sender remoteJID] full] msgIs:  @"Unable to reach server."];
		
        NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

@end
