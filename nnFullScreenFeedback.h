//
//  nnFullScreenFeedback.h
//
//  Created by Brice Tebbs on 6/3/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface nnFullScreenFeedback :  UIViewController {
    UILabel *statusInfo;
    UIActivityIndicatorView *spinner;
    BOOL freeRotate;

}
@property (nonatomic, retain) IBOutlet UILabel *statusInfo;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, assign) BOOL freeRotate;




@end
