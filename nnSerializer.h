//
//  nnSerializer.h
//
//  Created by Brice Tebbs on 4/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnCoder.h"




// Note this should really be more abstracted but for now the serializer always makes a string
                    
@interface nnSerializer : NSObject <nnCoder> {
    NSMutableDictionary *classToTag;
    NSMutableDictionary *tagToClass;
    
    NSString* theString;
    NSScanner* scanner;

}

-(void)beginFrame;
-(void)prepareToWrite:  (NSObject*) buffer;
-(void)prepareToRead: (NSObject*) buffer;  // Actually always a  NSString for now
-(NSString*)getStringBuffer;

-(void)addObjectType: (Class)cobj withTag: (NSString*) tag;


@end


