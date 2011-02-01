//
//  nnCustomTableViewCell.h
//
//  A customized cell for use in table views
//
//  Created by Brice Tebbs on 7/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class nnCustomTableViewCell;
@protocol nnCustomTableViewCellDelegate
-(void)newValue: (double)value forCell: (nnCustomTableViewCell*)cell;
@end

@interface nnCustomTableViewCell : UITableViewCell {
    UILabel *cellLabel;
    NSObject* userData;
    id <nnCustomTableViewCellDelegate> delegate;
}


@property (nonatomic, assign) IBOutlet id <nnCustomTableViewCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *cellLabel;
@property (nonatomic, retain) NSObject* userData;

@end
