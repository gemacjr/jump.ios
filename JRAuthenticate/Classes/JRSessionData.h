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
//#import "JRPublishActivityController.h"

#define SOCIAL_PUBLISHING

@interface JRProvider : NSObject
{
	NSString *name;
	NSString *friendlyName;
	NSString *placeholderText;
	NSString *shortText;
	BOOL providerRequiresInput;

	NSString *userInput;
	NSString *welcomeString;
    
    NSString *open_identifier;
	NSString *url;
    
	NSDictionary *providerStats;	
}

@property (readonly) NSString *name;
@property (readonly) NSString *friendlyName;
@property (readonly) NSString *shortText;
@property (readonly) NSString *placeholderText;
@property (readonly) BOOL providerRequiresInput;

@property (retain) NSString *userInput;
@property (retain) NSString *welcomeString;

- (JRProvider*)initWithName:(NSString*)_name andStats:(NSDictionary*)_stats;
- (BOOL)isEqualToProvider:(JRProvider*)provider;
@end

@protocol JRSessionDelegate <NSObject>

- (void)jrAuthenticationDidCancel;
- (void)jrAuthenticationDidCompleteWithToken:(NSString*)tok andProvider:(NSString*)prov;
- (void)jrAuthenticationDidFailWithError:(NSError*)err;
- (void)jrAuthenticateDidReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload;
- (void)jrAuthenticateCallToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error;

@end

@class JRActivityObject;

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


@interface JRSessionData : NSObject <JRConnectionManagerDelegate>
{
	NSMutableArray	*delegates;
//	id<JRSessionDelegate> delegate;
	    
	JRProvider *currentProvider;
	JRProvider *returningBasicProvider;	
    JRProvider *currentSocialProvider;
    JRProvider *returningSocialProvider;
	
	NSDictionary    *providerInfo;
	NSArray			*basicProviders;
    NSArray         *socialProviders;
    
    NSMutableDictionary    *deviceTokensByProvider;
    NSMutableDictionary    *identifiersProviders;
	
    JRActivityObject *activity;
    
	BOOL hidePoweredBy;
    UIView *customView;
    NSDictionary *customProvider;
	
	NSURL	 *startUrl;
    BOOL      isSocial;
    
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

@property (readonly) NSDictionary *providerInfo;
@property (readonly) NSArray *basicProviders;
@property (readonly) NSArray *socialProviders;

@property (retain) JRActivityObject *activity;

@property (readonly) BOOL hidePoweredBy;
@property (readonly) UIView       *customView;
@property (readonly) NSDictionary *customProvider;


@property (readonly) NSURL    *startUrl;
@property (readonly) NSString *baseUrl;

@property (assign) BOOL forceReauth;


- (void)addDelegate:(id<JRSessionDelegate>)_delegate;
- (void)removeDelegate:(id<JRSessionDelegate>)_delegate;

- (NSString*)identifierForProvider:(NSString*)provider;

- (id)initWithAppId:(NSString*)_appId /*tokenUrl:(NSString*)tokUrl*/ andDelegate:(id<JRSessionDelegate>)_delegate;
- (void)reconfigure;

- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index;
- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index;

- (void)setReturningBasicProviderToNewBasicProvider:(JRProvider*)provider;
- (void)setCurrentBasicProviderToReturningProvider;

- (void)setBasicProvider:(JRProvider*)provider;
- (void)setSocialProvider:(JRProvider*)provider;
	
- (BOOL)gatheringInfo;

- (NSString*)deviceTokenForProvider:(NSString*)provider;
- (void)forgetDeviceTokenForProvider:(NSString*)provider;
- (void)forgetAllDeviceTokens;

- (void)makeCallToTokenUrl:(NSString*)tokenURL WithToken:(NSString *)token;

- (void)authenticationDidCancel;
- (void)authenticationDidCompleteWithAuthenticationToken:(NSString*)authenticationToken andDeviceToken:(NSString*)deviceToken;
- (void)authenticationDidCompleteWithToken:(NSString*)authenticationToken;
- (void)authenticationDidFailWithError:(NSError*)_error;
@end
