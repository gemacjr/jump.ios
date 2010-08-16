//
//  FeedReader.h
//  Quick Share
//
//  Created by lilli on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentParser.h"
//#import "JRAuthenticate.h"

@interface StoryEnclosure : NSObject
{
    /* An enclosure has three required attributes. url says where the enclosure is located, length says 
       how big it is in bytes,and type says what its type is, a standard MIME type.  The url must be an http url. 
       (e.g., <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />) */
    NSString *url; 
    NSString *mimeType; 
    NSInteger length;
    UIImage *image;
}

@property (readonly) NSString *url; 
@property (readonly) NSString *mimeType;
@property (readonly) NSInteger length;
@property (readonly) UIImage *image;
@end

@interface StoryImage : NSObject
{
    NSString *alt;		/* Specifies an alternate text for an image (e.g., x) */
	NSString *src;		/* (URL) Specifies the URL of an image (e.g., x) */
	NSString *height;		/* p(ixels) pecifies the height of an image (e.g., x) */
	NSString *width;		/* (pixels) Specifies the width of an image (e.g., x) */
    
}
@property (readonly) NSString *alt;
@property (readonly) NSString *src;
@property (readonly) NSString *height;
@property (readonly) NSString *width;
@end

@class Feed;
@interface Story : NSObject
{
	NSString *title;		/* The title of the item. (e.g., Venice Film Festival Tries to Quit Sinking) */
	NSString *link;         /* The URL of the item. (e.g., http://nytimes.com/2004/12/07FEST.html) */
	NSString *description;	/* The item synopsis. (e.g., Some of the most heated chatter at the Venice Film Festival this week was about the way that the arrival of the stars at the Palazzo del Cinema was being staged.) */
	NSString *author;		/* Email address of the author of the item. (e.g., oprah\@oxygen.net) */
	NSString *category;		/* Includes the item in one or more categories. */
	NSString *comments;		/* URL of a page for comments relating to the item. (e.g., http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290) */
	NSString *guid;         /* A string that uniquely identifies the item. (e.g., http://inessential.com/2002/09/01.php#a2) */
	NSString *pubDate;		/* Indicates when the item was published. (e.g., Sun, 19 May 2002 15:21:36 GMT) */
	NSString *source;		/* The RSS channel that the item came from. */

    NSString *plainText;
	
    StoryEnclosure *enclosure;	/* Describes a media object that is attached to the item. */
    NSMutableArray *storyImages;
    
    Feed *feed;
}

@property (readonly) NSString *title;
@property (readonly) NSString *link;
@property (readonly) NSString *description;
@property (readonly) NSString *author;
@property (readonly) NSString *category;
@property (readonly) NSString *comments;
@property (readonly) NSString *guid;
@property (readonly) NSString *pubDate;
@property (readonly) NSString *source;
@property (readonly) NSString *plainText;
@property (readonly) StoryEnclosure *enclosure;
@property (readonly) NSMutableArray *storyImages;
@property (readonly) Feed *feed;
@end

@interface FeedImage : NSObject
{
    /* Required elements */
    NSString *url;      /* This is the URL of a GIF, JPEG or PNG image that represents the channel. */
    NSString *title;    /* This describes the image, it's used in the ALT attribute of the HTML <img> tag when the channel is rendered in HTML. */
    NSString *link;     /* This is the URL of the site, when the channel is rendered, the image is a link to the site. (Note, in practice the image <title> and <link> should have the same value as the channel's <title> and <link>. */
    
    /* Optional elements */
    NSString *description;   /* This contains text that is included in the TITLE attribute of the link formed around the image in the HTML rendering. */
    NSInteger width;       /* These values indicate the width and height of the image in pixels. */
    NSInteger height;      /* These values indicate the width and height of the image in pixels. */
}
@property (retain) NSString *url;
@property (retain) NSString *title;
@property (retain) NSString *link; 
@property (retain) NSString *description;
@property NSInteger width;    
@property NSInteger height;   
@end


