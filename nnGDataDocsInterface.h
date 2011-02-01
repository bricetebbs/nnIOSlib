//
//  nnGDataDocsInterface.h
//  metime
//
//  Created by Brice Tebbs on 7/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "northNitch.h"
#import "GDataFeedDocList.h"
#import "GDataServiceGoogleDocs.h"

@protocol nnGDataDocsInterfaceDelegate
@optional
-(void)foundUploadFeed: (NSString*)feed withError: (NSError*)error;
-(void)spreadsheetCreated: (NSString*)name withError: (NSError*)error;
@end

@interface nnGDataDocsInterface : NSObject
{
    GDataServiceGoogleDocs* service;
    id <nnGDataDocsInterfaceDelegate> delegate;
}

-(nnErrorCode)setupGDataDocsInterface: (NSString*)username: (NSString*) password;

-(GDataServiceTicket*)getUploadFeed;

-(GDataServiceTicket*)createSpreadsheet:(NSString*)name  usingUploadFeed: (NSString*)docFeed;

@property (nonatomic, assign) id <nnGDataDocsInterfaceDelegate> delegate;

@end
