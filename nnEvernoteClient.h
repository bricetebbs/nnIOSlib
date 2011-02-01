//
//  nnEvernoteClient.h
//  cloudlist
//
//  Created by Brice Tebbs on 5/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class THTTPClient;
@class TBinaryProtocol;
@class EDAMUserStoreClient;
@class EDAMUser;
@class EDAMNoteStoreClient;
@class EDAMNote;


#import "nnListItem.h"
#import "nnTableViewDataProvider.h"
#import "nnRemoteSyncManager.h"

@interface nnEvernoteClient : NSObject  <nnRemoteDataSourceDelegate, nnRemoteSyncTrackingInfoDelegate> {
    NSString *consumerKey;
	NSString *consumerSecret;
    
    EDAMUser *edamUser;
    NSString *authToken;
    
    // Im guessing we don't need to keep these around
    NSURL *userStoreUri;
	NSString *noteStoreUriBase;
    
    EDAMUserStoreClient *userStore;
    EDAMNoteStoreClient *noteStore;
    
    BOOL isSetup;
    
    NSString* appName;    
    NSString* noteTag;    
}

-(nnErrorCode)setupEvernote: (NSString*) appName withKey: (NSString*)consumerKey withSecret: (NSString*) consumerSecret 
                     useTag: (NSString*) tag
                 useSandBox: (BOOL) sandbox;
-(nnErrorCode)authenticate: (NSString*)username withPassword: (NSString*)password;


@property (nonatomic, readonly) BOOL isSetup;

@end

@interface nnEvernoteTODOParser : NSObject <NSXMLParserDelegate>
{
    nnListItem *currentItem;
    BOOL lineBreakerFound;
    NSMutableArray* parseList;
    NSString* header;
    NSMutableArray* todoBuffer;
    
}
-(id)initWithBuffer: (NSMutableArray*) buffer;

@property (nonatomic, retain) NSString* header;

@end

