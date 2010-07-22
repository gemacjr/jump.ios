//
//  JRActivityObject.h
//  JRAuthenticate
//
//  Created by lilli on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    JRMediaTypeImage = 1,
    JRMediaTypeFlash,
    JRMediaTypeMp3
} JRMediaType;

@interface JRMediaObject : NSObject
{
    JRMediaType type;
}
// TODO: Do we need this or is the isKindOfClass method going to perform the same function
@property (readonly) JRMediaType type;
@end


@interface JRImageMediaObject : JRMediaObject
{
//    JRMediaType type;
    NSString *src;
    NSString *href;
}
//@property (readonly) JRMediaType type;
@property (readonly) NSString *src;
@property (readonly) NSString *href;

- (id)initWithSrc:(NSString *)_src andHref:(NSString *)_href;
@end

@interface JRFlashMediaObject : JRMediaObject
{
//    JRMediaType type;
    NSString *swfsrc;
    NSString *imgsrc;		
    NSUInteger width;		
    NSUInteger height;
    NSUInteger expanded_width;
    NSUInteger expanded_height;
}
//@property (readonly) JRMediaType type;
@property (readonly) NSString *swfsrc;
@property (readonly) NSString *imgsrc;
@property NSUInteger width;		
@property NSUInteger height;
@property NSUInteger expanded_width;
@property NSUInteger expanded_height;

- (id)initWithSwfsrc:(NSString *)_swfsrc andImgsrc:(NSString *)_imgsrc;
@end

@interface JRMp3MediaObject : JRMediaObject
{
//    JRMediaType type;
    NSString *src;
    NSString *title;
    NSString *artist;
    NSString *album;
}
//@property (readonly) JRMediaType type;
@property (readonly) NSString *src;
@property (retain) NSString *title;
@property (retain) NSString *artist;
@property (retain) NSString *album;

- (id)initWithsrc:(NSString *)_src;
@end


@interface JRPhotoObject : NSObject
{
    NSString *path;
    NSString *album;
}
@property (retain) NSString *path;
@property (retain) NSString *album;

- (id)initWithPath:(NSString *)_path andAlbum:(NSString*)_album;
@end

@interface JRActionLink : NSObject
{
    NSString *text;
    NSString *href;
}
@property (retain) NSString *text;
@property (retain) NSString *href;

- (id)initWithText:(NSString *)_text andHref:(NSString *)_href;
@end

@interface JRActivityObject : NSObject 
{
    NSString *display_name;
    
    NSString            *action;  							
    NSString            *user_generated_content;
    NSString            *title;				
    NSString            *description;
    NSMutableArray      *action_links; 					
    NSMutableArray      *media;
    JRPhotoObject       *attachment;
    NSMutableDictionary *properties;
}

@property (retain) NSString *display_name;
@property (retain) NSString *action;  							
@property (retain) NSString *user_generated_content;
@property (retain) NSString *title;				
@property (retain) NSString *description;
@property (retain) NSMutableArray *action_links; 					
@property (retain) NSMutableArray *media;
@property (retain) JRPhotoObject  *attachment;
@property (retain) NSMutableDictionary *properties;

- (id)initWithDisplayName:(NSString*)name;
- (NSDictionary*)dictionaryForObject;
@end
