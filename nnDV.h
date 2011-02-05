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
    nnkDVDataTypeBool= 1,
    nnkDVDataTypeInt = 2,
    nnkDVDataTypeDouble = 3,
    nnkDVDataTypeString = 4,
//    nnkDVDataTypeObject = 1000, Maybe sometime
};

NSString* nnDVLabelForType(int type);

//
// The protocol for talking between the DV vars and the datastore This might get broken up or 
// Made more friendly to the UI.
//
@protocol nnDVStoreProtocol <NSObject>


-(BOOL)boolForKey:(NSString*)key;
-(void)setBool: (BOOL) b forKey: (NSString*)key;

-(double)doubleForKey:(NSString*)key;
-(void)setDouble: (double) d forKey: (NSString*)key;

-(NSInteger)integerForKey: (NSString*)key;
-(void)setInteger: (NSInteger) i forKey:(NSString*)key;

-(NSString*)stringForKey:(NSString*)key;
-(void)setString: (NSString*)s forKey: (NSString*)key;

-(void) registerDefaults: (NSDictionary*) def;

-(NSInteger) numSamplesForKey: (NSString*) key;

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
    BOOL hold_updates;   // Updates are held until save
}

-(id)init: (NSString*)name withHandler: (id <nnDVStoreProtocol>) handler;
-(int)getDataType;
-(void)notifyUpdate; // Send out the changed message to the delegate

-(void)handleChangeBool: (BOOL)b;
-(void)handleChangeDouble: (double) d;
-(void)handleChangeString: (NSString*) s;
-(void)handleChangeInteger: (NSInteger) i;

-(BOOL)getBool;
-(double)getDouble;
-(NSString*)getString;
-(NSInteger)getInteger;
-(NSInteger)getNumSamples;

-(void)storeBool: (BOOL)b;
-(void)storeDouble: (double) d;
-(void)storeString: (NSString*) s;
-(void)storeInteger: (NSInteger) i;


@property (nonatomic, assign) id <nnDVChangedProtocol> dvChangedDelegate;
@property (nonatomic, retain) id <nnDVStoreProtocol> dvStoreHandler;
@property (nonatomic, retain) NSString* dvVarName;
@end

@interface nnDVBool : nnDVBase @end
@interface nnDVString : nnDVBase @end
@interface nnDVInt : nnDVBase @end
@interface nnDVDouble : nnDVBase @end
@interface nnDVObject : nnDVBase @end

// This is a protocol for UI object derived classes to insure they implement
// methods called by the controllers.
@protocol nnDVUIBaseProtocol
-(void)setup;
-(void)populate;
-(void)save;
-(BOOL)isChanged;
@property (retain, nonatomic) nnDVBase* dvInfo;
@end

