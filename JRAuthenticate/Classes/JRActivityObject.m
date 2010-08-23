//
//  JRActivityObject.m
//  JRAuthenticate
//
//  Created by lilli on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JRActivityObject.h"
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


@interface NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped;
@end


@implementation NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped
{
//    NSString *str = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%34"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%38"];
    
    return str;
}
@end


//@interface NSCFString (NSString_URL_ESCAPING)
//- (NSString*)URLEscaped;
//@end
//
//
//@implementation NSCFString (NSString_URL_ESCAPING)
//- (NSString*)URLEscaped
//{
//    //    NSString *str = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
//    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
//    
//    return str;
//}
//@end

@protocol JRMediaObjectProtocol
- (NSDictionary*)dictionaryForObject;
@end

//@interface JRMediaObject () <JRMediaObjectProtocol>
//@end


@implementation JRMediaObject 
- (id)init
{
    return [super init];
}
@end

@interface JRImageMediaObject () <JRMediaObjectProtocol>
@property (retain) NSString *tag;
//- (NSDictionary*)dictionaryForObject;
@end

@interface JRMp3MediaObject () <JRMediaObjectProtocol>
//- (NSDictionary*)dictionaryForObject;
@end

@interface JRFlashMediaObject () <JRMediaObjectProtocol>
@property (retain) NSString *tag;
//- (NSDictionary*)dictionaryForObject;
@end


@implementation JRImageMediaObject 
@synthesize src;
@synthesize href;
@synthesize preview;
@synthesize tag;

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
@synthesize tag;

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


//@interface JRPhotoObject ()
//- (NSDictionary*)dictionaryForObject;
//@end
//
//@implementation JRPhotoObject 
//@synthesize path;
//@synthesize album;
//
//- (id)initWithPath:(NSString *)_path andAlbum:(NSString*)_album;
//{
//    // TODO: Make sure the path points to a real picture, as well
//    if (!_path)
//    {
//        [self release];
//        return nil;
//    }
//    
//    if (self = [super init])
//    {
//        path = _path;
//        album = _album;
//    }
//    
//    return self;
//}
//
//- (NSDictionary*)dictionaryForObject
//{
//    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: 
//                                  @"attachment", @"photo", 
//                                  [path URLEscaped], @"source", nil] autorelease];
//    
//    if (album)
//        [dict setValue:[album URLEscaped] forKey:@"album"];
//    
//    return dict;
//}
//@end


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

- (void)setMedia:(NSMutableArray *)_media
{
    media = [[NSMutableArray arrayWithArray:
              [_media filteredArrayUsingPredicate:
               [NSPredicate predicateWithFormat:@"cf_baseClassName = %@", NSStringFromClass([JRMediaObject class])]]] retain];
}

- (NSMutableArray*)media
{
    if (!media)
        media = [[NSMutableArray alloc] initWithCapacity:1];
    
    return media;
}

- (void)setAction_links:(NSMutableArray *)_action_links
{
    action_links = [[NSMutableArray arrayWithArray:
                     [_action_links filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRActionLink class])]]] retain];
}

- (NSMutableArray*)action_links
{
    if (!action_links)
        action_links = [[NSMutableArray alloc] initWithCapacity:1];

    return action_links;
}

