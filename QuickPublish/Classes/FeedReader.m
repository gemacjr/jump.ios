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
 
 File:	 FeedReader.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "FeedReader.h"
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define QUICK_PUBLISH_CACHED_STORIES @"quickpublish.feeddata.cachedstories"
#define QUICK_PUBLISH_CACHED_STORY_LINKS @"quickpublish.feeddata.cachedstorylinks"

@interface StoryImage ()
- (void)setAlt:(NSString*)_alt;
- (void)downloadImage;
@end

@implementation StoryImage
@synthesize alt;
@synthesize src;
@synthesize height;
@synthesize width;
@synthesize image;
@synthesize downloadFailed;

- (id)initWithSrc:(NSString*)_src
{
    if (_src == nil)
    {
        [self release];
        return nil;
    }
    
    if ([super init])
    {
        src = [_src retain];
    }
    
    return self;
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    image = [[UIImage imageWithData:payload] retain];
    
    if (!image)
        downloadFailed = YES;
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }
- (void)connectionDidFailWithError:(NSError*)_error request:(NSURLRequest*)request andTag:(void*)userdata { downloadFailed = YES; }
- (void)connectionWasStoppedWithTag:(void*)userdata { }         
         
/* To save memory, image will only download itself if prompted to do so by the story. */
- (void)downloadImage
{
    NSURL *url = [NSURL URLWithString:src];
    
    if(!url)
        return;
    
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:nil];
}

- (void)setAlt:(NSString*)_alt
{
	[alt release];
	alt = [_alt retain];
}

- (void)dealloc
{
    [src release];
    [alt release];
    [image release];
    
    [super dealloc];
}
@end

@interface Story ()
- (void)setTitle:(NSString*)_title;
- (void)setLink:(NSString*)_link;
- (void)setDescription:(NSString*)_description;
- (void)setAuthor:(NSString*)_author;
- (void)setPubDate:(NSString*)_pubDate;
- (void)setPlainText:(NSString*)_plainText;
- (void)addStoryImage:(NSString*)_storyImage;
- (void)setFeedUrl:(NSString*)_feedUrl;
@end


@implementation Story
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize author;
@synthesize pubDate;
@synthesize plainText;
@synthesize storyImages;
@synthesize feedUrl;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:link forKey:@"link"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeObject:author forKey:@"author"];
    [coder encodeObject:pubDate forKey:@"pubDate"];
    [coder encodeObject:plainText forKey:@"plainText"];
    [coder encodeObject:storyImageUrls forKey:@"storyImageUrls"];
    [coder encodeObject:feedUrl forKey:@"feedUrl"];
}

- (id)initWithCoder:(NSCoder *)coder
{    
    self = [[Story alloc] init];
    if (self != nil)
    {
        title = [[coder decodeObjectForKey:@"title"] retain];
        link = [[coder decodeObjectForKey:@"link"] retain];
        description = [[coder decodeObjectForKey:@"description"] retain];
        author = [[coder decodeObjectForKey:@"author"] retain];
        pubDate = [[coder decodeObjectForKey:@"pubDate"] retain];
        plainText = [[coder decodeObjectForKey:@"plainText"] retain];
        storyImageUrls = [[coder decodeObjectForKey:@"storyImageUrls"] retain];
        feedUrl = [[coder decodeObjectForKey:@"feedUrl"] retain];
    }   
    
    return self;
}

