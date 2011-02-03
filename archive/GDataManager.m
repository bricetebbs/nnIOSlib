//
//  GDataManager.m
//  metime
//
//  Created by Brice Tebbs on 7/20/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "GDataManager.h"

@interface GDataManager ()

-(void)processUploadStack;

@property (nonatomic, retain) NSDictionary* uploadData;
@property (nonatomic, retain) nnGDataSpreadsheetInterface* gDataSpreadsheetInterface;
@property (nonatomic, retain) nnGDataDocsInterface* gDataDocsInterface;
@property (nonatomic, retain) NSError* uploadError;
@property (nonatomic, retain) NSDictionary* dataColumns;
@property (nonatomic, retain) NSString* spreadsheetName;
@end


@implementation GDataManager

@synthesize uploadData;
@synthesize gDataSpreadsheetInterface;
@synthesize gDataDocsInterface;
@synthesize uploadError;
@synthesize dataColumns;
@synthesize preferenceManager;
@synthesize delegate;
@synthesize spreadsheetName;


-(void)dealloc
{
    [uploadData release];
    [gDataSpreadsheetInterface release];
    [gDataDocsInterface release];
    [uploadError release];
    [dataColumns release];
    [spreadsheetName release];
    [super dealloc];
}


-(nnErrorCode)setupGDataManager: (NSString*)username: (NSString*) password
{
    gDataSpreadsheetInterface = [[nnGDataSpreadsheetInterface alloc] init];
    [gDataSpreadsheetInterface setupGDataSpreadsheetInterface: username : password];
    gDataSpreadsheetInterface.delegate = self;
    
    gDataDocsInterface = [[nnGDataDocsInterface alloc] init];
    [gDataDocsInterface setupGDataDocsInterface:userame:password];
    gDataDocsInterface.delegate= self;
    
    uploadStackPointer = 0;
    self.spreadsheetName = DEFAULT_SPREADSHEET_NAME;
    
  //  [GDataHTTPFetcher setIsLoggingEnabled:YES];
    return nnkNoError;
}


-(void)resetFeeds
{
    [preferenceManager setString:@"" forKey:PREF_SPREADSHEET_WORKSHEET_FEED];
    [preferenceManager setString:@"" forKey:PREF_SPREADSHEET_TABLE_FEED];
    [preferenceManager setString:@"" forKey:PREF_TABLE_RECORD_FEED];
    [preferenceManager setString:@"" forKey:PREF_DOCLIST_UPLOAD_FEED];
}

-(void)setNameForSpreadsheet:(NSString *)name;
{
    self.spreadsheetName = name;
}
-(void)setSpreadsheetHeaders:(NSDictionary *)dict;
{
    self.dataColumns = dict;
}

-(void)setDataForUpdate:(NSDictionary *)dict
{
    self.uploadData = dict;
}


-(NSInteger)topOfUploadStack
{
    if (uploadStackPointer > 0) {
        return uploadStack[uploadStackPointer-1];
    }
    else {
        return -1;
    }
    
}

-(NSInteger)popUploadStack
{
    if (uploadStackPointer > 0) {
        return uploadStack[--uploadStackPointer];
    }
    else
    {
        return -1;
    }
}

-(void)pushUploadStack: (NSInteger)state
{
    if (uploadStackPointer < UPLOAD_STACK_SIZE) {
        uploadStack[uploadStackPointer++] = state;
    }
}

enum UploadStates {
    
    kStateNeedsToUploadData = 1,
    kStateNeedsSpreadsheetTableFeed = 2,
    kStateNeedsTableRecordFeed = 3,
    kStateNeedsToCreateTable = 4,
    kStateNeedsWorksheet = 5,
    kStateNeedsSpreadsheetWorksheetFeed = 6,
    kStateNeedsToCreateWorksheet = 7,
    kStateNeedsToCreateSpreadsheet = 8,
    kStateNeedsDocListUploadFeed = 9,
    kStateNeedsToReturnError= 10,
};


#pragma mark CallBacks

