/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:   FeedReader.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "FeedReader.h"
#import "JREngage.h"
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define QUICK_PUBLISH_CACHED_VERSION @"quickpublish.cachedversion"
#define QUICK_PUBLISH_CACHED_STORIES @"quickpublish.feeddata.cachedstories"
#define QUICK_PUBLISH_CACHED_STORY_LINKS @"quickpublish.feeddata.cachedstorylinks"

#define QUICK_PUBLISH_STORY_TITLE @"quickpublish.story.title"
#define QUICK_PUBLISH_STORY_LINK @"quickpublish.story.link"
#define QUICK_PUBLISH_STORY_DESCRIPTION @"quickpublish.story.description"
#define QUICK_PUBLISH_STORY_AUTHOR @"quickpublish.story.author"
#define QUICK_PUBLISH_STORY_PUBDATE @"quickpublish.story.pubdate"
#define QUICK_PUBLISH_STORY_PLAINTEXT @"quickpublish.story.plaintext"
#define QUICK_PUBLISH_STORY_STORYIMAGEURLS @"quickpublish.story.storyimageurls"
#define QUICK_PUBLISH_STORY_FEEDURL @"quickpublish.story.feedurl"
#define QUICK_PUBLISH_STORY_IMAGES @"quickpublish.story.images"

#define QUICK_PUBLISH_STORYIMAGE_SRC @"quickpublish.storyimage.src"
#define QUICK_PUBLISH_STORYIMAGE_FILENAME @"quickpublish.storyimage.filename"
#define QUICK_PUBLISH_STORYIMAGE_DOWNLOADFAILED @"quickpublish.storyimage.downloadfailed"

#define QUICK_PUBLISH_LAST_UPDATE_DATE @"quickpublish.reader.lastupdatedate"

@interface NSString (HTML_StyleOut)
- (NSString*)stringWithCommentedOutHTMLStyleTags;
@end

@implementation NSString (HTML_StyleOut)
- (NSString*)stringWithCommentedOutHTMLStyleTags
{
    NSMutableString *result;// = [[NSMutableString alloc] initWithCapacity:self.length];

    //NSMutableString *newDescription;
    NSArray *splitString = [self componentsSeparatedByString:@"<style type=\"text/css\">"];

    if (!splitString)
        return self;

    int length = [splitString count];

    if (length == 0)
        return self;

    if (length == 1 && [((NSString*)[splitString objectAtIndex:0]) isEqualToString:self])
        return self;

    result = [NSMutableString stringWithString:[splitString objectAtIndex:0]];

    for (NSUInteger i = 1; i < length; i++)
    {
        NSString *currentString = [splitString objectAtIndex:i];


        NSString *styleMatchers = @"(.+?)</style>(.+)";
        NSArray *styleCaptures =
                [currentString captureComponentsMatchedByRegex:styleMatchers
                                                       options:RKLCaseless | RKLDotAll
                                                         range:NSMakeRange(0, [currentString length])
                                                         error:nil];

        if (!styleCaptures)
            [result appendFormat:@"<style type=\"text/css\">%@", currentString];
        else if ([styleCaptures count] != 3)
            [result appendFormat:@"<style type=\"text/css\">%@", currentString];
        else
            [result appendFormat:@"<!--style type=\"text/css\">%@</style-->%@",
             [styleCaptures objectAtIndex:1],
             [styleCaptures objectAtIndex:2]];
    }

    return result;
}

@end

@interface StoryImage ()
- (void)downloadImage;
@end

@implementation StoryImage
@synthesize src;
@synthesize image;
@synthesize downloadFailed;


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:src forKey:QUICK_PUBLISH_STORYIMAGE_SRC];
    [coder encodeObject:fileName forKey:QUICK_PUBLISH_STORYIMAGE_FILENAME];
    [coder encodeBool:downloadFailed forKey:QUICK_PUBLISH_STORYIMAGE_DOWNLOADFAILED];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self != nil)
    {
        src = [[coder decodeObjectForKey:QUICK_PUBLISH_STORYIMAGE_SRC] retain];
        fileName = [[coder decodeObjectForKey:QUICK_PUBLISH_STORYIMAGE_FILENAME] retain];
        downloadFailed = [coder decodeBoolForKey:QUICK_PUBLISH_STORYIMAGE_DOWNLOADFAILED];

        NSString  *imagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
            stringByAppendingPathComponent:fileName];
        image = [[UIImage imageWithContentsOfFile:imagePath] retain];
    }

    return self;
}

