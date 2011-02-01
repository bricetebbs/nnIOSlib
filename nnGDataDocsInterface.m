//
//  nnGDataDocsInterface.m
//  metime
//
//  Created by Brice Tebbs on 7/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnGDataDocsInterface.h"
#import "GDataServiceGoogleDocs.h"
#import "GDataQueryDocs.h"
#import "GDataEntrySpreadsheetDoc.h"

@interface nnGDataDocsInterface () 
@property (nonatomic, retain) GDataServiceGoogleDocs* service;
@end

@implementation nnGDataDocsInterface
@synthesize service;
@synthesize delegate;


- (void)dealloc {
    [service release];    
    [super dealloc];
}


-(nnErrorCode)setupGDataDocsInterface: (NSString*)username: (NSString*) password
{
    self.service = [[GDataServiceGoogleDocs  alloc] init];
//    [service setServiceShouldFollowNextLinks:YES];
  //  [service setIsServiceRetryEnabled:YES]; 
   // Maybe  [service setShouldServiceFeedsIgnoreUnknowns:YES];
    [self.service setUserCredentialsWithUsername:username
                                        password:password];
    return nnkNoError;
}




// docList list fetch callback
- (void)uploadFeedFetch:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedDocList *)feed
                     error:(NSError *)error 
{
    [delegate foundUploadFeed: [[feed uploadLink] href] withError:error];
}



-(GDataServiceTicket*)getUploadFeed
{
    nnDebugLog(@"In get Upload Feed");
    NSURL *feedURL = [GDataServiceGoogleDocs docsFeedURL];

    GDataQueryDocs *query = [GDataQueryDocs documentQueryWithFeedURL:feedURL];
    [query setMaxResults:1000];
    [query setShouldShowFolders:YES];

    
    [service setServiceUserData: nil];
    
    GDataServiceTicket* ticket = [self.service fetchFeedWithQuery:query
                            delegate:self
                   didFinishSelector:@selector(uploadFeedFetch:finishedWithFeed:error:)];
    return ticket;
}


- (void)createSpreadsheetWorker:(GDataServiceTicket *)ticket
              finishedWithEntry:(GDataEntrySpreadsheetDoc *)entry
                          error:(NSError *)error {
    NSLog(@"new spreadsheet entry: %@ \nerror:%@", entry, error);
    
    [delegate spreadsheetCreated: ticket.userData withError:error];
}


-(GDataServiceTicket*)createSpreadsheet:(NSString*)name usingUploadFeed: docFeed
{

    NSString *columns = @",,,";
    
    
    NSData *data = [columns dataUsingEncoding:NSUTF8StringEncoding];
    
    GDataEntrySpreadsheetDoc *newEntry = [GDataEntrySpreadsheetDoc documentEntry];
    [newEntry setTitleWithString:name];
    [newEntry setUploadData:data];
    [newEntry setUploadMIMEType:@"text/csv"];
    [newEntry setUploadSlug: [NSString stringWithFormat:@"%@.csv", name]];
    
    NSURL *postURL =[NSURL URLWithString:docFeed];
    
    [service setServiceUserData: name];
    
    GDataServiceTicket* ticket = [self.service fetchEntryByInsertingEntry:newEntry
                                                              forFeedURL:postURL
                                                                    delegate:self
                      didFinishSelector:@selector(createSpreadsheetWorker:finishedWithEntry:error:)];
    
    
    return ticket;
}



@end
