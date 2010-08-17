//
//  FeedReader.m
//  Quick Share
//
//  Created by lilli on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedReader.h"

static NSDate* NSDateFromRfc822String(NSString* dateString)
{    
    /*  The <_pubDate> element in RSS 2.0 follows the date format specified in RFC822.
        The full version of RFC822 is EEE, dd MMM yyyy HH:mm:ss z (e.g., Fri, 12 Mar 2010 12:34:56 PST).
        Apparently, both the day of the week and seconds are optional, and the timezone may be listed
        as universal time ("UT" or "GMT"), a North American time zone abbreviation ("PST", etc.),
        military time ("Y:+12"), or +HHMM ("+0800").
     
        Because of the optional elements, this function will attempt to dynamically detect which bits
        are present, and set the date format correctly. 
     
        We will test for four different combinations:
            * EEE, dd MMM yyyy HH:mm:ss z => Fri, 12 Mar 2010 12:34:56 PST
            * dd MMM yyyy HH:mm:ss z      => 12 Mar 2010 12:34:56 PST
            * EEE, dd MMM yyyy HH:mm z    => Fri, 12 Mar 2010 12:34 PST
            * dd MMM yyyy HH:mm z         => 12 Mar 2010 12:34 PST
    */
    
    static NSDateFormatter *formatter = nil;
    
    NSRange rangeOfComma = [dateString rangeOfString:@","];
    NSArray *separatedByColons = [dateString componentsSeparatedByString:@":"];

    BOOL isDayOfWeek = NO;
    BOOL areSeconds = NO;
    
    if (rangeOfComma.location != NSNotFound) // That is, if we DID find a comma, then start the format with "EEE, "
        isDayOfWeek = YES;
    
    if ([separatedByColons count] > 2)
        areSeconds = YES;
    
    NSMutableString *format = [NSString stringWithFormat:
                               @"%@dd MMM yyyy HH:mm%@ z", 
                               (isDayOfWeek ? @"EEE, " : @""), 
                               (areSeconds ? @":ss" : @"")];
    
    if (formatter == nil) 
        formatter = [[NSDateFormatter alloc] init];
   
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:dateString];
}

static NSString* NSStringFromDate(NSDate* date)
{    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) 
        formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    return [formatter stringFromDate:date];
}

static NSDate* NSDateFromNonStandardDrupalString(NSString* dateString)
{    
    static NSDateFormatter *formatter = nil;
    
    NSRange rangeOfDate = { 0, 10 };
    NSRange rangeOfTime = { 13, 8 };
    
    /* String is coming in with weird format of "yyyy-MM-ddzzz(?)HH:mm:ss-:??", which doesn't seem 
       to want to get parsed.  I know it's a hack, but I'm going to chop the string into the 
       important bits (date and time) and just parse that. */
    
    NSString *newDateString = [[[dateString substringWithRange:rangeOfDate]
                                       stringByAppendingString:@" "]
                                       stringByAppendingString:
                                [dateString substringWithRange:rangeOfTime]];
    
    NSMutableString *format = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (formatter == nil) 
        formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:newDateString];
}

@interface StoryImage ()
- (void)setAlt:(NSString*)_alt;
- (void)setSrc:(NSString*)_src;
- (void)setHeight:(NSString*)_height;
- (void)setWidth:(NSString*)_width;
@end

@implementation StoryImage
@synthesize alt;
@synthesize src;
@synthesize height;
@synthesize width;

- (void)setAlt:(NSString*)_alt
{
	[alt release];
	alt = [_alt retain];
}

- (void)setSrc:(NSString*)_src
{
	[src release];
	src = [_src retain];
}

- (void)setHeight:(NSString*)_height
{
	[height release];
	height = [_height retain];
}

- (void)setWidth:(NSString*)_width
{
	[width release];
	width = [_width retain];
}
@end

@interface StoryEnclosure ()
- (void)setUrl:(NSString*)_url; 
- (void)setMimeType:(NSString*)_mimeType;
- (void)setLength:(NSInteger)_length;
- (void)setImage:(UIImage*)_image;
@end

@implementation StoryEnclosure
@synthesize url;
@synthesize mimeType;
@synthesize length;
@synthesize image;

- (void)setUrl:(NSString*)_url
{
    [url release];
    url = [_url retain];
}

