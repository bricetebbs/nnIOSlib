//
//  nnLoggedEvent.h
//  metime
//
//  Created by Brice Tebbs on 7/5/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "northNitch.h"

@interface nnLoggedEvent : NSObject {
    NSInteger key;
    NSInteger kind;
    NSInteger value;
    NSInteger dayOfWeek;
    NSInteger timeOfDay; // In seconds
    UInt64 resourceId;
    double timestamp;
    double latitude;
    double longitude;
}

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger dayOfWeek;
@property (nonatomic, assign) NSInteger timeOfDay;
@property (nonatomic, assign) UInt64 resourceId;
@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;


@end
