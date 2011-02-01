//
//  nnPreferenceManager.m
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnPreferenceManager.h"


@implementation nnPreferenceManager

-(NSObject*)objectForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: key];
}

-(void)setObject: id forKey: (NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:id forKey:key];
}

-(BOOL)boolForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: key];
}

-(void)setBool:(BOOL)b forKey: (NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
}

-(double)doubleForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey: key];
}

-(void)setDouble:(double)d forKey: (NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setDouble:d forKey:key];
}

-(NSString*)stringForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey: key];
}

-(void)setString:(NSString*)s forKey: (NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:key];
}

-(void) registerDefaults: (NSDictionary*) def
{
    
    [[NSUserDefaults standardUserDefaults] registerDefaults: def];
}

@end
