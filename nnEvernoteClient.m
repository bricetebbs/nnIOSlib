//
//  nnEvernoteClient.m
//  cloudlist
//
//  Created by Brice Tebbs on 5/12/10.
//  Copyright 2010 northNitch Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "nnEvernoteClient.h"

#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "EvernoteUserStore.h"
#import "EvernoteNoteStore.h"



@interface nnEvernoteClient ()

@property (nonatomic, retain) NSString *consumerKey;
@property (nonatomic, retain) NSString *consumerSecret;


@property (nonatomic, retain) NSString* appName;    
@property (nonatomic, retain) NSString* noteTag;    

@property (nonatomic, retain) EDAMUser *edamUser;

@property (nonatomic, retain) NSString *authToken;

@property (nonatomic, retain) EvernoteUserStore *userStore;
@property (nonatomic, retain) EvernoteNoteStore *noteStore;

@end


@implementation nnEvernoteClient
@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize userStore;
@synthesize noteTag;
@synthesize appName;
@synthesize edamUser;
@synthesize authToken;
@synthesize isSetup;
@synthesize noteStore;

NSString* DEFAULT_NOTE_HEADER_WITH_BANNER = @"<en-note>\n<div>This note was created with <a href=\"http://www.nimbulist.com\">nimbulist</a> a program which makes Evernote into a quick todo list for the iPhone. </div><div>For more information see <a href=\"http://www.nimbulist.com\">http://www.nimbulist.com</a>.</div>\n";
NSString* DEFAULT_NOTE_HEADER_NO_BANNER = @"<en-note>\n";

-(void)dealloc
{
    [consumerKey release];
    [consumerSecret release];
    [edamUser release];
    [authToken release];
    [noteTag release];
    [appName release];
    [userStore release];
    [noteStore release];

    [super dealloc];
}


-(void)setupClient
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    self.authToken = session.authenticationToken;
    self.noteStore = [EvernoteNoteStore noteStore];
    self.userStore = [EvernoteUserStore userStore];
    isSetup = YES;
}

-(BOOL)isAuthenticated
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    if([session isAuthenticated])
    {
        [self setupClient];
    }
    return [session isAuthenticated];
}

-(NSString*)getUser
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    if([session isAuthenticated])
    {
        EDAMUser* user = [session.userStore getUser: session.authenticationToken];
        return user.username;
    }
    return nil;
}

-(NSString*)getGuidForAPPTag: (NSString*) tagName
{
    NSArray *tagList = [[noteStore noteStore] listTags: self.authToken];
    
    for (EDAMTag* tag in tagList)
    {
        if ([tagName isEqualToString: [tag name]]) 
        {
            return [tag guid];
        }
    }
    // We don't have this tag.. Oh no!
    EDAMTag *ctag = [[EDAMTag alloc] init];
    [ctag setName: tagName];
    EDAMTag* newTag = [[noteStore noteStore] createTag: authToken :ctag];
    [ctag release];
    
    return [newTag guid];
}

-(nnErrorCode)logout
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    [session logout];
    return nnkNoError;
}


-(void)setup: (NSString*)applicationName withTag: (NSString*) tagName
{
    self.appName = applicationName;
    self.noteTag = tagName;
}

-(nnErrorCode)handleOAuth: (UIViewController*) view
{
    EvernoteSession *session = [EvernoteSession sharedSession];

    [session authenticateWithViewController: view
                          completionHandler:^(NSError *error) {
                              // Authentication response is handled in this block
                              if (error || !session.isAuthenticated) {
                                  // Either we couldn't authenticate or something else went wrong - inform the user
                                  if (error) {
                                      NSLog(@"Error authenticating with Evernote service: %@", error);
                                      UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                       message:@"Failure returned from Evernote Server - Please try Again."
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil] autorelease];
                                      [alert show];
                                  }
                                  else if (!session.isAuthenticated) {
                                      NSLog(@"User could not be authenticated.");
                                  
                                      UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:@"Unable to authenticate. Please check credentials and try again later."
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil] autorelease];
                                      [alert show];
                                  }
                              }
                              else {
                                  [self setupClient];
                              }
                          }
     ];
     return nnkNoError;
}

