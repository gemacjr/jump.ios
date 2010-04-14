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


#import "JRAuthenticate.h"

@implementation JRAuthenticate

@synthesize theAppName;
@synthesize theTokenUrl;

@synthesize token;
@synthesize tokenUrlPayload;

static JRAuthenticate* singletonJRAuth = nil;
+ (JRAuthenticate*)jrAuthenticate 
{
	return singletonJRAuth;
}

+ (void)setJRAuthenticate:(JRAuthenticate*)jrAuth 
{
	singletonJRAuth = jrAuth;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (jrModalNavController) 
		[jrModalNavController dismissModalNavigationController:NO];	
}


- (void)showJRAuthenticateDialog
{
	if (errorStr) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Initialization Error"
														message:@"JRAuthenticate had a problem initializing and cannot be used at this time."
													   delegate:self
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		
		return;
	}
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
	if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] initWithSessionData:sessionData];
	
	[window addSubview:jrModalNavController.view];
	
	[jrModalNavController presentModalNavigationController];
}


- (void)startGetBaseUrl
{
#if LOCAL // TODO: Change this to use stringWithFormat instead
	NSString *urlString = [[@"http://lillialexis.janrain.com:8080/jsapi/v3/base_url?appId=" 
							stringByAppendingString:theAppId]
						   stringByAppendingString:@"&skipXdReceiver=true"];
#else
	NSString *urlString = [[@"http://rpxnow.com/jsapi/v3/base_url?appId=" 
							stringByAppendingString:theAppId]
						   stringByAppendingString:@"&skipXdReceiver=true"];
#endif
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url) // Then there was an error
		return;
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
	NSString *tag = [[NSString alloc] initWithFormat:@"getBaseURL"];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was a problem getting the base url."];
}

- (void)finishGetBaseUrl:(NSString*)dataStr
{
	printf("finishGetBaseUrl\n");
	NSArray *arr = [dataStr componentsSeparatedByString:@"\""];
	
	if(!arr)
		return;
	
	theAppName = [arr objectAtIndex:1];
	
	NSUInteger length = [theAppName length];
	unichar endChar = [theAppName characterAtIndex:(length - 1)];
	if (endChar == '/') 
	{ // TODO: Use stringTrim function instead
		theAppName = [theAppName stringByReplacingCharactersInRange:NSMakeRange ((length - 1), 1) withString:@""];
	}
	
	[theAppName retain];
	
	sessionData = [[JRSessionData alloc] initWithBaseUrl:theAppName];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	NSString* tag = (NSString*)userdata;
	
	if ([tag isEqualToString:@"getBaseURL"])
	{
		if ([payload hasPrefix:@"RPXNOW._base_cb(true"])
		{
			[self finishGetBaseUrl:payload];
		}
		else // There was an error...
		{
			errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
		}
	}
	else if ([tag isEqualToString:@"token_url_payload"])
	{
		tokenUrlPayload = payload;
		for (id<JRAuthenticateDelegate> delegate in delegates) 
		{
			[delegate jrAuthenticate:self didReachTokenURL:tokenUrlPayload];
		}
	}

	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
	
	if ([tag isEqualToString:@"getBaseURL"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
	}
	else if ([tag isEqualToString:@"getConfiguredProviders"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
	}
	
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	[(NSString*)userdata release];
}

- (JRAuthenticate*)initWithAppID:(NSString*)appId 
					 andTokenUrl:(NSString*)tokenUrl 
						delegate:(id<JRAuthenticateDelegate>)delegate
{
	if (appId == nil)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init])
	{
		singletonJRAuth = self;
		
		delegates = [[NSArray alloc] initWithObjects:[delegate retain], nil];
		
		theAppId = [[NSString alloc] initWithString:appId];
		theTokenUrl = (tokenUrl) ? [[NSString alloc] initWithString:tokenUrl] : nil;

		[self startGetBaseUrl];
	}	
		
	return self;
}

+ (JRAuthenticate*)jrAuthenticateWithAppID:(NSString*)appId 
					 andTokenUrl:(NSString*)tokenUrl
						delegate:(id<JRAuthenticateDelegate>)delegate
{
	if(singletonJRAuth)
		return singletonJRAuth;
	
	return [[JRAuthenticate alloc] initWithAppID:appId 
									 andTokenUrl:tokenUrl 
										delegate:delegate];
}	

- (void)didCompleteAuthentication:(NSDictionary*)userInfo
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didCompleteAuthentication:userInfo];
	}
}

- (void)makeCallToTokenUrlWithToken:(NSString*)tok
{
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", tok] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:theTokenUrl]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
	NSString* tag = [NSString stringWithFormat:@"token_url_payload"];
	[tag retain];
	
	[JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
	
//	[self startProgress];
}


- (void)didReceiveToken:(NSString*)tok
{
	token = tok;
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didReceiveToken:token];
	}
	
	[jrModalNavController dismissModalNavigationController:YES];
	
	if (theTokenUrl)
		[self makeCallToTokenUrlWithToken:token];
	
	
	NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	[cookieStore setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
	NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:604800];
	
	NSHTTPCookie	*cookie = nil;
	
	[sessionData setReturningProviderToProvider:sessionData.currentProvider];
	
	cookie = [NSHTTPCookie cookieWithProperties:
			  [NSDictionary dictionaryWithObjectsAndKeys:
			   sessionData.returningProvider.name, NSHTTPCookieValue,
			   @"login_tab", NSHTTPCookieName,
			   @"jrauthenticate.rpxnow.com", NSHTTPCookieDomain,
			   @"/", NSHTTPCookiePath,
			   @"FALSE", NSHTTPCookieDiscard,
			   date, NSHTTPCookieExpires, nil]];
	[cookieStore setCookie:cookie];
	
	cookie = [NSHTTPCookie cookieWithProperties:
			  [NSDictionary dictionaryWithObjectsAndKeys:
			   sessionData.returningProvider.userInput, NSHTTPCookieValue,
			   @"user_input", NSHTTPCookieName,
			   @"jrauthenticate.rpxnow.com", NSHTTPCookieDomain,
			   @"/", NSHTTPCookiePath,
			   @"FALSE", NSHTTPCookieDiscard,
			   date, NSHTTPCookieExpires, nil]];
	[cookieStore setCookie:cookie];
	
}

- (void)didReachTokenURL:(NSString*)payload
{
	tokenUrlPayload = payload;
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didReachTokenURL:tokenUrlPayload];
	}
}

- (void)didFailWithError:(NSString*)error 
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didFailWithError:nil];
	}
}

- (void)didNotCompleteAuthentication:(NSString*)reason 
{ 
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}
}

- (void)cancelAuthentication
{	
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}

	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)cancelAuthenticationWithError:(NSError*)error
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didFailWithError:nil];
	}	
	
	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)unloadModalViewController
{
	[[jrModalNavController view] removeFromSuperview];
	[jrModalNavController release];
	jrModalNavController = nil;	
}



- (void)dealloc 
{
	if (singletonJRAuth == self)
		singletonJRAuth = nil;
	
	[errorStr release];

	[sessionData release];
	
	[delegates release];
	
	[jrModalNavController release];
	
	[theAppId release];
	[theAppName release];
	[theTokenUrl release];
	
	[super dealloc];
}


@end
