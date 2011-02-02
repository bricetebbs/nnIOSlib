//
//  nnLoginSettingsViewController.m
//
//  Created by Brice Tebbs on 5/13/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnLoginSettingsViewController.h"

@interface nnLoginSettingsViewController()
@property (nonatomic,retain) id <nnDVStoreProtocol> preferenceManager;
@end

@implementation nnLoginSettingsViewController

@synthesize preferenceManager;
@synthesize password;
@synthesize username;
@synthesize spinner;
@synthesize loginCheck;
@synthesize delegate;
@synthesize indicatorButton;
@synthesize authChanged;
@synthesize version;

- (void)dealloc {
    [spinner release];
    [indicatorButton release];
    [loginCheck release];
    [password release];
    [username release];
    [version release];
    [preferenceManager release];
    [super dealloc];
}


-(void)setupPreferences: (id <nnDVStoreProtocol>) pm usernameKey:(NSString*) user passwordKey: (NSString*)pass
{

    self.preferenceManager = pm;
    
    self.username.dvInfo = [[[nnDVString alloc] init: user withHandler: pm] autorelease];
    self.password.dvInfo = [[[nnDVString alloc] init: pass withHandler: pm] autorelease];
    
}


-(void)storeSettings
{
    [username save];
    [password save];
    self.authChanged = YES;
}

-(void)populateSettings
{
    [username populate];
    [password populate];
    [indicatorButton setHidden: YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField { 
    
    [theTextField resignFirstResponder];
    return YES; 
} 


- (void)viewWillAppear: (BOOL) animated {
    
    [super viewWillAppear: animated]; 
    
    
    NSString* buildStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString* versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    self.version.text = [NSString stringWithFormat:@"Version: %@.%@", versionStr, buildStr];
    
    [self populateSettings];
    
    
}

-(void)showAuthTestResult: (NSString*) string 
{
    
    UIImage *image;
    if ([string isEqualToString:@"OK"])
    {
        image = [UIImage imageNamed:@"indicator_good.png"];
    }
    else 
    {
        image = [UIImage imageNamed:@"indicator_bad.png"];
    }
    
    [indicatorButton setHidden: NO];
    [indicatorButton setBackgroundImage:image  forState: UIControlStateNormal];
    [spinner stopAnimating];
    
}

// Override this in subclass
-(void)testLogin
{
    [indicatorButton setHidden: YES];
    [spinner startAnimating];

    // Sub should call
    // [self authTestResult: @"OK"];
}


-(void)cancel
{
    [self.delegate settingsComplete:self cancel: YES];	
}

-(void)save
{
    [self storeSettings];
    [self.delegate settingsComplete:self cancel: NO];	
}

@end

