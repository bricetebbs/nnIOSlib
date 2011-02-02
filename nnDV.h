//
//  nnDV.h
//
//  A simple protocol for storing values.
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


// DV Types
enum 
{
    nnkDVDataTypeObject = 1,
    nnkDVDataTypeBool   = 2,
    nnkDVDataTypeDouble = 3,
    nnkDVDataTypeString = 4,
};


//
// The protocol for talking between the DV vars and the datastore
//
@protocol nnDVStoreProtocol <NSObject>

-(NSObject*)objectForKey:(NSString*)key;
-(void)setObject: id forKey: (NSString*)key;

-(BOOL)boolForKey:(NSString*)key;
-(void)setBool: (BOOL) b forKey: (NSString*)key;

-(double)doubleForKey:(NSString*)key;
-(void)setDouble: (double) d forKey: (NSString*)key;

-(NSString*)stringForKey:(NSString*)key;
-(void)setString: (NSString*)s forKey: (NSString*)key;

-(void) registerDefaults: (NSDictionary*) def;

// Some functions to specify records?
@end



// Protocol for listeners for changes
@class nnDVBase;
@protocol nnDVChangedProtocol 
-(void)valueUpdated: (nnDVBase*) element;
@end

// "Abstract" Base class for DV Vars
@interface nnDVBase : NSObject
{
    NSString* dvVarName;
    id <nnDVStoreProtocol> dvStoreHandler;
    id <nnDVChangedProtocol> dvChangedDelegate;
}
-(id)init: (NSString*)name withHandler: (id <nnDVStoreProtocol>) handler;
-(int)getDataType;

@property (nonatomic, assign) id <nnDVChangedProtocol> dvChangedDelegate;
@property (nonatomic, retain) id <nnDVStoreProtocol> dvStoreHandler;
@property (nonatomic, retain) NSString* dvVarName;
@end

@interface nnDVBool : nnDVBase @end
@interface nnDVString : nnDVBase @end
@interface nnDVDouble : nnDVBase @end
@interface nnDVObject : nnDVBase @end

// This is a protocol for UI object derived classes to insure they implement
// methods called by the controllers.
@protocol nnDVUIBaseProtocol
-(void)setup;
-(void)populate;
-(void)save;
@property (retain, nonatomic) nnDVBase* dvInfo;
@end