- (id)initWithImageSrc:(NSString*)imageSrc andStoryTitle:(NSString*)storyTitle
{
    if (imageSrc == nil)
    {
        [self release];
        return nil;
    }

    self = [super init];
    if (self)
    {
        src = [imageSrc retain];

        if (!storyTitle)
            storyTitle = @"";

        NSString *titleMinusSpaces = [[[storyTitle stringByRemovingNewLinesAndWhitespace]
            stringByReplacingOccurrencesOfString:@"/" withString:@""]
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *srcMinusPath = [src lastPathComponent];

        fileName = [[NSString alloc] initWithFormat:@"%@%@", titleMinusSpaces, srcMinusPath];
    }

    return self;
}

- (void)deleteFromDisk
{
    NSString  *imagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
        stringByAppendingPathComponent:fileName];

    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath:imagePath error:&error];
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    image = [[UIImage imageWithData:payload] retain];

    if (!image)
        downloadFailed = YES;
    else
    {
        NSString  *imagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
            stringByAppendingPathComponent:fileName];
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    }
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }
- (void)connectionDidFailWithError:(NSError*)_error request:(NSURLRequest*)request andTag:(void*)userdata { downloadFailed = YES; }
- (void)connectionWasStoppedWithTag:(void*)userdata { }

/* To save memory, image will only download itself if prompted to do so by the story. */
- (void)downloadImage
{
    DLog(@"Downloading story image: %@", src);

    NSURL *url = [NSURL URLWithString:src];

    if(!url)
        return;

    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:nil];
}

- (void)dealloc
{
    [src release];
    [image release];
    [fileName release];

    [super dealloc];
}
@end

@interface Story ()
- (void)setHtmlText:(NSString*)newHtmlText;
- (void)setPubDate:(NSString*)newHtmlText;
@property (retain) NSString *title;
@property (retain) NSString *link;
@property (retain) NSString *author;
@property (retain) NSString *plainText;
@property (retain) NSString *feedUrl;
@end

@implementation Story
@synthesize title;
@synthesize link;
@synthesize htmlText;
@synthesize author;
@synthesize pubDate;
@synthesize plainText;
@synthesize storyImages;
@synthesize feedUrl;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:title forKey:QUICK_PUBLISH_STORY_TITLE];
    [coder encodeObject:link forKey:QUICK_PUBLISH_STORY_LINK];
    [coder encodeObject:htmlText forKey:QUICK_PUBLISH_STORY_DESCRIPTION];
    [coder encodeObject:author forKey:QUICK_PUBLISH_STORY_AUTHOR];
    [coder encodeObject:pubDate forKey:QUICK_PUBLISH_STORY_PUBDATE];
    [coder encodeObject:plainText forKey:QUICK_PUBLISH_STORY_PLAINTEXT];
    [coder encodeObject:feedUrl forKey:QUICK_PUBLISH_STORY_FEEDURL];

    [coder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:storyImages] forKey:QUICK_PUBLISH_STORY_IMAGES];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self != nil)
    {
        title     = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_TITLE] retain];
        link      = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_LINK] retain];
        htmlText  = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_DESCRIPTION] retain];
        author    = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_AUTHOR] retain];
        pubDate   = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_PUBDATE] retain];
        plainText = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_PLAINTEXT] retain];
        feedUrl   = [[coder decodeObjectForKey:QUICK_PUBLISH_STORY_FEEDURL] retain];

        NSData *archivedImages = [coder decodeObjectForKey:QUICK_PUBLISH_STORY_IMAGES];
        if (archivedImages != nil)
        {
            NSArray *unarchivedImages = [NSKeyedUnarchiver unarchiveObjectWithData:archivedImages];
            if (unarchivedImages != nil)
                storyImages = [[NSMutableArray alloc] initWithArray:unarchivedImages];
        }
    }

    return self;
}

