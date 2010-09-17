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
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

/* Added a category to NSString including a function to correctly escape the JRActivityObject
   members so that there are no errors when sending the json structure to rpxnow's publish_activity api */
@interface NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped;
@end

// TODO: Test for all characters that might blow up the publish_activity api call
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

// TODO: Are there any keywords/directives that I should add to correctly use
// JRMediaObject as an abstract base class?
@protocol JRMediaObjectProtocol
- (NSDictionary*)dictionaryForObject;
@end

// TODO: Is this really needed anymore?
@implementation JRMediaObject 
- (id)init
{
    return [super init];
}
@end

// TODO: Figure out the correct way to inherit the dictionaryForObject function 
// from the base class while keeping the declaration in the implementation file (.m)
@interface JRImageMediaObject () <JRMediaObjectProtocol>
//- (NSDictionary*)dictionaryForObject;
@end

@interface JRMp3MediaObject () <JRMediaObjectProtocol>
@end

@interface JRFlashMediaObject () <JRMediaObjectProtocol>
@end

@implementation JRImageMediaObject 
@synthesize src;
@synthesize href;
@synthesize preview;

- (id)initWithSrc:(NSString*)_src andHref:(NSString*)_href
{
    if (!_src || !_href)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        src = [_src retain];
        href = [_href retain];
    }
    
    return self;
}

- (void)setPreviewImage:(UIImage*)image
{
    [preview release];
    preview = [image retain];
}

- (NSDictionary*)dictionaryForObject
{
    return [[[NSDictionary alloc] initWithObjectsAndKeys:
             @"image", @"type", 
             [src URLEscaped], @"src", 
             [href URLEscaped], @"href", nil] autorelease];
}
@end

@implementation JRFlashMediaObject 
@synthesize swfsrc;
@synthesize imgsrc;
@synthesize width;		
@synthesize height;
@synthesize expanded_width;
@synthesize expanded_height;
@synthesize preview;

- (id)initWithSwfsrc:(NSString*)_swfsrc andImgsrc:(NSString*)_imgsrc
{
    if (!_swfsrc || !_imgsrc)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        swfsrc = [_swfsrc retain];
        imgsrc = [_imgsrc retain];
    }
    
    return self;
}

- (void)setPreviewImage:(UIImage*)image
{
    [preview release];
    preview = [image retain];
}

- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                                  @"flash", @"type", 
                                  [swfsrc URLEscaped], @"swfsrc", 
                                  [imgsrc URLEscaped], @"imgsrc", nil] autorelease];

    if (width)
        [dict setObject:[NSString stringWithFormat:@"%d", width] forKey:@"width"];
    
    if (height)
        [dict setValue:[NSString stringWithFormat:@"%d", height] forKey:@"height"];
    
    if (expanded_width)
        [dict setValue:[NSString stringWithFormat:@"%d", expanded_width] forKey:@"expanded_width"];
    
    if (expanded_height)
        [dict setValue:[NSString stringWithFormat:@"%d", expanded_height] forKey:@"expanded_height"];
    
    return dict;
}
@end

@implementation JRMp3MediaObject 
@synthesize src;
@synthesize title;
@synthesize artist;
@synthesize album;

- (id)initWithsrc:(NSString*)_src
{
    if (!_src)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        src = [_src retain];
    }
    
    return self;
}

- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                                  @"mp3", @"type", 
                                  [src URLEscaped], @"src", nil] autorelease];
    
    if (title)
        [dict setValue:[title URLEscaped] forKey:@"title"];
    
    if (artist)
        [dict setValue:[artist URLEscaped] forKey:@"artist"];
    
    if (album)
        [dict setValue:[album URLEscaped] forKey:@"album"];
    
    return dict;
}
@end


@interface JRActionLink ()
- (NSDictionary*)dictionaryForObject;
@end

@implementation JRActionLink
@synthesize text;
@synthesize href;

- (id)initWithText:(NSString*)_text andHref:(NSString*)_href
{
    if (!_text || !_href)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        text = [_text retain];
        href = [_href retain];
    }
    
    return self;
}

- (NSDictionary*)dictionaryForObject
{
    return [[[NSDictionary alloc] initWithObjectsAndKeys:
             [text URLEscaped], @"text",
             [href URLEscaped], @"href", nil] autorelease];
}
@end

@implementation JRActivityObject
@synthesize action;  							
@synthesize url;
@synthesize user_generated_content;
@synthesize title;				
@synthesize description;
@synthesize properties;
@dynamic action_links; 					
@dynamic media;

- (id)initWithAction:(NSString*)_action andUrl:(NSString*)_url
{
    if (!_action || !_url)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init]) 
	{
        action = [_action retain];
        url = [_url retain];
    }
    
	return self;
}

