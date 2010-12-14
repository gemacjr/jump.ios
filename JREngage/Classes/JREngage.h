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
 
 File:	 JREngage.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/**
 * @mainpage Janrain Engage for the iPhone, version 2
 *
 * <a href="http://rpxnow.com/docs/iphone">
 * Janrain Engage for iPhone SDK</a> makes it easy to include third party authentication and 
 * social publishing in your iPhone app.  This Objective-C library includes the same key
 * features as our web version, as well as additional features created specifically for the mobile 
 * platform. With as few as three lines of code, you can authenticate your users with their 
 * accounts on Google, Yahoo!, Facebook, etc., and they can immediately publish their 
 * activities to multiple social networks, including Facebook, Twitter, LinkedIn, MySpace,
 * and Yahoo, through one simple interface.
 *
 * Beyond authentication and social sharing, the latest release of the Engage for iPhone SDK
 * now allows mobile apps to:
 *   - Share content, activities, game scores or invitations via Email or SMS
 *   - Customize the login experience by displaying native and social login options on the same screen
 *   - Track popularity and click through rates on various links included in the 
 *     shared email message with automatic URL shortening for up to 5 URLs
 *   - Provide an additional level of security with forced re-authentication when 
 *     users are about to make a purchase or conduct a sensitive transaction
 *   - Configure and maintain separate lists of providers for mobile and web apps
 *   - Match the look and feel of the iPhone app with customizable background colors, images, and navigation bar tints
 * 
 * Before you begin, you need to have created a <a href="https://rpxnow.com/signup_createapp_plus">Janrain Engage application</a>,
 * which you can do on <a href="http://rpxnow.com">http://rpxnow.com</a>
 *
 * For an overview of how the library works and how you can take advantage of the library's features, 
 * please see the <a href="http://rpxnow.com/docs/iphone_v2#user_experience">"Overview"</a> section of our documentation.
 * 
 * To begin using the SDK, please see the <a href="http://rpxnow.com/docs/iphone_v2#quick">"Quick Start Guide"</a>.
 * 
 * For more detailed documentation of the library's API, you can use 
 * the <a href="http://rpxnow.com/docs/iphone_api/annotated.html">"JREngage API"</a> documentation.
 **/

/**
 * \page Providers
 * \section basicProviders List of Providers
 *
 * Here is a list of possible strings that the argument (NSString*)provider can be
 * when used in the authentication methods:
 *   - "aol"
 *   - "blogger"
 *   - "facebook"
 *   - "flickr"
 *   - "google"
 *   - "hyves"
 *   - "linkedin"
 *   - "live_id"
 *   - "livejournal"
 *   - "myopenid"
 *   - "myspace"
 *   - "netlog"
 *   - "openid"
 *   - "paypal"
 *   - "twitter"
 *   - "verisign"  
 *   \if wordpress_is_working 
 *   - "wordpress"
 *   \endif
 *   - "yahoo" 
 *
 * \note As your Engage application is limited by the number of providers it may use, 
 * you may only see a subset of this list.
 *
 * \section socialProviders List of Social Providers
 *
 * Here is a list of possible strings that the argument (NSString*)provider can be
 * when used in the social publishing methods:
 *   - "facebook"
 *   - "linkedin"
 *   - "myspace"
 *   - "twitter"
 *   - "yahoo" 
 *
 * \note As your Engage application is limited by the number of providers it may use, 
 * you may only see a subset of this list.
 **/


/* Preprocessor directive that conditionally compiles the code that uses the weakly-linked MessageUI.Framework.
 This framework is required if you want to include the ability to share activities with email or sms.  By default
 the JRENGAGE_INCLUDE_EMAIL_SMS flag should always be set to "1", which can cause errors with the linker if the 
 framework isn't included, but I figured most apps would want the email and sms sharing ability.  If you don't want
 to add the MessageUI.Framework to one or more of your apps that use the JREngage library, you don't have to change
 this value to "0" (which could cause merging issues if I make changes later).
 
 Instead, if you want to override this setting, you need to add the preprocessor flag "OVERRIDE_INCLUDE_EMAIL_SMS"
 to your target's GCC_PREPROCESSOR_DEFINITIONS build setting (also listed as "Preprocessor Macros" under the
 "GCC 4.2 - Preprocessing" heading). */
