//
//  nnDVSpinner.m
//  metime
//
//  Created by Brice Tebbs on 3/25/12.
//  Copyright (c) 2012 northNitch Studios. All rights reserved.
//

#import "nnDVSpinner.h"

@implementation nnDVSpinner

@synthesize dvInfo;
@synthesize numRows;
@synthesize labels;

- (void)dealloc {
    [dvInfo release];
    [labels release];
    [super dealloc];
} 


-(id)init: (NSString*)name withHandler: (id <nnDVStoreProtocol>) hdnlr
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.numRows = 5;
    }
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
          
}

-(void)populate
{
    [self selectRow: [self.dvInfo getInteger] inComponent:0 animated:FALSE];

}

-(void)save
{
    if ([self isChanged])
    {
        [self.dvInfo storeInteger: [self selectedRowInComponent: 0]];
    }
}

-(void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"rows"])
    {
        self.numRows = [value intValue];
    }
    if ([key isEqualToString:@"items"])
    {
        self.labels = [value componentsSeparatedByString:@","];
        self.numRows = [self.labels count];
    }
}


- (id)valueForKey:(NSString *)key
{
    return 0;
}


-(BOOL)isChanged
{
    return [self.dvInfo getInteger] != [self selectedRowInComponent: 0];
}

-(void)pickerChanged
{
    [self.dvInfo handleChangeInteger: [self selectedRowInComponent:0]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.numRows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.labels)
    {
        return [self.labels objectAtIndex: row];
    }
  
    return [NSString stringWithFormat:@"Row %d",row];
}

- (void)pickerView:(nnDVSpinner *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView pickerChanged];
}


@end
