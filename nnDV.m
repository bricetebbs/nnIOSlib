//
//  nnDV.m
//  glogger
//
//  Created by Brice Tebbs on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "nnDV.h"


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

@implementation nnDVObject
-(int)getDataType { return nnkDVDataTypeObject; }
@end

