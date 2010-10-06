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
 * <a href="http://rpxnow.com/docs/iphone_v2">
 * Janrain Engage for iPhone</a> makes it easy to include third party authentication and 
 * social publishing in your iPhone app.  This Objective-C library includes the same key
 * features as our web version.  With a few lines of code, you can authenticate your
 * users with their accounts on Google, Yahoo!, Facebook, etc., and they can immediately 
 * publish their activities to multiple social networks, including Facebook, Twitter, LinkedIn, 
 * MySpace and Yahoo, through one simple interface.
 * 
 * Before you begin, you need to have created a <a href="https://rpxnow.com/signup_createapp_plus">Janrain Engage application</a>,
 * which you can do on <a href="http://rpxnow.com">http://rpxnow.com</a>
 *
 * For an overview of how the library works and how you can take advantage of the library's features, 
 * please see the <a href="http://rpxnow.com/docs/iphone_v2#user_experience">"Overview"</a> section of our documentation.
 * 
 * To begin using the library, please see the <a href="http://rpxnow.com/docs/iphone_v2#quick">"Quick Start Guide"</a>.
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
 *   - "twitter"
 *   - "verisign"
 *   - "wordpress"
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

#import <Foundation/Foundation.h>
#import "JRSessionData.h"
#import "JRActivityObject.h"
#import "JRUserInterfaceMaestro.h"

#define SOCIAL_PUBLISHING

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
 * Sent if the authorization was canceled for any reason other than an error.  For example, 
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
 **/
- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;

/**
 * Sent after JREngage has successfully posted the token to your application's token_url, containing 
 * the headers and body of the response from the server
 *
 * @param tokenUrl
 *   The URL on the server where the token was posted and server-side authentication was completed
 *
 * @param reponse
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

/** 
 * \name Configure Delegates
 * Add/remove objects that implement the JREngageDelegate protocol
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
 * \name Show the JREngage Library
 * Methods that initiate authentication and social publishing with JREngage
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
/*@}*/

/** 
 * \name Interface Configuration
 * Methods used to customize the library's user interface
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

///**
// * May not use...
// **/
//- (void)setCustomNavigationControllerShouldPopToViewController:(UIViewController*)viewController;
///*@}*/

/** 
 * \name User Management
 * Methods that manage authenticated users remembered by the library
 **/
/*@{*/

/**
 *
 **/
- (NSDictionary*)getUserForProvider:(NSString*)provider;

/**
 * Tell JREngage to forget that a user is already signed in with the given provider
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref socialProviders "List of Social Providers"
 * 
 * \note: The library only remembers users who have signed in through the social publishing interface
 **/
- (void)signoutUserForSocialProvider:(NSString*)provider;

/**
 * Tell JREngage to forget that a user is signed in with all \ref socialProviders "Social Providers"
 * 
 * \note: The library only remembers users who have signed in through the social publishing interface
 **/
- (void)signoutUserForAllSocialProviders;

/**
 * Tell JREngage to forget that a user is already signed in with the given provider
 *
 * @param provider
 *   The name of the provider on which the user authenticated.  For a list of possible strings, 
 *   please see the \ref basicProviders "List of Providers"
 **/
- (void)signoutUserForProvider:(NSString*)provider;

/**
 * Tell JREngage to forget that a user is signed in with all \ref basicProviders "Providers"
 **/
- (void)signoutUserForAllProviders;
/*@}*/

/** 
 * \name Cancel
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
