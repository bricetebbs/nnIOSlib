//
//  nnLoadURL.h
//  cloudlist
//
//  Created by Brice Tebbs on 5/11/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol nnLoadURLDelegate
-(void)loadComplete;
-(void)failedWithError:(NSError*) error;
-(void)receivedData:(NSData*) data;
@end

@interface nnLoadURL : NSObject {
    
    NSURLConnection* _connection;
    NSString *urlString;
    id <nnLoadURLDelegate> handler;
}

@property (nonatomic, retain) id <nnLoadURLDelegate> handler;
-(void)loadURL: (NSString*) url;
@end
