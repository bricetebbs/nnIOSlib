//
//  nnShortSound.h
//
//  Super simple class for playing a sound
// 
//  Created by Brice Tebbs on 6/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface nnShortSound : NSObject {
    NSString* soundName;
    SystemSoundID soundID;
}

-(id)initWithSoundName:(NSString*)name;
-(void)playSound;

@end
