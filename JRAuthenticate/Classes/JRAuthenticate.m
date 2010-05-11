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

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation JRAuthenticate

@synthesize theBaseUrl;
@synthesize theTokenUrl;

@synthesize theToken;
@synthesize theTokenUrlPayload;

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
    DLog(@"");
	if (jrModalNavController) 
		[jrModalNavController dismissModalNavigationController:NO];	
}

- (void)showJRAuthenticateDialog
{
    DLog(@"");
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
	if (!theBaseUrl)
		[self startGetBaseUrl];
	
	
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
    DLog(@"url: %@", urlString);
	
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
	DLog(@"dataStr: %@", dataStr);
	
	NSArray *arr = [dataStr componentsSeparatedByString:@"\""];
	
	if(!arr)
		return;
	
	theBaseUrl = [arr objectAtIndex:1];
	
	NSUInteger length = [theBaseUrl length];
	unichar endChar = [theBaseUrl characterAtIndex:(length - 1)];
	if (endChar == '/') 
	{ // TODO: Use stringTrim function instead
		theBaseUrl = [theBaseUrl stringByReplacingCharactersInRange:NSMakeRange ((length - 1), 1) withString:@""];
	}
	
	[theBaseUrl retain];
	
	if (!sessionData)
		sessionData = [[JRSessionData alloc] initWithBaseUrl:theBaseUrl andDelegate:self];
	
	if (jrModalNavController)
		jrModalNavController.sessionData = sessionData;
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
 	NSString* tag = [(NSString*)userdata retain]; 

	DLog(@"payload: %@", payload);
	DLog(@"tag:     %@", tag);

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
	else if ([tag hasPrefix:@"token_url:"])
	{
		theTokenUrlPayload = [[NSString stringWithString:payload] retain];
		NSString* tokenURL = [[NSString stringWithString:[[request URL] absoluteString]] retain];
							
		for (id<JRAuthenticateDelegate> delegate in delegates) 
		{
			[delegate jrAuthenticate:self didReachTokenURL:tokenURL withPayload:theTokenUrlPayload];
		}
	}

	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = [(NSString*)userdata retain];
	DLog(@"tag:     %@", tag);
	
	if ([tag isEqualToString:@"getBaseURL"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
	}
	else if ([tag hasPrefix:@"token_url:"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error posting the token to the token URL.\nThere was an error in the response to a request."];
		NSRange prefix = [tag rangeOfString:@"token_url:"];
		
		NSString *tokenURL = (prefix.length > 0) ? [tag substringFromIndex:prefix.length]: nil;
		
		for (id<JRAuthenticateDelegate> delegate in delegates) 
		{
			[delegate jrAuthenticate:self callToTokenURL:tokenURL didFailWithError:error];
		}
	}
	
//	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	[(NSString*)userdata release];
}

- (JRAuthenticate*)initWithAppID:(NSString*)appId 
					 andTokenUrl:(NSString*)tokenUrl 
						delegate:(id<JRAuthenticateDelegate>)delegate
{
	DLog(@"appID:    %@", appId);
	DLog(@"tokenURL: %@", tokenUrl);

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

- (void)makeCallToTokenUrl:(NSString*)tokenURL WithToken:(NSString *)token
{
	DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", tokenURL);
	
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenURL]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
	NSString* tag = [[NSString stringWithFormat:@"token_url:%@", tokenURL] retain];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Problem initializing connection to Token URL"
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
                                                         code:100
                                                     userInfo:userInfo];
		
		for (id<JRAuthenticateDelegate> delegate in delegates) 
		{
			[delegate jrAuthenticate:self callToTokenURL:tokenURL didFailWithError:error];
		}
	}
}

- (void)makeCallToTokenUrlWithToken:(NSString*)token
{
	[self makeCallToTokenUrl:theTokenUrl WithToken:token];
}	

- (void)jrAuthenticationDidCompleteWithToken:(NSString*)token
{
	DLog(@"token: %@", token);
	
	theToken = [token retain];
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didReceiveToken:token];
	}
	
	[jrModalNavController dismissModalNavigationController:YES];

	[sessionData loadCookieData];

	if (theTokenUrl)
		[self makeCallToTokenUrlWithToken:theToken];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didFailWithError:error];
	}
}

- (void)jrAuthenticationDidCancel
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}
}

- (void)cancelAuthentication
{	
	DLog(@"");

	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}

	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)cancelAuthenticationWithError:(NSError*)error
{
	DLog(@"");

	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didFailWithError:error];
	}	
	
	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)unloadModalViewController
{
	DLog(@"");

	[[jrModalNavController view] removeFromSuperview];
	[jrModalNavController release];
	jrModalNavController = nil;	
}

- (void)dealloc 
{
	DLog(@"");

	if (singletonJRAuth == self)
		singletonJRAuth = nil;
	
	[jrModalNavController release];
	
	[theAppId release];
	[theBaseUrl release];
	[theTokenUrl release];
	
	[delegates release];
	
	[theToken release];
	[theTokenUrlPayload release];
	
	[sessionData release];
	
	[errorStr release];
	
	[super dealloc];
}


@end