#ifndef OVERRIDE_INCLUDE_EMAIL_SMS
#define JRENGAGE_INCLUDE_EMAIL_SMS 1
#endif

/**
 * @defgroup customInterface Custom User Interface
 * \brief Customize the user interface with your application's colors, images, native login, etc.
 *
 * \detail
 * The Engage for iPhone SDK provides the ability to customize the look and feel of the user interface,
 * as well as the ability to add your own native login experience, through the Custom Interface API.  
 * You can set many of the interface defaults in the JREngage-Info.plist file and override these defaults
 * programmatically through any of the ...CustomInterface functions.  
 *
 * The SDK accepts a dictionaries of values, indexed by a pre-defined set of keys (below), 
 * and uses these to set the properties of the library's user interface.
 *
 * First, the library loads the DefaultValues dictionary from the JREngage.CustomInterface section of the 
 * JREngage-Info.plist file, and uses these values when configuring the library's user interface.
 * Then, the library loads the CustomValues dictionary from the JREngage.CustomInterface section of the 
 * JREngage-Info.plist file.  Any values specified in this section of the property list will override
 * the corresponding default value specified in the DefaultValues section.  You should only makes changes
 * to the CustomValues section*. TODO ADD FOOTNOTE
 *
 * To configure the SDK programmatically (e.g., dynamically integrating your native login experience
 * above or below the library's social logins), create an NSDictionary object, indexed by a pre-defined set of 
 * keys (below) and pass this to the library through the  - (void)setCustomInterface:(NSDictionary*)customizations
 * method.  Any values specified in this dictionary will override the corresponding values specified in the 
 * JREngage-Info.plist. 
 *
 * You can also launch authentication and social sharing with a custom interface dictionary through 
 * the - (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations 
 * or - (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity andCustomInterface:(NSDictionary*)customizations
 * methods.  Any values passed into the show...Dialog methods will override the corresponding values passed into 
 * the - (void)setCustomInterface:(NSDictionary*)customizations method.
 *
 * @{
 **/

/** 
 * \name Navigation Bar Tint
 * Key to specify the tint color of the library's navigation bar
 **/
/*@{*/

/**
 * Key for a \c UIColor object to set as the tint color of the library's navigation bar
 *
 * \note If you push the library's dialogs onto your own navigation controller, setting this value will have no effect.
 **/
#define kJRNavigationBarTintColor  @"NavigationBar.TintColor"

/**
 * Key for an \c NSArray of doubles to set as the RGBa tint values for color of the library's navigation bar
 *
 * \note If you push the library's dialogs onto your own navigation controller, setting this value will have no effect.
 **/
#define kJRNavigationBarTintColorRGBa  @"NavigationBar.TintColor.RGBa"
/*@}*/


/** 
 * \name Background Colors
 * Keys to specify the background colors of the library's dialogs
 **/
/*@{*/

/**
 * Key for a \c UIColor object to set as the background color of the Providers Table and the User Landing screen.
 **/
#define kJRAuthenticationBackgroundColor  @"Authentication.Background.Color"

/**
 * Key for a \c UIColor object to set as the background color of the Social Sharing screen.
 **/
#define kJRSocialSharingBackgroundColor   @"SocialSharing.Background.Color"

/**
 * Key for an \c NSArray of doubles to set as the RGBa values of the background color for the Providers Table and the User Landing screen.
 **/
#define kJRAuthenticationBackgroundColorRGBa  @"Authentication.Background.Color.RGBa"

/**
 * Key for an \c NSArray of doubles to set as the RGBa values of the background color for the Social Sharing screen.
 **/
#define kJRSocialSharingBackgroundColorRGBa   @"SocialSharing.Background.Color.RGBa"
/*@}*/

/** 
 * \name Background Images
 * Keys to specify the name of the images to be used as the background of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \c NSString name of the image to be set as the background image of the Providers Table on the iPhone.
 **/
#define kJRProviderTableBackgroundImageName   @"ProviderTable.Background.Image.Name"

/**
 * Key for the \c NSString name of the image to be set as the background image of the User Landing screen on the iPhone.
 **/
#define kJRUserLandingBackgroundImageName     @"UserLanding.Background.Image.Name"

/**
 * Key for the \c NSString name of the image to be set as the background image of the Social Sharing screen on the iPhone.
 **/
