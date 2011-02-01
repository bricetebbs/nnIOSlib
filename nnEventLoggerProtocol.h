//
//  nnEventLoggerProtocol.h
//  metime
//
//  Created by Brice Tebbs on 7/1/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "northNitch.h"
#import "nnLoggedEvent.h"

@protocol nnEventLoggerProtocol

-(nnErrorCode)logEvent: (NSInteger)kind forKey:(NSInteger)key value:(NSInteger)value;
-(nnErrorCode)countEvents: (NSInteger)kind forKey:(NSInteger)key storeIn:(NSInteger*)count;
-(nnErrorCode)fetchEvents: (NSInteger)kind storeIn: (NSMutableArray*)results;
@end
