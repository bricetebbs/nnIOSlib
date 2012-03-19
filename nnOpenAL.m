//
//  nnOpenAL.m
//
//  Created by Brice Tebbs on 6/19/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "nnOpenAL.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>

typedef ALvoid	AL_APIENTRY	(*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);
ALvoid  alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);


@implementation nnOpenAL

- (void)cleanup
{	
    alDeleteSources(1, &source);
    alDeleteBuffers(1, &buffer);
	
    alcDestroyContext(context);
    alcCloseDevice(device);
}




-(void)dealloc
{
    [self cleanup];
    [super dealloc];
}


- (nnErrorCode) loadSound: (NSString*) soundName
{
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	
	NSBundle* bundle = [NSBundle mainBundle];
	
	// get some audio data from a wave file
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:soundName ofType:@"caf"]] retain];
	
	if (fileURL)
	{	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CFRelease(fileURL);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			nnDebugLog(@"error loading sound: %x\n", error);
			return nnkOALLoadFail;
		}
		
		// use the static buffer data API
		alBufferDataStaticProc(buffer, format, data, size, freq);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			nnDebugLog(@"error attaching audio to buffer: %x\n", error);
            return nnkOALBufferAttachFail;
		}		
	}
	else
		nnDebugLog(@"Could not find sound file %@", soundName);
    
	alGetError(); // Clear the error
    
	// Turn Looping ON
	alSourcei(source, AL_LOOPING, AL_TRUE);
	
	// Set Source Position
	float sourcePosAL[] = {0.0, 0.0, 0.0};
	alSourcefv(source, AL_POSITION, sourcePosAL);
	
	// Set Source Reference Distance
	alSourcef(source, AL_REFERENCE_DISTANCE, 50.0f);
	
	// attach OpenAL Buffer to OpenAL Source
	alSourcei(source, AL_BUFFER, buffer);
	
	if((error = alGetError()) != AL_NO_ERROR) {
		nnDebugLog(@"Error attaching buffer to source: %x\n", error);
		return nnkOALSourceAttachFail;
	}	
    return nnkNoError;
}



-(nnErrorCode)setup
{
	ALenum	error;
    
    OSStatus result = AudioSessionInitialize(NULL, NULL, nil, self);
    if (result)
        nnDebugLog(@"Error initializing audio session! %d\n", result);
    else {
#if 0
        // if there is other audio playing, we don't want to play the background music
        UInt32 size = sizeof(iPodIsPlaying);
        result = AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &iPodIsPlaying);
        if (result) NSLog(@"Error getting other audio playing property! %d", result);
        
        // if the iPod is playing, use the ambient category to mix with it
        // otherwise, use solo ambient to get the hardware for playing the app background track
        UInt32 category = (iPodIsPlaying) ? kAudioSessionCategory_AmbientSound : kAudioSessionCategory_SoloAmbientSound;
        
        result = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if (result) NSLog(@"Error setting audio session category! %d\n", result);
        
        result = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, RouteChangeListener, self);
        if (result) NSLog(@"Couldn't add listener: %d", result);
        
#endif
        result = AudioSessionSetActive(true);
        if (result) NSLog(@"Error setting audio session active! %d\n", (int)result);
    }
    
    
	device = alcOpenDevice(NULL);
	if (device != NULL)
	{
        context = alcCreateContext(device, 0);
		if (context != NULL)
		{
			alcMakeContextCurrent(context);
            alGenBuffers(1, &buffer);
            
			if((error = alGetError()) != AL_NO_ERROR) {
                nnDebugLog(@"Failed to allocate Buffer");
				return nnkOALBufferFail;
			}
			
			// Create some OpenAL Source Objects
			alGenSources(1, &source);
			if(alGetError() != AL_NO_ERROR) 
			{
                nnDebugLog(@"Failed to allocate source");
                return nnkOALSourceFail;
			}
		}
	}
	alGetError();
    return nnkNoError;
}

- (void)start
{
	ALenum error;
	
	NSLog(@"Start!\n");
	// Begin playing our source file
	alSourcePlay(source);
	if((error = alGetError()) != AL_NO_ERROR) {
		NSLog(@"error starting source: %x\n", error);
	} 
}

- (void)stop
{
	ALenum error;
	
	NSLog(@"Stop!!\n");
	// Stop playing our source file
	alSourceStop(source);
	if((error = alGetError()) != AL_NO_ERROR) {
		NSLog(@"error stopping source: %x\n", error);
	} 
}


-(void)setSourcePos:(float *)pos
{
    alSourcefv(source, AL_POSITION, pos);
}

-(void)setVolume:(double)vol
{
    alSourcef(source, AL_GAIN, vol);
}


ALvoid  alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq)
{
	static	alBufferDataStaticProcPtr	proc = NULL;
    
    if (proc == NULL) {
        proc = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
    }
    
    if (proc)
        proc(bid, format, data, size, freq);
	
    return;
}

void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate)
{
	OSStatus						err = noErr;	
	SInt64							theFileLengthInFrames = 0;
	AudioStreamBasicDescription		theFileFormat;
	UInt32							thePropertySize = sizeof(theFileFormat);
	ExtAudioFileRef					extRef = NULL;
	void*							theData = NULL;
	AudioStreamBasicDescription		theOutputFormat;
    
	// Open a file with ExtAudioFileOpen()
	err = ExtAudioFileOpenURL(inFileURL, &extRef);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileOpenURL FAILED, Error = %ld\n", err); goto Exit; }
	
	// Get the audio data format
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
	if (theFileFormat.mChannelsPerFrame > 2)  { printf("MyGetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n"); goto Exit;}
    
	// Set the client format to 16 bit signed integer (native-endian) data
	// Maintain the channel count and sample rate of the original source format
	theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
	theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
    
	theOutputFormat.mFormatID = kAudioFormatLinearPCM;
	theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mFramesPerPacket = 1;
	theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
	theOutputFormat.mBitsPerChannel = 16;
	theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	// Set the desired client (output) data format
	err = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
	
	// Get the total frame count
	thePropertySize = sizeof(theFileLengthInFrames);
	err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
	if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %ld\n", err); goto Exit; }
	
	// Read all the data into memory
	UInt32		dataSize = theFileLengthInFrames * theOutputFormat.mBytesPerFrame;;
	theData = malloc(dataSize);
	if (theData)
	{
		AudioBufferList		theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
		
		// Read the data into an AudioBufferList
		err = ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
		if(err == noErr)
		{
			// success
			*outDataSize = (ALsizei)dataSize;
			*outDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*outSampleRate = (ALsizei)theOutputFormat.mSampleRate;
		}
		else 
		{ 
			// failure
			free (theData);
			theData = NULL; // make sure to return NULL
			printf("MyGetOpenALAudioData: ExtAudioFileRead FAILED, Error = %ld\n", err); goto Exit;
		}	
	}
	
Exit:
	// Dispose the ExtAudioFileRef, it is no longer needed
	if (extRef) ExtAudioFileDispose(extRef);
	return theData;
}




@end
