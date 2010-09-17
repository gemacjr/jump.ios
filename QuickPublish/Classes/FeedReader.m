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

@interface NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped;
@end


@implementation NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%34"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%38"];
    
    return str;
}
@end

@interface StoryImage ()
- (void)setAlt:(NSString*)_alt;
//- (void)setHeight:(CGFloat)_height;
//- (void)setWidth:(CGFloat)_width;
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
        
//        NSURL *url = [NSURL URLWithString:src];
//        
//        if(!url)
//            return self;
//        
//        NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
//        [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:nil stringEncodeData:NO];
    }
    
    return self;
}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata 
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
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:nil stringEncodeData:NO];    
}

- (void)setAlt:(NSString*)_alt
{
	[alt release];
	alt = [_alt retain];
}

//- (void)setHeight:(CGFloat)_height
//{
//	height = _height;
//}
//
//- (void)setWidth:(CGFloat)_width
//{
//	width = _width;
//}

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
- (void)setFeed:(Feed*)_feed;
@end


@implementation Story
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize author;
@synthesize pubDate;
@synthesize plainText;
@synthesize storyImages;
@synthesize feed;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:link forKey:@"link"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeObject:author forKey:@"author"];
    [coder encodeObject:pubDate forKey:@"pubDate"];
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
    }   
    
    return self;
}

- (void)setTitle:(NSString*)_title
{
	[title release];
	title = [_title retain];
    DLog(@"title:\t\t\t%@", title);
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
    plainText = [_plainText retain];
}

- (void)addStoryImage:(NSString*)_storyImage
{
    if (!storyImages)
        storyImages = [[NSMutableArray alloc] initWithCapacity:1];

    DLog(@"storyImages:\t\t\t%@", _storyImage);

//    _storyImage = [_storyImage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (![_storyImage hasPrefix:@"http"])
    {
        _storyImage = [NSString stringWithFormat:@"%@%@", self.feed.link, _storyImage];
    }
    
    StoryImage *image = [[[StoryImage alloc] initWithSrc:_storyImage] autorelease];
    
    [storyImages addObject:image];
    
    /* Only download the first coupla images */
    if ([storyImages count] <= 2)
        [image downloadImage];
}

- (void)setFeed:(Feed*)_feed
{
    [feed release];
    feed = [_feed retain];
}

- (void)dealloc
{
	[title release];
	[link release];
	[description release];
	[author release];
	[pubDate release];
    [plainText release];
    
    [feed release];

    [storyImages release];
	[super dealloc];
}
@end

@interface Feed ()
- (void)setUrl:(NSString*)_url;
- (void)setTitle:(NSString*)_title;
- (void)setLink:(NSString*)_link;

@property (readonly) NSString *url;
@end


@implementation Feed
@synthesize url;
@synthesize title;
@synthesize link;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:url forKey:@"url"];
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:link forKey:@"link"];
}

- (id)initWithCoder:(NSCoder *)coder
{    
    self = [[Feed alloc] init];
    if (self != nil)
    {
        url = [[coder decodeObjectForKey:@"url"] retain];
        title = [[coder decodeObjectForKey:@"title"] retain];
        link = [[coder decodeObjectForKey:@"link"] retain];
        
        stories = nil;
    }   
    
    return self;
}

- (void)setUrl:(NSString*)_url
{
	[url release];
	url = [_url retain];
}

- (void)setTitle:(NSString*)_title
{
	[title release];
	title = [_title retain];
}

- (void)setLink:(NSString*)_link
{
	[link release];
	link = [_link retain];
}

- (NSMutableArray*)stories
{
    if (!stories)
        stories = [[NSMutableArray alloc] initWithCapacity:20];
    
    return stories;
}

- (void)dealloc
{
    [url release];
    
 	[title release];
    [link release];
    
    [stories release];
    
    [super dealloc];
}
@end

@interface FeedReader ()
- (void)downloadFeedStories;
@end


@implementation FeedReader
@synthesize selectedStory;
@synthesize jrEngage;
@synthesize feedReaderDetail;

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

static NSString *appId = @"pdjicmldlhebgeepdbdn";
static NSString *tokenUrl = @"http://social-tester.appspot.com/login";

- (id)init
{
	if (self = [super init]) 
	{
        singleton = self;
        
//        NSData *archivedFeeds = [[NSUserDefaults standardUserDefaults] objectForKey:@"archivedFeeds"];
//        if (archivedFeeds != nil)
//        {
//            NSDictionary *unarchivedFeeds = [NSKeyedUnarchiver unarchiveObjectWithData:archivedFeeds];
//            if (unarchivedFeeds != nil)
//                feeds = [[NSMutableDictionary alloc] initWithDictionary:unarchivedFeeds];
//        }
//        
//        if (!feeds)
//            feeds = [[NSMutableDictionary alloc] initWithCapacity:1];
        
//        allStories = [[NSMutableArray alloc] initWithCapacity:25];//[feeds count]*20];
        
        jrEngage = [JREngage jrEngageWithAppID:appId andTokenUrl:tokenUrl delegate:self];
        
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

//+ (FeedReader*)initFeedReader
//{
//	if(singleton)
//		return singleton;
//    
//	return [[super allocWithZone:nil] init];
//}	


- (void)downloadFeedStories
{   
    NSError *error = nil;
    NSURL *path = [NSURL URLWithString:@"http://www.janrain.com/misc/janrain_blog.json"];//[[NSBundle mainBundle] pathForResource:@"janrain_blog" ofType:@"json"];  
    NSString *janrain_blog_json = [[[NSString alloc] initWithContentsOfURL:path
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:&error] autorelease];
    NSDictionary *janrain_blog_dictionary = [janrain_blog_json JSONValue];  

    if (!janrain_blog_dictionary)
        return;
    
    feed = [[Feed alloc] init];
    [feed setTitle:@"Janrain | Blog"];
    [feed setLink:@"http://www.janrain.com"];

    NSArray *stories = [janrain_blog_dictionary objectForKey:@"feed"];
    
    for (NSDictionary *item in stories)
    {
        Story *story = [[[Story alloc] init] autorelease];
        NSDictionary *story_dict = [item objectForKey:@"story"];
        
        [story setTitle:[story_dict objectForKey:@"title"]];
        [story setLink:[story_dict objectForKey:@"link"]];
        [story setDescription:[story_dict objectForKey:@"description"]];
        [story setAuthor:[story_dict objectForKey:@"creator"]];
        [story setPubDate:[story_dict objectForKey:@"date"]];
        [story setPlainText:[story_dict objectForKey:@"plainText"]];
        [story setFeed:feed];
        
        NSArray *images = [story_dict objectForKey:@"images"];
        
        for (NSString *image in images)
        {
            [story addStoryImage:image];
        }
        
        [feed.stories addObject:story];
    }
}

- (NSArray*)allStories
{
    return feed.stories;
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString *)provider 
{
    [feedReaderDetail authenticationFailed:error];
}
- (void)jrAuthenticationReceivedAuthenticationTokenForProvider:(NSString*)provider { }

- (void)jrEngageDialogDidFailToShow { }

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)_tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider { }
- (void)jrAuthenticationCallToTokenUrl:(NSString*)_tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider { }
- (void)jrAuthenticationDidNotComplete { }

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider { }
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailForProvider:(NSString*)provider { }
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider { }
- (void)jrSocialDidNotCompletePublishing { }
- (void)jrSocialDidCompletePublishing { }
@end