- (void)deleteImagesFromDisk
{
    for (StoryImage *image in storyImages)
        [image deleteFromDisk];
}

- (void)addStoryImage:(NSString*)newStoryImage
{
    DLog(@"Adding a story image: %@", newStoryImage);

    if (!storyImages)
        storyImages = [[NSMutableArray alloc] initWithCapacity:1];

    if (![newStoryImage hasPrefix:@"http"])
    {
        newStoryImage = [NSString stringWithFormat:@"%@%@", self.feedUrl, newStoryImage];
    }

    StoryImage *image = [[[StoryImage alloc] initWithImageSrc:newStoryImage andStoryTitle:title] autorelease];

    [storyImages addObject:image];

 /* Only download the first coupla images */
    if ([storyImages count] <= 2)
        [image downloadImage];
}

- (NSString*)scaledWidthAndHeight:(NSString*)style
{
    NSString *patternWidth = @"(.*?)width:(.+?)px(.*)";
    NSString *patternHeight = @"(.*?)height:(.+?)px(.*)";

    NSArray *matcherWidth = [style captureComponentsMatchedByRegex:patternWidth
                                                           options:(RKLCaseless | RKLDotAll)
                                                             range:NSMakeRange(0, [style length])
                                                             error:NULL];
    NSArray *matcherHeight = [style captureComponentsMatchedByRegex:patternHeight
                                                            options:(RKLCaseless | RKLDotAll)
                                                              range:NSMakeRange(0, [style length])
                                                              error:NULL];

    if (![matcherWidth count])
        return style;

    NSString *widthString = [[matcherWidth objectAtIndex:2]
                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int width = [widthString intValue];

    if (width <= 280)
        return style;

    style = [style stringByReplacingOccurrencesOfString:
                       [NSString stringWithFormat:@"width:%@px", [matcherWidth objectAtIndex:2]]
                                                 withString:@"width: 280px"];

    double ratio = width / 280.0;

    if ([matcherHeight count])
    {
        NSString *heightString = [[matcherHeight objectAtIndex:2]
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        int height = [heightString intValue];
        int newHeight = [[NSNumber numberWithDouble:(height / ratio)] intValue];

        style = [style stringByReplacingOccurrencesOfString:
                   [NSString stringWithFormat:@"height:%@px", [matcherHeight objectAtIndex:2]]
                                             withString:
                   [NSString stringWithFormat:@"height:%dpx", newHeight]];
    }

    return style;
}

- (NSString*)descriptionWithScaledAndExtractedImages:(NSString*)oldDescription
{
    NSMutableString *newDescription;
    NSArray *splitDescription = [oldDescription componentsSeparatedByString:@"<img"];

    if (!splitDescription)
        return oldDescription;

    int length = [splitDescription count];

    if (length == 0)
        return oldDescription;

    if (length == 1 && [((NSString *)[splitDescription objectAtIndex:0]) isEqualToString:oldDescription])
        return oldDescription;

    newDescription = [NSMutableString stringWithString:[splitDescription objectAtIndex:0]];

    for (NSUInteger i = 1; i < length; i++)
    {
        NSString *currentString = [splitDescription objectAtIndex:i];

        // TODO: Do we need the try/catch??
        @try {
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
            {
                NSString *styleMatchers = @"(.+?)style=\"(.+?)\"(.+?)/>(.+)";
                NSArray *styleCaptures =
                            [currentString captureComponentsMatchedByRegex:styleMatchers
                                                                   options:RKLCaseless | RKLDotAll
                                                                     range:NSMakeRange(0, [currentString length])
                                                                     error:nil];

                // TODO: Will this ever be null, or just empty
                if (!styleCaptures)
                    [newDescription appendFormat:@"<img %@", currentString];
                else if ([styleCaptures count] != 5)
                    [newDescription appendFormat:@"<img %@", currentString];
                else
                    [newDescription appendFormat:@"<img %@ style=\"%@\" %@/>%@",
                            [styleCaptures objectAtIndex:1], [self scaledWidthAndHeight:[styleCaptures objectAtIndex:2]],
                            [styleCaptures objectAtIndex:3], [styleCaptures objectAtIndex:4]];
            }
            else
            {
                [newDescription appendFormat:@"<img %@", currentString];
            }

            NSString *srcMatchers = @"(.+?)src=\"(.+?)\"(.+?)/>(.+)";
            NSArray *srcCaptures =
                        [currentString captureComponentsMatchedByRegex:srcMatchers
                                                               options:RKLCaseless
                                                                 range:NSMakeRange(0, [currentString length])
                                                                 error:nil];

            if ([srcCaptures count] == 5)
                [self addStoryImage:[srcCaptures objectAtIndex:2]];

        } @catch (NSException *e) {
            DLog(@"Exception: %@", [e description]);
            [newDescription appendFormat:@"<img %@", currentString];
        }
    }

    return [NSString stringWithString:newDescription];
}

- (void)setHtmlText:(NSString*)newHtmlText
{
    [htmlText release];

    htmlText = [[self descriptionWithScaledAndExtractedImages:newHtmlText] retain];
    [self setPlainText:[[htmlText stringWithCommentedOutHTMLStyleTags] stringByConvertingHTMLToPlainText]];
}

- (void)setPubDate:(NSString*)newPubDate
{
    NSRange rangeOfDashColonTimezone = [newPubDate rangeOfString:@"-:"];
    if (rangeOfDashColonTimezone.location == NSNotFound)
        goto JUST_FINISH;

    newPubDate = [newPubDate substringToIndex:rangeOfDashColonTimezone.location];

//    NSError *error;
//    NSString *pattern = @"[0-9]{4}-[0-9]{2}-[0-9]{2}([A-Za-z]{3})[0-9]{2}:[0-9]{2}:[0-9]{2}";
//    NSArray *matcher = [_pubDate captureComponentsMatchedByRegex:pattern
//                                                               options:RKLCaseless
//                                                                 range:NSMakeRange(0, [_pubDate length])
//                                                                 error:&error];
//
//    if (error || [matcher count] < 2)
//        goto JUST_FINISH;
//
//    NSString *timezone = [matcher objectAtIndex:1];
//
//    _pubDate = [_pubDate stringByReplacingOccurrencesOfString:timezone withString:@"T"];

    NSDate *date = [NSDate dateFromRFC3339String:newPubDate];

    if (!date)
        goto JUST_FINISH;

    if ([NSDateFormatter resolveClassMethod:@selector(localizedStringFromDate:dateStyle:timeStyle:)])
        newPubDate = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];

JUST_FINISH:
    [pubDate release];
    pubDate = [newPubDate retain];
}

- (void)dealloc
{
    [title release];
    [link release];
    [htmlText release];
    [author release];
    [pubDate release];
    [plainText release];

    [feedUrl release];

    [storyImages release];
    [super dealloc];
}
@end

@interface Feed ()
- (void)loadStories;
- (void)saveStories;
@end

@implementation Feed
@synthesize url;
@synthesize rssUrl;

- (id)init
{
    self = [super init];

    if (self)
    {
        title = @"Janrain | Blog";
        url = @"http://www.janrain.com";
        rssUrl = @"http://www.janrain.com/feed/blogs";
        stories = nil;
        storyLinks = nil;

        [self loadStories];
    }

    return self;
}

- (NSMutableArray*)stories
{
//    if (!stories)
//        stories = [[NSMutableArray alloc] initWithCapacity:20];

    return stories;
}

- (BOOL)isNewStory:(Story*)story addAtIndex:(NSUInteger)index
{
    if ([storyLinks containsObject:[story link]])
        return NO;

    if (index > [stories count])
        [stories addObject:story];
    else
        [stories insertObject:story atIndex:index];

    [storyLinks addObject:[story link]];

    while ([stories count] > 30)
    {
        Story *lastStory = [stories lastObject];
        [lastStory deleteImagesFromDisk];
        [stories removeLastObject];
        [storyLinks removeObject:[lastStory link]];
    }

    return YES;
}

- (void)saveStories
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:stories]
                                              forKey:QUICK_PUBLISH_CACHED_STORIES];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:storyLinks]
                                              forKey:QUICK_PUBLISH_CACHED_STORY_LINKS];

    NSString *currentVersion = [[NSDictionary dictionaryWithContentsOfFile:
                                                 [[[NSBundle mainBundle] bundlePath]
                                                 stringByAppendingPathComponent:@"Info.plist"]]
                                 objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:QUICK_PUBLISH_CACHED_VERSION];
}