- (void)setTitle:(NSString*)_title
{
	[title release];
	title = [[[_title stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"]
                      stringByReplacingOccurrencesOfString:@"%34" withString:@"\""] retain];
}

- (void)setLink:(NSString*)_link
{
	[link release];
	link = [_link retain];
}

- (void)setDescription:(NSString*)_description
{
    [description release];
	description = [[_description stringByReplacingOccurrencesOfString:@"%34" withString:@"\""] retain];
    
    [self setPlainText:_description];
}

- (void)setAuthor:(NSString*)_author
{
	[author release];
	author = [_author retain];
}

- (void)setPubDate:(NSString*)_pubDate
{
    [pubDate release];
    pubDate = [_pubDate retain];
}

- (void)setPlainText:(NSString*)_plainText
{
    [plainText release];
    plainText = [[_plainText stringByReplacingOccurrencesOfString:@"%34" withString:@"\""] retain];
}

- (void)addStoryImage:(NSString*)_storyImage
{
    if (!storyImages)
        storyImages = [[NSMutableArray alloc] initWithCapacity:1];

    if (![_storyImage hasPrefix:@"http"])
    {
        _storyImage = [NSString stringWithFormat:@"%@%@", self.feedUrl, _storyImage];
    }
    
    StoryImage *image = [[[StoryImage alloc] initWithSrc:_storyImage] autorelease];
    
    [storyImages addObject:image];
    [storyImageUrls addObject:_storyImage];
    
 /* Only download the first coupla images */
    if ([storyImages count] <= 2)
        [image downloadImage];
}

- (void)setFeedUrl:(NSString*)_feedUrl
{
    [feedUrl release];
    feedUrl = [_feedUrl retain];
}

- (void)dealloc
{
	[title release];
	[link release];
	[description release];
	[author release];
	[pubDate release];
    [plainText release];
    
    [feedUrl release];

    [storyImages release];
    [storyImageUrls release];
	[super dealloc];
}
@end

@interface Feed ()
//- (void)setUrl:(NSString*)_url;
//- (void)setTitle:(NSString*)_title;
//- (void)setLink:(NSString*)_link;

@property (readonly) NSString *url;
@end


@implementation Feed
@synthesize url;
@synthesize title;
@synthesize link;

- (id)init 
{
    if (self = [super init])
	{
        title = @"Janrain | Blog";
        link = @"http://www.janrain.com";
        url = @"http://www.janrain.com/feed/blogs";
        
        NSData *archivedStories = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_STORIES];
        if (archivedStories != nil)
        {
            NSArray *unarchivedStories = [NSKeyedUnarchiver unarchiveObjectWithData:archivedStories];
            if (unarchivedStories != nil)
                stories = [[NSMutableArray alloc] initWithArray:unarchivedStories];
            else
                stories = [[NSMutableArray alloc] initWithCapacity:25];
        }

        NSData *archivedStoryLinks = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_STORY_LINKS];
        if (archivedStoryLinks != nil)
        {
            NSSet *unarchivedStoryLinks = [NSKeyedUnarchiver unarchiveObjectWithData:archivedStoryLinks];
            if (unarchivedStoryLinks == nil || [stories count] == 0)
                storyLinks = [[NSMutableSet alloc] initWithCapacity:25];
            else
                storyLinks = [[NSMutableArray alloc] initWithSet:unarchivedStoryLinks];
        }
	}
	
	return self;	
}

//- (void)encodeWithCoder:(NSCoder *)coder
//{
//    [coder encodeObject:url forKey:@"url"];
//    [coder encodeObject:title forKey:@"title"];
//    [coder encodeObject:link forKey:@"link"];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:stories] 
//                                              forKey:QUICK_PUBLISH_CACHED_STORIES];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:storyLinks] 
//                                              forKey:QUICK_PUBLISH_CACHED_STORY_LINKS];
//}
//
//- (id)initWithCoder:(NSCoder *)coder
//{    
//    self = [[Feed alloc] init];
//    if (self != nil)
//    {
//        url = [[coder decodeObjectForKey:@"url"] retain];
//        title = [[coder decodeObjectForKey:@"title"] retain];
//        link = [[coder decodeObjectForKey:@"link"] retain];
//        
//        NSData *archivedStories = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_STORIES];
//        if (archivedStories != nil)
//        {
//            NSArray *unarchivedStories = [NSKeyedUnarchiver unarchiveObjectWithData:archivedStories];
//            if (unarchivedStories != nil)
//                stories = [[NSMutableArray alloc] initWithArray:unarchivedStories];
//            else
//                stories = [[NSMutableArray alloc] initWithCapacity:25];
//        }
//
//        NSData *archivedStoryLinks = [[NSUserDefaults standardUserDefaults] objectForKey:QUICK_PUBLISH_CACHED_STORY_LINKS];
//        if (archivedStoryLinks != nil)
//        {
//            NSSet *unarchivedStoryLinks = [NSKeyedUnarchiver unarchiveObjectWithData:archivedStoryLinks];
//            if (unarchivedStoryLinks == nil || [stories count] == 0)
//                storyLinks = [[NSMutableSet alloc] initWithCapacity:25];
//            else
//                storyLinks = [[NSMutableArray alloc] initWithArray:unarchivedStoryLinks];
//        }
//    }   
//    
//    return self;
//}

//- (void)setUrl:(NSString*)_url
//{
//	[url release];
//	url = [_url retain];
//}
//
//- (void)setTitle:(NSString*)_title
//{
//	[title release];
//	title = [_title retain];
//}
//
//- (void)setLink:(NSString*)_link
//{
//	[link release];
//	link = [_link retain];
//}

- (NSMutableArray*)stories
{
//    if (!stories)
//        stories = [[NSMutableArray alloc] initWithCapacity:20];
    
    return stories;
}

- (BOOL)newStory:(Story*)story addAtIndex:(int)index 
{
//    if ([storyLinks containsObject:[story link]])
//        return NO;
    
    @try 
    {
        [stories insertObject:story atIndex:index];
        [storyLinks addObject:[story link]];
    }
    @catch (NSException *e)
    {
        [stories insertObject:story atIndex:0];
        [storyLinks addObject:[story link]];
    }
    
    return YES;
}

