//
//  nnCoreDataAppDelegate.m
//  formulate
//
//  Created by Brice Tebbs on 2/9/11.
//  Copyright 2011 northnitch. All rights reserved.
//

#import "nnCoreDataAppDelegate.h"


@implementation nnCoreDataAppDelegate

@synthesize coreDataManager;


- (void)dealloc {
    [coreDataManager release];
	[super dealloc];
}


- (void)awakeFromNib {
    // Pass the managed object context to the root view controller.
    
    nnCoreDataManager *cdm = [[nnCoreDataManager alloc] init];
    self.coreDataManager = cdm;
    [cdm release];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application 
{
    [coreDataManager handleAppTermination];
}



#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



@end