- (void)setMimeType:(NSString*)_mimeType
{
    [mimeType release];
    mimeType = [_mimeType retain];
}

- (void)setLength:(NSInteger)_length
{
    length = _length;
}

- (void)setImage:(UIImage*)_image
{
    [image release];
    image = [_image retain];    
}
@end

@interface Story ()
- (void)setTitle:(NSString*)_title;
- (void)setLink:(NSString*)_link;
- (void)setDescription:(NSString*)_description;
- (void)setAuthor:(NSString*)_author;
- (void)setCategory:(NSString*)_category;
- (void)setComments:(NSString*)_comments;
- (void)setEnclosure:(StoryEnclosure*)_enclosure;
- (void)setGuid:(NSString*)_guid;
- (void)setPubDate:(NSString*)_pubDate;
- (void)setSource:(NSString*)_source;
- (void)setPlainText:(NSString*)_plainText;
- (void)addStoryImage:(NSDictionary*)_storyImage;
- (void)setFeed:(Feed*)_feed;
@end


@implementation Story
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize author;
@synthesize category;
@synthesize comments;
@synthesize enclosure;
@synthesize guid;
@synthesize pubDate;
@synthesize source;
@synthesize plainText;
@synthesize storyImages;
@synthesize feed;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:link forKey:@"link"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeObject:author forKey:@"author"];
    [coder encodeObject:category forKey:@"category"];
    [coder encodeObject:comments forKey:@"comments"];
    [coder encodeObject:enclosure forKey:@"enclosure"];
    [coder encodeObject:guid forKey:@"guid"];
    [coder encodeObject:pubDate forKey:@"pubDate"];
    [coder encodeObject:source forKey:@"source"];
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
        category = [[coder decodeObjectForKey:@"category"] retain];
        comments = [[coder decodeObjectForKey:@"comments"] retain];
        enclosure = [[coder decodeObjectForKey:@"enclosure"] retain];
        guid = [[coder decodeObjectForKey:@"guid"] retain];
        pubDate = [[coder decodeObjectForKey:@"pubDate"] retain];
        source = [[coder decodeObjectForKey:@"source"] retain];
    }   
    
    return self;
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

- (void)setDescription:(NSString*)_description
{
	description = [[NSString stringWithFormat:@"%@%@", (description ? description : @""), _description] retain];
}

- (void)setAuthor:(NSString*)_author
{
	[author release];
	author = [_author retain];
}

- (void)setCategory:(NSString*)_category
{
	category = [[NSString stringWithFormat:@"%@%@", (category ? category : @""), _category] retain];
}

- (void)setComments:(NSString*)_comments
{
	comments = [[NSString stringWithFormat:@"%@%@", (comments ? comments : @""), _comments] retain];
}

- (void)setEnclosure:(StoryEnclosure*)_enclosure
{
	[enclosure release];
	enclosure = [_enclosure retain];
}

- (void)setGuid:(NSString*)_guid
{
	[guid release];
	guid = [_guid retain];
}

- (void)setPubDate:(NSString*)_pubDate
{
    NSLog(@"\n"
          "_pubDate:   |%@| \n"
          "parsed:     |%@|", _pubDate, pubDate);

    [pubDate release];
    pubDate = [NSStringFromDate(NSDateFromNonStandardDrupalString(_pubDate)) retain];
    
}

- (void)setSource:(NSString*)_source
{
	[source release];
	source = [_source retain];
}

- (void)setPlainText:(NSString*)_plainText
{
    [plainText release];
    plainText = [_plainText retain];
}

- (void)addStoryImage:(NSDictionary*)_storyImage
{
    
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
	[category release];
	[comments release];
	[enclosure release];
	[guid release];
	[pubDate release];
	[source release];
    [feed release];

	[super dealloc];
}
@end

@interface FeedImage ()
- (void)setUrl:(NSString*)_url;
- (void)setTitle:(NSString*)_title;
- (void)setLink:(NSString*)_link; 
- (void)setDescription:(NSString*)_description;
- (void)setWidth:(NSInteger)_width;    
- (void)setHeight:(NSInteger)_height;   
@end

@implementation FeedImage
@synthesize url;
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize width;
@synthesize height;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:url forKey:@"url"];
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:link forKey:@"link"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeInteger:width forKey:@"width"];
    [coder encodeInteger:height forKey:@"height"];
}