- (void)saveStories
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:stories] 
                                              forKey:QUICK_PUBLISH_CACHED_STORIES];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:storyLinks] 
                                              forKey:QUICK_PUBLISH_CACHED_STORY_LINKS];    
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
Story *currentStory;
int counter;
//NSString *currentElement; 
//NSString *currentTitle;
//NSString *currentDate;
//NSString *currentLink;
//NSString *currentDescription;
//NSString *currentAuthor;
//
//@property (retain) NSString *currentElement; 
//@property (retain) NSString *currentTitle;
//@property (retain) NSString *currentDate;
//@property (retain) NSString *currentLink;
//@property (retain) NSString *currentDescription;
//@property (retain) NSString *currentAuthor;
- (void)downloadFeedStories;
@end


@implementation FeedReader
@synthesize selectedStory;
@synthesize jrEngage;
@synthesize feedReaderDetail;

//@synthesize currentDate;
//@synthesize currentTitle;
//@synthesize currentLink;
//@synthesize currentAuthor;
//@synthesize currentDescription;

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
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

//static NSString *appId = @"<your_app_id>";
//static NSString *tokenUrl = @"<your_token_url>";

- (id)init
{
	if (self = [super init]) 
	{
        singleton = self;
        jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:nil/*tokenUrl*/ delegate:self];

        [self downloadFeedStories];
	}
    
	return self;
}

+ (FeedReader*)feedReader
{
	if(singleton)
		return singleton;
    
	return [[super allocWithZone:nil] init];
}

- (void)downloadFeedStories
{   
    UIApplication *app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = YES;
        
    counter = 0;
    
    DLog(@"Initializing feed");
    feed = [[Feed alloc] init];
	NSURL *xmlURL = [NSURL URLWithString:[feed url]];
	
    DLog(@"Initializing xml parser");
	parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
    DLog(@"Starting to parse the Janrain Blog feed");
    [parser parse];
        
//    NSArray *stories = [janrain_blog_dictionary objectForKey:@"feed"];
//    
//    for (NSDictionary *item in stories)
//    {
//        Story *story = [[[Story alloc] init] autorelease];
//        NSDictionary *story_dict = [item objectForKey:@"story"];
//        
//        [story setTitle:[story_dict objectForKey:@"title"]];
//        [story setLink:[story_dict objectForKey:@"link"]];
//        [story setDescription:[story_dict objectForKey:@"description"]];
//        [story setAuthor:[story_dict objectForKey:@"creator"]];
//        [story setPubDate:[story_dict objectForKey:@"date"]];
//        [story setPlainText:[story_dict objectForKey:@"plainText"]];
//        [story setFeed:feed];
//        
//        NSArray *images = [story_dict objectForKey:@"images"];
//        
//        for (NSString *image in images)
//        {
//            [story addStoryImage:image];
//        }
//        
//        [feed.stories addObject:story];
//    }
//    
//    app.networkActivityIndicatorVisible = NO;
}

- (void)parserDidStartDocument:(NSXMLParser*)xmlParser
{
	DLog(@"Found the feed and started parsing");
}

- (void)parser:(NSXMLParser*)xmlParser parseErrorOccurred:(NSError*)parseError 
{
	NSString *errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];

	DLog(@"Error parsing XML: %@", errorString);
	
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" 
                                                          message:errorString 
                                                         delegate:self 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser*)xmlParser didStartElement:(NSString*)elementName 
  namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName 
    attributes:(NSDictionary*)attributeDict
{
	DLog(@"Started element: %@", elementName);

	currentElement = [[NSString alloc] initWithString:elementName];
	if ([elementName isEqualToString:@"item"]) 
	{
        DLog(@"Element is a story");
        currentStory = [[Story alloc] init];
        [currentStory setFeedUrl:feed.url];
//		currentTitle = [[NSMutableString alloc] init];
//		currentDate = [[NSMutableString alloc] init];
//		currentDescription = [[NSMutableString alloc] init];
//		currentLink = [[NSMutableString alloc] init];
//      currentAuthor = [[NSMutableString alloc] init];
//      currentPlainText = [[NSMutableString alloc] init];
	}
    else
    {
        currentContent = [[NSMutableString alloc] init];
    }

}

