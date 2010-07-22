//
//  JRActivityObject.m
//  JRAuthenticate
//
//  Created by lilli on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JRActivityObject.h"


@interface NSString (NSString_URL_ESCAPING)

- (NSString*)URLEscaped;

@end


@implementation NSString (NSString_URL_ESCAPING)

- (NSString*)URLEscaped
{
//    NSString *str = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
    
    return str;
}

@end


@implementation JRMediaObject 
@synthesize type;
- (id)initWithType:(JRMediaType)_type 
{
    if (!_type)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        type = _type;
    }
    
    return self;
}
@end

@interface JRImageMediaObject ()
- (NSDictionary*)dictionaryForObject;
@end

@interface JRMp3MediaObject ()
- (NSDictionary*)dictionaryForObject;
@end

@interface JRFlashMediaObject ()
- (NSDictionary*)dictionaryForObject;
@end


@implementation JRImageMediaObject 
//@synthesize type;
@synthesize src;
@synthesize href;
- (id)initWithSrc:(NSString*)_src andHref:(NSString*)_href
{
    if (!_src || !_href)
    {
        [self release];
        return nil;
    }
    
    if (self = [super initWithType:JRMediaTypeImage])
    {
        src = _src;
        href = _href;
    }
    
    return self;
}

- (NSDictionary*)dictionaryForObject
{
//    NSDictionary *odfs = [[NSDictionary alloc] initWithObjectsAndKeys:@"type", @"image", @"src", src, @"href", href, nil];
    return [[[NSDictionary alloc] initWithObjectsAndKeys:
             @"image", @"type", 
             [src URLEscaped], @"src", 
             [href URLEscaped], @"href", nil] autorelease];
}
@end

@implementation JRFlashMediaObject 
//@synthesize type;
@synthesize swfsrc;
@synthesize imgsrc;
@synthesize width;		
@synthesize height;
@synthesize expanded_width;
@synthesize expanded_height;
- (id)initWithSwfsrc:(NSString*)_swfsrc andImgsrc:(NSString*)_imgsrc
{
    if (!_swfsrc || !_imgsrc)
    {
        [self release];
        return nil;
    }
    
    if (self = [super initWithType:JRMediaTypeFlash])
    {
        swfsrc = _swfsrc;
        imgsrc = _imgsrc;
    }
    
    return self;
}

- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                                  @"flash", @"type", 
                                  [swfsrc URLEscaped], @"swfsrc", 
                                  [imgsrc URLEscaped], @"imgsrc", nil] autorelease];

    if (width)
        [dict setObject:[NSString stringWithFormat:@"%d", width] forKey:@"width"];
//        [dict setValue:width forKey:@"width"];
    
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
//@synthesize type;
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
    
    if (self = [super initWithType:JRMediaTypeMp3])
    {
        src = _src;
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


@interface JRPhotoObject ()
- (NSDictionary*)dictionaryForObject;
@end

@implementation JRPhotoObject 
@synthesize path;
@synthesize album;

- (id)initWithPath:(NSString *)_path andAlbum:(NSString*)_album;
{
    // TODO: Make sure the path points to a real picture, as well
    if (!_path)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        path = _path;
        album = _album;
    }
    
    return self;
}

- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                                  @"attachment", @"photo", 
                                  [path URLEscaped], @"source", nil] autorelease];
    
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
        text = _text;
        href = _href;
    }
    
    return self;
}

- (NSDictionary*)dictionaryForObject
{
    //    NSDictionary *odfs = [[NSDictionary alloc] initWithObjectsAndKeys:@"type", @"image", @"src", src, @"href", href, nil];
    return [[[NSDictionary alloc] initWithObjectsAndKeys:
             [text URLEscaped], @"text",
             [href URLEscaped], @"href", nil] autorelease];
}

@end


@implementation JRActivityObject
@synthesize display_name;
@synthesize action;  							
@synthesize user_generated_content;
@synthesize title;				
@synthesize description;
@synthesize action_links; 					
@synthesize media;
@synthesize attachment;
@synthesize properties;

- (id)initWithDisplayName:(NSString*)name
{
    if (!name)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init]) 
	{
        display_name = name;
    }
    
	return self;
}


- (NSDictionary*)dictionaryForObject
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:7] autorelease];
    [dict setValue:[action URLEscaped] forKey:@"action"];
    
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
        NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:[media count]] autorelease];
        
        for (JRActionLink *item in media)
        {
            [arr addObject:[item dictionaryForObject]];
        }
        
        [dict setValue:arr forKey:@"media"];
    }
    
    if (attachment)
        [dict setValue:[attachment dictionaryForObject] forKey:@"attachment"];

    
    if ([properties count])
        [dict setValue:properties forKey:@"properties"];
    
    return dict;
}


@end

