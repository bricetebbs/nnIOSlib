//
//  nnLoginSettingsViewController.h
//  A class for driving a view for app settings with login credentials
//
//  Created by Brice Tebbs on 8/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "nnDVStoreProtocol.h"

@protocol nnLoginSettingsViewDelegate;


@interface nnLoginSettingsViewController : UIViewController <UITextFieldDelegate> {
    
    id <nnLoginSettingsViewDelegate> delegate;
    UITextField *username;
    UITextField *password;
    UIButton *loginCheck;
    UIButton *indicatorButton;
    BOOL authChanged;
    UILabel *version;
    UIActivityIndicatorView *spinner;
    
    NSString *usernameKey;
    NSString *passwordKey;
    
    id <nnDVStoreProtocol> preferenceManager;
    
}

@property (nonatomic, assign)  id <nnLoginSettingsViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIButton *loginCheck;
@property (nonatomic, retain) IBOutlet UIButton *indicatorButton;
@property (nonatomic, retain) IBOutlet UILabel *version;


@property (nonatomic, assign) BOOL authChanged;

-(void)setupPreferences: (id <nnDVStoreProtocol>) pm usernameKey: user passwordKey: pass;

-(IBAction)save;
-(IBAction)cancel;
-(IBAction)testLogin;


-(void)showAuthTestResult: (NSString*) result;
// Extend these in your subclass
-(void)storeSettings;
-(void)populateSettings;

@end


@protocol nnLoginSettingsViewDelegate
- (void)settingsComplete:(nnLoginSettingsViewController *)controller cancel: (BOOL) canceled;
@end

