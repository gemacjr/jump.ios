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

 File:   JRSessionData.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "SFHFKeychainUtils.h"
#import "JRConnectionManager.h"
#import "JRActivityObject.h"

@protocol JRUserInterfaceDelegate <NSObject>
- (void)userInterfaceWillClose;
- (void)userInterfaceDidClose;
@end

typedef enum
{
    ConfigurationError = 1,
    AuthenticationError = 2,
    SocialSharingError = 3,
} JRErrorCategory;

typedef enum
{
    JRUrlError = 100,
    JRDataParsingError,
    JRJsonError,
    JRConfigurationInformationError,
    JRSessionDataFinishGetProvidersError,
    JRDialogShowingError,
    JRProviderNotConfiguredError,
} JREngageConfigurationError;

typedef enum
{
    JRAuthenticationFailedError = 200
} JREngageAuthenticationError;

typedef enum
{
    JRPublishFailedError = 300,
    JRPublishErrorBadConnection,
    JRPublishErrorActivityNil,
    JRPublishErrorMissingParameter,
    JRPublishErrorMissingApiKey,
    JRPublishErrorCharacterLimitExceeded,
    JRPublishErrorFacebookGeneric,
    JRPublishErrorInvalidFacebookSession,
    JRPublishErrorInvalidFacebookMedia,
    //JRPublishErrorInvalidFacebookActionLinks/Properties,
    JRPublishErrorTwitterGeneric,
    JRPublishErrorDuplicateTwitter,
    JRPublishErrorLinkedInGeneric,
    JRPublishErrorMyspaceGeneric,
    JRPublishErrorYahooGeneric,
    JRPublishErrorInvalidOauthKey, /* Will be deprecating */
    JRPublishErrorLinkedInCharacterExceeded, /* Will be deprecating */
} JREngageSocialPublishingError;

extern NSString * JREngageErrorDomain;

@interface JRError : NSObject
+ (NSError*)setError:(NSString*)message withCode:(NSInteger)code;
@end

@interface JRActivityObject (shortenedUrl)
@property (retain) NSString *shortenedUrl;
@end

@interface JRAuthenticatedUser : NSObject
{
    NSString *_photo;
    NSString *_preferredUsername;
    NSString *_deviceToken;
    NSString *_providerName;
    NSString *_welcomeString;
}
@property (readonly) NSString *photo;
@property (readonly) NSString *preferredUsername;
@property (readonly) NSString *deviceToken;
@property (readonly) NSString *providerName;
@property (copy)     NSString *welcomeString;
@end

@interface JRProvider : NSObject
{
    NSString *_name;

    NSString *_friendlyName;
    NSString *_placeholderText;
    NSString *_shortText;
    BOOL      _requiresInput;

    NSString *_openIdentifier;
    NSString *_url;
    BOOL      _forceReauth;

    NSString *_userInput;

    NSDictionary *_socialSharingProperties;
    BOOL          _social;

    NSArray *_cookieDomains;
}

@property (readonly) NSString     *name;
@property (readonly) NSString     *friendlyName;
@property (readonly) NSString     *shortText;
@property (readonly) NSString     *placeholderText;
@property (readonly) BOOL          requiresInput;
@property            BOOL          forceReauth;
@property (retain)   NSString     *userInput;
@property (readonly) NSDictionary *socialSharingProperties;
@property (readonly) NSArray      *cookieDomains;
- (BOOL)isEqualToReturningProvider:(NSString*)returningProvider;
@end

@protocol JRSessionDelegate <NSObject>
@optional
- (void)authenticationDidRestart;
- (void)authenticationDidCancel;

//- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider;
- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider;
- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)authenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;
- (void)authenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)publishingDidRestart;
- (void)publishingDidCancel;
- (void)publishingDidComplete;

- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider;
- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)urlShortenedToNewUrl:(NSString*)url forActivity:(JRActivityObject*)activity;
@end

@class JRActivityObject;

@interface JRSessionData : NSObject <JRConnectionManagerDelegate>
{
    NSMutableArray *delegates;

    JRProvider *currentProvider;
    NSString   *returningBasicProvider;
    NSString   *returningSocialProvider;

/*  allProviders is a dictionary of JRProviders, where each JRProvider contains the information specific to that
    provider. basicProviders and socialProviders are arrays of NSStrings, each string being the primary key in allProviders
    for that provider, representing the list of providers to be used in authentication and social publishing.
    The arrays are in the order configured by the RP on http://rpxnow.com. */
    NSMutableDictionary *allProviders;
    NSArray             *basicProviders;
    NSArray             *socialProviders;
    NSMutableDictionary *authenticatedUsersByProvider;