- (void)validateActivity//ForDelegate:(id<JRActivityValidatorDelegate>)delegate
{    
    if ([media count] > 0)
    {
        NSArray *images = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRImageMediaObject class])]];
        NSArray *songs  = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRMp3MediaObject class])]];
        NSArray *videos = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRFlashMediaObject class])]];
        
        DLog(@"images count: %d", [images count]);
        DLog(@"songs count : %d", [songs count]);
        DLog(@"videos count: %d", [videos count]);
        
        // If we have images and either songs or videos or both
        if ([images count] && ([songs count] || [videos count]))
        {
            DLog(@"([images count] && ([songs count] || [videos count]))");
            
            // Set Warning
            //            ActivityValidationWarning *warning = [self setError:@"" 
            //                                                       withCode:JRMoreThanOnKindOfMediaInActivityWarning 
            //                                                    andSeverity:JRWarningSeverityActivityValidationHasWarnings];
            
            // Only using images, songs or video will be ignored
            // Keep only images
            [media filterUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRImageMediaObject class])]];
        }
        else if ([songs count] && [videos count])
        {
            DLog(@"([songs count] && [videos count])");
            // Set Warning
            // Only using songs (or videos - whatever Facebook says)
            // Keep only songs
            [media filterUsingPredicate:[NSPredicate predicateWithFormat:@"cf_className = %@", NSStringFromClass([JRMp3MediaObject class])]];
        }
        
        //        if ([images count])
        //        {
        //            DLog(@"([images count])");
        //            
        //            // TODO: Determine if you can send more than 4 or 5 pictures
        ////            if ([images count] > 5)
        ////            {
        ////                DLog(@"([images count] > 5)");
        ////                // Set warning
        ////                // Only using first 5 images
        ////                // Set media to only first 5
        ////                while ([media count] > 5)
        ////                    [media removeLastObject];
        ////                //[media removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:{5, [images count]}]];
        ////            }
        ////            else
        ////            {
        ////                // Set media to images ... or it already is ...
        ////            }
        //            
        //            NSUInteger index = 0;
        //            for (JRImageMediaObject *image in media)
        //            {
        //                NSURL        *_url = [NSURL URLWithString:image.src];
        //                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_url];
        //                NSString     *tag = [NSString stringWithFormat:@"fetchImageThumbnail_%d", index++];
        //
        ////                image.tag = tag;
        //                
        //                if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO])
        //                {
        //                    DLog("(![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO])");
        //                    // Set warning
        //                }
        //                
        //                [request release];            
        //            }   
        //        }
        //        else 
        if ([songs count])
        {
            DLog(@"([songs count])");
            if ([songs count] > 1)
            {
                DLog(@"([songs count] > 1)");
                // Set warning
                // Only using first song
                // Set media to only first song
                while ([media count] > 1)
                    [media removeLastObject];
            }
            else
            {
                // Set media to songs ... or it already is ...
            }
            
            //            JRMp3MediaObject *song = [media objectAtIndex:0];            
            //            if (![NSURLConnection canHandleRequest:[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:song.src]] autorelease]])
            //            {
            //                DLog(@"(![NSURLConnection canHandleRequest:[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:song.src]] autorelease]])");
            //                // Set error
            //            }
        }
        else if ([videos count])
        {
            DLog(@"([videos count)]");
            if ([videos count] > 1)
            {            
                DLog(@"([videos count] > 1)");
                // Set warning
                // Only using first video
                // Set media to only first video
                while ([media count] > 1)
                    [media removeLastObject];
            }
            else
            {
                // Set media to songs ... or it already is ...
            }
            
            //            JRFlashMediaObject *video = [media objectAtIndex:0];            
            //            if (![NSURLConnection canHandleRequest:[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:video.swfsrc]] autorelease]])
            //            {
            //                DLog(@"(![NSURLConnection canHandleRequest:[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:video.swfsrc]] autorelease]])");
            //                // Set error
            //            }
            //
            //            NSURL        *_url = [[NSURL URLWithString:video.imgsrc] autorelease];
            //            NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:_url] autorelease];
            //            NSString     *tag = @"fetchVideoPreview";
            
            //            video.tag = tag;
            
            //            if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO])
            //            {
            //                DLog(@"(![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO])");
            //                // Set error
            //            }
            
        }
    }
}

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
    
//    if (attachment)
//        [dict setValue:[attachment dictionaryForObject] forKey:@"attachment"];
    
    if ([properties count])
        [dict setValue:properties forKey:@"properties"];
    
    return [NSDictionary dictionaryWithObject:dict forKey:@"activity"];
}

//- (NSError*)setError:(NSString*)message withCode:(NSInteger)code andSeverity:(NSString*)severity
//{
//    DLog(@"");
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                               message, NSLocalizedDescriptionKey,
//                               severity, @"severity", nil];
//    
//    return [[NSError alloc] initWithDomain:@"JRAuthenticate"
//                                      code:code
//                                  userInfo:userInfo] ;
//}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }

- (void)setPreview:(NSData*)preview forObject:(JRMediaObject*)mediaObject
{
//    if ([mediaObject performSelector:setPreviewImage])
//        [mediaObject setPreviewImage:[UIImage imageWithData:preview]];         
}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata 
{
    NSString *tag = (NSString*)userdata;
    
    if ([tag hasPrefix:@"fetchImagePreview"])
    {
        NSArray *imageArr = [media filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag = %@", tag]];
        
        if ([imageArr count] != 1)
        {
            DLog(@"uh oh!");
        }
        else
        {    
            [self setPreview:payload forObject:[imageArr objectAtIndex:0]];
        }

    }
    else if ([tag hasPrefix:@"fetchVideoPreview"])
    {
        
    }



}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata { }

- (void)connectionWasStoppedWithTag:(void*)userdata { }
@end