//
//  nnLoadURL.m
//  cloudlist
//
//  Created by Brice Tebbs on 5/11/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnLoadURL.h"
 
@interface nnLoadURL ()

@property (nonatomic, retain) NSURLConnection* connection;
@end


@implementation nnLoadURL
@synthesize connection = _connection;
@synthesize handler;

-(void)loadURL:(NSString *)url
{
    
    NSURL* urlObj;
    NSURLRequest *request;
    [urlString release];
    urlString = [url retain];
    
    urlObj = [NSURL URLWithString: urlString];
    request = [NSURLRequest requestWithURL: urlObj ];
    
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    assert(theConnection == self.connection);
  
    [handler receivedData:data];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    assert(theConnection == self.connection);
    [handler failedWithError: error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    assert(theConnection == self.connection);
    [handler loadComplete];
}





@end
