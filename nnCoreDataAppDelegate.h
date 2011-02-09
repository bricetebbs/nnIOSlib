//
//  nnCoreDataAppDelegate.h
//  formulate
//
//  Created by Brice Tebbs on 2/9/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nnCoreDataManager.h"


@interface nnCoreDataAppDelegate : NSObject <UIApplicationDelegate> {
    nnCoreDataManager *coreDataManager;
}

@property (nonatomic, retain) nnCoreDataManager* coreDataManager;

- (NSURL *)applicationDocumentsDirectory;
@end