@interface Feed : NSObject
{
	NSString *title;            /* The name of the channel. It's how people refer to your service. If you have an HTML website that contains the same information as your RSS file, the title of your channel should be the same as the title of your website. (e.g., GoUpstate.com News Headlines) */
	NSString *link;             /* The URL to the HTML website corresponding to the channel. (e.g., http://www.goupstate.com/) */
	NSString *description;      /* Phrase or sentence describing the channel. (e.g., The latest news from GoUpstate.com, a Spartanburg Herald-Journal Web site.) */
	NSString *language;         /* The language the channel is written in. This allows aggregators to group all Italian language sites, for example, on a single page. A list of allowable values for this element, as provided by Netscape, is here. You may also use values defined by the W3C. (e.g., en-us) */
	NSString *copyright;        /* Copyright notice for content in the channel. (e.g., Copyright 2002, Spartanburg Herald-Journal) */
	NSString *managingEditor;	/* Email address for person responsible for editorial content. (e.g., geo@herald.com (George Matesky)) */
	NSString *webMaster;		/* Email address for person responsible for technical issues relating to channel. (e.g., betty@herald.com (Betty Guernsey)) */
	NSString *pubDate;          /* The publication date for the content in the channel. For example, the New York Times publishes on a daily basis, the publication date flips once every 24 hours. That's when the pubDate of the channel changes. All date-times in RSS conform to the Date and Time Specification of RFC 822, with the exception that the year may be expressed with two characters or four characters (four preferred). (e.g., Sat, 07 Sep 2002 00:00:01 GMT) */
	NSString *lastBuildDate;	/* The last time the content of the channel changed. (e.g., Sat, 07 Sep 2002 09:42:31 GMT) */
	NSString *category;         /* Specify one or more categories that the channel belongs to. Follows the same rules as the <item>-level category element. More info. (e.g., <category>Newspapers</category>) */
	NSString *generator;		/* A string indicating the program used to generate the channel. (e.g., MightyInHouse Content System v2.3) */
	NSString *docs;             /* A URL that points to the documentation for the format used in the RSS file. It's probably a pointer to this page. It's for people who might stumble across an RSS file on a Web server 25 years from now and wonder what it is. (e.g., http://blogs.law.harvard.edu/tech/rss) */
	NSString *cloud;            /* Allows processes to register with a cloud to be notified of updates to the channel, implementing a lightweight publish-subscribe protocol for RSS feeds. (e.g., <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>) */
	NSString *ttl;              /* ttl stands for time to live. It's a number of minutes that indicates how long a channel can be cached before refreshing from the source. (e.g., <ttl>60</ttl>) */
	NSString *rating;           /* The PICS rating for the channel. */
	NSString *textInput;		/* Specifies a text input box that can be displayed with the channel. */
	NSString *skipHours;		/* A hint for aggregators telling them which hours they can skip. */
	NSString *skipDays;         /* A hint for aggregators telling them which days they can skip. */
    
    FeedImage *image;            /* Specifies a GIF, JPEG or PNG image that can be displayed with the channel. */

    NSMutableArray *stories;
    
    Story *currentStory;
    FeedImage *currentImage;
    StoryEnclosure *currentEnclosure;
    
    NSString *currentElement;
}

@property (readonly) NSString *title;
@property (readonly) NSString *link;
@property (readonly) NSString *description;
@property (readonly) NSString *language;
@property (readonly) NSString *copyright;
@property (readonly) NSString *managingEditor;
@property (readonly) NSString *webMaster;
@property (readonly) NSString *pubDate;
@property (readonly) NSString *lastBuildDate;
@property (readonly) NSString *category;
@property (readonly) NSString *generator;
@property (readonly) NSString *docs;
@property (readonly) NSString *cloud;
@property (readonly) NSString *ttl;
@property (readonly) NSString *rating;
@property (readonly) NSString *textInput;
@property (readonly) NSString *skipHours;
@property (readonly) NSString *skipDays;
@property (readonly) FeedImage *image;
@property (readonly) NSMutableArray *stories;
@end

@interface FeedReader : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary *xmlParsers;
    Feed *currentlyBeingParsedFeed;

    NSMutableDictionary *feeds;
    NSMutableArray *allStories;
//    NSMutableDictionary *allStories;
    
    Story *selectedStory;
}
@property (readonly) NSMutableDictionary *feeds;
@property (readonly) NSMutableArray *allStories;
@property (retain) Story *selectedStory;

+ (FeedReader*)initFeedReader;
+ (FeedReader*)feedReader;

- (void)addFeedForUrl:(NSString*)url;
- (void)removeFeedForUrl:(NSString*)url;
@end
