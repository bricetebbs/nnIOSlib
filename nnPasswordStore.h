//
//  nnPasswordStore.h
//  cloudlist
//
//  Created by Brice Tebbs on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface nnPasswordStore : NSObject {
    
    NSString* serviceName;
    NSString* identifier;
}

-(void)setup: (NSString*)serviceTag keyString: (NSString*) key;
- (BOOL)setPassword:(NSString*)password;
- (NSString*)getPassword;

@end
