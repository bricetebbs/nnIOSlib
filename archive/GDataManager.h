//
//  GDataManager.h
//  metime
//
//  Created by Brice Tebbs on 7/20/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "nnGDataDocsInterface.h"
#import "nnGDataSpreadsheetInterface.h"
#import "nnDV.h"

#import "Metime.h"

// Would like to move this to an NN class at some point

@protocol GDataManagerDelegate
-(void)updateComplete:(NSError*)error;
-(void)progressMessage:(NSString*)message;
@end

#define  UPLOAD_STACK_SIZE 10

@interface GDataManager : NSObject <nnGDataDocsInterfaceDelegate, nnGDataSpreadsheetInterfaceDelegate> {
    
    NSError* uploadError;
    NSDictionary* dataColumns;
    NSInteger uploadStack[UPLOAD_STACK_SIZE]; 
    NSInteger uploadStackPointer;
    NSDictionary* uploadData;
    NSString* spreadsheetName;
    
    nnGDataSpreadsheetInterface* gDataSpreadsheetInterface;
    nnGDataDocsInterface* gDataDocsInterface;
    
    id <GDataManagerDelegate> delegate;
    id <nnDVStoreProtocol> preferenceManager;  // To make this nn We should really get rid of this somehow
}


@property (nonatomic, assign) id <GDataManagerDelegate> delegate;
@property (nonatomic, assign) id <nnDVStoreProtocol> preferenceManager;


-(nnErrorCode)setupGDataManager: (NSString*)username: (NSString*) password;

//
// Keys are headers values are values
//
-(void)setDataForUpdate:(NSDictionary*)dict;

//
-(void)setNameForSpreadsheet:(NSString *)sheetName;

// Keys must be Sheet Column names like A,B,C  values are Headers

-(void)setSpreadsheetHeaders:(NSDictionary *) dict;

// Send update. Result in callback updateComplete.
-(void)pushUpdate;
-(void)resetFeeds; //Bascially kill all the preferences
@end
