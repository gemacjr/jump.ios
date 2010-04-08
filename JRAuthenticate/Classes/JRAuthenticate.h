/* 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 * Redistributions in binary
 form must reproduce the above copyright notice, this list of conditions and the
 following disclaimer in the documentation and/or other materials provided with
 the distribution. 
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
 */


#import <Foundation/Foundation.h>
#import <JSON/JSON.h>
#import "JRConnectionManager.h"
#import "JRModalNavigationController.h"
#import "JRWebViewController.h"
#import "JRSessionData.h"

#define LOCAL 0

@protocol JRAuthenticateDelegate <NSObject>

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didCompleteAuthentication:(NSDictionary*)userInfo;

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token;
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenUrlPayload;

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSString*)error;
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didNotCompleteAuthentication:(NSString*)reason;
@end


@interface JRAuthenticate : NSObject 
{
	JRModalNavigationController *jrModalNavController;
	
	NSString		*theAppId;
	NSString		*theAppName;
	NSString		*theTokenUrl;
	
	NSArray			*delegates;
	
	NSString		*token;
	NSString		*tokenUrlPayload;
	
	JRSessionData	*sessionData;
	
	NSString		*errorStr;
}

@property (nonatomic, readonly) NSString* theAppName;
@property (nonatomic, readonly) NSString* theTokenUrl;

@property (nonatomic, readonly) NSString* token;
@property (nonatomic, readonly) NSString* tokenUrlPayload;

+ (JRAuthenticate*)jrAuthenticate;
+ (void)setJRAuthenticate:(JRAuthenticate*)jrAuth;

+ (JRAuthenticate*)initWithAppID:(NSString*)appId 
					 andTokenUrl:(NSString*)tokenUrl
						delegate:(id<JRAuthenticateDelegate>)delegate;

- (void)showJRAuthenticateDialog;

- (void)cancelAuthentication;
- (void)cancelAuthenticationWithError:(NSString*)error;

- (void)didCompleteAuthentication:(NSDictionary*)userInfo;

- (void)didReceiveToken:(NSString*)token;
- (void)didReachTokenURL:(NSString*)tokenURLdataLoad;

- (void)didFailWithError:(NSString*)error;
- (void)didNotCompleteAuthentication:(NSString*)reason;

@end
