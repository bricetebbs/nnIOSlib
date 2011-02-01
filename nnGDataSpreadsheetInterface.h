//
//  nnGDataSpreadsheetInterface.h
//  metime
//
//  Created by Brice Tebbs on 7/16/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "northNitch.h"
#import "GDataServiceGoogleSpreadsheet.h"
#import "GDataFeedSpreadsheet.h"
#import "GDataEntrySpreadsheet.h"
#import "GDataEntryWorksheet.h"
#import "GDataFeedSpreadsheetList.h"

@protocol nnGDataSpreadsheetInterfaceDelegate
@optional
-(void)rowDataInserted: (NSDictionary*)dict withError: (NSError*)error;
-(void)worksheetCreated:(NSString*) name  withError: (NSError*)error;
-(void)tableCreated:(NSString*)name withRecordFeed: (NSString*)updateURL withError: (NSError*)error;


-(void)foundTableEntry:(NSString*)name withEntryURL:(NSString*)entryURL withRecordFeed: (NSString*) recordURL withError: (NSError*)error;
-(void)foundSpreadsheetEntry:(NSString*) name withEntryURL:(NSString*) entryURL withWorksheetFeed: (NSString*)feedURL andTableFeed: (NSString*)tableURL withError:(NSError*)error;
-(void)foundWorksheetEntry:(NSString*)name withEntryURL:(NSString*) entryURL withListFeed:(NSString*)feedURL withError:(NSError*)error;
@end


@interface nnGDataSpreadsheetInterface : NSObject <nnGDataSpreadsheetInterfaceDelegate> {

    GDataServiceGoogleSpreadsheet* service;
    id <nnGDataSpreadsheetInterfaceDelegate> delegate;
    
}

@property (nonatomic, assign) id <nnGDataSpreadsheetInterfaceDelegate> delegate;

-(nnErrorCode)setupGDataSpreadsheetInterface: (NSString*)username: (NSString*) password;


-(GDataServiceTicket*)createWorksheet: (NSString*) name intoURL:(NSString *)postURL;


-(GDataServiceTicket*)createTable: (NSString*) name withColumns: (NSDictionary*) dict inWorksheet: (NSString*) worksheet usingURL: (NSString*)tableFeed;

    
-(GDataServiceTicket*)getFeedsForSpreadsheet:(NSString*)name;
-(GDataServiceTicket*)getFeedsForTable:(NSString *)name inFeed: (NSString*) tableFeed;
-(GDataServiceTicket*)getFeedsForWorksheet:(NSString*)name inFeed: (NSString*) worksheetFeed;


// Headers in sheet must match dict keys
-(GDataServiceTicket*)insertRowData:(NSDictionary*)dict intoURL: (NSString*)postURL;

@end
