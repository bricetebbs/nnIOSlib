//
//  nnListItem.h
//
//  Created by Brice Tebbs on 5/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "northNitch.h"

@interface nnListItem : NSObject {
    NSInteger pk;     // Storage Key for sql
    NSInteger groupKey;  // Group key for sql
    NSInteger priority; // Order
    NSInteger state;    // Checked etc
    NSString* label;    // To show in lists etc
        
    id _buffer;         // In base class this is just a string
}

@property (nonatomic, assign)  NSInteger pk;
@property (nonatomic, assign)  NSInteger groupKey;
@property (nonatomic, assign)  NSInteger priority;
@property (nonatomic, assign)  NSInteger state;

@property (nonatomic, copy)    NSString* label;

-(NSString*)getStringData;
-(void)setStringData:(NSString *) data;
- (NSComparisonResult)compareByStatusReverse:(nnListItem *)other;
@end