- (void)loadStories
{
    NSString *cachedVersion  = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_VERSION];
    NSString *currentVersion = [[NSDictionary dictionaryWithContentsOfFile:
                                                 [[[NSBundle mainBundle] bundlePath]
                                                 stringByAppendingPathComponent:@"Info.plist"]]
                                 objectForKey:@"CFBundleVersion"];

    if ([cachedVersion isEqualToString:currentVersion])
    {
        NSData *archivedStories = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_STORIES];
        if (archivedStories != nil)
        {
            NSArray *unarchivedStories = [NSKeyedUnarchiver unarchiveObjectWithData:archivedStories];
            if (unarchivedStories != nil)
                stories = [[NSMutableArray alloc] initWithArray:unarchivedStories];
        }

        NSData *archivedStoryLinks = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_STORY_LINKS];
        if (archivedStoryLinks != nil)
        {
            NSSet *unarchivedStoryLinks = [NSKeyedUnarchiver unarchiveObjectWithData:archivedStoryLinks];
            if (unarchivedStoryLinks != nil)
                storyLinks = [[NSMutableSet alloc] initWithSet:unarchivedStoryLinks];
        }
    }

    /* If this is the first time this is running, the classes changed between versions, or anything went wrong */
    if (!stories || !storyLinks || ![stories count] || ![storyLinks count])
    {
        storyLinks = [[NSMutableSet alloc] initWithCapacity:25];
        stories = [[NSMutableArray alloc] initWithCapacity:25];
    }
}

