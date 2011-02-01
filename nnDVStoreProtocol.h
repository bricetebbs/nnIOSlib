//
//  nnDVStoreProtocol.h
//
//  A simple protocol for storing values.
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol nnDVStoreProtocol

-(NSObject*)objectForKey:(NSString*)key;
-(void)setObject: id forKey: (NSString*)key;

-(BOOL)boolForKey:(NSString*)key;
-(void)setBool: (BOOL) b forKey: (NSString*)key;


-(double)doubleForKey:(NSString*)key;
-(void)setDouble: (double) d forKey: (NSString*)key;


-(NSString*)stringForKey:(NSString*)key;
-(void)setString: (NSString*)s forKey: (NSString*)key;


-(void) registerDefaults: (NSDictionary*) def;
@end

