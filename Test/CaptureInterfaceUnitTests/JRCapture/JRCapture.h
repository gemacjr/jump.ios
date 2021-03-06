/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/**
 * @mainpage Janrain Capture for iOS
 *
 * @brief TODO: write the brief
 *
 * TODO: write the doc
 **/

#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureUser.h"
#import "JRCaptureUser+Extras.h"
#import "JRCaptureError.h"

typedef enum
{
    JRConventionalSigninNone = 0,
    JRConventionalSigninUsernamePassword,
    JRConventionalSigninEmailPassword,
} JRConventionalSigninType;

typedef enum
{
    JRCaptureRecordNewlyCreated,          // now it exists, and it is new
    JRCaptureRecordExists,                // already created, not new
    JRCaptureRecordMissingRequiredFields, // not created, does not exist
} JRCaptureRecordStatus;

@class JRActivityObject;

@protocol JRCaptureSigninDelegate <NSObject>
@optional
/**
 * Sent if the application tries to show a JREngage dialog, and JREngage failed to show.  May
 * occur if the JREngage library failed to configure, or if the activity object was nil, etc.
 *
 * @param error
 *   The error that occurred during configuration
 *
 * @note
 * This message is only sent if your application tries to show a JREngage dialog, and not necessarily
 * when an error occurs, if, say, the error occurred during the library's configuration.  The raison d'etre
 * is based on the possibility that your application may preemptively configure JREngage, but never actually
 * use it.  If that is the case, then you won't get any error.
 **/
- (void)engageSigninDialogDidFailToShowWithError:(NSError*)error;
/*@}*/

/**
 * @name Authentication
 * Messages sent by JREngage during authentication
 **/
/*@{*/

/**
 * Sent if the authentication was canceled for any reason other than an error.  For example,
 * the user hits the "Cancel" button, any class (e.g., the %JREngage delegate) calls the
 * cancelAuthentication message, or if configuration of the library is taking more than about
 * 16 seconds (rare) to download.
 **/
- (void)engageSigninDidNotComplete;


- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider;

/**
  * TODO
  */
- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)captureUser
                                        status:(JRCaptureRecordStatus)captureRecordStatus;

/**
 * Sent when authentication failed and could not be recovered by the library.
 *
 * @param error
 *   The error that occurred during authentication
 *
 * @param provider
 *   The name of the provider on which the user tried to authenticate.  For a list of possible strings,
 *   please see the \ref basicProviders "List of Providers"
 *
 * @note
 * This message is not sent if authentication was canceled.  To be notified of a canceled authentication,
 * see jrAuthenticationDidNotComplete().
 **/
- (void)engageAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;

/**
 * Sent when the call to the token URL has failed.
 * @param error
 *   The error that occurred during Capture authentication
 **/
- (void)captureAuthenticationDidFailWithError:(NSError*)error;
@end

#ifdef JRENGAGE_SHARING_WITH_CAPTURE
@protocol JRCaptureSharingDelegate <JRCaptureSigninDelegate>
@optional
/**
 * @name SocialPublishing
 * Messages sent by JREngage during social publishing
 **/
/*@{*/
- (void)engageSocialSharingDialogDidFailToShowWithError:(NSError*)error;
/**
 * Sent if social publishing was canceled for any reason other than an error.  For example,
 * the user hits the "Cancel" button, any class (e.g., the %JREngage delegate) calls the cancelPublishing
 * message, or if configuration of the library is taking more than about 16 seconds (rare) to download.
 **/
- (void)engageSocialSharingDidNotComplete;

/**
 * Sent after the social publishing dialog is closed (e.g., the user hits the "Close" button) and publishing
 * is complete. You can receive multiple jrSocialDidPublishActivity:forProvider:()
 * messages before the dialog is closed and publishing is complete.
 **/
- (void)engageSocialSharingDidComplete;

/**
 * Sent after the user successfully shares an activity on the given provider.
 *
 * @param activity
 *   The shared activity
 *
 * @param provider
 *   The name of the provider on which the user published the activity.  For a list of possible strings,
 *   please see the \ref socialProviders "List of Social Providers"
 **/
- (void)engageSocialSharingDidSucceedForActivity:(JRActivityObject*)activity onProvider:(NSString*)provider;

