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

}
@property (nonatomic, retain) IBOutlet UILabel *statusInfo;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;




@end
