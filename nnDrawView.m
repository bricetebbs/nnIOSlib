//
//  nnDrawView.m
//
//  Created by Brice Tebbs on 3/5/10.
//  Copyright northNitch Studios Inc. 2010. All rights reserved.
//

#import "nnDrawView.h"
#import "nnMessageSystem.h"
#import "QuartzCore/QuartzCore.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>



BOOL ANIMATING = NO;
BOOL SHOW_FRAMERATE = YES;
int TOUCH_LINE_WIDTH = 4.0;

@implementation nnDrawView

@synthesize dragPoints;
@synthesize startTime;
@synthesize interactDelegate;
- (void)setup
{
    frameRate = [[nnRateCounter alloc] init];
}   

- (void)dealloc {
    if (backData) 
    {
        CFRelease(backData);
    }
    
    [frameRate release];
    [super dealloc];
}


-(UInt32)pixelAtPoint:(CGPoint)p
{
    if (!backData)
        return 0;
    
    NSInteger xSize = self.bounds.size.width;
    
    const UInt32* pixels;
    UInt32 px, py;
    px = p.x;
    py = p.y;
    pixels = (const UInt32*)CFDataGetBytePtr(backData);
    NSInteger offset = xSize * py + px;
    
    return pixels[offset];
}


-(void)loadKernelOfWidth:(NSInteger)width into: (UInt32*)kernel at: (CGPoint)p
{
    UInt32 px, py, sx,sy,ex,ey;
    
    const UInt32* pixels;

    
    NSInteger xSize = self.bounds.size.width;
    NSInteger ySize = self.bounds.size.height;
    
    px = p.x;
    py = p.y;
    sx = px - width/2;
    sy = py - width/2;
    ex = px + width/2;
    ey = py + width/2;
    
    
    UInt32 ix, iy;
    UInt32 outIdx = 0;
    
    pixels = (const UInt32*)CFDataGetBytePtr(backData);
    UInt32 yOff;
    for (py = sy; py <= ey; py++)
    {
        iy = py;
        if(iy < 0)
            iy = 0;
        
        if(iy > ySize-1)
            iy = ySize-1;
        
        yOff = xSize * iy;
        
        for (px=sx; px <=ex; px++) {
            ix = px;
            if(ix < 0)
                ix = 0;
            if(ix > xSize-1)
                ix = xSize-1;
            kernel[outIdx++] = pixels[ yOff + ix];
        }
    }
    
}



//
// Aslo returns the bounding of the dirty Region this makes
//
-(void)addToTouchArray:(NSSet *)touches outRect:(CGRect*)rect {
    
    CGPoint p = [[touches anyObject] locationInView:self];

    *rect = CGRectMake(p.x - TOUCH_LINE_WIDTH/2.0,
                       p.y - TOUCH_LINE_WIDTH/2.0,
                       TOUCH_LINE_WIDTH,
                       TOUCH_LINE_WIDTH);
    
    if ([self.dragPoints count] > 0)
    {
        CGPoint lastP = [[self.dragPoints lastObject] CGPointValue];
        CGRect r2 = CGRectMake(lastP.x - TOUCH_LINE_WIDTH/2.0,
                               lastP.y- TOUCH_LINE_WIDTH/2.0,
                               TOUCH_LINE_WIDTH,
                               TOUCH_LINE_WIDTH);
        *rect = CGRectUnion(*rect, r2);
    }
    [self.dragPoints addObject: [NSValue valueWithCGPoint: p]];
    
  ///  [interactDelegate touchIsAt:p];
}


-(IBAction) clearSceneInfo
{
    [scene release];
    scene = nil;
    [currentSceneObject release];
    currentSceneObject = nil;

    [self setNeedsDisplay];
}


- (void) addSceneObjectPart: (nnSceneObjectPart*)part;
{
    if (!scene)
    {
        scene = [[NSMutableArray alloc] init];
    }
    
    if(!currentSceneObject)
    {
        currentSceneObject = [[nnSceneObject alloc] init];
        [scene addObject: currentSceneObject];
    }
    
    [currentSceneObject addPart: part];
    
    [self setNeedsDisplay];
}


// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    CGRect dirtyRect;
    inTouches = YES;
    
    if (self.dragPoints)
        [self.dragPoints removeAllObjects];
    else 
        self.dragPoints = [[NSMutableArray alloc] init];
    
    [self addToTouchArray: touches outRect:  &dirtyRect];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect dirtyRect;
    
    [self addToTouchArray: touches outRect: &dirtyRect];

    inTouches = NO;

    [self.interactDelegate touchUpPoints: self.dragPoints];
    
    [self setNeedsDisplay];
    if (ANIMATING)
        [self performSelector:@selector(nextTick:) withObject:@"Start" afterDelay: 0.5];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
    CGRect dirtyRect;
    [self addToTouchArray: touches outRect: &dirtyRect];    
    [self setNeedsDisplayInRect:dirtyRect];
    
    [self setNeedsDisplay];
}

