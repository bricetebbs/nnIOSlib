//
//  nnPreferenceManager.m
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnPreferenceManager.h"


@implementation nnPreferenceManager


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

-(NSInteger)integerForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey: key];
}

-(void)setInteger:(NSInteger)d forKey: (NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:d forKey:key];
}

-(NSString*)stringForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey: key];
}

-(void)setString:(NSString*)s forKey: (NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:key];
}

-(NSInteger)numSamplesForKey: (NSString*) key
{
    return 1;
}


-(void) registerDefaults: (NSDictionary*) def
{
    [[NSUserDefaults standardUserDefaults] registerDefaults: def];
}

@end
