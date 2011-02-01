//
//  nnShortSound.m
//
//  Created by Brice Tebbs on 6/7/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnShortSound.h"


@implementation nnShortSound

-(id)initWithSoundName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        soundName = [name copy];
        soundID = 0;
    }
    return self;
}

-(void)dealloc
{
    [soundName release];
    [super dealloc];
}

-(void)playSound
{
    if(!soundID)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource: soundName ofType:@"aiff"];
        NSURL *url = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID);
    }
    AudioServicesPlaySystemSound(soundID);
}


@end
