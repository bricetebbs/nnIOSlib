//
//  nnAddItemTableViewCell.h
//  cloudlist
//
//  Created by Brice Tebbs on 6/4/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol nnAddItemTableViewCellDelegate

-(void)addItemUsingString: (NSString*) name;


@end


@interface nnAddItemTableViewCell : UITableViewCell <UITextFieldDelegate> {
    UIButton *addButton;
    UITextField *addName;
    id <nnAddItemTableViewCellDelegate> delegate;
}

@property (nonatomic,retain) IBOutlet UIButton *addButton;
@property (nonatomic,retain) IBOutlet UITextField *addName;
@property (nonatomic, assign) id <nnAddItemTableViewCellDelegate> delegate;

-(IBAction)AddIt;

@end
