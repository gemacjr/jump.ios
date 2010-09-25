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


/**
 * @file
 * \brief Interface for creating and populating activities that you wish to publish.
 * 
 * Interface for creating and populating activities that you wish to publish
 * to your user's social networks.  Create an activity object, fill in the 
 * object's fields, and pass the object to the JREngage library when you
 * are ready to share.
 **/

#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"

/**
 * Base class for \c JRImageMediaObject, \c JRFlashMediaObject, and \c JRMp3MediaObject.
 **/
@interface JRMediaObject : NSObject { }
@end

/**
 * \brief Image object to be included in a post to a user's stream. 
 *
 * Create an image media object, fill in the object's fields, and add the object
 * the JRActivity's media array.  How the images get presented and whether or 
 * not they are used, depend on the provider.
 *
 * Each image must contain a src URL, which maps to the photo's URL, and an 
 * href URL, which maps to the URL where a user should be taken if he or she clicks the photo.
 *
 * \sa Format and rules are identical to those described on the @link http://developers.facebook.com/docs/guides/attachments 
 * Facebook Developer page on Attachments. @endlink
 **/
@interface JRImageMediaObject : JRMediaObject
{
    // QTS: Place doxygen comments on instance variables or public properties?
    NSString *src;  /**< The photo's URL */
    NSString *href; /**< The URL where a user should be taken if he or she clicks the photo. */
    
    UIImage  *preview; /**< Contains the downloaded preview of the image for display in the publish activity dialog */
}
@property (readonly) NSString *src;
@property (readonly) NSString *href;
@property (retain) UIImage *preview;

/**
 * Returns a \c JRImageMediaObject initialized with the given src and href.
 *
 * @param _src
 *   The photo's URL.  This value cannot be \c nil.
 *
 * @param _href
 *   The URL where a user should be taken if he or she clicks the photo.  This value cannot be \c nil.
 *
 * @return
 *   A \c JRImageMediaObject initialized with the given \e src and \e href.  If either
 *   \c _src or \c _href are nil, returns \c nil.
 **/
- (id)initWithSrc:(NSString *)_src andHref:(NSString *)_href;
@end


/**
 * \brief Flash object to be included in a post to a user's stream. 
 *
 * Create an flash media object, fill in the object's fields, and add the object
 * the JRActivity's media array.  How the flash videos get presented and whether or 
 * not they are used, depend on the provider.
 *
 * Each video must contain a swfsrc url, which is the URL of the Flash object to be rendered,
 * and an imgsrc, which is the URL of an photo that should be displayed in place of the 
 * flash object until the user clicks to prompt the flash object to play.  Flash object
 * has two optional fields, \c width and \c height, which can be used to override the 
 * default choices when displaying the video in the provider's stream (e.g., Facebook's stream).
 * It also has two optional fields, \c expanded_width and \c expanded_height, to specify 
 * the width and height of flash object will resize to, on the provider's stream,
 * once the user clicks on it.
 *
 * \note You can only include one \c JRFlashMediaObject in the media array.  Any others
 * will be ignored.
 *
 * \sa Format and rules are identical to those described on the @link http://developers.facebook.com/docs/guides/attachments 
 * Facebook Developer page on Attachments. @endlink
 **/
@interface JRFlashMediaObject : JRMediaObject
{
    NSString *swfsrc;           /**< The URL of the Flash object to be rendered */
    NSString *imgsrc;           /**< The URL of an photo that should be displayed in place of the flash object */		
    NSUInteger width;           /**< Used to override the default width */		
    NSUInteger height;          /**< Used to override the default height */
    NSUInteger expanded_width;  /**< Width the video will resize to once the user clicks it */
    NSUInteger expanded_height; /**< Height the video will resize to once the user clicks it */
    
    UIImage *preview;           /**< Contains the downloaded preview of the image for display in the publish activity dialog */
}
@property (readonly) NSString *swfsrc;
@property (readonly) NSString *imgsrc;
@property NSUInteger width;		
@property NSUInteger height;
@property NSUInteger expanded_width;
@property NSUInteger expanded_height;
@property (retain) UIImage *preview;

