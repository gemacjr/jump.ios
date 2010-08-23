//
//  FeedReader.h
//  Quick Share
//
//  Created by lilli on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentParser.h"
#import "JRAuthenticate.h"
#import "FeedReaderDetail.h"

@class FeedReaderDetail;
@interface StoryImage : NSObject <JRConnectionManagerDelegate>
{
    NSString *alt;		/* Specifies an alternate text for an image (e.g., x) */
	NSString *src;		/* (URL) Specifies the URL of an image (e.g., x) */
	CGFloat *height;		/* p(ixels) pecifies the height of an image (e.g., x) */
	CGFloat *width;		/* (pixels) Specifies the width of an image (e.g., x) */
    
    UIImage *image;
    
    BOOL downloadFailed;    
}
@property (readonly) NSString *alt;
@property (readonly) NSString *src;
@property (readonly) CGFloat  *height;
@property (readonly) CGFloat  *width;
@property (readonly) UIImage  *image;
@property (readonly) BOOL downloadFailed;

- (id)initWithSrc:(NSString*)_src;
@end

@class Feed;
@interface Story : NSObject
{   
	NSString *title;		/* The title of the item. (e.g., Venice Film Festival Tries to Quit Sinking) */
	NSString *link;         /* The URL of the item. (e.g., http://nytimes.com/2004/12/07FEST.html) */
	NSString *description;	/* The item synopsis. (e.g., Some of the most heated chatter at the Venice Film Festival this week was about the way that the arrival of the stars at the Palazzo del Cinema was being staged.) */
	NSString *author;		/* Email address of the author of the item. (e.g., oprah\@oxygen.net) */
	NSString *pubDate;		/* Indicates when the item was published. (e.g., Sun, 19 May 2002 15:21:36 GMT) */

    NSString *plainText;
	
    NSMutableArray *storyImages;
    
    Feed *feed;
}

@property (readonly) NSString *title;
@property (readonly) NSString *link;
@property (readonly) NSString *description;
@property (readonly) NSString *author;
@property (readonly) NSString *pubDate;
@property (readonly) NSString *plainText;
@property (readonly) NSMutableArray *storyImages;
@property (readonly) Feed *feed;
@end

@interface Feed : NSObject
{
    NSString *url;

 	NSString *title;            /* The name of the channel. It's how people refer to your service. If you have an HTML website that contains the same information as your RSS file, the title of your channel should be the same as the title of your website. (e.g., GoUpstate.com News Headlines) */
	NSString *link;             /* The URL to the HTML website corresponding to the channel. (e.g., http://www.goupstate.com/) */

    NSMutableArray *stories;
}

@property (readonly) NSString *title;
@property (readonly) NSString *link;
@property (readonly) NSMutableArray *stories;
@end

@interface FeedReader : NSObject <JRAuthenticateDelegate>
{
//    NSMutableArray *allStories;
    
    Feed *feed;
    Story *selectedStory;
    
    JRAuthenticate *jrAuthenticate;
    
    FeedReaderDetail *feedReaderDetail;
}

@property (retain)   FeedReaderDetail *feedReaderDetail;
@property (readonly) NSMutableArray *allStories;
@property (retain)   Story *selectedStory;
@property (readonly) JRAuthenticate *jrAuthenticate;

//+ (FeedReader*)initFeedReader;
+ (FeedReader*)feedReader;
@end
