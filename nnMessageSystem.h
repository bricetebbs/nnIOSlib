//
//  nnMessageSystem.h
//
//  Created by Brice Tebbs on 4/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnSerializer.h"
#import "nnTransport.h"

@protocol nnMessageSystemDelegate
- (void) gotObject: (id) obj;
- (void) connectFailed: (NSString*) msg;
- (void) numConnectedPeers: (NSInteger) numConnected;
@end


@interface nnMessageSystem : NSObject <nnTransportDelegate> {
    nnSerializer* serializer;
    id <nnMessageSystemDelegate> handler;
    id <nnTransport> transportSystem;
}

//
// Really for subclasses only (protected)
//
-(void)parseObjectFromNSString: (NSString*) string;


// This is public to allow class registration
@property (nonatomic,retain)  nnSerializer* serializer;

//
// This is the real public api
//
-(void) setup;
-(void) sendObject: (id <nnEncodable>) object;
@property (nonatomic, assign) id <nnMessageSystemDelegate> handler;
@property (nonatomic, retain)  id <nnTransport> transportSystem;



@end
