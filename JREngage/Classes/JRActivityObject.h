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
 
 File:	 JRActivityObject.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"

//typedef NSError ActivityValidationError;
//typedef NSError ActivityValidationWarning;
//
//typedef enum
//{
//	JRMoreThanOnKindOfMediaInActivityWarning = 200,
//} JRActivityError;
//
//#define JRWarningSeverityMinor @"minor"
//#define JRWarningSeverityMajor @"major"
//#define JRWarningSeverityActivityValidationHasWarnings @"activityValidationHasWarnings"
//#define JRWarningSeverityActivityValidationHasWarningsInMedia @"activityValidationHasWarnings"
//
//#define JRErrorSeverityActivityValidationFailed @"activityValidationFailed"

typedef enum
{
    JRMediaTypeImage = 1,
    JRMediaTypeFlash,
    JRMediaTypeMp3
} JRMediaType;

@interface NSObject (CFAdditions)
- (NSString*)cf_baseClassName;
- (NSString*)cf_className;
@end

@implementation NSObject (CFAdditions)
- (NSString *) cf_baseClassName { return NSStringFromClass([self superclass]); }
- (NSString *) cf_className { return NSStringFromClass([self class]); }
@end

@class JRActivityObject;
@protocol JRActivityValidatorDelegate <NSObject>
@optional
- (void)jrActivityObjectPassedValidation:(JRActivityObject*)activity;
- (void)jrActivityObjectPassedValidation:(JRActivityObject*)activity withWarnings:(NSArray*)warnings;
- (void)jrActivityObjectFailedValidation:(JRActivityObject*)activity withErrors:(NSArray*)errors;
@end

@interface JRMediaObject : NSObject { }
@end

@interface JRImageMediaObject : JRMediaObject
{
    NSString *src;
    NSString *href;
    
    UIImage  *preview;
}
@property (readonly) NSString *src;
@property (readonly) NSString *href;
@property (retain) UIImage *preview;

- (id)initWithSrc:(NSString *)_src andHref:(NSString *)_href;
@end

@interface JRFlashMediaObject : JRMediaObject
{
    NSString *swfsrc;
    NSString *imgsrc;		
    NSUInteger width;		
    NSUInteger height;
    NSUInteger expanded_width;
    NSUInteger expanded_height;

    UIImage *preview;
}
@property (readonly) NSString *swfsrc;
@property (readonly) NSString *imgsrc;
@property NSUInteger width;		
@property NSUInteger height;
@property NSUInteger expanded_width;
@property NSUInteger expanded_height;
@property (retain) UIImage *preview;

- (id)initWithSwfsrc:(NSString *)_swfsrc andImgsrc:(NSString *)_imgsrc;
@end

@interface JRMp3MediaObject : JRMediaObject
{
    NSString *src;
    NSString *title;
    NSString *artist;
    NSString *album;
}
@property (readonly) NSString *src;
@property (retain) NSString *title;
@property (retain) NSString *artist;
@property (retain) NSString *album;

- (id)initWithsrc:(NSString *)_src;
@end

//@interface JRPhotoObject : NSObject
//{
//    NSString *path;
//    NSString *album;
//}
//@property (retain) NSString *path;
//@property (retain) NSString *album;
//
//- (id)initWithPath:(NSString *)_path andAlbum:(NSString*)_album;
//@end

@interface JRActionLink : NSObject
{
    NSString *text;
    NSString *href;
}
@property (retain) NSString *text;
@property (retain) NSString *href;

- (id)initWithText:(NSString *)_text andHref:(NSString *)_href;
@end

@interface JRActivityObject : NSObject <JRConnectionManagerDelegate>
{
    NSString            *action;  							
    NSString            *url;
    NSString            *user_generated_content;
    NSString            *title;				
    NSString            *description;
    NSMutableArray      *action_links; 					
    NSMutableArray      *media;
    NSMutableDictionary *properties;
//  JRPhotoObject       *attachment;
}

@property (readonly) NSString *action;  							
@property (readonly) NSString *url;
@property (retain) NSString *user_generated_content;
@property (retain) NSString *title;				
@property (retain) NSString *description;
@property (retain) NSMutableArray *action_links; 					
@property (retain) NSMutableArray *media;
@property (retain) NSMutableDictionary *properties;
//@property (retain) JRPhotoObject  *attachment;

- (id)initWithAction:(NSString*)_action andUrl:(NSString*)_url;
- (NSDictionary*)dictionaryForObject;
//- (void)validateActivityForDelegate:(id<JRActivityValidatorDelegate>)delegate;
@end