-(void)foundUploadFeed: (NSString*)feed withError: (NSError*)error
{
    nnDebugLog(@"Found Upload Feed =%@ \nError=%@",feed,error);
    NSAssert([self topOfUploadStack] == kStateNeedsDocListUploadFeed, @"Not in state we thought we were.");
    [preferenceManager setString: feed forKey: PREF_DOCLIST_UPLOAD_FEED];
    [self popUploadStack];
    [self processUploadStack];
    
}
-(void)spreadsheetCreated: (NSString*)name withError: (NSError*)error
{
    nnDebugLog(@"SpreadSheetCreated =%@\nError=%@",name,error);
    
    NSAssert([self topOfUploadStack] == kStateNeedsToCreateSpreadsheet, @"Not in state we thought we were.");
    [self popUploadStack];
    [self processUploadStack];
}


-(void)tableCreated:(NSString*)name withRecordFeed: (NSString*)updateURL withError: (NSError*)error;
{
    nnDebugLog(@"tableCreated =%@\nFeed=%@Error=%@",name,updateURL, error);
    
    
    NSAssert([self topOfUploadStack] == kStateNeedsToCreateTable, @"Not in state we thought we were.");
    
    [self popUploadStack];
    [self processUploadStack];
}


-(void)worksheetCreated: (NSString*)name withError: (NSError*)error
{
    nnDebugLog(@"WorksheetCreated =%@\nError=%@",name,error);
    
    NSAssert([self topOfUploadStack] == kStateNeedsToCreateWorksheet, @"Not in state we thought we were.");
    [self popUploadStack];
    [self processUploadStack];
}



-(void)foundSpreadsheetEntry:(NSString*) name withEntryURL: (NSString*) entryURL withWorksheetFeed: (NSString*) feedURL andTableFeed: (NSString*)tableURL withError:(NSError*)error;
{
    nnDebugLog(@"FeedURL for SpreadSheet=%@ Entry=%@\nForWorkSheets=%@\nForTables=%@\nError=%@",name, entryURL,feedURL, tableURL,error);
   // NSAssert([self topOfUploadStack] == kStateNeedsSpreadsheetWorksheetFeed, @"Not in state we thought we were.");
    if([entryURL length] < 1) // We need to create the sheet
    {
        [self pushUploadStack:kStateNeedsToCreateSpreadsheet];
        [self processUploadStack];
        return;
    }
    // Else Store the key
    [preferenceManager setString: feedURL forKey: PREF_SPREADSHEET_WORKSHEET_FEED];
    [preferenceManager setString: tableURL forKey: PREF_SPREADSHEET_TABLE_FEED];
    
    
    [self popUploadStack];
    [self processUploadStack];
}


-(void)foundWorksheetEntry:(NSString*) name withEntryURL: entryURL withListFeed:(NSString*)feedURL withError:(NSError*)error
{
    nnDebugLog(@"ListURL for Worksheet=%@ feed=%@",name, feedURL);
    
    NSAssert([self topOfUploadStack] == kStateNeedsSpreadsheetTableFeed, @"Not in state we thought we were.");
    if([entryURL length] < 1) // We need to create the sheet
    {
        [self pushUploadStack:kStateNeedsToCreateWorksheet];
        [self processUploadStack];
        return;
    }
    [self popUploadStack];
    [self processUploadStack];
}

-(void)foundTableEntry:(NSString*) name withEntryURL: entryURL withRecordFeed:(NSString*)feedURL withError:(NSError*)error
{
    nnDebugLog(@"Record Feed for Table=%@ feed=%@",name, feedURL);
    
    NSAssert([self topOfUploadStack] == kStateNeedsTableRecordFeed, @"Not in state we thought we were.");
    if([entryURL length] < 1) // We need to create the table
    {
        [self pushUploadStack:kStateNeedsToCreateTable];
        [self processUploadStack];
        return;
    }
    
    [preferenceManager setString: feedURL forKey: PREF_TABLE_RECORD_FEED];
    [self popUploadStack];
    [self processUploadStack];
}


-(void)rowDataInserted: (NSDictionary*)dict withError: (NSError*)error
{
    if (error) 
    {
        nnDebugLog(@"row insert Error=%@",error);
        self.uploadError = error;
        [self pushUploadStack:kStateNeedsToReturnError];
        [self processUploadStack];
        return;
    }
    
    NSAssert([self topOfUploadStack] == kStateNeedsToUploadData, @"Not in state we thought we were.");
    [self popUploadStack];
    [self processUploadStack];
}

