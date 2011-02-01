//
//  nnSerializer.m
//
//  Created by Brice Tebbs on 4/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnSerializer.h"


@implementation nnSerializer 


-(id)init
{
    self = [super init]; 
    if (self)
    {
        classToTag = [[NSMutableDictionary alloc] init];
        tagToClass= [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void)dealloc
{
    [classToTag release];
    [tagToClass release];
    
    [theString release];
     
    [super dealloc];
}

-(void)addObjectType: (Class)cobj withTag:(NSString*)tag
{
    [classToTag setObject: tag forKey: cobj];
    [tagToClass setObject: cobj forKey: tag];
}

-(void)beginFrame
{
    [self prepareToWrite:nil];
}

-(void)prepareToWrite: (NSObject*) buffer // We don't use the buffer here since we store it
{
    [theString release];
    theString = [[NSString alloc] init];
}

-(void)prepareToRead: (NSObject*) buffer;
{
    assert ([buffer isKindOfClass: [NSString class]]);
    
    [theString release];
    theString = (NSString*)buffer;
    [theString retain];
    scanner = [NSScanner scannerWithString:theString];
}

-(NSString*)getStringBuffer
{
    return [theString copy];
}

NSString *OPRE = @"{";  
NSString *OPOST = @"}";  
NSString *TSEP = @";";  // Token Seperator Can't have this in a string (sorry)
NSString *CONT_SET = @"{};";
NSString *CSEP = @",";

-(void)encodeCGPoint: (CGPoint*)point;
{
    // Should send float when its really float and int when its not
    theString = [theString stringByAppendingFormat:@"%@%g%@%g", TSEP, point->x, CSEP, point->y];
}
-(void)encodeInt: (int)i;
{
    theString = [theString stringByAppendingFormat:@"%@%d", TSEP, i];
}
-(void)encodeFloat: (float)f;
{
    theString = [theString stringByAppendingFormat:@"%@%g", TSEP, f];
    
}
-(void)encodeString: (NSString*)s;
{
    theString = [theString stringByAppendingFormat:@"%Q%@", TSEP,s];
}

-(void)encodeObjectTag: (NSString*)s;
{
    theString = [theString stringByAppendingFormat:@"%@", s];
}

-(void)encodeObjectPrefix
{
    theString = [theString stringByAppendingString:OPRE];
}

-(void)encodeObjectPostfix
{
    theString = [theString stringByAppendingString:OPOST];
}

-(NSString*) result
{
    return theString;
}

-(CGPoint)decodeCGPoint;
{
    CGPoint point;
    [scanner scanString:TSEP intoString:NULL];
    [scanner scanFloat:&point.x];
    [scanner scanString:CSEP intoString:NULL];
    [scanner scanFloat:&point.y];
    
    return point;
}

-(int)decodeInt;
{
    int i;
    [scanner scanString:TSEP intoString:NULL];
    [scanner scanInt:&i];
    return i;
}

-(float)decodeFloat;
{
    float f;
    [scanner scanString:TSEP intoString:NULL];
    [scanner scanFloat:&f];
    return f;
}

-(NSString*)decodeString;
{
    NSString* s = nil;
    [scanner scanString:TSEP intoString:NULL];
    [scanner scanUpToString:TSEP intoString:&s];
    return s;
}

-(NSString*)decodeObjectTag;
{
    NSCharacterSet* controlSet = [NSCharacterSet characterSetWithCharactersInString:CONT_SET]; 
    NSString* s = nil;
    [scanner scanCharactersFromSet:controlSet intoString:NULL];
    [scanner scanUpToCharactersFromSet:controlSet intoString:&s];
    return s;
}

-(void)decodeObjectPostfix
{
    [scanner scanString:OPOST intoString: NULL];
}



-(void)serializeObject: (id <nnEncodable>)object
{
    [self encodeObjectPrefix];
    if (object)
    {
        [self encodeObjectTag: [classToTag objectForKey:[ object class]]];
        [object encodeData: self];
    }
    else {
        [self encodeObjectTag:@"0"];
    }
    
    [self encodeObjectPostfix];
}


-(id)allocAndDeserializeObject
{
    Class cobj;
    id obj;
    NSString *s = [self decodeObjectTag];
    if (s == @"0")
    {
        obj = nil;
    }
    else
    {
        cobj = [tagToClass objectForKey:s];
        obj = [[cobj alloc] init];
        
        [obj decodeData: self];
    }
    [self decodeObjectPostfix];
    
    return obj;
}


@end