/**
 * Returns a \c JRFlashMediaObject initialized with the given swfsrc and imgsrc.
 *
 * @param _swfsrc
 *   The URL of the Flash object to be rendered.  This value cannot be \c nil.
 *
 * @param _imgsrc
 *   The URL of an photo that should be displayed in place of the flash object.  This value cannot be \c nil.
 *
 * @return
 *   A \c JRFlashMediaObject initialized with the given \e swfsrc and \e imgsrc.  If either
 *   \c _swfsrc or \c _imgsrc are nil, returns \c nil.
 **/
- (id)initWithSwfsrc:(NSString *)_swfsrc andImgsrc:(NSString *)_imgsrc;
@end


/**
 * \brief Mp3 object to be included in a post to a user's stream. 
 *
 * Create an mp3 media object, fill in the object's fields, and add the object
 * the JRActivity's media array.  How the mp3s get presented and whether or 
 * not they are used, depend on the provider.
 *
 * Each mp3 must contain a src url, which is the URL of the MP3 file to be rendered. 
 * The mp3 can also include a title, artist, and album.
 *
 * \note You can only include one \c JRMp3MediaObject in the media array.  Any others
 * will be ignored.
 *
 * \sa Format and rules are identical to those described on the @link http://developers.facebook.com/docs/guides/attachments 
 * Facebook Developer page on Attachments. @endlink
 **/
@interface JRMp3MediaObject : JRMediaObject
{
    NSString *src;      /**< The URL of the MP3 file to be rendered */
    NSString *title;    /**< The title of the song */
    NSString *artist;   /**< The artist */
    NSString *album;    /**< The album */
}
@property (readonly) NSString *src;
@property (retain) NSString *title;
@property (retain) NSString *artist;
@property (retain) NSString *album;

/**
 * Returns a \c JRMp3MediaObject initialized with the given src.
 *
 * @param _src
 *   The URL of the MP3 file to be rendered.  This value cannot be \c nil.
 *
 * @return
 *   A \c JRMp3MediaObject initialized with the given \e src.  If 
 *   \c _src is nil, returns \c nil.
 **/
- (id)initWithsrc:(NSString *)_src;
@end


/**
 * \brief A link a user can use to take action on an activity update on the provider.
 *
 * Create an action link object, fill in the object's fields, and add the object
 * the JRActivity's action_links array.
 *
 * Each action link must contain a link, \c href, and some \c text, describing what action
 * will happen if someone clicks the link. 
 * (E.g., "Rate this quiz result", "http://example.com/quiz/12345/result/6789/rate")
 **/
@interface JRActionLink : NSObject
{
    NSString *text; /**< The text describing the link */
    NSString *href; /**< A link a user can use to take action on an activity update on the provider */
}
@property (retain) NSString *text;
@property (retain) NSString *href;

/**
 * Returns a \c JRActionLink initialized with the given text and href.
 *
 * @param _text
 *   The text describing the link.  This value cannot be \c nil.
 *
 * @param _imgsrc
 *   A link a user can use to take action on an activity update on the provider.  This value cannot be \c nil.
 *
 * @return
 *   A \c JRActionLink initialized with the given \e text and \e href.  If either
 *   \c _text or \c _href are nil, returns \c nil.
 **/
- (id)initWithText:(NSString *)_text andHref:(NSString *)_href;
@end


/**
 * \brief An activity object you create, populate, and post to the user's activity stream. 
 *
 * Create an activity object, fill in the object's fields, and pass the object to
 * the JREngage library when you are ready to publish. Currently supported providers are:
 *   - Facebook
 *   - LinkedIn
 *   - Twitter
 *   - MySpace
 *   - Yahoo!
 *
 * Janrain Engage will make a best effort to use all of the fields submitted in the activity request, 
 * but note that how they get presented (and which ones are used) ultimately depends on the provider.
 *
 * This API will work if and only if:
 *   - Your Janrain Engage application has been configured to authenticate using the user's provider
 *   - The user has already authenticated and has given consent to publish activity
 * 
 * Otherwise, you will be given an error response indicating what was wrong. Detailed error responses will 
 * also be given if the activity parameter does not meet the formatting requirements described below. 
 * 
 * \sa For more information of Janrain Engage's activity api, see @link https://rpxnow.com/docs#api_activity
 * the activity section of our API Documentation. @endlink
 **/