- (void)dealloc
{
    [url release];
    [title release];
    [link release];

    [stories release];
    [storyLinks release];

    [super dealloc];
}
@end

@interface FeedReader ()
@property (retain) NSXMLParser     *parser;
@property (retain) Story           *currentStory;
@property (retain) NSString        *currentElement;
@property (retain) NSMutableString *currentContent;
@property          NSUInteger       counter;
@property (retain) id<FeedReaderDelegate>feedReaderDelegate;
@end

@implementation FeedReader
@synthesize parser;
@synthesize currentStory;
@synthesize currentElement;
@synthesize currentContent;
@synthesize counter;
@synthesize feedReaderDelegate;
@synthesize libraryDialogDelegate;
@synthesize jrEngage;
@synthesize currentlyReloadingBlog;
@synthesize selectedStory;
@dynamic dateOfLastUpdate;

static FeedReader* singleton = nil;
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self feedReader] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

//static NSString *appId = @"<your_app_id>";
//static NSString *tokenUrl = @"<your_token_url>";

- (id)init
{
    self = [super init];
    if (self)
    {
        singleton = self;
        feed      = [[Feed alloc] init];
        jrEngage  = [JREngage jrEngageWithAppId:appId andTokenUrl:nil/*tokenUrl*/ delegate:self];
    }

    return self;
}

+ (FeedReader*)feedReader
{
    if(singleton)
        return singleton;

    return [[[super allocWithZone:nil] init] autorelease];
}

- (void)downloadFeed:(id<FeedReaderDelegate>)delegate
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;

    currentlyReloadingBlog = YES;

    [self setFeedReaderDelegate:delegate];
    counter = 0;

    DLog(@"Initializing feed");
    NSURL *xmlURL = [NSURL URLWithString:[feed rssUrl]];

    DLog(@"Initializing xml parser");
    parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];

    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];

    DLog(@"Starting to parse the Janrain Blog feed");
    [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser*)xmlParser
{
    DLog(@"Found the feed and started parsing");
}

