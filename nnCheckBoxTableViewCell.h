//
//  nnCheckBoxTableViewCell.h
//
//  Created by Brice Tebbs on 5/10/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class nnCheckBoxTableViewCell;

@protocol nnCheckBoxTableCellDelegate
-(void)checkChanged: (BOOL)isChecked forCell: (nnCheckBoxTableViewCell*) item;
-(void)moreClickedforCell: (nnCheckBoxTableViewCell*)item;
@end


@interface nnCheckBoxTableViewCell : UITableViewCell {
    BOOL isChecked;
    UIButton *checkButton;
    UILabel *cellLabel;
    id <nnCheckBoxTableCellDelegate> handler;
    NSInteger index;
    
    UIButton *moreButton;
}

-(void) setChecked: (BOOL) checked;

-(IBAction)checkClicked;
-(IBAction)moreClicked;

@property (nonatomic, retain) IBOutlet UILabel *cellLabel;
@property (nonatomic, retain) IBOutlet UIButton *checkButton;

@property (nonatomic, retain) IBOutlet UIButton *moreButton;
@property (nonatomic, retain) id <nnCheckBoxTableCellDelegate> handler;
@property (nonatomic, assign) NSInteger index;


@end
