//
//  nnPreferenceUISwitch.m
//
//  Created by Brice Tebbs on 7/15/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnPreferenceUISwitch.h"
#import "northNitch.h"


@implementation nnPreferenceUISwitch
@synthesize preferenceName;
@synthesize delegate;

- (void)dealloc {
    [preferenceName release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)preferenceChanged
{
    nnDebugLog(@"Preference %@ is now %d", self.preferenceName, self.on);
    [delegate setBool: self.on forKey:self.preferenceName];
}

-(void)setup
{
    if(!_setupComplete)
    {
        [self addTarget:self action:@selector(preferenceChanged) forControlEvents:UIControlEventValueChanged];
        _setupComplete = YES;
        if(delegate)
        {
            NSObject *nobj = [delegate objectForKey:self.preferenceName];
            if (nobj == nil) {
                // Use control initial value for the preference setting.
                
                nnDebugLog(@"Using control default of %d for preference %@", self.on, self.preferenceName);
                [delegate setObject:[NSNumber numberWithBool: self.on] forKey:self.preferenceName];
            }
            else
            {
                BOOL currValue = [delegate boolForKey:self.preferenceName];
                nnDebugLog(@"Setting control to %d for preference %@", currValue, self.preferenceName);
                [self setOn: currValue animated: NO];
            }
        }
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

@end
