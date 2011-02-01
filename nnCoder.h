//
//  nnCoder.h
//
//  Created by Brice Tebbs on 4/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol nnEncodable;

@protocol nnCoder

//
// Simple Data Types we need to support
//
-(void)encodeCGPoint: (CGPoint*)p;
-(void)encodeInt: (int)i;
-(void)encodeFloat: (float)f;
-(void)encodeString: (NSString*)s;

-(CGPoint)decodeCGPoint;
-(int)decodeInt;
-(float)decodeFloat;
-(NSString*)decodeString;


//
// User for object serializer
//
-(void)encodeObjectPrefix;
-(void)encodeObjectPostfix;
-(void)encodeObjectTag: (NSString*)s;
-(NSString*)decodeObjectTag;


-(void)serializeObject: (id <nnEncodable>)object;
-(id)allocAndDeserializeObject;


//
// Brackets for frames of data
//
-(void)prepareToRead: (NSObject*) buffer; // Buffer object we are going to read from (file,string etc)
-(void)prepareToWrite:  (NSObject*) buffer;

@end


@protocol nnEncodable
//
// Should this include initWithCoder?
//
-(Class)class;
-(void)encodeData: (id <nnCoder>)coder;
-(void)decodeData: (id <nnCoder>)coder;
@end
                            
                    