 /* These values are used by sessionData to determine if the cached configuration is dirty or not.  As both the code and
    the configuration information (mostly regarding RP's chosen providers) will rarely change, the library caches the
    information so that it can use it immediately.  The http etag of the mobile_config_and_baseurl action indicates if the
    downloaded configuration information has changes, and the git commit value stored in JREngage-info.plist indicates if
    the code itself has changed. */
    NSString *savedConfigurationBlock;
    NSString *newEtag;
    NSString *gitCommit;

 /* So that customers can add new providers without rereleasing their code, the library dynamically downloads any of the
    icons it may be missing.  Once the library knows that a provider has all of it's icons, it adds the provider's name
    to the providersWithIcons set.  If a provider doesn't have its icons, the icon urls are added to the iconsStillNeeded
    dictionary with the provider as the key.  This dictionary is saved between launches, in case the downloading of the
    icons fails, is interrupted, etc. */
    NSMutableSet        *providersWithIcons;
    NSMutableDictionary *iconsStillNeeded;

 /* The activity that the calling application is trying to share */
    JRActivityObject *activity;

 /* Server and RP properties */
    NSString *tokenUrl;
    NSString *baseUrl;
    NSString *appId;
    NSString *device;

    BOOL hidePoweredBy;

    // QTS: What is the behavior of this (i.e., how does it affect social publishing?)
    //      when selected during a basic authentication call?
    BOOL authenticatingDirectlyOnThisProvider;
    BOOL alwaysForceReauth;
    BOOL forceReauthJustThisTime;

    BOOL canRotate;

 /* TRUE if the library is currently sharing an activity */
    BOOL socialSharing;

 /* TRUE if either of the the library's dialogs are loaded */
    BOOL dialogIsShowing;

    BOOL stillNeedToShortenUrls;

 /* Because configuration errors aren't reported until the calling application needs the library,
    we save this event in an instance variable. */
    NSError  *error;

}
@property (retain)   JRProvider *currentProvider;
@property (readonly) NSString   *returningBasicProvider;
@property (readonly) NSString   *returningSocialProvider;

@property (readonly) NSMutableDictionary *allProviders;
@property (readonly) NSArray             *basicProviders;
@property (readonly) NSArray             *socialProviders;

@property (copy)     JRActivityObject *activity;

@property (copy)     NSString *tokenUrl;
@property (readonly) NSString *baseUrl;

@property (readonly) BOOL hidePoweredBy;
@property            BOOL alwaysForceReauth;
@property            BOOL forceReauthJustThisTime;
@property            BOOL authenticatingDirectlyOnThisProvider;
@property            BOOL socialSharing;
@property            BOOL dialogIsShowing;
@property            BOOL canRotate;
@property (retain, readonly) NSError *error;

+ (id)jrSessionData;
+ (id)jrSessionDataWithAppId:(NSString*)newAppId tokenUrl:(NSString*)newTokenUrl andDelegate:(id<JRSessionDelegate>)newDelegate;

- (void)tryToReconfigureLibrary;
- (id)reconfigureWithAppId:(NSString*)newAppId tokenUrl:(NSString*)newTokenUrl;

- (void)addDelegate:(id<JRSessionDelegate>)delegateToAdd;
- (void)removeDelegate:(id<JRSessionDelegate>)delegateToRemove;

- (NSURL*)startUrlForCurrentProvider;

- (void)setReturningBasicProviderToNil;
- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index;
- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index;
- (JRProvider*)getProviderNamed:(NSString*)name;

- (BOOL)weShouldBeFirstResponder;

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider;
- (JRAuthenticatedUser*)authenticatedUserForProviderNamed:(NSString*)provider;

- (void)forgetAuthenticatedUserForProvider:(NSString*)providerName;
- (void)forgetAllAuthenticatedUsers;

- (void)shareActivityForUser:(JRAuthenticatedUser*)user;
- (void)setStatusForUser:(JRAuthenticatedUser*)user;

- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary*)payloadDict;
- (void)triggerAuthenticationDidStartOver:(id)sender;
- (void)triggerAuthenticationDidCancel;
- (void)triggerAuthenticationDidCancel:(id)sender;
- (void)triggerAuthenticationDidTimeOutConfiguration;
- (void)triggerAuthenticationDidFailWithError:(NSError*)theError;

- (void)triggerPublishingDidStartOver:(id)sender;
- (void)triggerPublishingDidCancel;
- (void)triggerPublishingDidCancel:(id)sender;
- (void)triggerPublishingDidTimeOutConfiguration;
- (void)triggerPublishingDidFailWithError:(NSError*)theError;

- (void)triggerEmailSharingDidComplete;
- (void)triggerSmsSharingDidComplete;
@end