- (id)initWithCoder:(NSCoder *)coder
{    
    self = [[Feed alloc] init];
    if (self != nil)
    {
        url = [[coder decodeObjectForKey:@"url"] retain];
        title = [[coder decodeObjectForKey:@"title"] retain];
        link = [[coder decodeObjectForKey:@"link"] retain];
        description = [[coder decodeObjectForKey:@"description"] retain];
        width = [coder decodeIntForKey:@"width"];
        height = [coder decodeIntForKey:@"height"];
    }   
    
    return self;
}


- (void)setUrl:(NSString*)_url
{
    url = [[NSString stringWithFormat:@"%@%@", (url ? url : @""), _url] retain];    
}

- (void)setTitle:(NSString*)_title
{
    title = [[NSString stringWithFormat:@"%@%@", (title ? title : @""), _title] retain];
}

- (void)setLink:(NSString*)_link
{
    link = [[NSString stringWithFormat:@"%@%@", (link ? link : @""), _link] retain];
}

- (void)setDescription:(NSString*)_description
{
    description = [[NSString stringWithFormat:@"%@%@", (description ? description : @""), _description] retain];
}

- (void)setWidth:(NSInteger)_width;    
{
    
}

- (void)setHeight:(NSInteger)_height;   
{
    
}
@end


@interface Feed ()
- (void)setTitle:(NSString*)_title;
- (void)setLink:(NSString*)_link;
- (void)setDescription:(NSString*)_description;
- (void)setLanguage:(NSString*)_language;
- (void)setCopyright:(NSString*)_copyright;
- (void)setManagingEditor:(NSString*)_managingEditor;
- (void)setWebMaster:(NSString*)_webMaster;
- (void)setPubDate:(NSString*)_pubDate;
- (void)setLastBuildDate:(NSString*)_lastBuildDate;
- (void)setCategory:(NSString*)_category;
- (void)setGenerator:(NSString*)_generator;
- (void)setDocs:(NSString*)_docs;
- (void)setCloud:(NSString*)_cloud;
- (void)setTtl:(NSString*)_ttl;
- (void)setRating:(NSString*)_rating;
- (void)setTextInput:(NSString*)_textInput;
- (void)setSkipHours:(NSString*)_skipHours;
- (void)setSkipDays:(NSString*)_skipDays;

- (void)setImage:(FeedImage*)_image;
@property (retain) NSMutableArray *stories;
@property (retain) Story *currentStory;
@property (retain) FeedImage *currentImage;
@property (retain) StoryEnclosure *currentEnclosure;
@property (retain) NSString *currentElement;
@end


@implementation Feed
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize language;
@synthesize copyright;
@synthesize managingEditor;
@synthesize webMaster;
@synthesize pubDate;
@synthesize lastBuildDate;
@synthesize category;
@synthesize generator;
@synthesize docs;
@synthesize cloud;
@synthesize ttl;
@synthesize image;
@synthesize rating;
@synthesize textInput;
@synthesize skipHours;
@synthesize skipDays;
@synthesize stories;
@synthesize currentStory;
@synthesize currentImage;
@synthesize currentElement;
@synthesize currentEnclosure;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:link forKey:@"link"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeObject:language forKey:@"language"];
    [coder encodeObject:copyright forKey:@"copyright"];
    [coder encodeObject:managingEditor forKey:@"managingEditor"];
    [coder encodeObject:webMaster forKey:@"webMaster"];
    [coder encodeObject:pubDate forKey:@"pubDate"];
    [coder encodeObject:lastBuildDate forKey:@"lastBuildDate"];
    [coder encodeObject:category forKey:@"category"];
    [coder encodeObject:generator forKey:@"generator"];
    [coder encodeObject:docs forKey:@"docs"];
    [coder encodeObject:cloud forKey:@"cloud"];
    [coder encodeObject:ttl forKey:@"ttl"];
    [coder encodeObject:image forKey:@"image"];
    [coder encodeObject:rating forKey:@"rating"];
    [coder encodeObject:textInput forKey:@"textInput"];
    [coder encodeObject:skipHours forKey:@"skipHours"];
    [coder encodeObject:skipDays forKey:@"skipDays"];
}

