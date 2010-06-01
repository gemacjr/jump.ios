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
#import <JSON/JSON.h>
#import "JRConnectionManager.h"

@interface JRProvider : NSObject
{
	NSString *name;
	NSString *friendlyName;
	NSString *placeholderText;
	NSString *shortText;
	BOOL providerRequiresInput;

	NSString *userInput;
	NSString *welcomeString;
	
	NSDictionary *providerStats;	
}

@property (readonly) NSString *name;
@property (readonly) NSString *friendlyName;
@property (readonly) NSString *shortText;
@property (readonly) NSString *placeholderText;
@property (readonly) BOOL providerRequiresInput;

@property (retain) NSString *userInput;
@property (retain) NSString *welcomeString;

- (JRProvider*)initWithName:(NSString*)nm andStats:(NSDictionary*)stats;
@end

@protocol JRSessionDelegate <NSObject>

- (void)jrAuthenticationDidCancel;
- (void)jrAuthenticationDidCompleteWithToken:(NSString*)tok andProvider:(NSString*)prov;
- (void)jrAuthenticationDidFailWithError:(NSError*)err;

@end

@interface JRSessionData : NSObject <JRConnectionManagerDelegate>
{
	id<JRSessionDelegate> delegate;
	
	JRProvider *currentProvider;
	JRProvider *returningProvider;	
	
	NSDictionary	*allProviders;
	NSDictionary	*providerInfo;
	NSArray			*configedProviders;
	
	BOOL hidePoweredBy;
	
	NSURL *startURL;
	
	NSString *baseURL;
	
	NSString *errorStr;

	BOOL forceReauth;
	
	NSString *token;
}

@property (readonly) NSString *errorStr;

@property (readonly) JRProvider *currentProvider;
@property (readonly) JRProvider *returningProvider;

@property (readonly) NSDictionary *allProviders;
@property (readonly) NSArray *configedProviders;

@property (readonly) BOOL hidePoweredBy;

@property (readonly) NSURL *startURL;
@property (assign) BOOL forceReauth;

@property (readonly) NSString* token;

- (id)initWithBaseUrl:(NSString*)URL andDelegate:(id<JRSessionDelegate>)del;
- (void)setReturningProviderToProvider:(JRProvider*)provider;
- (void)setProvider:(NSString *)prov;
- (void)setCurrentProviderToReturningProvider;
//- (void)loadCookieData;
	
- (void)authenticationDidCancel;
- (void)authenticationDidCompleteWithToken:(NSString*)tok;
- (void)authenticationDidFailWithError:(NSError*)err;
@end