#define kJRSocialSharingBackgroundImageName   @"SocialSharing.Background.Image.Name"

/**
 * Key for the \c NSString name of the image to be set as the background image of the Providers Table on the iPad.
 **/
#define kJRProviderTableBackgroundImageName_iPad   @"ProviderTable.Background.Image.Name-iPad"

/**
 * Key for the \c NSString name of the image to be set as the background image of the User Landing screen on the iPad.
 **/
#define kJRUserLandingBackgroundImageName_iPad     @"UserLanding.Background.Image.Name-iPad"

/**
 * Key for the \c NSString name of the image to be set as the background image of the Social Sharing screen on the iPad.
 **/
#define kJRSocialSharingBackgroundImageName_iPad   @"SocialSharing.Background.Image.Name-iPad"
/*@}*/

/** 
 * \name Title Views
 * Keys to specify the UIViews to be used as the title views of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \c UIView object to be set as the title view of the Providers Table on the iPhone.
 *
 * \note If this value is set, it will override any string value set for kJRProviderTableTitleString,
 * although the kJRProviderTableTitleString value will be used as the text on the back button.
 **/
#define kJRProviderTableTitleView        @"ProviderTable.Title.View"

/**
 * Key for the \c UIView object to be set as the title view of the Social Sharing screen on the iPhone.
 *
 * \note If this value is set, it will override any string value set for kJRSocialSharingTitleString,
 * although the kJRSocialSharingTitleString value will be used as the text on the back button.
 **/
#define kJRSocialSharingTitleView        @"SocialSharing.Title.View"

/**
 * Key for the \c UIView object to be set as the title view of the Providers Table on the iPad.
 *
 * \note If this value is set, it will override any string value set for kJRProviderTableTitleString,
 * although the kJRProviderTableTitleString value will be used as the text on the back button.
 **/
#define kJRProviderTableTitleView_iPad   @"ProviderTable.Title.View-iPad"

/**
 * Key for the \c UIView object to be set as the title view of the Social Sharing screen on the iPad.
 *
 * \note If this value is set, it will override any string value set for kJRSocialSharingTitleString,
 * although the kJRSocialSharingTitleString value will be used as the text on the back button.
 **/
#define kJRSocialSharingTitleView_iPad   @"SocialSharing.Title.View-iPad"
/*@}*/

/** 
 * \name Title Strings
 * Keys to specify the NSString titles to be used as the titles of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \c NSString title to be set as the title of the Providers Table.
 * 
 * \note If a UIView* is set for kJRProviderTableTitleView or kJRProviderTableTitleView_iPad are set, 
 * this string will not appear as the title on the navigation bar.  It will only be used as the text on
 * the back button.
 **/
#define kJRProviderTableTitleString   @"ProviderTable.Title.String"

/**
 * Key for the \c NSString title to be set as the title of the Social Sharing screen.
 * 
 * \note If a UIView* is set for kJRSocialSharingTitleView or kJRSocialSharingTitleView_iPad are set, 
 * this string will not appear as the title on the navigation bar.  It will only be used as the text on
 * the back button.
 **/
#define kJRSocialSharingTitleString   @"SocialSharing.Title.String"
/*@}*/

/** 
 * \name Provider Table Header and Footer Views
 * Keys to specify the UIViews to be used as the Provider Table's header and footer views
 **/
/*@{*/

/**
 * Key for the \c UIView object to be set as the header view of the Providers Table on the iPhone.
 **/
#define kJRProviderTableHeaderView       @"ProviderTable.Table.Header.View"

/**
 * Key for the \c UIView object to be set as the footer view of the Providers Table on the iPhone.
 **/
#define kJRProviderTableFooterView       @"ProviderTable.Table.Footer.View"

/**
 * Key for the \c UIView object to be set as the header view of the Providers Table on the iPad.
 **/
#define kJRProviderTableHeaderView_iPad  @"ProviderTable.Table.Header.View-iPad"

/**
 * Key for the \c UIView object to be set as the footer view of the Providers Table on the iPad.
 **/
#define kJRProviderTableFooterView_iPad  @"ProviderTable.Table.Footer.View-iPad"
/*@}*/

/** 
 * \name Provider Table Section Header and Footer Views
 * Keys to specify the UIViews to be used as the Provider Table's providers section header and footer views
 **/
/*@{*/