@interface JRActivityObject : NSObject 
{
   /**
    * A string describing what the user did, written in the third person (e.g., 
    * "wrote a restaurant review", "posted a comment", "took a quiz")
    **/
    NSString *action;  					
    
   /**
    * The URL of the resource being mentioned in the activity update 
    **/
    NSString *url;
    
   /**
    * A string containing user-supplied content, such as a comment or the first paragraph of an article 
    * that the user wrote. 
    * 
    * \note Some providers (Twitter in particular) may truncate this value.
    **/
    NSString *user_generated_content;    

   /**
    * The title of the resource being mentioned in the activity update. 
    * No length restriction on the status is imposed by Janrain Engage, 
    * however Yahoo truncates this value to 256 characters. 
    **/
    NSString *title;                     
    
   /**
    * A description of the resource mentioned in the activity update
    **/
    NSString *description;
    
   /**
    * An array of \c JRActionLink objects, each having two attributes: text and href. 
    * An action link is a link a user can use to take action on an activity update on the provider.
    * (E.g., "Take this quiz", "http://example.com/quiz/12345/take")
    * 
    * \note Any objects added to this array that are not of type \c JRActionLink will be ignored.
    **/
    NSMutableArray *action_links;
    
   /**
    * An array of objects with base class \c JRMediaObject (i.e., \c JRImageMediaObject, 
    * \c JRFlashMediaObject, \c JRMp3MediaObject). 
    * 
    * To publish attached media objects with your activity, create the preferred
    * object, populate the object's fields, then add the object to the \c media array.
    * You can attach pictures, videos, and mp3s to your activity, although how the
    * media objects get presented and whether or not they are used, depend on the provider.
    *
    * \note If you include more than one media type in the array, JREngage will 
    * choose only one of these types, in this order:
    *   -# image
    *   -# flash
    *   -# mp3
    * Also, any ojects added to this array that are not of type /c JRActionLink will be ignored.
    * 
    * \sa Media object format and rules are identical to those described on the @link http://developers.facebook.com/docs/guides/attachments 
    * Facebook Developer page on Attachments. @endlink
    **/   
    NSMutableArray *media;

   /**
    * An object with attributes describing properties of the update. An attribute value can be 
    * a string or an object with two attributes, text and href. 
    * Example:
    *   properties: 
    *   {
    *       "Time": "05:00",
    *       "Location": 
    *       {
    *           "text": "Portland",
    *           "href": "http://en.wikipedia.org/wiki/Portland,_Oregon"
    *       }
    *   }
    **/
    NSMutableDictionary *properties;
}

@property (readonly) NSString *action;  							
@property (readonly) NSString *url;
@property (retain) NSString *user_generated_content;
@property (retain) NSString *title;				
@property (retain) NSString *description;
@property (retain) NSMutableArray *action_links; 					
@property (retain) NSMutableArray *media;
@property (retain) NSMutableDictionary *properties;

/**
 * Returns a \c JRActivityObject initialized with the given action and url.
 *
 * @param _action
 *   A string describing what the user did, written in the third person.  This value cannot be \c nil.
 *
 * @param _url
 *   The URL of the resource being mentioned in the activity update.  This value cannot be \c nil.
 *
 * @return
 *   A \c JRActionObject initialized with the given \e action and \e url.  If either
 *   \c _action or \c _url are nil, returns \c nil.
 **/
- (id)initWithAction:(NSString*)_action andUrl:(NSString*)_url;

/**
 * Returns an \c NSDictionary representing the \c JRActivityObject.
 *
 * @return
 *   An \c NSDictionary of \c NSString objects representing the \c JRActivityObject.
 *
 * \note This function should not be used directly.  It is intended only for use by the
 * JREngage library.
 **/
- (NSDictionary*)dictionaryForObject;
@end
