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

 File:	 JRActivityObject.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRActivityObject.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


@implementation NSString (NSString_URL_HANDLING)
- (NSString*)URLEscaped
{

    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL,
                                (CFStringRef)self,
                                NULL,
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    return encodedString;

//    NSString *str = [self stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
//    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%34"];
//    str = [str stringByReplacingOccurrencesOfString:@";" withString:@"%3b"];
//
//    return str;
}

- (BOOL)isWellFormedAbsoluteUrl
{
    NSURL *url = [NSURL URLWithString:self];
    if (url && url.scheme && url.host)
        return YES;

    return NO;
}
@end

/* Added the CF_Class_Name_Additions category to NSObject to filter objects in our media array based on their base class (JRMediaObject) */
@interface NSObject (CF_Class_Name_Additions)
- (NSString*)cf_baseClassName;
- (NSString*)cf_className;
@end

/* Added these functions to the NSObject object to filter objects in our media array based on their base class (JRMediaObject) */
@implementation NSObject (CF_Class_Name_Additions)
- (NSString*) cf_baseClassName { return NSStringFromClass([self superclass]); }
- (NSString*) cf_className { return NSStringFromClass([self class]); }
@end

@interface NSPredicate (JRObject_Class_Name_Predicates)
+ (NSPredicate*)predicateForMediaObjectBaseClass;
+ (NSPredicate*)predicateForImageMediaObjectClass;
+ (NSPredicate*)predicateForFlashMediaObjectClass;
+ (NSPredicate*)predicateForMp3MediaObjectClass;
+ (NSPredicate*)predicateForActionLinkObjectClass;
@end

@implementation NSPredicate (JRObject_Class_Name_Predicates)
+ (NSPredicate*)predicateForMediaObjectBaseClass  { return [NSPredicate predicateWithFormat:@"cf_baseClassName = %@", NSStringFromClass([JRMediaObject class])];}
+ (NSPredicate*)predicateForImageMediaObjectClass { return [NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRImageMediaObject class])]; }
+ (NSPredicate*)predicateForFlashMediaObjectClass { return [NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRMp3MediaObject class])]; }
+ (NSPredicate*)predicateForMp3MediaObjectClass   { return [NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRFlashMediaObject class])]; }
+ (NSPredicate*)predicateForActionLinkObjectClass { return [NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRActionLink class])]; }
@end

@protocol JRMediaObjectDelegate <NSObject>
- (NSDictionary*)dictionaryForObject;
@end

@implementation JRMediaObject
@end

@interface JRImageMediaObject () <JRMediaObjectDelegate>
@end
@interface JRMp3MediaObject () <JRMediaObjectDelegate>
@end
@interface JRFlashMediaObject () <JRMediaObjectDelegate>
@end

@implementation JRImageMediaObject
@synthesize src          = _src;
@synthesize href         = _href;
@synthesize preview      = _preview;

- (id)initWithSrc:(NSString*)src andHref:(NSString*)href
{
    if (![src isWellFormedAbsoluteUrl] || ![href isWellFormedAbsoluteUrl])
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _src  = [src copy];
        _href = [href copy];
    }

    return self;
}

+ (id)imageMediaObjectWithSrc:(NSString*)src andHref:(NSString*)href
{
    if (![src isWellFormedAbsoluteUrl] || ![href isWellFormedAbsoluteUrl])
        return nil;

    return [[[JRImageMediaObject alloc] initWithSrc:src andHref:href] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JRImageMediaObject *imageMediaObjectCopy =
                               [[JRImageMediaObject allocWithZone:zone] initWithSrc:_src
                                                                            andHref:_href];

	imageMediaObjectCopy.preview = _preview;//[[_preview copy] autorelease];

	return imageMediaObjectCopy;
}

- (NSDictionary*)dictionaryForObject
{
    return [[[NSDictionary alloc] initWithObjectsAndKeys:
             @"image", @"type",
             [_src URLEscaped], @"src",
             [_href URLEscaped], @"href", nil] autorelease];
}

- (void)dealloc
{
    [_src release];
    [_href release];
    [_preview release];

    [super dealloc];
}
@end

@implementation JRFlashMediaObject
@synthesize swfsrc          = _swfsrc;
@synthesize imgsrc          = _imgsrc;
@synthesize width           = _width;
@synthesize height          = _height;
@synthesize expanded_width  = _expanded_width;
@synthesize expanded_height = _expanded_height;
@synthesize preview         = _preview;

- (id)initWithSwfsrc:(NSString*)swfsrc andImgsrc:(NSString*)imgsrc
{
    if (![swfsrc isWellFormedAbsoluteUrl] || ![imgsrc isWellFormedAbsoluteUrl])
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _swfsrc = [swfsrc copy];
        _imgsrc = [imgsrc copy];
    }

    return self;
}

