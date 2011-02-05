//
//  nnDV.m
//  glogger
//
//  Created by Brice Tebbs on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
@synthesize dvVarName;
@synthesize dvChangedDelegate;
@synthesize dvHoldUpdates;

-(void)dealloc
{
    [dvVarName release];
    [dvStoreHandler release];
    [super dealloc];
}

-(id)init: (NSString*)name withHandler: (id <nnDVStoreProtocol>) hdnlr
{
    self = [super init];
    if (self)
    {
        self.dvVarName = name;
        self.dvStoreHandler = hdnlr;
    }
    return self;
}

-(int)getDataType { return 0;}

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
    [self.dvStoreHandler setBool: b forKey: self.dvVarName];
    [self notifyUpdate];
}

-(void)storeDouble: (double) d
{
    [self.dvStoreHandler setDouble: d forKey: self.dvVarName];
    [self notifyUpdate];
}

-(void)storeString: (NSString*) s
{
    [self.dvStoreHandler setString: s forKey: self.dvVarName];
    [self notifyUpdate];
}

-(void)storeInteger: (NSInteger) i
{
    [self.dvStoreHandler setInteger: i forKey: self.dvVarName];
    [self notifyUpdate];
}


-(BOOL)getBool
{
    return [self.dvStoreHandler boolForKey: self.dvVarName];
}
-(double)getDouble
{
    return [self.dvStoreHandler doubleForKey: self.dvVarName];
}
-(NSString*)getString
{
    return [self.dvStoreHandler stringForKey: self.dvVarName];
}
-(NSInteger)getInteger
{
    return [self.dvStoreHandler integerForKey: self.dvVarName];
}

-(NSInteger)getNumSamples
{
    return [self.dvStoreHandler numSamplesForKey: self.dvVarName];
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