- (id)initWithCoder:(NSCoder *)coder
{    
    self = [[Feed alloc] init];
    if (self != nil)
    {
        title = [[coder decodeObjectForKey:@"title"] retain];
        link = [[coder decodeObjectForKey:@"link"] retain];
        description = [[coder decodeObjectForKey:@"description"] retain];
        language = [[coder decodeObjectForKey:@"language"] retain];
        copyright = [[coder decodeObjectForKey:@"copyright"] retain];
        managingEditor = [[coder decodeObjectForKey:@"managingEditor"] retain];
        webMaster = [[coder decodeObjectForKey:@"webMaster"] retain];
        pubDate = [[coder decodeObjectForKey:@"pubDate"] retain];
        lastBuildDate = [[coder decodeObjectForKey:@"lastBuildDate"] retain];
        category = [[coder decodeObjectForKey:@"category"] retain];
        generator = [[coder decodeObjectForKey:@"generator"] retain];
        docs = [[coder decodeObjectForKey:@"docs"] retain];
        cloud = [[coder decodeObjectForKey:@"cloud"] retain];
        ttl = [[coder decodeObjectForKey:@"ttl"] retain];
        image = [[coder decodeObjectForKey:@"image"] retain];
        rating = [[coder decodeObjectForKey:@"rating"] retain];
        textInput = [[coder decodeObjectForKey:@"textInput"] retain];
        skipHours = [[coder decodeObjectForKey:@"skipHours"] retain];
        skipDays = [[coder decodeObjectForKey:@"skipDays"] retain];
    }   
    
    return self;
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

- (void)setDescription:(NSString*)_description
{
	description = [[NSString stringWithFormat:@"%@%@", (description ? description : @""), _description] retain];
}

- (void)setLanguage:(NSString*)_language
{
	[language release];
	language = [_language retain];
}

- (void)setCopyright:(NSString*)_copyright
{
	[copyright release];
	copyright = [_copyright retain];
}

- (void)setManagingEditor:(NSString*)_managingEditor
{
	[managingEditor release];
	managingEditor = [_managingEditor retain];
}

- (void)setWebMaster:(NSString*)_webMaster
{
	[webMaster release];
	webMaster = [_webMaster retain];
}

- (void)setPubDate:(NSString*)_pubDate
{
    [pubDate release];
    pubDate = [NSStringFromDate(NSDateFromNonStandardDrupalString(_pubDate)) retain];   
}

- (void)setLastBuildDate:(NSString*)_lastBuildDate
{
	[lastBuildDate release];
	lastBuildDate = [_lastBuildDate retain];
}

- (void)setCategory:(NSString*)_category
{
	[category release];
	category = [_category retain];
}

- (void)setGenerator:(NSString*)_generator
{
	[generator release];
	generator = [_generator retain];
}

- (void)setDocs:(NSString*)_docs
{
	[docs release];
	docs = [_docs retain];
}

- (void)setCloud:(NSString*)_cloud
{
	[cloud release];
	cloud = [_cloud retain];
}

- (void)setTtl:(NSString*)_ttl
{
	[ttl release];
	ttl = [_ttl retain];
}

- (void)setRating:(NSString*)_rating
{
	[rating release];
	rating = [_rating retain];
}

- (void)setTextInput:(NSString*)_textInput
{
	[textInput release];
	textInput = [_textInput retain];
}

- (void)setSkipHours:(NSString*)_skipHours
{
	[skipHours release];
	skipHours = [_skipHours retain];
}

- (void)setSkipDays:(NSString*)_skipDays
{
	[skipDays release];
	skipDays = [_skipDays retain];
}

- (void)setImage:(FeedImage*)_image
{
    [image release];
    image = [_image retain];    
}
@end

@interface FeedReader ()
- (void)downloadFeedStories;
@end


@implementation FeedReader
@synthesize feeds;
@synthesize selectedStory;

static FeedReader* singleton = nil;
+ (FeedReader*)feedReader
{
	return singleton;
}

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

- (id)init
{
	if (self = [super init]) 
	{
        singleton = self;
        
        NSData *archivedFeeds = [[NSUserDefaults standardUserDefaults] objectForKey:@"archivedFeeds"];
        if (archivedFeeds != nil)
        {
            NSDictionary *unarchivedFeeds = [NSKeyedUnarchiver unarchiveObjectWithData:archivedFeeds];
            if (unarchivedFeeds != nil)
                feeds = [[NSMutableDictionary alloc] initWithDictionary:unarchivedFeeds];
        }
        
        if (!feeds)
            feeds = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        allStories = [[NSMutableArray alloc] initWithCapacity:[feeds count]*20];
        
        xmlParsers = [[NSMutableDictionary alloc] initWithCapacity:[feeds count]];
                      
        [self downloadFeedStories];
	}
    
	return self;
}

+ (FeedReader*)initFeedReader
{
	if(singleton)
		return singleton;
    
	return [[super allocWithZone:nil] init];
}	


- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    //-------------------------------------------------------------------//
	NSLog(@"found file and started parsing");
    //-------------------------------------------------------------------//
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    [currentlyBeingParsedFeed release];
    
    //-------------------------------------------------------------------//
	NSString *errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" 
                                                         message:errorString 
                                                        delegate:self 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
	[errorAlert show];
    //-------------------------------------------------------------------//
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI 
 qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    Feed *feed = currentlyBeingParsedFeed;//[xmlParsers objectForKey:parser.systemID];
    feed.currentElement = elementName;
    
	if ([elementName isEqualToString:@"item"]) 
    {
        feed.currentStory = [[Story alloc] init];
        [feed.currentStory setFeed:feed];
    }
    else if ([elementName isEqualToString:@"image"])
    {
        feed.currentImage = [[FeedImage alloc] init];
    }
    else if ([elementName isEqualToString:@"enclosure"])
    {
        feed.currentEnclosure = [[StoryEnclosure alloc] init];
    }
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName 
  namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName
{
    Feed *feed = currentlyBeingParsedFeed;//[xmlParsers objectForKey:parser];
	
    if ([elementName isEqualToString:@"description"] && feed.currentStory)
    {
        ContentParser *contentParser = [[ContentParser alloc] init];
        [contentParser regexParse:feed.currentStory.description];
//        [contentParser processContent:feed.currentStory.description];
        
        NSMutableString *plainText = [contentParser currentContent];//[[NSMutableString alloc] init];        
//        for (NSString *chunk in contentParser.theStringsBetweenElements)
//        {
//            [plainText appendFormat:@"%@ ", chunk];
//        }
        
        [feed.currentStory setPlainText:plainText];
//        [plainText release];
        
        for (NSDictionary *image in contentParser.images)
        {
            [feed.currentStory addStoryImage:image];
        }
        
        [contentParser release];
    }
    
    if ([elementName isEqualToString:@"item"]) 
    {
		[feed.stories addObject:feed.currentStory];
        [feed.currentStory release];
        feed.currentStory = nil;
	}
    else if ([elementName isEqualToString:@"image"]) 
    {
		[feed setImage:feed.currentImage];
        [feed.currentImage release];
        feed.currentImage = nil;
	}
                 
    feed.currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	Feed *feed = currentlyBeingParsedFeed;//[xmlParsers objectForKey:parser];
	
    if (feed.currentStory)
    {
		if ([feed.currentElement isEqualToString:@"title"])
		{
			[feed.currentStory setTitle:string];
		}
		else if ([feed.currentElement isEqualToString:@"link"])
		{
			[feed.currentStory setLink:string];
		}
		else if ([feed.currentElement isEqualToString:@"description"])
		{
			[feed.currentStory setDescription:string];
		}
		else if ([feed.currentElement isEqualToString:@"author"])
		{
			[feed.currentStory setAuthor:string];
		}
		else if ([feed.currentElement isEqualToString:@"category"])
		{
			[feed.currentStory setCategory:string];
		}
		else if ([feed.currentElement isEqualToString:@"comments"])
		{
			[feed.currentStory setComments:string];
		}
		else if ([feed.currentElement isEqualToString:@"enclosure"])
		{
			//[feed setEnclosure:string];
		}
		else if ([feed.currentElement isEqualToString:@"guid"])
		{
			[feed.currentStory setGuid:string];
		}
		else if ([feed.currentElement isEqualToString:@"pubDate"])
		{
			[feed.currentStory setPubDate:string];
		}
		else if ([feed.currentElement isEqualToString:@"source"])
		{
			[feed.currentStory setSource:string];
		}
    }
    else if (feed.currentImage)
    {
        if ([feed.currentElement isEqualToString:@"url"]) 
        {
            [feed.currentImage setUrl:string];
        }
        else if ([feed.currentElement isEqualToString:@"title"]) 
        {
            [feed.currentImage setTitle:string];
        }
        else if ([feed.currentElement isEqualToString:@"link"]) 
        {
            [feed.currentImage setLink:string];
        }
        else if ([feed.currentElement isEqualToString:@"description"]) 
        {
            [feed.currentImage setDescription:string];
        }
    }
    else
    {
		if ([feed.currentElement isEqualToString:@"title"])
		{
			[feed setTitle:string];
		}
		else if ([feed.currentElement isEqualToString:@"link"])
		{
			[feed setLink:string];
		}
		else if ([feed.currentElement isEqualToString:@"description"])
		{
			[feed setDescription:string];
		}
		else if ([feed.currentElement isEqualToString:@"language"])
		{
			[feed setLanguage:string];
		}
		else if ([feed.currentElement isEqualToString:@"copyright"])
		{
			[feed setCopyright:string];
		}
		else if ([feed.currentElement isEqualToString:@"managingEditor"])
		{
			[feed setManagingEditor:string];
		}
		else if ([feed.currentElement isEqualToString:@"webMaster"])
		{
			[feed setWebMaster:string];
		}
		else if ([feed.currentElement isEqualToString:@"pubDate"])
		{
			[feed setPubDate:string];
		}
		else if ([feed.currentElement isEqualToString:@"lastBuildDate"])
		{
			[feed setLastBuildDate:string];
		}
		else if ([feed.currentElement isEqualToString:@"category"])
		{
			[feed setCategory:string];
		}
		else if ([feed.currentElement isEqualToString:@"generator"])
		{
			[feed setGenerator:string];
		}
		else if ([feed.currentElement isEqualToString:@"docs"])
		{
			[feed setDocs:string];
		}
		else if ([feed.currentElement isEqualToString:@"cloud"])
		{
			[feed setCloud:string];
		}
		else if ([feed.currentElement isEqualToString:@"ttl"])
		{
			[feed setTtl:string];
		}
		else if ([feed.currentElement isEqualToString:@"image"])
		{
//			[feed setImage:string];
		}
		else if ([feed.currentElement isEqualToString:@"rating"])
		{
			[feed setRating:string];
		}
		else if ([feed.currentElement isEqualToString:@"textInput"])
		{
			[feed setTextInput:string];
		}
		else if ([feed.currentElement isEqualToString:@"skipHours"])
		{
			[feed setSkipHours:string];
		}
		else if ([feed.currentElement isEqualToString:@"skipDays"])
		{
			[feed setSkipDays:string];
		}
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    Feed *feed = currentlyBeingParsedFeed;//[xmlParsers objectForKey:parser];
    
    @synchronized (allStories)
    {
        for (Story* story in feed.stories)
        {
            [allStories addObject:story];
            //[allStories setObject:feed forKey:story];
        }
    }
  
    [currentlyBeingParsedFeed release];
//    [xmlParsers removeObjectForKey:parser];
}

- (void)parseFeed:(Feed*)feed atUrl:(NSString*)url 
{
    currentlyBeingParsedFeed = [feed retain];
	
    if (!feed.stories)
        feed.stories = [[NSMutableArray alloc] init];
    
	NSURL *xmlUrl = [NSURL URLWithString:url];
    
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlUrl];
        
	[parser setDelegate:self];
    
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];

//    [xmlParsers setObject:feed forKey:parser.systemID];
	[parser parse];
}

- (void)downloadFeedStories
{
    for (NSString* url in [feeds allKeys])
    {
        [self parseFeed:[feeds objectForKey:url] atUrl:url];
    }
}


- (void)addFeedForUrl:(NSString*)url
{
    Feed* feed = [[[Feed alloc] init] autorelease];
    
    if (![feeds objectForKey:url])
    {
        [feeds setObject:feed forKey:url];
        [self parseFeed:feed atUrl:url];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:feeds] 
                                                  forKey:@"archivedFeeds"];
    }
}

- (void)removeFeedForUrl:(NSString*)url
{
    Feed *feed = [feeds objectForKey:url];
    
    @synchronized (allStories)
    {
        for (Story* story in [feed stories])
        {
            [allStories removeObject:story];
        }
    }
    
    [feeds removeObjectForKey:url];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:feeds] 
                                              forKey:@"archivedFeeds"];
}

- (NSArray*)allStories
{
    @synchronized (allStories)
    {
        return allStories;
    }
}




@end
