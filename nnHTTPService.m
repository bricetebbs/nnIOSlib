//
//  nnHTTPService.m
//
//  Created by Brice Tebbs on 8/11/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "JSON.h"

#import "nnHTTPService.h"
#import "ASIFormDataRequest.h"
#import "northNitch.h"

@interface nnHTTPService ()
@property (nonatomic,retain) ASIFormDataRequest* request;


@property (nonatomic,retain) ASIHTTPRequest* failedRequest;
@property (nonatomic, retain) NSString* serverString;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* authenticationURL;
@property (nonatomic, retain) NSDictionary* lastPostData;

-(void)authenticateAndRetry:(ASIHTTPRequest *)failedRequest;
@end


@implementation nnHTTPService
@synthesize delegate;
@synthesize request;
@synthesize failedRequest;
@synthesize serverString;
@synthesize username;
@synthesize password;
@synthesize authenticationURL;
@synthesize lastPostData;


- (id)initWithServerString:(NSString *)server
{
    self = [self init];
    self.serverString = server;
    return self;
}

-(void)submitPostRequest:(NSString *)url withData:(NSDictionary *)data andTag: (NSString*)tag
{
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/%@",self.serverString, url]]];
    [request setUseKeychainPersistence:NO];
    [request setDelegate:self];
    
    [request setUserInfo: [NSDictionary dictionaryWithObject: tag forKey: @"command"]];
    [request setDidFinishSelector:@selector(postComplete:)];
    [request setDidFailSelector:@selector(postFailed:)];
    for(NSString* key in data)
    {
        [request addPostValue: [data objectForKey:key] forKey:key];
    }
    
    self.lastPostData = data;
    [request startAsynchronous];
}


-(void)retryFailedRequest
{
    // Must put a retry limit in here
    
    NSString *tag = [self.failedRequest.userInfo objectForKey:@"command"];
    
    [self submitPostRequest:[self.failedRequest.originalURL relativeString] withData: self.lastPostData andTag:tag];
}




-(void) processResponse:(NSObject*) response forRequest: (ASIHTTPRequest *)theRequest 
{
    [delegate serviceResponse: response forTag: [theRequest.userInfo objectForKey:@"command"] withError: [request error]];
}

- (void)postFailed:(ASIHTTPRequest *)theRequest
{
    [self processResponse: [request responseString] forRequest: theRequest];
}


-(BOOL) needsAuth:(ASIHTTPRequest *)theRequest
{
    NSString* url = [theRequest.url absoluteString];
    NSString* orignalUrl = [theRequest.originalURL absoluteString];
    NSRange textRange = [url rangeOfString:@"/login/?next"];
    
    return ![url isEqualToString: orignalUrl] && textRange.location != NSNotFound;
}


- (void)postComplete:(ASIHTTPRequest *)theRequest
{
    if ([self needsAuth:theRequest])
    {
        [self authenticateAndRetry: theRequest];
        return;
    }
    NSString* responseStr = [request responseString];
    SBJsonParser *parser = [SBJsonParser new];
    NSObject* obj = [parser objectWithString:responseStr];
    
    [self processResponse: obj forRequest: theRequest];
    
    [parser release];
}



-(void) authComplete: (ASIHTTPRequest*)theRequest
{
    NSString* responseStr = [request responseString];
    nnDebugLog(@"Rs=%@",responseStr);
    
    // Only do this if response was ok.
    [self retryFailedRequest];
    
}

-(void) authFailed: (ASIHTTPRequest*)theRequest
{
    NSString* responseStr = [request responseString];
    nnDebugLog(@"FR=%@",responseStr);
}

-(void)authenticateAndRetry:(ASIHTTPRequest *)fRequest  // Break into an AUTH and A Retry function so Clients can request auth without having to post
{
    self.request = [ASIFormDataRequest 
                                       requestWithURL:[NSURL URLWithString:
                                                       [NSString stringWithFormat: @"%@/%@",
                                                        self.serverString, 
                                                        self.authenticationURL]]];
    [request setUseKeychainPersistence:NO];
    [request setDelegate:self];
    
    [request setDidFinishSelector:@selector(authComplete:)];
    [request setDidFailSelector:@selector(authFailed:)];
    [request addPostValue: self.username forKey:@"username"];
    [request addPostValue: self.password forKey:@"password"];
    
    self.failedRequest = fRequest;
   
    [request startAsynchronous];
}


-(void)checkAuthenticationCredentials: (NSString*)authURL username: (NSString*)uname password: (NSString*)pword
{
    [self submitPostRequest: authURL withData: [NSDictionary dictionaryWithObjectsAndKeys: uname, @"username",
                                                                                   pword, @"password", nil]
                                                                                   andTag: @"check_auth"];
}


-(void)setAuthenticationCredentials: (NSString*)authURL username: (NSString*)uname password: (NSString*)pword
{
    self.authenticationURL = authURL;
    self.username = uname;
    self.password = pword;
    
    isAuthenticated = NO;
}



@end
