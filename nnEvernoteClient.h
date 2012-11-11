//
//  nnEvernoteClient.h
//  cloudlist
//
//  Created by Brice Tebbs on 5/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EvernoteSession.h"
#import "EvernoteUserStore.h"
#import "EvernoteNoteStore.h"

@class EDAMUser;
@class EDAMNote;

#import "nnListItem.h"
#import "nnTableViewDataProvider.h"
#import "nnRemoteSyncManager.h"



@interface nnEvernoteClient : NSObject  <nnRemoteDataSourceDelegate, nnRemoteSyncTrackingInfoDelegate> {
    NSString *consumerKey;
	NSString *consumerSecret;
    
    EDAMUser *edamUser;
    EvernoteUserStore *userStore;
    EvernoteNoteStore *noteStore;
    
    BOOL isSetup;
    NSString* appName;    
    NSString* noteTag;
}

-(void)setup:(NSString*)applicationName withTag: (NSString*) tagName;

-(void)setupClient;
-(nnErrorCode)handleOAuth: (UIViewController*) view;
-(nnErrorCode)logout;
-(BOOL)isAuthenticated;
-(NSString*)getUser;
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

