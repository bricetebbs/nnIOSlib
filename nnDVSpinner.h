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

// This is for the setup
- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)keyPath;

// People who override the delegates can call this to make it do the save
-(void)pickerChanged;

@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, retain) NSArray* labels;

@end