/**
 * Key for the \c UIView object to be set as the view of the providers section header in the Providers Table on the iPhone.
 * 
 * \note Setting this value overrides any string set as the kJRProviderTableSectionHeaderTitleString.
 **/
#define kJRProviderTableSectionHeaderView       @"ProviderTable.Section.Header.View"

/**
 * Key for the \c UIView object to be set as the view of the providers section footer in the Providers Table on the iPhone.
 * 
 * \note Setting this value overrides any string set as the kJRProviderTableSectionFooterTitleString.
 **/
#define kJRProviderTableSectionFooterView       @"ProviderTable.Section.Footer.View"

/**
 * Key for the \c UIView object to be set as the view of the providers section header in the Providers Table on the iPad.
 * 
 * \note Setting this value overrides any string set as the kJRProviderTableSectionHeaderTitleString.
 **/
#define kJRProviderTableSectionHeaderView_iPad  @"ProviderTable.Section.Header.View-iPad"

/**
 * Key for the \c UIView object to be set as the view of the providers section footer in the Providers Table on the iPad.
 * 
 * \note Setting this value overrides any string set as the kJRProviderTableSectionFooterTitleString.
 **/
#define kJRProviderTableSectionFooterView_iPad  @"ProviderTable.Section.Footer.View-iPad"
/*@}*/

/** 
 * \name Provider Table Section Header and Footer Views
 * Keys to specify the UIViews to be used as the Provider Table's providers section header and footer views
 **/
/*@{*/

/**
 * Key for the \c NSString to be set as the title of the providers section header in the Providers Table.
 * 
 * \note If a UIView* is set for kJRProviderTableSectionHeaderView or kJRProviderTableSectionHeaderView_iPad are set, 
 * this string will not be used.
 **/
#define kJRProviderTableSectionHeaderTitleString  @"ProviderTable.Section.Header.Title.String"

/**
 * Key for the \c NSString to be set as the title of the providers section footer in the Providers Table.
 * 
 * \note If a UIView* is set for kJRProviderTableSectionFooterView or kJRProviderTableSectionFooterView_iPad are set, 
 * this string will not be used.
 **/
#define kJRProviderTableSectionFooterTitleString  @"ProviderTable.Section.Footer.Title.String"
/*@}*/

/** @} */

#import <Foundation/Foundation.h>
#import "JRSessionData.h"
#import "JRActivityObject.h"
#import "JRUserInterfaceMaestro.h"

@class JREngage;
@class JRUserInterfaceMaestro;

/**
 * \brief
 * The JREngageDelegate protocol is adopted by an object that wishes to receive notifications when and 
 * information about a user that authenticates with your application and publishes activities to their 
 * social networks.
 *
 * This protocol will notify the delegate(s) when authentication and social publishing succeed or fail,
 * it will provider the delegate(s) with the authenticated user's profile data, and, if server-side
 * authentication is desired, it can provide the delegate(s) with the data payload returned by your 
 * server's token URL.
 **/
@protocol JREngageDelegate <NSObject>
@optional

/** 
 * \name Configuration 
 * Messages sent by JREngage during dialog launch/configuration
 **/
/*@{*/

/**
 * Sent if the application tries to show a JREngage dialog, and JREngage failed to show.  May
 * occur if the JREngage library failed to configure, or if the activity object was nil, etc.
 *
 * @param error
 *   The error that occurred during configuration
 *
 * \note
 * This message is only sent if your application tries to show a JREngage dialog, and not necessarily 
 * when an error occurs, if, say, the error occurred during the library's configuration.  The raison d'etre 
 * is based on the possibility that your application may preemptively configure JREngage, but never actually 
 * use it.  If that is the case, then you won't get any error.
 **/
- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error;
/*@}*/

/** 
 * \name Authentication
 * Messages sent  by JREngage during authentication
 **/
/*@{*/

/**
 * Sent if the authentication was canceled for any reason other than an error.  For example, 
 * the user hits the "Cancel" button, any class (e.g., the JREngage delegate) calls the cancelAuthentication
 * message, or if configuration of the library is taking more than about 16 seconds (rare) to download.
 **/
- (void)jrAuthenticationDidNotComplete;