-(void)drawTouches: (CGContextRef) context
{
    int i;
    CGPoint point;
    
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, TOUCH_LINE_WIDTH);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    
    for(i = 0; i < [self.dragPoints count]; i++)
    {
        point = [[self.dragPoints objectAtIndex: i] CGPointValue];
        if (i == 0)
            CGContextMoveToPoint(context, point.x, point.y);
        else
            CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)nextTick:(NSString*) string {
  
    if ([string isEqualToString: @"Start"])
    {
        self.startTime = CFAbsoluteTimeGetCurrent();
    }
    [self setNeedsDisplay];
   
}

- (void)drawInfoString: (CGContextRef) context string: (NSString*) string
{
    CGContextSaveGState(context);
    
    CGContextSelectFont (context,  "Helvetica-Bold", 12,kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, 10);
    CGContextSetTextDrawingMode (context, kCGTextFill);
    CGContextSetRGBFillColor (context, 0, 0, 0, .5); 
    
    CGAffineTransform xform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);

    CGContextSetTextMatrix (context, xform);
    const char *b =[string cStringUsingEncoding:NSMacOSRomanStringEncoding];
    CGContextShowTextAtPoint (context, 10, 20, b, strlen(b)); 
    
    CGContextRestoreGState(context);
}

-(void)drawOverlaysInContext: (CGContextRef)context
{
}

-(void)drawSceneInContext:(CGContextRef)context
{
    //
    // Draw objects
    // 
    CGContextSaveGState(context);
    
  //  CGContextTranslateCTM(context, scrollOffset.x, scrollOffset.y);
  //  CGContextScaleCTM(context, zoomScale, zoomScale);
    
    // Set some reasonable drawing defaults
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetRGBStrokeColor(context, 1.0,0.0,1.0,1.0);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    
    // Turn on Shadow cause its fun
 
   
       // CGSize shadowOffset = CGSizeMake (10, -5);
       // CGContextSetShadow (context, shadowOffset, 5);
    
    
    for (nnSceneObject *sobj in scene) 
    {
        CGContextSaveGState(context);
            [sobj draw:context];
        CGContextRestoreGState(context);
    }

    
    [self drawOverlaysInContext: context];
    //
    // Draw the touches so far if we have some
    //

    CGContextRestoreGState(context);

    
    if (inTouches) {
        [self drawTouches: context];
    }
    //
    // Display Frame Rate
    //
    if(ANIMATING || SHOW_FRAMERATE)
    {
        [frameRate sample];  
        [self drawInfoString: context string: [NSString stringWithFormat:@"%5.2f", [frameRate getRate]]];
    }
    
}


-(void)renderToImage
{
    NSInteger xSize = self.bounds.size.width;
    NSInteger ySize = self.bounds.size.height;
    
    NSInteger bytesPerRow = (xSize * 4);
    
    void *bitmapData = calloc(ySize, bytesPerRow);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();    
    
    CGContextRef offscreen = CGBitmapContextCreate (bitmapData,
                                         xSize,
                                         ySize,
                                         8,
                                         bytesPerRow,
                                         colorSpace,
                                        kCGImageAlphaPremultipliedLast
                            );
                                        
    [self drawSceneInContext: offscreen];
    
    // draw stuff into offscreen
                                                    
    CGImageRef cgImage = CGBitmapContextCreateImage(offscreen);
   
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    
    const UInt8* pixels;
    
    pixels = CFDataGetBytePtr(data);
#if 0
    int i;
    for (i = 0; i < bytesPerRow*ySize; i++) {
        if (pixels[i] > 0) {
            nnDebugLog(@"[%d]=%d",i, pixels[i]);
        }
    }
#endif

    UIImage *image = [UIImage imageWithCGImage:cgImage];

    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);    
    
    CFRelease(cgImage);
    CFRelease(offscreen);
    free(bitmapData);
}



-(void)createBackData
{
    NSInteger xSize = self.bounds.size.width;
    NSInteger ySize = self.bounds.size.height;
    
    NSInteger bytesPerRow = (xSize * 4);
    
    void *bitmapData = calloc(ySize, bytesPerRow);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();    
    
    CGContextRef offscreen = CGBitmapContextCreate (bitmapData,
                                                    xSize,
                                                    ySize,
                                                    8,
                                                    bytesPerRow,
                                                    colorSpace,
                                                    kCGImageAlphaPremultipliedLast
                                                    );

    
    CGContextTranslateCTM(offscreen, 0,ySize);
    CGContextScaleCTM(offscreen, 1.0, -1.0);

    [self drawSceneInContext: offscreen];
    
    // draw stuff into offscreen
    
    CGImageRef cgImage = CGBitmapContextCreateImage(offscreen);
    
    backData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    
    CFRelease(cgImage);
    CFRelease(offscreen);
    
    free(bitmapData);
}





// Draw this view

- (void)drawRect:(CGRect)clipRect 
{
    if(ANIMATING && !inTouches)
    {
        for (nnSceneObject *sobj in scene) 
        {
            [sobj animate: CFAbsoluteTimeGetCurrent()];
        }
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, clipRect);
    
    [self drawSceneInContext: context];
    
    //
    // If not touching start the animation
    // 
    
    if(ANIMATING && !inTouches)
        [self performSelector:@selector(nextTick:) withObject:@"Tick" afterDelay: 0.02];
}

@end
