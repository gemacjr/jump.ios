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
 
 File:	 JRSessionData.h 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "JRConnectionManager.h"
#import "JRActivityObject.h"
#import "JRError.h"

#define SOCIAL_PUBLISHING
//
//typedef enum
//{
//	JRUrlError = 100,
//    JRDataParsingError,
//    JRJsonError,    
//    JRConfigurationInformationError,
//    JRSessionDataFinishGetProvidersError    
//} JREngageConfigurationError;
//
//typedef enum
//{
//    JRAuthenticationFailedError = 200
//} JREngageAuthenticationError;
//
//typedef enum
//{
//    JRPublishFailedError = 200,
//    JRPublishErrorMissingApiKey,
//    JRPublishErrorInvalidOauthToken,
//    JRPublishErrorDuplicateTwitter,
//    JRPublishErrorLinkedInCharacterExceded,
//} JREngageSocialPublishingError;
//
//// QTS: Do we really need this anymore?
//#define JRErrorSeverityNoNetworkConnection              @"noNetwork"
//#define JRErrorSeverityMinor                            @"minor"
//#define JRErrorSeverityMajor                            @"major"
//#define JRErrorSeverityConfigurationFailed              @"configurationFailed"
//#define JRErrorSeverityConfigurationInformationMissing  @"missingInformation"
//#define JRErrorSeverityAuthenticationFailed             @"authenticationFailed"
//#define JRErrorSeverityPublishFailed                    @"publishFailed"
//#define JRErrorSeverityPublishNeedsReauthentication     @"publishNeedsReauthentication"
//#define JRErrorSeverityPublishInvalidActivity           @"publishInvalidActivity"


@protocol JRUserInterfaceDelegate <NSObject>
- (void)userInterfaceWillClose;
- (void)userInterfaceDidClose;
@end


@interface JRAuthenticatedUser : NSObject
{
    NSString *photo;
    NSString *preferred_username;
    NSString *device_token;
    
    NSDictionary *auth_info;
    
    NSString *provider_name;
}
@property (readonly) NSString *photo;
@property (readonly) NSString *preferred_username;
@property (readonly) NSString *device_token;
@property (readonly) NSDictionary *auth_info;
@property (readonly) NSString *provider_name;
- (id)initUserWithDictionary:(NSDictionary*)dictionary forProviderNamed:(NSString*)_provider_name;
@end


@interface JRProvider : NSObject
{
	NSString *name;
    
	NSString *friendlyName;
	NSString *placeholderText;
	NSString *shortText;
	BOOL      requiresInput;
    
    NSString *openIdentifier;
	NSString *url;	
    NSString *extPerm;
	BOOL      forceReauth;
    BOOL      iconsPresent;
    
    NSString *userInput;
	NSString *welcomeString;
    
    NSDictionary *socialPublishingProperties;

}

@property (readonly) NSString *name;
@property (readonly) NSString *friendlyName;
@property (readonly) NSString *shortText;
@property (readonly) NSString *placeholderText;
@property (readonly) NSString *extPerm;
@property (readonly) BOOL      requiresInput;
@property            BOOL      forceReauth;
@property            BOOL      iconsPresent;
@property (retain)   NSString *userInput;
@property (retain)   NSString *welcomeString;
@property (readonly) NSDictionary *socialPublishingProperties;

- (JRProvider*)initWithName:(NSString*)_name andDictionary:(NSDictionary*)_dictionary;
- (BOOL)isEqualToProvider:(JRProvider*)provider;
- (BOOL)isEqualToReturningProvider:(NSString*)returningProvider;
@end

@protocol JRSessionDelegate <NSObject>
@optional
- (void)authenticationDidRestart;
- (void)authenticationDidCancel;

- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider;
- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider;
- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)authenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;
- (void)authenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)publishingDidRestart;
- (void)publishingDidCancel;
- (void)publishingDidComplete;

- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider;

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider;
@end

@class JRActivityObject;

@interface JRSessionData : NSObject <JRConnectionManagerDelegate>
{
	NSMutableArray	*delegates;
	    