/**
 * \anchor authDidSucceed
 *
 * Tells the delegate that the user has successfully authenticated with the given provider, passing to
 * the delegate an \c NSDictionary object with the user's profile data
 *
 * @param auth_info
 *   An \c NSDictionary of fields containing all the information Janrain Engage knows about the user 
 *   logging into your application.  Includes the field "profile" which contains the user's profile information
 *
 *   The structure of the dictionary (represented here in json) should look something like the 
 *   following:
 * \code
 "auth_info":
 {
   "profile": 
   {
     "displayName": "brian",
     "preferredUsername": "brian",
     "url": "http:\/\/brian.myopenid.com\/",
     "providerName": "Other",
     "identifier": "http:\/\/brian.myopenid.com\/"
   }
 }
 * \endcode
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 *
 * \sa For a full description of the dictionary and its fields, 
 * please see the <a href="https://rpxnow.com/docs#api_auth_info_response">auth_info response</a> 
 * section of the Janrain Engage API documentation.
 **/
- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider;

/**
 * Sent when authentication failed and could not be recovered by the library
 *
 * @param error
 *   The error that occurred during authentication
 *
 * @param provider
 *   The name of the provider on which the user tried to authenticate.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 *
 * \note
 * This message is not sent if authentication was canceled.  To be notified of a canceled authentication, 
 * see jrAuthenticationDidNotComplete.
 **/
- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;

/**
 * Sent after JREngage has successfully posted the token to your application's token_url, containing 
 * the body of the response from the server
 *
 * @param tokenUrl
 *   The URL on the server where the token was posted and server-side authentication was completed
 *
 * @param tokenUrlPayload
 *   The response from the server
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 * 
 * \warning This function may become deprecated in the future.
 *
 * \sa \ref tokenUrlReached "- (void)jrAuthenticationDidReachTokenUrl:withResponse:andPayload:forProvider:"
 **/
- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;

/**
 * \anchor tokenUrlReached
 *
 * Sent after JREngage has successfully posted the token to your application's token_url, containing 
 * the headers and body of the response from the server
 *
 * @param tokenUrl
 *   The URL on the server where the token was posted and server-side authentication was completed
 *
 * @param response
 *   The final NSURLResponse returned from the server
 *
 * @param tokenUrlPayload
 *   The response from the server
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 **/
- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;

/**
 * Sent when the call to the token URL has failed
 *
 * @param tokenUrl
 *   The URL on the server where the token was posted and server-side authentication was completed
 *
 * @param error
 *   The error that occurred during server-side authentication
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 **/
- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider;
/*@}*/

/** 
 * \name SocialPublishing
 * Messages sent by JREngage during social publishing
 **/
/*@{*/

/**
 * Sent if social publishing was canceled for any reason other than an error.  For example, 
 * the user hits the "Cancel" button, any class (e.g., the JREngage delegate) calls the cancelPublishing
 * message, or if configuration of the library is taking more than about 16 seconds (rare) to download.
 **/
- (void)jrSocialDidNotCompletePublishing;

/**
 * Sent after the social publishing dialog is closed (e.g., the user hits the "Close" button) and publishing 
 * is complete. You can receive multiple \ref didPublish "- (void)jrSocialDidPublishActivity:forProvider:" 
 * messages before the dialog is closed and publishing is complete.
 **/
- (void)jrSocialDidCompletePublishing;

/**
 * \anchor didPublish
 * Sent after the user successfully shares an activity on the given provider
 *
 * @param activity
 *   The shared activity
 *
 * @param provider
 *   The name of the provider on which the user published the activity.  For a list of possible strings, 
 *   please see the \ref socialProviders "List of Social Providers"
 **/
- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider;

/**
 * Sent when publishing an activity failed and could not be recovered by the library
 *
 * @param activity
 *   The activity the user was trying to share
 *
 * @param error
 *   The error that occurred during publishing
 *
 * @param provider
 *   The name of the provider on which the user attempted to publish the activity.  For a list of possible strings, 
 *   please see the \ref socialProviders "List of Social Providers"
 **/
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider;
/*@}*/
@end

