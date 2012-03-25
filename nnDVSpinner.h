//
//  nnDVSpinner.h
//  metime
//
//  Created by Brice Tebbs on 3/25/12.
//  Copyright (c) 2012 northNitch Studios. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "nnDV.h"


@interface nnDVSpinner : UIPickerView <nnDVUIBaseProtocol, UIPickerViewDelegate, UIPickerViewDataSource> {
    nnDVBase *dvInfo;
    NSInteger numRows;
    NSArray *labels;
}

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)keyPath;


@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, retain) NSArray* labels;

@end