-(nnErrorCode)createNewNoteWithTitle: (NSString*)title setKey:(NSString**)key
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
     NSMutableString* content = [[NSMutableString alloc] init];
    EDAMNote *newNote;
    @try
    {
        title =[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        EDAMNotebook *defaultNotebook = [[noteStore noteStore] getDefaultNotebook:authToken];
        EDAMNote *note = [[EDAMNote alloc] init];
        
        EDAMNoteAttributes *attrs = [[EDAMNoteAttributes alloc] init];
        [attrs setSourceApplication: self.appName];
        
        NSArray *defaultTags = [NSArray arrayWithObject: [self getGuidForAPPTag: noteTag]];
        
        [note setNotebookGuid:[defaultNotebook guid]];
        [note setTitle:title];   
        [note setAttributes: attrs];
        
        [note setCreated:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
        [note setTagGuids: defaultTags];
        
        [content setString:	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
        [content appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"];
        [content appendString:@"<en-note></en-note>"];

        [note setContent:content];
        newNote = [[noteStore noteStore]createNote:authToken :note];
        [note release];
        [attrs  release];
        
    }
    
    @catch (NSException *e) {
        return nnkEvernoteCreateNoteFailed;
    }
    @finally {
        [content release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    *key= [[newNote guid] copy];
    return nnkNoError;

}

-(nnErrorCode)deleteNoteWithGUID:(NSString *)guid
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    @try
    {
        [noteStore.noteStore deleteNote:authToken :guid];
    }
    @catch (NSException *e) {
        return nnkEvernoteDeleteFailed;
    }
    @finally
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    return nnkNoError;
}


-(nnErrorCode)getAllTrackingInfo: (NSMutableArray*)rti
{
    EDAMNoteList* noteList;
    EDAMNoteFilter* noteFilter;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    @try {
        NSArray *tagArray = [NSArray arrayWithObject: [self getGuidForAPPTag: noteTag]];
        
        noteFilter = [[[EDAMNoteFilter alloc] initWithOrder: NoteSortOrder_CREATED ascending: YES
                                                      words: nil
                                               notebookGuid: nil
                                                   tagGuids: tagArray
                                                   timeZone: nil
                                                   inactive: NO] autorelease];
    }
    @catch (NSException* e) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nnkEvernoteFetchNoteListFailed;
    }
    
    @try
    {
        noteList = [[noteStore noteStore] findNotes: authToken : noteFilter : 0 : 1000];
    }
    @catch (NSException *e) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nnkEvernoteFetchNoteListFailed;
    }
    
    
    
    for (EDAMNote* note in [noteList notes]) {
        nnRemoteSyncTrackingInfo *rsti = [[nnRemoteSyncTrackingInfo alloc] init];
        rsti.tag = [note guid];
        rsti.label = [note title];
        rsti.remoteCurrentSeq = [note updateSequenceNum];
        [rti addObject: rsti];
        
        nnDebugLog(@"Note %@ usn=%d",rsti.label, [note updateSequenceNum]);
        [rsti release];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return nnkNoError;
}

-(nnErrorCode)writeItems: (NSArray*) items andHeader:(NSString*)header withTracking:(nnLocalSyncTrackingInfo*)ti
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    @try
    {
        EDAMNote* note = [[noteStore noteStore] getNote: authToken : ti.tag : NO :NO :NO :NO];
    
        NSMutableString* contentString = [[NSMutableString alloc] init];
        
        [contentString setString:	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
        [contentString appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n"];
        if (!header || [header length] < 1) { // If we have no header (a locally created note) make one
            [contentString appendString:  DEFAULT_NOTE_HEADER_NO_BANNER];
        }   
        else {
            [contentString appendString: header];
        }
         
        
        for (nnListItem* todo in items)
        {
            if(!todo.state)
            {
                [contentString appendString:@"<div>\n<en-todo></en-todo>"];
            }
            else
            {
                [contentString appendString:@"<div>\n<en-todo checked=\"true\"></en-todo>"];
            }
            
            [contentString appendString: [ todo getStringData]];
            
            [contentString appendString:@"\n</div>"];
        }
        
        [contentString appendString:@"\n</en-note>"];
        
        [note setContent:contentString];
        
        [note setUpdated:0];
        [[noteStore noteStore] updateNote: authToken : note];
                              
        note = [[noteStore noteStore] getNote: authToken : ti.tag : NO :NO :NO :NO];
        
        ti.remoteCurrentSeq = [note updateSequenceNum];
        
        
        [contentString release];
    }
    @catch (NSException *e) {
        return nnkEvernoteUpdateNoteFailed;
    }
    @finally {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    return nnkNoError;
}
-(nnErrorCode)readItems: (NSMutableArray*)items andHeader: (NSString**) header  withTracking:(nnLocalSyncTrackingInfo*)ti
{
    EDAMNote* note;
    NSData* content;
    NSXMLParser* parser;
    nnEvernoteTODOParser* parserDelegate;
    
    @try 
    {
        note  = [[noteStore noteStore] getNote: authToken : ti.tag : YES :NO :NO :NO];
        
        content = [[note content] dataUsingEncoding: NSUTF8StringEncoding];
    }
    @catch (NSException *e) {
        return nnkEvernoteFetchNoteFailed;
    }
    @finally {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    @try {
        parser = [[NSXMLParser alloc] initWithData: content];
        parserDelegate = [[nnEvernoteTODOParser alloc] initWithBuffer:  items ];
        
        [parser setDelegate: parserDelegate];
        
        [parser parse];
        
        *header = [parserDelegate.header copy];
        
    }
    @catch (NSException * e) {
        return nnkEvernoteParseNoteFailed;
    }
    @finally {
        [parser release];
        [parserDelegate release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }    
    return nnkNoError;
}


-(nnErrorCode)createNewGroupWithTitle: (NSString*)title setTag:(NSString**)tag
{
    nnErrorCode error = [self createNewNoteWithTitle: title setKey: tag];
    return error;
}


-(nnErrorCode)removeGroupTag: (NSString*)tag
{
    
    return [self deleteNoteWithGUID: tag];
}



@end

enum nnParserTrackerType {
    kParserStart = 1,
    kParserEnd = 2,
    kParserChars = 3
};

@interface nnParserTrackerItem : NSObject
{
    NSInteger kind;
    NSString* data;
    NSDictionary* attributes;
    BOOL hide;
    BOOL isBoth;
}

@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSDictionary *attributes;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) BOOL hide;
@property (nonatomic, assign) BOOL isBoth;

-(NSString*)render;

@end

@implementation nnParserTrackerItem
@synthesize data;
@synthesize kind;
@synthesize attributes;
@synthesize hide;
@synthesize isBoth;

-(void)dealloc
{
    [attributes release];
    [data release];
    [super dealloc];
}

-(NSString*)render
{
    if (hide)
        return [NSString stringWithFormat:@""];
    
    if(kind == kParserChars)
    {
        return data;
    }
    else if(kind == kParserEnd)
    {
        return [NSString stringWithFormat:@"</%@>", data];
    }
    else if(kind == kParserStart)
    {
        NSString* attrString = [NSString stringWithFormat:@""];
        if (attributes) {
            for (NSString* key in [attributes allKeys]) {
                attrString = [attrString stringByAppendingString: [NSString stringWithFormat: @" %@=\"%@\"",key,[attributes valueForKey: key]]];
            }
        }
        if ([attrString length] > 0) {
        }
        if (isBoth)
        {
            return [NSString stringWithFormat:@"<%@%@/>", data,attrString];
        }
        else
        {
             return [NSString stringWithFormat:@"<%@%@>", data,attrString];
        }
    }
    return nil;
}

@end


@implementation nnEvernoteTODOParser
@synthesize header;
-(void)dealloc
{
    [header release];
    [currentItem release];
    [parseList release];
    [super dealloc];
}

-(id)initWithBuffer:(NSMutableArray *)buffer
{
    self = [super init];
    if (self)
    {    
        parseList = [[NSMutableArray alloc] init];
        todoBuffer = buffer;
    }
    return self;
}

-(void)setupNewItem: (NSDictionary*) attributeDict
{
    currentItem = [[nnListItem alloc] init];
    NSString *checked = [attributeDict valueForKey:@"checked"];
    currentItem.state = checked != nil && [checked isEqualToString:@"true"];
    lineBreakerFound = NO;
}

-(NSString*)makeStringWith: (NSString*) original adding: (NSString*) add strip: (BOOL)strip
{
    if (strip)
    {
        add = [add stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (original) {
        return [original stringByAppendingString: add];
    }
    return add;
    
}


-(void) lineBreakerDetected
{
    if (currentItem && [currentItem.label length] > 0)
        lineBreakerFound = YES;
}

-(void)addToLabel: (NSString*)string
{
    if(currentItem && !lineBreakerFound)
    {
        currentItem.label = [self makeStringWith: currentItem.label adding:string strip:YES];
    }
}

-(void)addParseElement: (NSString*)string kind: (NSInteger) k attrs:(NSDictionary*)attrs
{
    nnParserTrackerItem *item = [[nnParserTrackerItem alloc] init];
    item.data = string;
    item.kind = k;
    item.attributes = attrs;
    
    [parseList addObject: item];
    [item release];
}


-(void)balanceParseStack
{
    nnParserTrackerItem *item;
    NSInteger index;
    BOOL noOneInTheMiddle = YES;
    

    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    // Hide all element tags by default
    for (item in parseList) {
        if (item.kind == kParserEnd || item.kind == kParserStart)
        {
            item.hide = YES;
        }
    }
    
    for(index = 0; index < [parseList count]; index++)
    {
        item = [parseList objectAtIndex: index];
        
        if (item.kind == kParserEnd) 
        {
            nnParserTrackerItem* last = [stack lastObject];
            if (last && last.kind == kParserStart && [last.data isEqualToString: item.data])
            {
                last.hide = NO;
                if(noOneInTheMiddle)
                {
                    last.isBoth = YES;
                }
                else
                {
                    item.hide = NO;
                }
                [stack removeLastObject];
            }
            noOneInTheMiddle = NO;
        }
        if(item.kind == kParserStart)
        {
            [stack addObject: item];
            noOneInTheMiddle = YES;
        }
        if(item.kind == kParserChars)
        {
            noOneInTheMiddle = NO;
        }
        if ([item.data isEqualToString:@"en-note"]) {
            item.hide = YES; // We special case this
        }
    }
        
    [stack release];
}

-(void)dumpTodo
{
    [self balanceParseStack];
    
    if (currentItem) {
        for (nnParserTrackerItem *item in parseList) {
            [currentItem  setStringData: [self makeStringWith: [currentItem getStringData] adding: [item render] strip: NO]];
        }
    }
    
    [todoBuffer addObject: currentItem];
    
    [parseList removeAllObjects];
    [currentItem release];
    currentItem = nil;
}

-(void)parseListToHeader;
{
    for (nnParserTrackerItem* item in parseList) {
        if (item.kind == kParserStart && [item.data isEqualToString: @"en-note"])
            self.header = [item render];
    }
    
    [self balanceParseStack];
    
    for (nnParserTrackerItem *item in parseList) {
        self.header = [self makeStringWith: self.header adding: [item render] strip: NO];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    if ([elementName isEqualToString: @"br"] || [elementName isEqualToString: @"div"] || [elementName isEqualToString: @"ol"] || [elementName isEqualToString: @"ul"])
    {
        [self lineBreakerDetected]; // Used to help make label smarter
    }

    if ([elementName isEqualToString: @"en-todo"])
    {
        if (currentItem)
        {   
            [self dumpTodo];
        }
        else 
        {
            [self parseListToHeader];
            [parseList removeAllObjects];
        }
        [self setupNewItem: attributeDict];
    }
    else // Add anything but to-do's to the list
    {
        [self addParseElement: elementName kind: kParserStart attrs:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (![elementName isEqualToString: @"en-todo"]) {
        [self addParseElement: elementName kind: kParserEnd attrs: nil];
    }
}




- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self addToLabel: string];
    string = nnEscapeForXML(string);
    [self addParseElement: string kind: kParserChars attrs: nil];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    if(currentItem)
        [self dumpTodo];
}


@end

