//
//  nnGDataSpreadsheetInterface.m
//  metime
//
//  Created by Brice Tebbs on 7/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnGDataSpreadsheetInterface.h"
#import "GDataFeedWorksheet.h"
#import "GDataEntrySpreadsheetList.h"
#import "GDataSpreadsheetCustomElement.h"
#import "GDataFeedSpreadsheetList.h"
#import "GDataEntrySpreadsheetTable.h"
#import "GDataSpreadsheetData.h"
#import "GDataEntrySpreadsheetRecord.h"
#import "GDataSpreadsheetField.h"
#import "GDataSpreadsheetColumn.h"
#import "GDataServiceGoogleDocs.h"


@interface nnGDataSpreadsheetInterface () 

@property (nonatomic, retain) GDataServiceGoogleSpreadsheet* service;

@end


@implementation nnGDataSpreadsheetInterface
@synthesize service;
@synthesize delegate;


-(void)dealloc
{
    [self.service release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Setup 
-(nnErrorCode)setupGDataSpreadsheetInterface:(NSString *)username :(NSString *)password
{
    self.service = [[GDataServiceGoogleSpreadsheet  alloc] init];
    
    [self.service setUserCredentialsWithUsername:username
                                   password:password];
    
    // Maybe [service setShouldServiceFeedsIgnoreUnknowns:YES];
    [service setServiceShouldFollowNextLinks:YES];
    [service setIsServiceRetryEnabled:YES]; 
    
    return nnkNoError;
}



#pragma mark -
#pragma mark Insert Row 


-(void)insertRowWorker:(GDataServiceTicket*) ticket finishedWithEntry: (GDataEntrySpreadsheetRecord*) entry error: (NSError*)err
{
    [delegate rowDataInserted: ticket.userData withError: err];
}

-(GDataServiceTicket*)insertRowData:(NSDictionary *)dict intoURL:(NSString *)postURL
{
    GDataEntrySpreadsheetRecord *record = [GDataEntrySpreadsheetRecord recordEntry ]; 
    
    NSString* key;
    for (key in dict) 
    {
        GDataSpreadsheetField *obj = [GDataSpreadsheetField fieldWithName: key value:[dict valueForKey:key]];
        [record addField: obj];
    }
    
    [record setTitleWithString:@"record"];
    
    nnDebugLog(@"posting with %@",postURL);
    NSURL *feedURL = [NSURL URLWithString:postURL];
    
    
    [service setServiceUserData: dict];

    GDataServiceTicket* ticket = [self.service fetchEntryByInsertingEntry:record 
                                                               forFeedURL: feedURL 
                                                                 delegate:self 
                                                        didFinishSelector:@selector (insertRowWorker:finishedWithEntry:error:)]; 
    
    return ticket;
}



#pragma mark -
#pragma mark Worksheet
- (void)getWorksheetWorker:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedWorksheet *)feed
                     error:(NSError *)error 
{
    GDataEntryWorksheet* foundWorksheet = nil;
    if (error == nil) {  
        for (GDataEntryWorksheet *entry in [feed entries]) 
        {
            NSString *name = [[entry title] stringValue];
            nnDebugLog(@"Sheet is %@",name);
            if ([name isEqualToString: ticket.userData])
            {
                foundWorksheet = entry;
                NSLog(@"found worksheet's title: %@", name);
                break;
            }
        }
    }
    
    [delegate foundWorksheetEntry: ticket.userData
                     withEntryURL:[[foundWorksheet selfLink] href] 
                     withListFeed:[[foundWorksheet listFeedURL] absoluteString]  
                        withError:error];
    
}


-(GDataServiceTicket*)getFeedsForWorksheet:(NSString*)name inFeed: (NSString*) worksheetFeed
{
    NSURL *feedURL = [NSURL URLWithString:worksheetFeed];
    
    
    [service setServiceUserData: name];
    GDataServiceTicket* ticket = [self.service fetchFeedWithURL:feedURL
                          delegate:self
                 didFinishSelector:@selector(getWorksheetWorker:finishedWithFeed:error:)];
    
    return ticket;
}


-(void)createWorksheetWorker:(GDataServiceTicket*) ticket finishedWithEntry: (GDataEntryWorksheet*) entry error: (NSError*)err
{
    [delegate worksheetCreated: ticket.userData withError: err];
}


-(GDataServiceTicket*)createWorksheet: (NSString*)name  intoURL:(NSString *)postURL
{
    
    GDataEntryWorksheet *worksheet = [GDataEntryWorksheet worksheetEntry]; 
    
    [worksheet setTitleWithString:name];
    [worksheet setColumnCount:5];
    [worksheet setRowCount:10];
    
    NSURL *feedURL = [NSURL URLWithString:postURL];
    
    
    [service setServiceUserData: name];
    
    GDataServiceTicket* ticket = [self.service fetchEntryByInsertingEntry:worksheet 
                                                               forFeedURL: feedURL 
                                                                 delegate:self 
                                                        didFinishSelector:@selector (createWorksheetWorker:finishedWithEntry:error:)]; 
    
    
    return ticket;
}



#pragma mark -
#pragma mark Table
- (void)getTableWorker:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedWorksheet *)feed
                     error:(NSError *)error 
{
    GDataEntrySpreadsheetTable* foundTable = nil;
    if (error == nil) {  
        for (GDataEntrySpreadsheetTable *entry in [feed entries]) 
        {
            NSString *name = [[entry title] stringValue];
            if ([name isEqualToString: ticket.userData])
            {
                foundTable = entry;
                NSLog(@"found table  title: %@", name);
                break;
            }
        }
    }
    
    [delegate foundTableEntry: ticket.userData
                 withEntryURL:[[foundTable selfLink] href] 
               withRecordFeed:[[foundTable recordFeedURL] absoluteString]  
                    withError:error];
    
}