- (void)feedDidFinishDownloading
{
    currentlyReloadingBlog = NO;

    [feedReaderDelegate feedDidFinishDownloading];
    [feedReaderDelegate release], feedReaderDelegate = nil;

    [feed saveStories];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:QUICK_PUBLISH_LAST_UPDATE_DATE];
}

- (void)feedDidFailToDownload
{
    currentlyReloadingBlog = NO;

    [feedReaderDelegate feedDidFailToDownload];
    [feedReaderDelegate release], feedReaderDelegate = nil;

    [feed saveStories];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:QUICK_PUBLISH_LAST_UPDATE_DATE];
}

- (NSDate*)dateOfLastUpdate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_LAST_UPDATE_DATE];
}

- (void)parser:(NSXMLParser*)xmlParser parseErrorOccurred:(NSError*)parseError
{
//  NSString *errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
    if ([parseError code] == 512)
        DLog(@"Error parsing XML: %@", [parseError description]);
    else
        DLog(@"Duplicate story found; stopping xml parse");

    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;

//    UIAlertView * errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error loading content"
//                                                           message:errorString
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil] autorelease];
//  [errorAlert show];

    if ([parseError code] == 512)
        [self feedDidFinishDownloading];
    else
        [self feedDidFailToDownload];
}

- (void)parser:(NSXMLParser*)xmlParser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
    DLog(@"Started element: %@", elementName);

    currentElement = [[NSString alloc] initWithString:elementName];
    if ([elementName isEqualToString:@"item"])
    {
        currentStory = [[Story alloc] init];
        [currentStory setFeedUrl:feed.url];
    }
    else if ([elementName isEqualToString:@"description"])
    { // TODO: This else block appears to do nothing different...
        currentContent = [[NSMutableString alloc] init];
    }
    else
    {
        currentContent = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser*)xmlParser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        if (![feed isNewStory:currentStory addAtIndex:counter])
            [parser abortParsing];
        [currentStory release], currentStory = nil;
        counter++;
    }
    else if ([currentElement isEqualToString:@"title"])
        [currentStory setTitle:currentContent];
    else if ([currentElement isEqualToString:@"link"])
        [currentStory setLink:currentContent];
    else if ([currentElement isEqualToString:@"description"])
        [currentStory setHtmlText:currentContent];
    else if ([currentElement isEqualToString:@"pubDate"])
        [currentStory setPubDate:currentContent];
    else if ([currentElement isEqualToString:@"dc:creator"])
        [currentStory setAuthor:currentContent];

    [currentElement release], currentElement = nil;
    [currentContent release], currentContent = nil;
}

- (void)parser:(NSXMLParser*)xmlParser foundCharacters:(NSString*)string
{
    if ([currentElement isEqualToString:@"dc:creator"])
        DLog(@"Found characters: %@", string);

    if ([currentElement isEqualToString:@"title"]       ||
        [currentElement isEqualToString:@"link"]        ||
        [currentElement isEqualToString:@"description"] ||
        [currentElement isEqualToString:@"pubDate"]     ||
        [currentElement isEqualToString:@"dc:creator"])
        [currentContent appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser*)xmlParser
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;

    DLog(@"All done!");
    DLog(@"Stories array has %d items", [feed.stories count]);

    [self feedDidFinishDownloading];
}

- (NSArray*)allStories
{
    return [NSArray arrayWithArray:feed.stories];
}

/* Entire JREngageDelegate protocol */
- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sharing Failed"
                                                     message:@"An error occurred while attempting to share this article.  Please try again."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];

    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
        [libraryDialogDelegate libraryDialogClosed];
}

//- (void)jrAuthenticationDidNotComplete { }
//- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider { }
//- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider { }
//- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider { }
//- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider { }

- (void)jrSocialDidNotCompletePublishing
{
    DLog(@"");
    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
            [libraryDialogDelegate libraryDialogClosed];
}

- (void)jrSocialDidCompletePublishing
{
    DLog(@"");
    if ([libraryDialogDelegate respondsToSelector:@selector(libraryDialogClosed)])
            [libraryDialogDelegate libraryDialogClosed];
}

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider { DLog(@""); }
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider { DLog(@""); }

- (void)dealloc {

    [super dealloc];
}
@end
