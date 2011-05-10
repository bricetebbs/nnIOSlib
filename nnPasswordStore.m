//
//  nnPasswordStore.m
//
//  Created by Brice Tebbs on 4/27/11.
//  Copyright 2011 northNitch Studios Inc. All rights reserved.
//

#import "nnPasswordStore.h"

#import <Security/Security.h>

@interface nnPasswordStore() 

@property (nonatomic,retain)  NSString *serviceName;
@property (nonatomic,retain)  NSString *identifier;
@end

@implementation nnPasswordStore
@synthesize serviceName, identifier;

-(void)dealloc
{
    [serviceName release];
    [identifier release];
    
    [super dealloc];
}

- (NSMutableDictionary *)newSearchDictionary {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
	
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
    NSData *encodedIdentifier = [self.identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];
	
    return searchDictionary; 
}

- (NSData *)searchKeychainCopyMatching  {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary];
	
    // Add search attributes
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
    NSData *result = nil;
    SecItemCopyMatching((CFDictionaryRef)searchDictionary,
                                          (CFTypeRef *)&result);
	
    [searchDictionary release];
    
    return result;
}

- (BOOL)createKeychainValue:(NSString *)password {
    NSMutableDictionary *dictionary = [self newSearchDictionary];
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(id)kSecValueData];
	
    OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
    [dictionary release];
	
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)updateKeychainValue:(NSString *)password {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(id)kSecValueData];
	
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    
    [searchDictionary release];
    [updateDictionary release];
	
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}


-(void)setup: (NSString*)serviceTag keyString: (NSString*) key
{

    self.serviceName = serviceTag;
    self.identifier = key;
    
}

- (BOOL)setPassword:(NSString*)password
{
    NSString* oldPword = [self getPassword];
    BOOL ok = YES;
    if (!oldPword)
    {
        ok = [self createKeychainValue: password ];
    }
    else
    {
        ok = [self updateKeychainValue: password ];
    }
    return ok;
}


- (NSString*)getPassword
{
    NSData *passwordData = [self searchKeychainCopyMatching];
    if (passwordData) {
        NSString *password = [[NSString alloc] initWithData:passwordData
                                                   encoding:NSUTF8StringEncoding];
        [passwordData release];
        return password;
    }
    return nil;
}




@end