+ (id)flashMediaObjectWithSwfsrc:(NSString*)swfsrc andImgsrc:(NSString*)imgsrc
{
    if (![swfsrc isWellFormedAbsoluteUrl] || ![imgsrc isWellFormedAbsoluteUrl])
        return nil;

    return [[[JRFlashMediaObject alloc] initWithSwfsrc:swfsrc andImgsrc:imgsrc] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JRFlashMediaObject *flashMediaObjectCopy =
                               [[JRFlashMediaObject allocWithZone:zone] initWithSwfsrc:_swfsrc
                                                                             andImgsrc:_imgsrc];

    flashMediaObjectCopy.width           = _width;
    flashMediaObjectCopy.height          = _height;
    flashMediaObjectCopy.expanded_width  = _expanded_width;
    flashMediaObjectCopy.expanded_height = _expanded_height;
    flashMediaObjectCopy.preview         = _preview;//[[_preview copy] autorelease];

	return flashMediaObjectCopy;
}

- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"flash", @"type",
                                  [_swfsrc URLEscaped], @"swfsrc",
                                  [_imgsrc URLEscaped], @"imgsrc", nil] autorelease];

    if (_width)
        [dict setObject:[NSString stringWithFormat:@"%d", _width] forKey:@"width"];

    if (_height)
        [dict setValue:[NSString stringWithFormat:@"%d", _height] forKey:@"height"];

    if (_expanded_width)
        [dict setValue:[NSString stringWithFormat:@"%d", _expanded_width] forKey:@"expanded_width"];

    if (_expanded_height)
        [dict setValue:[NSString stringWithFormat:@"%d", _expanded_height] forKey:@"expanded_height"];

    return dict;
}

- (void)dealloc
{
    [_swfsrc release];
    [_imgsrc release];
    [_preview release];

    [super dealloc];
}
@end

@implementation JRMp3MediaObject
@synthesize src    = _src;
@synthesize title  = _title;
@synthesize artist = _artist;
@synthesize album  = _album;

- (id)initWithSrc:(NSString*)src
{
    if (![src isWellFormedAbsoluteUrl])
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _src = [src copy];
    }

    return self;
}

+ (id)mp3MediaObjectWithSrc:(NSString*)src
{
    if (![src isWellFormedAbsoluteUrl])
        return nil;

    return [[[JRMp3MediaObject alloc] initWithSrc:src] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JRMp3MediaObject *mp3MediaObjectCopy =
                             [[JRMp3MediaObject allocWithZone:zone] initWithSrc:_src];

    mp3MediaObjectCopy.title  = _title;
    mp3MediaObjectCopy.artist = _artist;
    mp3MediaObjectCopy.album  = _album;

	return mp3MediaObjectCopy;
}

- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"mp3", @"type",
                                  [_src URLEscaped], @"src", nil] autorelease];

    if (_title)
        [dict setValue:[_title URLEscaped] forKey:@"title"];

    if (_artist)
        [dict setValue:[_artist URLEscaped] forKey:@"artist"];

    if (_album)
        [dict setValue:[_album URLEscaped] forKey:@"album"];

    return dict;
}

- (void)dealloc
{
    [_src release];
    [_title release];
    [_artist release];
    [_album release];

    [super dealloc];
}
@end


