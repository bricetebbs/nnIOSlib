//
//  nnOpenAL.h
//
//  Created by Brice Tebbs on 6/19/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#import "northNitch.h"

@interface nnOpenAL : NSObject {
	ALuint			source;
	ALuint			buffer;
	ALCcontext*		context;
	ALCdevice*		device;
    
	void*					data;
}

-(nnErrorCode)setup;
-(nnErrorCode)loadSound: (NSString*) soundName;

-(void)start;
-(void)stop;
-(void)setVolume: (double)vol;
-(void)setSourcePos:(float*)pos;


@end
