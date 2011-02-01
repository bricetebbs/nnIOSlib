//
//  nnXMPPTransport.h
//  idrawer
//
//  Created by Brice Tebbs on 5/6/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnGenericTransport.h"

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;


@interface nnXMPPTransport : nnGenericTransport <nnTransport> {
    XMPPStream *xmppStream;
	
    NSString *localJID;
    
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isOpen;
    
    NSMutableSet *availablePeers;
}

    

@end