@interface JRActionLink ()
- (NSDictionary*)dictionaryForObject;
@end

@implementation JRActionLink
@synthesize text = _text;
@synthesize href = _href;

- (id)initWithText:(NSString*)text andHref:(NSString*)href
{
    if (!text || ![href isWellFormedAbsoluteUrl])
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _text = [text copy];
        _href = [href copy];
    }

    return self;
}

+ (id)actionLinkWithText:(NSString*)text andHref:(NSString*)href
{
    if (!text || !href)
        return nil;

    return [[[JRActionLink alloc] initWithText:text andHref:href] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JRActionLink *actionLinkCopy = [[JRActionLink allocWithZone:zone] initWithText:_text
                                                                           andHref:_href];
	return actionLinkCopy;
}

- (NSDictionary*)dictionaryForObject
{
    return [[[NSDictionary alloc] initWithObjectsAndKeys:
             [_text URLEscaped], @"text",
             [_href URLEscaped], @"href", nil] autorelease];
}

- (void)dealloc
{
    [_text release];
    [_href release];

    [super dealloc];
}
@end

static NSArray* filteredArrayOfValidUrls (NSArray *urls)
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[urls count]];

    for (NSObject *url in urls)
        if ([url isKindOfClass:[NSString class]])
            if ([((NSString*)url) isWellFormedAbsoluteUrl])
                [array addObject:[[url copy] autorelease]];

    return array;
}

@implementation JREmailObject
@synthesize subject     = _subject;
@synthesize messageBody = _messageBody;
@synthesize isHtml      = _isHtml;
@synthesize urls        = _urls;

- (id)initWithSubject:(NSString *)subject andMessageBody:(NSString *)messageBody isHtml:(BOOL)isHtml andUrlsToBeShortened:(NSArray*)urls
{
    if ((self = [super init]))
    {
        if (subject)
            _subject = [subject copy];

        if (messageBody)
            _messageBody = [messageBody copy];

        _isHtml = isHtml;
        _urls   = [filteredArrayOfValidUrls (urls) retain];
    }

    return self;
}

+ (id)emailObjectWithSubject:(NSString *)subject andMessageBody:(NSString *)messageBody isHtml:(BOOL)isHtml andUrlsToBeShortened:(NSArray*)urls
{
    return [[[JREmailObject alloc] initWithSubject:subject andMessageBody:messageBody isHtml:isHtml andUrlsToBeShortened:urls] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JREmailObject *emailObjectCopy = [[JREmailObject allocWithZone:zone] initWithSubject:_subject
                                                                          andMessageBody:_messageBody
                                                                                  isHtml:_isHtml
                                                                    andUrlsToBeShortened:_urls];

	return emailObjectCopy;
}

- (void)dealloc
{
    [_subject release];
    [_messageBody release];
    [_urls release];

    [super dealloc];
}
@end


@implementation JRSmsObject
@synthesize message = _message;
@synthesize urls    = _urls;

- (id)initWithMessage:(NSString*)message andUrlsToBeShortened:(NSArray*)urls
{
    if ((self = [super init]))
    {
        if (message)
            _message = [message copy];

        _urls =  [filteredArrayOfValidUrls (urls) retain];
    }

    return self;
}

+ (id)smsObjectWithMessage:(NSString *)message andUrlsToBeShortened:(NSArray*)urls
{
    return [[[JRSmsObject alloc] initWithMessage:message andUrlsToBeShortened:urls] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JRSmsObject *smsObjectCopy = [[JRSmsObject allocWithZone:zone] initWithMessage:_message
                                                              andUrlsToBeShortened:_urls];

	return smsObjectCopy;
}

- (void)dealloc
{
    [_message release];
    [_urls release];

    [super dealloc];
}
@end

@implementation JRActivityObject
@synthesize action                 = _action;
//@synthesize url                    = _url;
@synthesize userGeneratedContent   = _userGeneratedContent;
@synthesize resourceTitle          = _resourceTitle;
@synthesize resourceDescription    = _resourceDescription;
@synthesize properties             = _properties;
@synthesize email                  = _email;
@synthesize sms                    = _sms;
@dynamic url;
@dynamic user_generated_content;
@dynamic title;
@dynamic description;
@dynamic actionLinks;
@dynamic action_links;
@dynamic media;

- (id)initWithAction:(NSString*)action andUrl:(NSString*)url
{
    if (!action)
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _action = [action copy];

        if ([url isWellFormedAbsoluteUrl])
            _url    = [url copy];
    }

    return self;
}

+ (id)activityObjectWithAction:(NSString*)action andUrl:(NSString*)url
{
    if (!action)
        return nil;

    return [[[JRActivityObject alloc] initWithAction:action andUrl:url] autorelease];
}

- (id)initWithAction:(NSString*)action
{
    if (!action)
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _action = [action copy];
    }

    return self;
}

