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


-(BOOL)boolForKey:(NSObject*)key;
-(void)setBool: (BOOL) b forKey: (NSObject*)key;

-(double)doubleForKey:(NSObject*)key;
-(void)setDouble: (double) d forKey: (NSObject*)key;

-(NSInteger)integerForKey: (NSObject*)key;
-(void)setInteger: (NSInteger) i forKey:(NSObject*)key;

-(NSString*)stringForKey:(NSObject*)key;
-(void)setString: (NSString*)s forKey: (NSObject*)key;

-(NSInteger) numSamplesForKey: (NSObject*) key;


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
    NSObject* dvTag;
    id <nnDVStoreProtocol> dvStoreHandler;
    id <nnDVChangedProtocol> dvChangedDelegate;
    BOOL dvHoldUpdates;   // Updates are held until save
}

-(id)init: (NSObject*)name withHandler: (id <nnDVStoreProtocol>) handler;
-(int)getDataType;
-(void)notifyUpdate; // Send out the changed message to the delegate


-(BOOL)matchesTag: (NSObject*)o;

//Helpers for user classes
-(void)handleChangeBool: (BOOL)b;
-(void)handleChangeDouble: (double) d;
-(void)handleChangeString: (NSString*) s;
-(void)handleChangeInteger: (NSInteger) i;


-(BOOL)getBool;
-(double)getDouble;
-(NSString*)getString;
-(NSInteger)getInteger;

// THis is used for a nnDVStoreProtocol which counts the changes/records
-(NSInteger)getNumSamples;

-(void)storeBool: (BOOL)b;
-(void)storeDouble: (double) d;
-(void)storeString: (NSString*) s;
-(void)storeInteger: (NSInteger) i;


@property (nonatomic, assign) id <nnDVChangedProtocol> dvChangedDelegate;
@property (nonatomic, retain) id <nnDVStoreProtocol> dvStoreHandler;
@property (nonatomic, retain) NSObject* dvTag;
@property (nonatomic, assign) BOOL dvHoldUpdates;
@end

@interface nnDVBool : nnDVBase @end
@interface nnDVString : nnDVBase @end
@interface nnDVInt : nnDVBase @end
@interface nnDVDouble : nnDVBase @end
@interface nnDVObject : nnDVBase @end

// This is a protocol for UI object derived classes to insure they implement
// methods called by the controllers.
@protocol nnDVUIBaseProtocol
-(void)populate;  // Load the UI element from the DV
-(void)save;      // Save what is in the DV to the UI Element
-(BOOL)isChanged; // Does the UI element differ from the DV Value
@property (retain, nonatomic) nnDVBase* dvInfo;
@end

