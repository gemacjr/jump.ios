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
    JRMediaTypeImage,
    JRMediaTypeFlash,
    JRMediaTypeMp3
} JRMediaType;

@interface JRImageMediaObject : NSObject
{
    JRMediaType type;
    NSString *src;
    NSString *href;
}
@property (readonly) JRMediaType type;
@property (readonly) NSString *src;
@property (readonly) NSString *href;

- (id)initWithSrc:(NSString *)_src andHref:(NSString *)_href;
@end

@interface JRFlashMediaObject : NSObject
{
    JRMediaType type;
    NSString *swfsrc;
    NSString *imgsrc;		
    NSUInteger width;		
    NSUInteger height;
    NSUInteger expanded_width;
    NSUInteger expanded_height;
}
@property (readonly) JRMediaType type;
@property (readonly) NSString *swfsrc;
@property (readonly) NSString *imgsrc;
@property NSUInteger width;		
@property NSUInteger height;
@property NSUInteger expanded_width;
@property NSUInteger expanded_height;

- (id)initWithSwfsrc:(NSString *)_swfsrc andImgsrc:(NSString *)_imgsrc;
@end

@interface JRMp3MediaObject : NSObject
{
    JRMediaType type;
    NSString *src;
    NSString *title;
    NSString *artist;
    NSString *album;
}
@property (readonly) JRMediaType type;
@property (readonly) NSString *src;
@property (retain) NSString *title;
@property (retain) NSString *artist;
@property (retain) NSString *album;

- (id)initWithsrc:(NSString *)_src;
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


//@interface JRActivityElement : NSObject 
//{
//    //    NSString* name;
//    //    Class classType;
//    id value;
//    BOOL visable;
//    BOOL userCanEdit;
//    
//}
////@property (retain) NSString* name;
////@property (retain) Class classType;
//@property (retain) id value;
//@property BOOL visable;
//@property BOOL userCanEdit;
//
//
//@end
//
//@interface JRActionElement : JRActivityElement { }
//@end
//
//@interface JRUserContentElement : JRActivityElement { }
//@end
//
//@interface JRTitleElement : JRActivityElement { }
//@end
//
//@interface JRDescriptionElement : JRActivityElement { }
//@end
//
//@interface JRActionLinksElement : JRActivityElement { }
//@end
//
//@interface JRMediaObjectsElement : JRActivityElement { }
//@end
//
//@interface JRPropertiesElement : JRActivityElement { }
//@end

@interface JRActivityObject : NSObject 
{
    NSString *display_name;
    
    NSString            *action;  							
    NSString            *user_generated_content;
    NSString            *title;				
    NSString            *description;
    NSMutableArray      *action_links; 					
    NSMutableArray      *media;
    NSMutableDictionary *properties;
    
//    JRActionElement         *action;  							
//    JRUserContentElement    *user_generated_content;
//    JRTitleElement          *title;				
//    JRDescriptionElement    *description;
//    JRActionLinksElement    *action_links; 					
//    JRMediaObjectsElement   *media;
//    JRPropertiesElement     *properties;
}

@property (retain) NSString *display_name;
@property (retain) NSString *action;  							
@property (retain) NSString *user_generated_content;
@property (retain) NSString *title;				
@property (retain) NSString *description;
@property (retain) NSMutableArray *action_links; 					
@property (retain) NSMutableArray *media;
@property (retain) NSMutableDictionary *properties;

//@property (readonly) JRActionElement         *action;  							
//@property (readonly) JRUserContentElement    *user_generated_content;
//@property (readonly) JRTitleElement          *title;				
//@property (readonly) JRDescriptionElement    *description;
//@property (readonly) JRActionLinksElement    *action_links; 					
//@property (readonly) JRMediaObjectsElement   *media;
//@property (readonly) JRPropertiesElement     *properties;

- (id)initWithDisplayName:(NSString*)name;
- (NSDictionary*)dictionaryForObject;
@end
