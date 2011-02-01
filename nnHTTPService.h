//
//  nnHTTPService.h
//  
//  THis is a wrapper around ASIHttp to be a base class for talking to a service
//  Designed to work with a django server for authentication etc.
//
//  Created by Brice Tebbs on 8/11/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASIFormDataRequest;
@class ASIHTTPRequest;



// Get the response from the service.
@protocol nnHTTPServiceDelegate
-(void)serviceResponse: (NSObject*)response forTag: (NSString*)tag withError: (NSError*) error;
@end

@interface nnHTTPService : NSObject {
    
	ASIFormDataRequest *request;
    id <nnHTTPServiceDelegate> delegate;
    
    
	ASIHTTPRequest *failedRequest;
    NSDictionary* lastPostData;
    
    NSString* serverString;  // The full address of the server
    
    // Keep the authentication info around in case we need to re-auth
    NSString* username;
    NSString* password;
    NSString* authenticationURL;
    
    BOOL isAuthenticated;
}

-(id)initWithServerString: (NSString*)server;

// Initialize the stored authentication info
-(void)setAuthenticationCredentials: (NSString*)authURL username: (NSString*)uname password: (NSString*)pword;

// Post the credentials to the authURL
-(void)checkAuthenticationCredentials: (NSString*)authURL username: (NSString*)uname password: (NSString*)pword;

// Submit a post request
// This function will detect if authentication needs to happen (looks for a redirect to "/login/?next
// If this happens it will (re)authenticate with the server and rety the post.
-(void)submitPostRequest: (NSString*)url withData: (NSDictionary*) data andTag: (NSString*) tag;


// Probably we also need this
//-(void)submitGetRequest: (NSString*)url andTag: (NSString*) tag;




// To Override in subclasses
// The default will call the serviceResponse Delegate . For more custom handling override this method
-(void) processResponse:(NSObject*) response forRequest: (ASIHTTPRequest *)theRequest;


// The default response delegate to call
@property (nonatomic, assign) id <nnHTTPServiceDelegate> delegate;

@end
