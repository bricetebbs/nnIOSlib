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
    if(!hold_updates)
    {
        [self storeBool: b];
        [self notifyUpdate];
    }
}

-(void)handleChangeDouble: (double) d
{
    if(!hold_updates)
    {
        [self storeDouble: d];
        [self notifyUpdate];
    }
}

-(void)handleChangeString: (NSString*) s
{
    if(!hold_updates)
    {
        [self storeString: s];
        [self notifyUpdate];
    }
}

-(void)handleChangeInteger: (NSInteger) i
{
    if(!hold_updates)
    {
        [self storeInteger: i];
        [self notifyUpdate];
    }
}

-(void)storeBool: (BOOL) b
{
    [self.dvStoreHandler setBool: b forKey: self.dvVarName];
}

-(void)storeDouble: (double) d
{
    [self.dvStoreHandler setDouble: d forKey: self.dvVarName];
}

-(void)storeString: (NSString*) s
{
    [self.dvStoreHandler setString: s forKey: self.dvVarName];
}

-(void)storeInteger: (NSInteger) i
{
    [self.dvStoreHandler setInteger: i forKey: self.dvVarName];
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





