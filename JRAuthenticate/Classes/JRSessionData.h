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

#define SOCIAL_PUBLISHING

typedef enum
{
	JRUrlError = 100,
    JRDataParsingError,
    JRJsonError,    
    JRConfigurationInformationError,
    JRSessionDataFinishGetProvidersError    
} JRSessionDataError;

#define JRErrorSeverityMinor @"minor"
#define JRErrorSeverityMajor @"major"
#define JRErrorSeverityConfigurationFailed @"configurationFailed"
#define JRErrorSeverityConfigurationInformationMissing @"missingInformation"
#define JRErrorSeverityAuthenticationFailed @"authenticationFailed"

@interface JRAuthenticatedUser : NSObject
{
    NSString *photo;
    NSString *preferred_username;
    NSString *device_token;
    
    NSString *provider_name;
}
@property (readonly) NSString *photo;
@property (readonly) NSString *preferred_username;
@property (readonly) NSString *device_token;
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
	
    NSString *userInput;
	NSString *welcomeString;
}

@property (readonly) NSString *name;
@property (readonly) NSString *friendlyName;
@property (readonly) NSString *shortText;
@property (readonly) NSString *placeholderText;
@property (readonly) BOOL      requiresInput;
@property (retain)   NSString *userInput;
@property (retain)   NSString *welcomeString;

- (JRProvider*)initWithName:(NSString*)_name andDictionary:(NSDictionary*)_dictionary;
- (BOOL)isEqualToProvider:(JRProvider*)provider;
@end

@protocol JRSessionDelegate <NSObject>
- (void)authenticationDidCancel;
- (void)authenticationDidCancelForProvider:(NSString*)provider;
- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider;
- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;
- (void)authenticateDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSString*)tokenUrlPayload forProvider:(NSString*)provider;
- (void)authenticateCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)publishingDidCancel;
- (void)publishingDidCancelForProvider:(NSString*)provider;
- (void)publishingDidCompleteWithActivity:(JRActivityObject*)activity forProvider:(NSString*)provider;
- (void)publishingDidFailWithError:(NSError*)error forProvider:(NSString*)provider;
@end

@class JRActivityObject;

@interface JRSessionData : NSObject <JRConnectionManagerDelegate>
{
	NSMutableArray	*delegates;
	    
	JRProvider *currentProvider;
	JRProvider *returningBasicProvider;	
    JRProvider *currentSocialProvider;
    JRProvider *returningSocialProvider;
	
    /* allProviders is an array of JRProviders, where each JRProvider containing the information
     specific to that provider. basicProviders and socialProviders are arrays of NSStrings, each
     string being the primary key for a provider.  The arrays are in the order specified by the rp. */
	NSMutableDictionary *allProviders;
	NSArray             *basicProviders;
    NSArray             *socialProviders;
    
    NSMutableDictionary *authenticatedUsersByProvider;
	
    JRActivityObject *activity;
    
	BOOL hidePoweredBy;
    UIView *customView;
    NSDictionary *customProvider;
	
	NSURL	 *startUrl;
    BOOL      isSocial;
    
    NSString *tokenUrl;
	NSString *baseUrl;
    NSString *appId;
	
	// TODO: What is the behavior of this (i.e., how does it affect social publishing?)
    //       when selected during a basic authentication call?
    BOOL forceReauth;

    BOOL configurationComplete;
	NSString *errorStr;
    NSError  *error;
}

@property (readonly) BOOL configurationComplete;
@property (readonly) NSError *error;

@property (readonly) JRProvider *currentProvider;
@property (readonly) JRProvider *currentBasicProvider;
@property (readonly) JRProvider *returningBasicProvider;
@property (readonly) JRProvider *currentSocialProvider;
@property (readonly) JRProvider *returningSocialProvider;

@property (readonly) NSMutableDictionary *allProviders;
@property (readonly) NSArray             *basicProviders;
@property (readonly) NSArray             *socialProviders;

@property (retain) JRActivityObject *activity;

@property (readonly) BOOL hidePoweredBy;
@property (readonly) UIView       *customView;
@property (readonly) NSDictionary *customProvider;

@property (readonly) NSString *tokenUrl;
@property (readonly) NSURL    *startUrl;
@property (readonly) NSString *baseUrl;

@property (assign) BOOL forceReauth;
@property (readonly) BOOL isSocial;


+ (JRSessionData*)jrSessionData;
+ (JRSessionData*)jrSessionDataWithAppId:(NSString*)_appId tokenUrl:(NSString*)_tokenUrl andDelegate:(id<JRSessionDelegate>)_delegate;

- (void)addDelegate:(id<JRSessionDelegate>)_delegate;
- (void)removeDelegate:(id<JRSessionDelegate>)_delegate;

- (void)reconfigure;

- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index;
- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index;

- (void)setReturningBasicProviderToNewBasicProvider:(JRProvider*)provider;
- (void)setCurrentBasicProviderToReturningProvider;

- (void)setBasicProvider:(JRProvider*)provider;
- (void)setSocialProvider:(JRProvider*)provider;
	
- (BOOL)gatheringInfo;

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider;
- (void)forgetAuthenticatedUserForProvider:(NSString*)provider;
- (void)forgetAllAuthenticatedUsers;

- (void)shareActivity:(JRActivityObject*)_activity forUser:(JRAuthenticatedUser*)user;

- (void)makeCallToTokenUrl:(NSString*)tokenURL withToken:(NSString*)token forProvider:(NSString*)provider;

- (void)authenticationDidCancel;
- (void)authenticationDidCompleteWithPayload:(NSDictionary*)payloadDict forProvider:(JRProvider*)provider;
- (void)authenticationDidCompleteWithAuthenticationToken:(NSString*)authenticationToken andDeviceToken:(NSString*)deviceToken;
- (void)authenticationDidCompleteWithToken:(NSString*)authenticationToken;
- (void)authenticationDidFailWithError:(NSError*)_error;
@end