#pragma mark Upload

-(void)processUploadStack
{
    NSInteger uploadState = [self topOfUploadStack];
    
    if (uploadState == -1) {
        [delegate updateComplete: nil];
        return;
    }
    [delegate progressMessage: [NSString stringWithFormat:@"Processing Stack State=%d",uploadState]];
    
    
    if(uploadState == kStateNeedsToUploadData)
    {
        NSString* feedURL = [preferenceManager stringForKey: PREF_TABLE_RECORD_FEED];
        if (![feedURL length])
        {
            [self pushUploadStack: kStateNeedsTableRecordFeed];
            [self processUploadStack];
        }
        else
        {
            [gDataSpreadsheetInterface insertRowData: uploadData intoURL:feedURL]; 
        }
    }
    if(uploadState == kStateNeedsTableRecordFeed)
    {
        NSString* feedURL = [preferenceManager stringForKey: PREF_SPREADSHEET_TABLE_FEED];
        if (![feedURL length])
        {
            [self pushUploadStack: kStateNeedsSpreadsheetTableFeed];
            [self processUploadStack];
        }
        else
        {
            [gDataSpreadsheetInterface getFeedsForTable:DEFAULT_TABLE_NAME inFeed:feedURL];
        }
    }
    else if (uploadState == kStateNeedsToCreateTable)
    {
        NSString* feedURL = [preferenceManager stringForKey: PREF_SPREADSHEET_TABLE_FEED];
        if (![feedURL length])
        {
            [self pushUploadStack: kStateNeedsSpreadsheetTableFeed];
            [self processUploadStack];
        }
        else
        {
            [gDataSpreadsheetInterface createTable:DEFAULT_TABLE_NAME withColumns:dataColumns inWorksheet:DEFAULT_WORKSHEET_NAME usingURL:feedURL];
        }
        
    }
    else if (uploadState == kStateNeedsSpreadsheetTableFeed) 
    {
        [gDataSpreadsheetInterface getFeedsForSpreadsheet:self.spreadsheetName]; 
    }
    else if (uploadState == kStateNeedsWorksheet)
    {
        
        NSString* feedURL = [preferenceManager stringForKey: PREF_SPREADSHEET_WORKSHEET_FEED];
        if (![feedURL length])
        {
            [self pushUploadStack: kStateNeedsSpreadsheetWorksheetFeed ];
            [self processUploadStack];
        }
        [gDataSpreadsheetInterface createWorksheet:DEFAULT_WORKSHEET_NAME intoURL: feedURL];
    }

    else if (uploadState == kStateNeedsSpreadsheetWorksheetFeed) 
    {   
        [gDataSpreadsheetInterface getFeedsForSpreadsheet:self.spreadsheetName]; 
    }
    else if (uploadState == kStateNeedsToCreateWorksheet) 
    {
        NSString* feedURL = [preferenceManager stringForKey: PREF_SPREADSHEET_WORKSHEET_FEED];
        if (![feedURL length])
        {
            [self pushUploadStack: kStateNeedsSpreadsheetWorksheetFeed ];
            [self processUploadStack];
        }
        else 
        {
            [gDataSpreadsheetInterface createWorksheet:DEFAULT_WORKSHEET_NAME intoURL: feedURL];
        }
    }
    else if (uploadState == kStateNeedsToCreateSpreadsheet) 
    {
        NSString* feedURL = [preferenceManager stringForKey: PREF_DOCLIST_UPLOAD_FEED];
        if (![feedURL length])
        {
            [self pushUploadStack: kStateNeedsDocListUploadFeed];
            [self processUploadStack];
        }
        else 
        {
            [gDataDocsInterface createSpreadsheet:self.spreadsheetName usingUploadFeed:feedURL];
        }
    }
    else if(uploadState == kStateNeedsDocListUploadFeed)
    {
        [gDataDocsInterface getUploadFeed];
    }
    else if(uploadState == kStateNeedsToReturnError)
    {
        uploadStackPointer = 0;
        [delegate updateComplete: uploadError];
    }
}

-(void)pushUpdate
{
    [self pushUploadStack: kStateNeedsToUploadData];
    [self processUploadStack];
}


@end
