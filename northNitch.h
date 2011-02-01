//
//  northNitch.h
//
//  Created by Brice Tebbs on 5/28/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//


enum nnErrorCodes
{
    nnkNoError = 0,
    nnkTableDataCommunicationError = 100,
    
    nnkEvernoteConnectionFailed = 1000, 
    nnkEvernoteBadCredentials = 1001,
    nnkEvernoteDeleteFailed = 1002,
    nnkEvernoteCreateNoteFailed = 1003,
    nnkEvernoteFetchNoteFailed = 1004,
    nnkEvernoteParseNoteFailed = 1005,
    nnkEvernoteFetchNoteListFailed = 1006,
    nnkEvernoteUpdateNoteFailed = 1005,
    
    nnkSQLiteDBFileError = 1010,
    nnkSQLiteDBOpenError = 1011,
    nnkSQLiteSQLStmtError = 1012,
    nnkSQLiteTableMissing = 1013,
    nnkSQLiteQueryError = 1014,
    nnkSQLiteQueryComplete = 1015,
    
    nnkOALBufferFail = 2000,
    nnkOALSourceFail = 2001,
    nnkOALLoadFail = 2002,
    nnkOALSourceAttachFail = 2003,
    nnkOALBufferAttachFail = 2004
    
};

typedef int nnErrorCode;
BOOL notInPortraitMode();
NSString* nnStringForCGAffineTransform(CGAffineTransform);
NSString* nnEscapeForXML(NSString* string);


NSString* makeUUID();


void nnGetDateInfo(double *timestamp, NSInteger* hours, NSInteger *minutes, NSInteger* seconds, NSInteger* dayOfWeek);

nnErrorCode nnIvarsForObject(NSObject *obj, NSMutableDictionary *results);

#ifdef nnDEBUG_MODE
#define nnDebugLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define nnDebugLog( s, ... ) 
#endif
#define nnLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