/**
 * \brief
 * Main API for interacting with the Janrain Engage for iPhone library
 * 
 * \details
 * Use the JREngage object to authenticate a user with your application and 
 * allow them to publish activities to their social networks.
 * 
 * If you wish to include 3rd-Party Authentication and Social Publishing in your iPhone 
 * application, you can use the JREngage class to achieve this.  Prior to using the JREngage
 * library, you must already have an application on <a href="http://rpxnow.com">http://rpxnow.com</a>.
 * This is all that is required for basic authentication, although some providers may require extra
 * configuration (which can be done through your application's <a href="http://rpxnow.com/relying_parties">Dashboard</a>
 * For social publishing, you will need to configure your rpxnow application with the desired providers.
 *
 * If desired, you can optionally implement server-side authentication<span class="footnote">*</span>.
 * When provided, the JREngage library can post the user's authentication token to a url on your server: 
 * the token url.  Your server can complete authentication, access more of JREngage's API, log the authentication, etc.
 * and the server's response will be passed back through to your iPhone application.
 *
 * <span class="footnote">*</span>In the previous version of the Engage for iPhone library, implementing token url that
 * completed server-side authentication was required. This is no longer the case, although you can optionally implement 
 * the token url if you wish to continue authentication on your server.
 **/
@interface JREngage : NSObject <JRSessionDelegate>
{
    JRUserInterfaceMaestro *interfaceMaestro;   /*< \internal Class that handles customizations to the library's UI */
	JRSessionData	*sessionData;               /*< \internal Holds configuration and state for the JREngage library */
	NSMutableArray	*delegates;                 /*< \internal Array of JREngageDelegate objects */
}

/** 
 * \name Get the JREngage Instance
 * Methods that initialize and return the shared JREngage instance
 **/
/*@{*/

/**
 * Shared instance of the JREngage library
 * 
 * @return
 *   The instance of the JREngage library once it has been created, otherwise this will return \c nil
 **/
+ (JREngage*)jrEngage;

/**
 * \anchor engageWithAppId
 * Initializes and returns the shared instance of the JREngage library
 *
 * @param appId
 *   This is your 20-character application ID.  You can find this on your application's Dashboard
 *   on <a href="http://rpxnow.com">http://rpxnow.com</a>.  This value cannot be \c nil.
 *    
 * @param tokenUrl
 *   The url on your server where you wish to complete authentication.  If provided, 
 *   the JREngage library will post the user's authentication token to this url where it can
 *   used for further authentication and processing.  When complete, the library will pass the 
 *   server's response back to the your application.
 *   
 * @param delegate
 *   The delegate object that implements the JREngageDelegate protocol.
 *
 * @return
 *   The shared instance of the \c JREngage object initialized with the given
 *   \c appId, \c tokenUrl, and \c delegate.  If the given \c appId is nil, returns \c nil.
 **/
+ (JREngage*)jrEngageWithAppId:(NSString*)appId 
                   andTokenUrl:(NSString*)tokenUrl
                      delegate:(id<JREngageDelegate>)delegate;
/*@}*/

/** 
 * \name Manage the Delegates
 * Add/remove delegates that implement the JREngageDelegate protocol
 **/
/*@{*/

/**
 * Add a JREngageDelegate to the JREngage library
 *
 * @param delegate
 *   The object that implements the JREngageDelegate protocol
 **/
- (void)addDelegate:(id<JREngageDelegate>)delegate;

/** 
 * Remove a JREngageDelegate from the JREngage library
 *
 * @param delegate
 *   The object that implements the JREngageDelegate protocol
 **/
- (void)removeDelegate:(id<JREngageDelegate>)delegate;
/*@}*/

/** \anchor showMethods **/
/** 
 * \name Show the JREngage Dialogs
 * Methods that display JREngage's dialogs to initiate authentication and social publishing
 **/
/*@{*/

/**
 * \anchor showAuthDialog
 *
 * Use this function to begin authentication.  The JREngage library will 
 * pop up a modal dialog and take the user through the sign-in process.
 **/
- (void)showAuthenticationDialog;

/**
 * Use this function to begin authentication.  The JREngage library will 
 * pop up a modal dialog, configured with the given custom interface, 
 * and take the user through the sign-in process.
 *
 * @param customizations
 *   A dictionary of objects and properties to be used by the library to customize 
 *   the look and feel of the user interface and/or add a native login experience
 *
 * \note Any values specified in the \c customizations dictionary will override the 
 * corresponding values specified in both the JREngage-Info.plist and the dictionary 
 * passed into the - (void)setCustomInterface:(NSDictionary*)customizations method.
 **/
- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations;

/**
 *
 **/