	JRProvider *currentProvider;
	NSString   *returningBasicProvider;	
    NSString   *returningSocialProvider;
    
/*  allProviders is a dictionary of JRProviders, where each JRProvider contains the information specific
    to that provider. basicProviders and socialProviders are arrays of NSStrings, each string being
    the primary key in allProviders for that provider.  The arrays are in the order specified by the rp. */
	NSMutableDictionary *allProviders;
	NSArray             *basicProviders;
    NSArray             *socialProviders;
    NSMutableDictionary *authenticatedUsersByProvider;
	
    NSString *savedConfigurationBlock;
    NSString *newEtag;
    NSString *gitCommit;
    
    NSMutableSet        *providersWithIcons;
    NSMutableDictionary *iconsStillNeeded;
    
    JRActivityObject *activity;
    
    NSString *tokenUrl;
	NSString *baseUrl;
    NSString *appId;
	
	// QTS: What is the behavior of this (i.e., how does it affect social publishing?)
    //      when selected during a basic authentication call?
    BOOL alwaysForceReauth;
    BOOL forceReauth;
	BOOL hidePoweredBy;
    BOOL social;

    BOOL dialogIsShowing;
    NSError  *error;
    
    NSString *device;
}
@property (retain)   JRProvider *currentProvider;
@property (readonly) NSString   *returningBasicProvider;
@property (readonly) NSString   *returningSocialProvider;

@property (readonly) NSMutableDictionary *allProviders;
@property (readonly) NSArray             *basicProviders;
@property (readonly) NSArray             *socialProviders;

@property (retain)   JRActivityObject *activity;

@property (retain)   NSString *tokenUrl;
@property (readonly) NSString *baseUrl;

@property            BOOL alwaysForceReauth;
@property (assign)   BOOL forceReauth;
@property (readonly) BOOL hidePoweredBy;
@property (assign)   BOOL social;

@property BOOL dialogIsShowing;
@property (readonly) NSError *error;

+ (JRSessionData*)jrSessionData;
+ (JRSessionData*)jrSessionDataWithAppId:(NSString*)_appId tokenUrl:(NSString*)_tokenUrl andDelegate:(id<JRSessionDelegate>)_delegate;

- (void)addDelegate:(id<JRSessionDelegate>)_delegate;
- (void)removeDelegate:(id<JRSessionDelegate>)_delegate;

- (void)tryToReconfigureLibrary;
- (NSURL*)startUrlForCurrentProvider;

- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index;
- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index;
- (JRProvider*)getProviderNamed:(NSString*)name;
- (void)setReturningBasicProviderToNil;

- (BOOL)weShouldBeFirstResponder;
- (void)downloadPicture:(NSString*)picture;// thenCallSelector:(@selector)selector;

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider;
- (JRAuthenticatedUser*)authenticatedUserForProviderNamed:(NSString*)provider;

- (void)forgetAuthenticatedUserForProvider:(NSString*)providerName;
- (void)forgetAllAuthenticatedUsers;

- (void)shareActivityForUser:(JRAuthenticatedUser*)user;

- (void)makeCallToTokenUrl:(NSString*)tokenURL withToken:(NSString*)token forProvider:(NSString*)provider;

- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary*)payloadDict;
- (void)triggerAuthenticationDidStartOver:(id)sender;
- (void)triggerAuthenticationDidCancel;
- (void)triggerAuthenticationDidCancel:(id)sender;
- (void)triggerAuthenticationDidTimeOutConfiguration;
- (void)triggerAuthenticationDidFailWithError:(NSError*)_error;

- (void)triggerPublishingDidStartOver:(id)sender;
- (void)triggerPublishingDidCancel;
- (void)triggerPublishingDidCancel:(id)sender;
- (void)triggerPublishingDidTimeOutConfiguration;
- (void)triggerPublishingDidFailWithError:(NSError*)_error;

- (void)triggerEmailSharingDidComplete;
- (void)triggerSmsSharingDidComplete;
@end