- (void)parser:(NSXMLParser*)xmlParser didEndElement:(NSString*)elementName 
  namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	NSLog(@"Ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) 
	{
        DLog(@"Element is a story");
//        [currentStory setTitle:currentTitle];
//        [currentStory setLink:currentLink];
//        [currentStory setDescription:currentDescription];
//        [currentStory setAuthor:currentAuthor];
//        [currentStory setPubDate:currentDate];
//        [currentStory setPlainText:[self removeHtmlFromString:currentDescription]];
//        [currentStory setFeed:feed];
        
        if (![feed newStory:currentStory addAtIndex:counter])
            [parser abortParsing];

		NSLog(@"Adding story: %@", [currentStory title]);        
        
        [currentStory release], currentStory = nil;
        counter++;
	}
    else if ([currentElement isEqualToString:@"title"]) 
        [currentStory setTitle:currentContent];
	else if ([currentElement isEqualToString:@"link"]) 
        [currentStory setLink:currentContent];
	else if ([currentElement isEqualToString:@"description"]) 
        [currentStory setDescription:currentContent];
	else if ([currentElement isEqualToString:@"pubDate"]) 
        [currentStory setPubDate:currentContent];
    else if ([currentElement isEqualToString:@"dc:creator"])
        [currentStory setAuthor:currentContent];
    
    [currentElement release], currentElement = nil;
    [currentContent release], currentContent = nil;
}

//- (NSString*)removeHtmlFromString:(NSString*)htmlString
//{
//    return htmlString;
//}

- (void)parser:(NSXMLParser*)xmlParser foundCharacters:(NSString*)string
{
	DLog(@"Found characters: %@", string);

	if ([currentElement isEqualToString:@"title"] ||
        [currentElement isEqualToString:@"link"] ||
        [currentElement isEqualToString:@"description"] ||
        [currentElement isEqualToString:@"pubDate"] ||
        [currentElement isEqualToString:@"dc:creator"])
        [currentContent appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser*)xmlParser
{
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = NO;
	
    DLog(@"All done!");
	DLog(@"Stories array has %d items", [feed.stories count]);
	
    [feed saveStories];
}


//- (void)downloadFeedStories
//{   
//    UIApplication* app = [UIApplication sharedApplication]; 
//    app.networkActivityIndicatorVisible = YES;
//
//    NSError *error = nil;
//    NSURL *path = [NSURL URLWithString:@"http://www.janrain.com/misc/janrain_blog.txt"];
//    NSString *janrain_blog_json = [[[NSString alloc] initWithContentsOfURL:path
//                                                                  encoding:NSUTF8StringEncoding
//                                                                     error:&error] autorelease];
//    
//    NSDictionary *janrain_blog_dictionary = nil;
//    
//    if (!error)
//        janrain_blog_dictionary = [janrain_blog_json JSONValue];  
//    else
//        error = nil;
//    
//    if (!janrain_blog_dictionary)
//    {
//        NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"janrain_blog" ofType:@"json"];  
//        janrain_blog_json = [NSString stringWithContentsOfFile:pathStr encoding:NSUTF8StringEncoding error:&error];
//        
//        if (error)
//            return;
//        
//        janrain_blog_dictionary = [janrain_blog_json JSONValue];  
//        
//        if (!janrain_blog_json)
//            return;
//    }
//        
//    feed = [[Feed alloc] init];
//    [feed setTitle:@"Janrain | Blog"];
//    [feed setLink:@"http://www.janrain.com"];
//
//    NSArray *stories = [janrain_blog_dictionary objectForKey:@"feed"];
//    
//    for (NSDictionary *item in stories)
//    {
//        Story *story = [[[Story alloc] init] autorelease];
//        NSDictionary *story_dict = [item objectForKey:@"story"];
//        
//        [story setTitle:[story_dict objectForKey:@"title"]];
//        [story setLink:[story_dict objectForKey:@"link"]];
//        [story setDescription:[story_dict objectForKey:@"description"]];
//        [story setAuthor:[story_dict objectForKey:@"creator"]];
//        [story setPubDate:[story_dict objectForKey:@"date"]];
//        [story setPlainText:[story_dict objectForKey:@"plainText"]];
//        [story setFeed:feed];
//        
//        NSArray *images = [story_dict objectForKey:@"images"];
//        
//        for (NSString *image in images)
//        {
//            [story addStoryImage:image];
//        }
//        
//        [feed.stories addObject:story];
//    }
//    
//    app.networkActivityIndicatorVisible = NO;
//}

- (NSArray*)allStories
{
    return feed.stories;
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error 
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sharing Failed"
                                                     message:@"An error occurred while attempting to share this article.  Please try again."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

/* Entire JREngageDelegate protocol */
//- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error { }
//- (void)jrAuthenticationDidNotComplete { }
//- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider { }
//- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider { }
//- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider { }
//- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider { }
//- (void)jrSocialDidNotCompletePublishing { }
//- (void)jrSocialDidCompletePublishing { }
//- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider { }
//- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider { }
@end