/**
 * Sent when publishing an activity failed and could not be recovered by the library.
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
- (void)engageSocialSharingDidFailForActivity:(JRActivityObject*)activity withError:(NSError*)error onProvider:(NSString*)provider;
/*@}*/
@end
#endif // JRENGAGE_SHARING_WITH_CAPTURE

@interface JRCapture : NSObject

+ (void)setEngageAppId:(NSString *)appId captureApidDomain:(NSString *)newCaptureApidDomain
       captureUIDomain:(NSString *)newCaptureUIDomain clientId:(NSString *)newClientId
     andEntityTypeName:(NSString *)newEntityTypeName;

#ifdef JRCAPTURE_ACCESS_TOKEN_CONTROL
+ (void)setAccessToken:(NSString *)newAccessToken;
#endif // JRCAPTURE_ACCESS_TOKEN_CONTROL

/**
 * @name Show the JREngage Dialogs
 * Methods that display JREngage's dialogs to initiate authentication and social publishing
 **/
/*@{*/

/**
 * Use this function to begin authentication.  The JREngage library will
 * pop up a modal dialog and take the user through the sign-in process.
 **/
+ (void)startEngageSigninDialogForDelegate:(id<JRCaptureSigninDelegate>)delegate;

#ifdef JRENGAGE_SHARING_WITH_CAPTURE
+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninState
                                          forDelegate:(id<JRCaptureSigninDelegate>)delegate;
#endif // JRENGAGE_SHARING_WITH_CAPTURE

/**
 * Use this function to begin authentication for one specific provider.  The JREngage library will
 * pop up a modal dialog, skipping the list of providers, and take the user straight to the sign-in
 * flow of the passed provider.  The user will not be able to return to the list of providers.
 *
 * @param provider
 *   The name of the provider on which the user will authenticate.  For a list of possible strings,
 *   please see the \ref basicProviders "List of Providers"
 **/
+ (void)startEngageSigninDialogOnProvider:(NSString*)provider
                              forDelegate:(id<JRCaptureSigninDelegate>)delegate;

#ifdef JRCAPTURE_CONVENTIONAL_SIGNIN
/**
 * Use this function to begin authentication.  The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, and take the user through the sign-in process.
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninState
                          andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                          forDelegate:(id<JRCaptureSigninDelegate>)delegate;
#endif // JRCAPTURE_CONVENTIONAL_SIGNIN

/**
* Use this function to begin authentication.  The JREngage library will pop up a modal dialog, configured
* with the given custom interface and skipping the list of providers, and take the user straight to the sign-in
* flow of the passed provider.  The user will not be able to return to the list of providers.
*
* @param provider
*   The name of the provider on which the user will authenticate.  For a list of possible strings,
*   please see the \ref basicProviders "List of Providers"
*
* @param customInterfaceOverrides
*   A dictionary of objects and properties, indexed by the set of
*   \link customInterface pre-defined custom interface keys\endlink,
*   to be used by the library to customize the look and feel of the user
*   interface and/or add a native login experience
*
* @note
* Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
* values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
**/
+ (void)startEngageSigninDialogOnProvider:(NSString*)provider
             withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                              forDelegate:(id<JRCaptureSigninDelegate>)delegate;


#ifdef JRENGAGE_SHARING_WITH_CAPTURE
/**
 * Use this function to begin social publishing. The JREngage library will pop up a modal dialog and
 * take the user through the sign-in process, if necessary, and share the given JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 **/
+ (void)startEngageSharingDialogWithActivity:(JRActivityObject*)activity
                                 forDelegate:(id<JRCaptureSharingDelegate>)delegate;

/**
 * Use this function to begin social publishing.  The JREngage library will pop up a modal dialog,
 * configured with the given custom interface, take the user through the sign-in process,
 * if necessary, and share the given JRActivityObject.
 *
 * @param activity
 *   The activity you wish to share
 *
 * @param customInterfaceOverrides
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customInterfaceOverrides dictionary will override the corresponding
 * values specified the dictionary passed into the setCustomInterfaceDefaults:() method.
 **/
+ (void)startEngageSharingDialogWithActivity:(JRActivityObject*)activity
                withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                 forDelegate:(id<JRCaptureSharingDelegate>)delegate;
#endif // JRENGAGE_SHARING_WITH_CAPTURE
@end
