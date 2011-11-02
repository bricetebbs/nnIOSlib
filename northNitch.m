//
//  northNitch.m
//  cloudlist
//
//  Created by Brice Tebbs on 5/28/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import "northNitch.h"

#import <Foundation/Foundation.h>


#import <objc/runtime.h>
#import <objc/message.h>



void nnGetDateInfo(double *timestamp, NSInteger* hours, NSInteger *minutes, NSInteger* seconds, NSInteger* dayOfWeek)
{
    NSDate* date = [NSDate date];
    NSCalendar *calendar=  [NSCalendar currentCalendar];
    
    if(timestamp)
        *timestamp = [date timeIntervalSince1970];
    
    NSUInteger flags = 0;
    if(hours)
        flags |= NSHourCalendarUnit;
    if (minutes) 
        flags |= NSMinuteCalendarUnit;
    if (seconds) {
        flags |= NSSecondCalendarUnit;
    }
    if (dayOfWeek) {
        flags |= NSWeekdayCalendarUnit;
    }

    NSDateComponents* components = [calendar components:flags fromDate:date];
    if(hours)
        *hours = components.hour;
    if (minutes) 
        *minutes = components.minute;
    if (seconds) {
        *seconds = components.second;
    }
    if (dayOfWeek) {
        *dayOfWeek = components.weekday;
    }
}


BOOL notInPortraitMode()
{
     UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    return (interfaceOrientation && interfaceOrientation !=UIInterfaceOrientationPortrait);
}

NSString* nnEscapeForXML(NSString* string)
{
    string = [string stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    string = [string stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];    
    string = [string stringByReplacingOccurrencesOfString:@"'"  withString:@"&apos;"];
    return string;
}

NSString* nnStringForCGAffineTransform(CGAffineTransform t)
{
    return [NSString stringWithFormat:@"[%f, %f, %f, %f] (%f,%f)",
            t.a,t.b,t.c,t.d,t.tx,t.ty];
}

NSString* makeUUID()
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef rval = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    return [(NSString *)rval autorelease];
}


nnErrorCode nnIvarsForObject(NSObject *obj, NSMutableDictionary* fields)
{
    NSUInteger count;
    Ivar *vars = class_copyIvarList([obj class], &count);
    for (NSUInteger i=0; i<count; i++) 
    {
        Ivar var = vars[i];
        [fields setObject: [NSString stringWithCString:ivar_getTypeEncoding(var) encoding:NSASCIIStringEncoding] 
                   forKey:[NSString stringWithCString: ivar_getName(var) encoding:NSASCIIStringEncoding]];
    }
    return nnkNoError;
}