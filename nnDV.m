//
//  nnDV.m
//  glogger
//
//  Created by Brice Tebbs on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "nnDV.h"

NSString* const nnkDVDataTypeLabelObject = @"object";
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
    if(type == nnkDVDataTypeObject)
        return nnkDVDataTypeLabelObject;
    
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


@implementation nnDVObject
-(int)getDataType { return nnkDVDataTypeObject; }
@end




