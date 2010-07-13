//
//  JRActivityObject.m
//  JRAuthenticate
//
//  Created by lilli on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JRActivityObject.h"
@implementation JRImageMediaObject 
@synthesize type;
@synthesize src;
@synthesize href;
- (id)initWithSrc:(NSString*)_src andHref:(NSString*)_href
{
    if (!_src || !_href)
    {
        [self release];
        return nil;
    }
    
    if (self = [super init])
    {
        type = JRMediaTypeImage;
        src = _src;
        href = _href;
    }
    
    return self;
}
@end

@implementation JRFlashMediaObject 
@synthesize type;
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
    
    if (self = [super init])
    {
        type = JRMediaTypeFlash;
        swfsrc = _swfsrc;
        imgsrc = _imgsrc;
    }
    
    return self;
}
@end

@implementation JRMp3MediaObject 
@synthesize type;
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
        type = JRMediaTypeMp3;
        src = _src;
    }
    
    return self;
}
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

@end

@implementation JRActionElement
- (id)init
{
    return self = [super init];
}
@end

@implementation JRUserContentElement
- (id)init
{
    return self = [super init];
}
@end

@implementation JRTitleElement
- (id)init
{
    return self = [super init];
}
@end

@implementation JRDescriptionElement
- (id)init
{
    return self = [super init];
}
@end

@implementation JRActionLinksElement
- (id)init
{
    return self = [super init];
}

- (void)setValue:(id)_value
{
    [value release];
    if ([_value isKindOfClass:[NSArray class]])
        value = ((NSMutableArray*)[[NSMutableArray alloc] initWithArray:(NSArray*)_value]);
    else if ([_value isKindOfClass:[JRActionLink class]])
        value = ((NSMutableArray*)[[NSMutableArray alloc] initWithObjects:(JRActionLink*)_value, nil]);
}
@end

@implementation JRMediaObjectsElement
- (id)init
{
    return self = [super init];
}

- (void)setValue:(id)_value
{
    [value release];
    if ([_value isKindOfClass:[NSArray class]])
        value = ((NSMutableArray*)[[NSMutableArray alloc] initWithArray:(NSArray*)_value]);
    //    else if ([_value isKindOfClass:[JRMediaObject class]])
    //        value = ((NSMutableArray*)[[NSMutableArray alloc] initWithObjects:(JRMediaObject*)_value, nil]);
}
@end

@implementation JRPropertiesElement
- (id)init
{
    return self = [super init];
}

- (void)setValue:(id)_value
{
    [value release];
    if ([_value isKindOfClass:[NSDictionary class]])
        value = ((NSMutableDictionary*)[[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)_value]);
}
@end

@implementation JRActivityElement 
//@synthesize name;
//@synthesize value;
//@synthesize classType;
@dynamic value;
@synthesize visable;
@synthesize userCanEdit;    

- (id)init//WithClassType:(Class)class
{
    //    if (class == nil)
    //	{
    //		[self release];
    //		return nil;
    //	}
	
	if (self = [super init]) 
	{
        //    value = [class alloc];
        //    classType = class;
    }
    
    return self;
}

- (void)setValue:(id)_value
{
    [value release];
    value = ((NSString*)[[NSString alloc] initWithString:_value]);
}

- (id)getValue
{
    return value;
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
//        action                  = [[JRActivityObject alloc] init];
//        user_generated_content  = [[JRActivityObject alloc] init];
//        title                   = [[JRActivityObject alloc] init];
//        description             = [[JRActivityObject alloc] init];
//        action_links            = [[JRActivityObject alloc] init];
//        media                   = [[JRActivityObject alloc] init];
//        properties              = [[JRActivityObject alloc] init];
    }
    
	return self;
}

@end