- (void)showAuthenticationDialogWithForcedReauthenticationOnLastUsedProvider;

/**
 * \anchor showPubDialog
 *
 * Use this function to begin social publishing.  The JREngage library will 
 * pop up a modal dialog and take the user through the sign-in process, if necessary,
 * and share the given \c JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 **/
- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity;

/**
 * Use this function to begin social publishing.  The JREngage library will 
 * pop up a modal dialog, configured with the given custom interface, 
 * take the user through the sign-in process, if necessary,
 * and share the given \c JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 *
 * @param customizations
 *   A dictionary of objects and properties to be used by the library to customize 
 *   the look and feel of the user interface and/or add a native login experience
 *
 * \note Any values specified in the \c customizations dictionary will override the 
 * corresponding values specified in both the JREngage-Info.plist and the dictionary 
 * passed into the - (void)setCustomInterface:(NSDictionary*)customizations method.
 **/
- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity andCustomInterface:(NSDictionary*)customizations;
/*@}*/

/** 
 * \name Configure the User Interface
 * Methods used to customize the JREngage's user interface
 **/
/*@{*/

/**
 * If you want to push the JREngage dialogs on your own navigation controller, pass
 * the \c UINavigationController to the JREngage library before calling \c showAuthenticationDialog
 *
 * @param navigationController
 *   Your application's navigation controller
 **/
- (void)setCustomNavigationController:(UINavigationController*)navigationController;

/**
 * Use this function if you want to customize the look and feel of the user interface or add 
 * your own native login experience, by passing an NSDictionary object indexed by the set of pre-defined 
 * custom interface keys.  TODO: Add link
 *
 * \note Any values specified in the \c customizations dictionary will override the 
 * corresponding values specified in the JREngage-Info.plist. \n
 * Any values specified in the \c customizations dictionary will be overridden the corresponding values specified in a 
 * dictionary passed into the  - (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations 
 * or - (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity andCustomInterface:(NSDictionary*)customizations
 * methods.  
 **/
- (void)setCustomInterface:(NSDictionary*)customizations;
/*@}*/

/** 
 * \name Management Authenticated Users
 * Methods that manage authenticated users remembered by the library
 **/
/*@{*/

// TODO: Deprecate these for the release
/**
 * Tell JREngage to forget that a user is already signed in with the given provider
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref socialProviders "List of Social Providers"
 * 
 * \warning This function may become deprecated in the future.
 *
 * \sa \ref signoutProvider "- (void)signoutUserForProvider:(NSString*)provider"
 **/
- (void)signoutUserForSocialProvider:(NSString*)provider;

/**
 * Tell JREngage to forget that a user is signed in with all \ref socialProviders "Social Providers"
 * 
 * \warning This function may become deprecated in the future.
 *
 * \sa \ref signoutAll "- (void)signoutUserForAllProviders"
 **/
- (void)signoutUserForAllSocialProviders;

// TODO: Deprecate these for the release
/**
 * \anchor signoutProvider
 *
 * Tell JREngage to forget that a user is already signed in with the given provider
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 **/
- (void)signoutUserForProvider:(NSString*)provider;

/**
 * \anchor signoutAll
 *
 * Tell JREngage to forget that a user is signed in with all \ref basicProviders "Providers"
 **/
- (void)signoutUserForAllProviders;

/**
 * Use this function to toggle whether or not the library should force the user to reauthenticate for all providers
 * 
 * @param force
 *   YES if the library should force reauthentication for all providers or NO if the library should
 *   perform the default behavior
 **/
- (void)alwaysForceReauthentication:(BOOL)force;
/*@}*/

/** 
 * \name Cancel the JREngage Dialogs
 * Methods to cancel authentication and social publishing
 **/
/*@{*/

/**
 * Use this functions if you need to cancel authentication for any reason.
 **/
- (void)cancelAuthentication;

/**
 * Use this functions if you need to cancel publishing for any reason.
 **/
- (void)cancelPublishing;
/*@}*/

/** 
 * \name Server-side Authentication
 * Methods to reconfigure server-side authentication
 **/
/*@{*/

/** 
 * \anchor updateTokenUrl
 *
 * Use this function to specify a different tokenUrl than the one you 
 * initiated the library with
 **/
- (void)updateTokenUrl:(NSString*)newTokenUrl;
/*@}*/
@end