-(GDataServiceTicket*)getFeedsForTable:(NSString*)name inFeed: (NSString*) tableFeed
{
    NSURL *feedURL = [NSURL URLWithString:tableFeed];
    
    [service setServiceUserData: name];
    GDataServiceTicket* ticket = [self.service fetchFeedWithURL:feedURL
                                                       delegate:self
                                              didFinishSelector:@selector(getTableWorker:finishedWithFeed:error:)];
    
    return ticket;
}


-(void)addTableWorker:(GDataServiceTicket*) ticket finishedWithEntry: (GDataEntrySpreadsheetTable*) entry error: (NSError*)error
{
    nnDebugLog(@"Table created entry =%@\nFeed=%@error=%@",entry, [[entry postLink] href],error);
    
    [delegate tableCreated: ticket.userData withRecordFeed:[[entry recordFeedURL] absoluteString] withError:error];
}

-( GDataServiceTicket*)createTable: (NSString*) name withColumns: (NSDictionary*) dict inWorksheet: (NSString*) worksheet usingURL: (NSString*)tableFeed
{
    NSURL *postURL = [NSURL URLWithString:tableFeed];
    
    
    GDataEntrySpreadsheetTable *newTable = [GDataEntrySpreadsheetTable tableEntry];
    GDataSpreadsheetData *headers = [GDataSpreadsheetData spreadsheetDataWithStartIndex:2 numberOfRows:0 insertionMode:kGDataSpreadsheetModeInsert];
    
    
    for (NSString* key in dict) 
    {
        [headers addColumn:[GDataSpreadsheetColumn columnWithIndexString:key name: [dict valueForKey:key]]];
    }
    
        
    [newTable setSpreadsheetHeaderWithRow:1];
    [newTable setSpreadsheetData:headers];
    [newTable setWorksheetNameWithString:worksheet];
    [newTable setTitleWithString:name];

    GDataServiceTicket *ticket;
    
    [service setServiceUserData: name];

    ticket = [self.service fetchEntryByInsertingEntry:newTable
                                                 forFeedURL:postURL delegate:self
                                          didFinishSelector:@selector(addTableWorker:finishedWithEntry:error:)]; 
    
    
    return ticket;
}



#pragma mark -
#pragma mark Spreadsheet


- (void)getSpreadsheetWorker:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedSpreadsheet *)feed error:(NSError *)error
{
    GDataEntrySpreadsheet* foundSheet = nil;
    
    if (error == nil) {  
        for (GDataEntrySpreadsheet *entry in [feed entries]) 
        {
            NSString *name = [[entry title] stringValue];
            if ([name isEqualToString: ticket.userData])
            {
                foundSheet = entry;
                break;
            }
        }
    }
    
    [self.delegate foundSpreadsheetEntry: ticket.userData
                            withEntryURL: [[foundSheet selfLink] href] 
                       withWorksheetFeed: [[foundSheet worksheetsFeedURL] absoluteString] 
                            andTableFeed: [[[foundSheet tablesFeedLink] URL] absoluteString]
                               withError: error];

    
}

-( GDataServiceTicket*)getFeedsForSpreadsheet:(NSString*)name;
{
    NSURL *feedURL = [NSURL URLWithString:kGDataGoogleSpreadsheetsPrivateFullFeed];
    
    
    
    [service setServiceUserData: name];
    GDataServiceTicket* ticket = [self.service fetchFeedWithURL:feedURL
                          delegate:self
                 didFinishSelector:@selector(getSpreadsheetWorker:finishedWithFeed:error:)];
    
    return ticket;
    
    
}

@end