+ (id)activityObjectWithAction:(NSString*)action
{
    if (!action)
        return nil;

    return [[[JRActivityObject alloc] initWithAction:action] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
	JRActivityObject *activityObjectCopy = [[JRActivityObject allocWithZone:zone] initWithAction:_action
                                                                                          andUrl:_url];

    activityObjectCopy.userGeneratedContent   = _userGeneratedContent;//_user_generated_content;
    activityObjectCopy.resourceTitle          = _resourceTitle;//_title;
    activityObjectCopy.resourceDescription    = _resourceDescription;//_description;
    activityObjectCopy.properties             = _properties;
    activityObjectCopy.email                  = _email;
    activityObjectCopy.sms                    = _sms;
    activityObjectCopy.actionLinks            = _actionLinks;//_action_links;
    activityObjectCopy.media                  = _media;

    return activityObjectCopy;
}

- (void)setUrl:(NSString*)url
{
    [_url release], _url = nil;

    if ([url isWellFormedAbsoluteUrl])
        _url = [url copy];
}

- (NSString*)url
{
    return [[_url copy] autorelease];
}

/* This function filters the given array, media, and only keeps the objects that
   directly inherit from the base class JRMediaObject (JRImageMediaObject, etc.).
   What it doesn't test for is if a user creates a new object that directly inherits
   JRMediaObject and passes that in.  If they do that, don't know why, worst case is
   that the app will crash.                                                          */
- (void)setMedia:(NSArray*)media
{
    NSPredicate    *predicate = [NSPredicate predicateForMediaObjectBaseClass];
    NSMutableArray *oldMedia  = _media;

    _media = [[NSMutableArray alloc] initWithArray:[media filteredArrayUsingPredicate:predicate]
                                         copyItems:YES];

    [oldMedia release];
}

- (NSArray*)media
{
    return [[_media copy] autorelease];
}

/* This function filters the given array, actionlinks, and only keeps the objects that
   have the class name JRActionLinks                                                     */
- (void)setActionLinks:(NSArray*)actionLinks
{
    NSPredicate    *predicate      = [NSPredicate predicateForActionLinkObjectClass];
    NSMutableArray *oldActionLinks = _actionLinks;

    _actionLinks = [[NSMutableArray alloc] initWithArray:[actionLinks filteredArrayUsingPredicate:predicate]
                                                copyItems:YES];

    [oldActionLinks release];
}

- (NSArray*)actionLinks
{
    return [[_actionLinks copy] autorelease];
}

/* Deprecated; calling new function instead. */
- (void)setAction_links:(NSArray*)action_links
{
    [self setActionLinks:action_links];
}

/* Deprecated; calling new function instead. */
- (NSArray*)action_links
{
    return [self actionLinks];
}

/* Some pre-processing of the activity object, mostly the media array, to deal with
   anything icky before sending it to rpxnow's publish_activity api                 */
- (void)validateActivity
{
    if ([_media count] > 0)
    {
        NSArray *images = [_media filteredArrayUsingPredicate:[NSPredicate predicateForImageMediaObjectClass]];
        NSArray *songs  = [_media filteredArrayUsingPredicate:[NSPredicate predicateForMp3MediaObjectClass]];
        NSArray *videos = [_media filteredArrayUsingPredicate:[NSPredicate predicateForFlashMediaObjectClass]];

        /* If we have images and either songs or videos or both */
        if ([images count] && ([songs count] || [videos count]))
        {
            /* Then we only use the images; The songs or videos will be ignored */
            [_media filterUsingPredicate:[NSPredicate predicateForImageMediaObjectClass]];
        }
        /* If we don't have images, but we have both songs and videos */
        else if ([songs count] && [videos count])
        {
            /* Then we only use the songs; The videos will be ignored */
            [_media filterUsingPredicate:[NSPredicate predicateForMp3MediaObjectClass]];
        }
        /* Otherwise, we only have videos... */

// Note to self: Facebook says you can only use 5 pictures, but testing didn't throw an error, even though
// it did throw errors when using more than one song or video. Just leaving this for now...
//        if ([images count] && [images count] > 5)
//        {
//            while ([media count] > 5)
//                [media removeLastObject];
//        }
//        else
        if ([songs count] && [songs count] > 1)
        {
            while ([_media count] > 1)
                [_media removeLastObject];
        }
        else if ([videos count] && [images count] > 1)
        {
            while ([_media count] > 1)
                [_media removeLastObject];
        }
    }
}

// Question to self: Is there a better way of doing this, like by using NSCoders to do the encoding?
/* This function goes through all of the fields of the activity object and turns the object into
   an NSDictionary of string values and keys so that it can be converted into json by the json
   library.  It also validates the objects and escapes icky characters in the process. */
- (NSDictionary*)dictionaryForObject
{
    [self validateActivity];

    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:7] autorelease];
    [dict setValue:[_action URLEscaped] forKey:@"action"];

    // Question to self: Figure out why Engage fails if there is no url, but accepts an empty one.  Shouldn't it ignore the no-url
    // when coming from mobile?  (It doesn't, so we just send a @"" when there isn't a url for the providers that can
    // handle that and thunk to set_status for those that don't.)
    if (_url)
        [dict setValue:[_url URLEscaped] forKey:@"url"];
    else
        [dict setValue:@"" forKey:@"url"];

    if (_userGeneratedContent)
        [dict setValue:[_userGeneratedContent URLEscaped] forKey:@"user_generated_content"];

    if (_resourceTitle)
        [dict setValue:[_resourceTitle URLEscaped] forKey:@"title"];

    if (_resourceDescription)
        [dict setValue:[_resourceDescription URLEscaped] forKey:@"description"];

    if ([_actionLinks count])
    {
        NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:[_actionLinks count]] autorelease];

        for (JRActionLink *link in _actionLinks)
        {
            [arr addObject:[link dictionaryForObject]];
        }

        [dict setValue:arr forKey:@"action_links"];
    }

    if ([_media count])
    {
        NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:[_media count]] autorelease];

        for (id<JRMediaObjectDelegate> item in _media)
        {
            [arr addObject:[item dictionaryForObject]];
        }

        [dict setValue:arr forKey:@"media"];
    }

    if ([_properties count])
        [dict setObject:_properties forKey:@"properties"];

    return dict;//[NSDictionary dictionaryWithObject:dict forKey:@"activity"];
}

- (void)setTitle:(NSString*)title                                   { self.resourceTitle = title;             }
- (void)setDescription:(NSString*)description                       { self.resourceDescription = description; }
- (void)setUser_generated_content:(NSString*)user_generated_content { self.userGeneratedContent = user_generated_content; }
- (NSString*)title                  { return self.resourceTitle;        }
- (NSString*)description            { return self.resourceDescription;  }
- (NSString*)user_generated_content { return self.userGeneratedContent; }

- (void)dealloc
{
    [_action release];
    [_url release];
    [_userGeneratedContent release];
    [_resourceTitle release];
    [_resourceDescription release];
    [_actionLinks release];
    [_media release];
    [_properties release];
    [_email release];
    [_sms release];
    [_shortenedUrl release];

    [super dealloc];
}
@end
