//
//  nnDV.m
//  glogger
//
//  Created by Brice Tebbs on 2/2/11.
//  Copyright 2011 northNitch Studios Inc. All rights reserved.
//

#import "nnDV.h"

NSString* const nnkDVDataTypeLabelBool =@"bool";
NSString* const nnkDVDataTypeLabelDouble = @"double";
NSString* const nnkDVDataTypeLabelInt = @"int";
NSString* const nnkDVDataTypeLabelString = @"string";


NSString* const nnkDVDataTypeLabelUnknown = @"unknown";

NSString* nnDVLabelForType(int type)
{
    if(type == nnkDVDataTypeBool)
        return nnkDVDataTypeLabelBool;
    if(type == nnkDVDataTypeInt)
        return nnkDVDataTypeLabelInt;
    if(type == nnkDVDataTypeDouble)
        return nnkDVDataTypeLabelDouble;
    if(type == nnkDVDataTypeString)
        return nnkDVDataTypeLabelString;
     return nnkDVDataTypeLabelUnknown;
}


@implementation nnDVBase

@synthesize dvStoreHandler;
@synthesize dvTag;
@synthesize dvChangedDelegate;
@synthesize dvHoldUpdates;

-(void)dealloc
{
    [dvTag release];
    [dvStoreHandler release];
    [super dealloc];
}

-(id)init: (NSString*)name withHandler: (id <nnDVStoreProtocol>) hdnlr
{
    self = [super init];
    if (self)
    {
        self.dvTag = name;
        self.dvStoreHandler = hdnlr;
    }
    return self;
}

-(int)getDataType { return 0;}



-(BOOL)matchesTag: (NSObject*)o
{
    return [self.dvTag isEqual: o];
}

-(void)notifyUpdate
{
    [self.dvChangedDelegate valueUpdated: self];
}

-(void)handleChangeBool: (BOOL) b
{
    if(!dvHoldUpdates)
    {
        [self storeBool: b];
    }
}

-(void)handleChangeDouble: (double) d
{
    if(!dvHoldUpdates)
    {
        [self storeDouble: d];
    }
}

-(void)handleChangeString: (NSString*) s
{
    if(!dvHoldUpdates)
    {
        [self storeString: s];
    }
}

-(void)handleChangeInteger: (NSInteger) i
{
    if(!dvHoldUpdates)
    {
        [self storeInteger: i];
    }
}

-(void)storeBool: (BOOL) b
{
    [self.dvStoreHandler setBool: b forKey: self.dvTag];
    [self notifyUpdate];
}

-(void)storeDouble: (double) d
{
    [self.dvStoreHandler setDouble: d forKey: self.dvTag];
    [self notifyUpdate];
}

-(void)storeString: (NSString*) s
{
    [self.dvStoreHandler setString: s forKey: self.dvTag];
    [self notifyUpdate];
}

-(void)storeInteger: (NSInteger) i
{
    [self.dvStoreHandler setInteger: i forKey: self.dvTag];
    [self notifyUpdate];
}


-(BOOL)getBool
{
    return [self.dvStoreHandler boolForKey: self.dvTag];
}
-(double)getDouble
{
    return [self.dvStoreHandler doubleForKey: self.dvTag];
}
-(NSString*)getString
{
    return [self.dvStoreHandler stringForKey: self.dvTag];
}
-(NSInteger)getInteger
{
    return [self.dvStoreHandler integerForKey: self.dvTag];
}

-(NSInteger)getNumSamples
{
    return [self.dvStoreHandler numSamplesForKey: self.dvTag];
}

@end


@implementation nnDVDouble
-(int)getDataType { return nnkDVDataTypeDouble; }
@end


@implementation nnDVString
-(int)getDataType { return nnkDVDataTypeString; }
@end


@implementation nnDVBool
-(int)getDataType { return nnkDVDataTypeBool; }
@end


@implementation nnDVInt
-(int)getDataType { return nnkDVDataTypeInt; }
@end





