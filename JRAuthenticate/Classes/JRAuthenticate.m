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
	
//	[theAppId retain];
	
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
//	else if ([tag isEqualToString:@"getConfiguredProviders"])
//	{
//		if ([payload rangeOfString:@"\"provider_info\":{"].length != 0)
//		{
//			[self finishGetConfiguredProviders:payload];
//		}
//		else // There was an error...
//		{
//			errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
//		}
//	}
	
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


//- (JRAuthenticate*)init
//{	
//	if (self = [super init]) 
//	{
//		singletonJRAuth = self;
//		
//		delegates = nil;
//		
//		theAppId = nil;
//		theAppName = nil;
//		theTokenUrl = nil;
//		
//		errorStr = nil;
//	
//		sessionData = nil;
//	}
//	
//	return singletonJRAuth;
//}

- (JRAuthenticate*)initWithAppID:(NSString*)appId 
					 // andAppName:(NSString*)appName 
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
//		[delegates retain];
		
		theAppId = [[NSString alloc] initWithString:appId];	//(appId) ? [NSString stringWithString:appId] : nil;
		theTokenUrl = (tokenUrl) ? [[NSString alloc] initWithString:tokenUrl] : nil;
//		theAppName = (appName) ? [NSString stringWithString:appName] : nil;
			
	//	if(!appName)
			[self startGetBaseUrl];
	//	else
	//		sessionData = [[JRSessionData alloc] initWithBaseUrl:appName];
	}	
		
	return self;
}

//+ (JRAuthenticate*)initWithAppID:(NSString*)appId 
//						delegate:(id<JRAuthenticateDelegate>)delegate
//{
//	if(singletonJRAuth)
//		return singletonJRAuth;
//	
//	return [[JRAuthenticate alloc] initWithAppID:appId 
//									  andAppName:nil 
//									 andTokenUrl:nil 
//										delegate:delegate];
//}	
//
//+ (JRAuthenticate*)initWithAppName:(NSString*)appName
//						  delegate:(id<JRAuthenticateDelegate>)delegate
//{
//	if(singletonJRAuth)
//		return singletonJRAuth;
//	
//	return [[JRAuthenticate alloc] initWithAppID:nil 
//									  andAppName:appName 
//									 andTokenUrl:nil 
//										delegate:delegate];
//}

+ (JRAuthenticate*)initWithAppID:(NSString*)appId 
					 andTokenUrl:(NSString*)tokenUrl
						delegate:(id<JRAuthenticateDelegate>)delegate
{
	if(singletonJRAuth)
		return singletonJRAuth;
	
	return [[JRAuthenticate alloc] initWithAppID:appId 
									 andTokenUrl:tokenUrl 
										delegate:delegate];
}	

//+ (JRAuthenticate*)initWithAppName:(NSString*)appName 
//					   andTokenUrl:(NSString*)tokenUrl
//						  delegate:(id<JRAuthenticateDelegate>)delegate
//{
//	if(singletonJRAuth)
//		return singletonJRAuth;
//	
//	return [[JRAuthenticate alloc] initWithAppID:nil 
//									  andAppName:appName 
//									 andTokenUrl:tokenUrl 
//										delegate:delegate];
//}


- (void)didCompleteAuthentication:(NSDictionary*)userInfo
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didCompleteAuthentication:userInfo];
	}
}

- (void)didReceiveToken:(NSString*)tok
{
	token = tok;
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didReceiveToken:token];
	}
	
	[jrModalNavController dismissModalNavigationController:YES];
//	[jrModalNavController restore];
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
        [delegate jrAuthenticate:self didFailWithError:error];
	}
}

- (void)didNotCompleteAuthentication:(NSString*)reason 
{ 
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didNotCompleteAuthentication:reason];
	}
}

- (void)cancelAuthentication
{	
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didNotCompleteAuthentication:@""];
	}

	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)cancelAuthenticationWithError:(NSString*)error
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didFailWithError:error];
	}	
	
	[jrModalNavController dismissModalNavigationController:NO];
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