/* This function filters the given array, _media, and only keeps the objects that 
   directly inherit from the base class JRMediaObject (JRImageMediaObject, etc.).
   What it doesn't test for is if a user creates a new object that directly inherits 
   JRMediaObject and passes that in.  If they do that, don't know why, worst case is
   that the app will crash.                                                          */
- (void)setMedia:(NSMutableArray *)_media
{
    media = [[NSMutableArray arrayWithArray:
              [_media filteredArrayUsingPredicate:
               [NSPredicate predicateWithFormat:@"cf_baseClassName = %@", NSStringFromClass([JRMediaObject class])]]] retain];
}

- (NSMutableArray*)media
{
    // TODO: Need to release?
    if (!media)
        media = [[NSMutableArray alloc] initWithCapacity:1];
    
    return media;
}

/* This function filters the given array, _action_links, and only keeps the objects that 
   have the class name JRActionLinks                                                     */
- (void)setAction_links:(NSMutableArray *)_action_links
{
    action_links = [[NSMutableArray arrayWithArray:
                     [_action_links filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRActionLink class])]]] retain];
}

- (NSMutableArray*)action_links
{
    // TODO: Need to release?
    if (!action_links)
        action_links = [[NSMutableArray alloc] initWithCapacity:1];

    return action_links;
}

/* Some pre-processing of the activity object, mostly the media array, to deal with 
   anything icky before sending it to rpxnow's publish_activity api                 */
- (void)validateActivity
{
    if ([media count] > 0)
    {
        NSArray *images = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRImageMediaObject class])]];
        NSArray *songs  = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRMp3MediaObject class])]];
        NSArray *videos = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRFlashMediaObject class])]];
        
        DLog(@"images count: %d", [images count]);
        DLog(@"songs count : %d", [songs count]);
        DLog(@"videos count: %d", [videos count]);
        
        /* If we have images and either songs or videos or both */
        if ([images count] && ([songs count] || [videos count]))
        {
            DLog(@"([images count] && ([songs count] || [videos count]))");
                        
            /* Then we only use the images; The songs or videos will be ignored */
            [media filterUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRImageMediaObject class])]];
        }
        /* If we don't have images, but we have both songs and videos */
        else if ([songs count] && [videos count])
        {
            DLog(@"([songs count] && [videos count])");

            /* Then we only use the songs; The videos will be ignored */
            [media filterUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRMp3MediaObject class])]];
        }
        /* Otherwise, we only have videos... */
      
// Facebook says you can only use 5 pictures, but testing didn't throw an error, even though
// it did throw errors when using more than one song or video. Just leaving this for now...
//        if ([images count] && [images count] > 5)
//        {
//            while ([media count] > 5)
//                [media removeLastObject];
//        }
//        else 
        if ([songs count] && [songs count] > 1)
        {
            while ([media count] > 1)
                [media removeLastObject];
        }
        else if ([videos count] && [images count] > 1)
        {
            while ([media count] > 1)
                [media removeLastObject];
        }
    }
}

// TODO: Is there a better way of doing this, like by using NSCoders to do the encoding?
/* This function goes through all of the fields of the activity object and turns the object into 
   an NSDictionary of string values and keys so that it can be converted into json by the json
   library.  It also validates the objects and escapes icky characters in the process. */
- (NSDictionary*)dictionaryForObject
{
    [self validateActivity];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:7] autorelease];
    [dict setValue:[action URLEscaped] forKey:@"action"];
    [dict setValue:[url URLEscaped] forKey:@"url"];
    
    if (user_generated_content)
        [dict setValue:[user_generated_content URLEscaped] forKey:@"user_generated_content"];
    
    if (title)
        [dict setValue:[title URLEscaped] forKey:@"title"];
    
    if (description)
        [dict setValue:[description URLEscaped] forKey:@"description"];
    
    if ([action_links count])
    {
        NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:[action_links count]] autorelease];
        
        for (JRActionLink *link in action_links)
        {
            [arr addObject:[link dictionaryForObject]];
        }
        
        [dict setValue:arr forKey:@"action_links"];
    }
    
    if ([media count])
    {
        DLog(@"[media count] = %d", [media count]);
        
        NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:[media count]] autorelease];
        
        for (JRMediaObject *item in media)
        {
            [arr addObject:[item dictionaryForObject]];
        }
        
        [dict setValue:arr forKey:@"media"];
    }
    
    // TODO: You still have written any code to handle all the different possibilities
    // that could go here, and this might end up crashing.  Find out if it does and fix this.
    if ([properties count])
        [dict setValue:properties forKey:@"properties"];
    
    return [NSDictionary dictionaryWithObject:dict forKey:@"activity"];
}
@end