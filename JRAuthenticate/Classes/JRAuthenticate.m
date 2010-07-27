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
 
 File:	 JRAuthenticate.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRAuthenticate.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
// TODO: Take this out of the production app
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation JRAuthenticate
//@synthesize theBaseUrl;
@synthesize theTokenUrl;
@synthesize theToken;
@synthesize theTokenUrlPayload;

static JRAuthenticate* singletonJRAuth = nil;
+ (JRAuthenticate*)jrAuthenticate 
{
	return singletonJRAuth;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self jrAuthenticate] retain];
}

- (JRAuthenticate*)initWithAppID:(NSString*)appId 
					 andTokenUrl:(NSString*)tokenUrl 
						delegate:(id<JRAuthenticateDelegate>)delegate
{
	DLog(@"appID:    %@", appId);
	DLog(@"tokenURL: %@", tokenUrl);
		
	if (self = [super init])
	{
		singletonJRAuth = self;
		
        // TODO: Do we need to retain the delegate or does initWithObjects do that for me?
        // TODO: Add a way to add delegates, or receive notifications automatically
		delegates = [[NSMutableArray alloc] initWithObjects:[delegate retain], nil];
		
//		theAppId = [[NSString alloc] initWithString:appId];
		theTokenUrl = (tokenUrl) ? [[NSString alloc] initWithString:tokenUrl] : nil;

        sessionData = [JRSessionData jrSessionDataWithAppId:appId andDelegate:self];
        jrModalNavController = [[JRModalNavigationController alloc] init];//WithSessionData:sessionData];
        
//		[self startGetBaseUrl];
	}	
	
	return self;
}



+ (JRAuthenticate*)jrAuthenticateWithAppID:(NSString*)appId 
							   andTokenUrl:(NSString*)tokenUrl
								  delegate:(id<JRAuthenticateDelegate>)delegate
{
	if(singletonJRAuth)
		return singletonJRAuth;
	
	if (appId == nil)
		return nil;
	
	return [[super allocWithZone:nil] initWithAppID:appId 
										andTokenUrl:tokenUrl 
										   delegate:delegate];
}	

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
	if (jrModalNavController) 
		[jrModalNavController dismissModalNavigationController:NO];	
}

- (void)showJRAuthenticateDialog
{
    if (sessionData.error)
    {
        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
        {
            [self jrAuthenticationDidFailWithError:[sessionData.error retain]];
            [sessionData reconfigure];
            [sessionData.error release];
            return;
        }
    }

    DLog(@"");
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
	if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] init];//WithSessionData:sessionData];
	
	[window addSubview:jrModalNavController.view];
	
	[jrModalNavController presentModalNavigationControllerForAuthentication];
}

- (void)showAuthenticationDialog
{
    if (sessionData.error)
    {
        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
        {
            [self jrAuthenticationDidFailWithError:[sessionData.error retain]];
            [sessionData reconfigure];
            [sessionData.error release];
            return;
        }
    }
    DLog(@"");
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}

	if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] init];//WithSessionData:sessionData];
	
	[window addSubview:jrModalNavController.view];
	
	[jrModalNavController presentModalNavigationControllerForAuthentication];
}

- (void)showPublishingDialogWithActivity:(JRActivityObject*)activity
{
    DLog(@"");

    if (sessionData.error)
    {
        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
        {
            [self jrAuthenticationDidFailWithError:[sessionData.error retain]];
            [sessionData reconfigure];
            [sessionData.error release];
            return;
        }
    }
    
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
    if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] init];//WithSessionData:sessionData];
	
	[window addSubview:jrModalNavController.view];

	[sessionData setActivity:activity];
	[jrModalNavController presentModalNavigationControllerForPublishingActivity];
}

- (void)makeCallToTokenUrl:(NSString*)tokenURL WithToken:(NSString *)token
{
	DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", tokenURL);

	[sessionData makeCallToTokenUrl:tokenURL WithToken:token];
}

- (void)jrAuthenticationDidCompleteWithToken:(NSString*)token andProvider:(NSString*)provider
{
	DLog(@"token: %@", token);
	
	theToken = [token retain];
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didReceiveToken:token];
		[delegate jrAuthenticate:self didReceiveToken:token forProvider:provider];
	}
	
	[jrModalNavController dismissModalNavigationController:YES];

	if (theTokenUrl)
        [sessionData makeCallToTokenUrl:theTokenUrl WithToken:theToken];
}

- (void)jrAuthenticateDidReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload
{
    for (id<JRAuthenticateDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticate:self didReachTokenURL:tokenURL withPayload:theTokenUrlPayload];
    }    
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didFailWithError:error];
	}
	
	[jrModalNavController dismissModalNavigationController:NO];
}


- (void)jrAuthenticateCallToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error
{
    for (id<JRAuthenticateDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticate:self callToTokenURL:tokenURL didFailWithError:error];
    }
}

- (void)jrAuthenticationDidCancel
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}
	
	[jrModalNavController dismissModalNavigationController:NO];
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

- (void)signoutUserForProvider:(NSString*)provider
{
    [sessionData forgetDeviceTokenForProvider:provider];
}

- (void)signoutUserForAllProviders
{
    [sessionData forgetAllDeviceTokens];
}


- (void)dealloc 
{
	DLog(@"");

	if (singletonJRAuth == self)
		singletonJRAuth = nil;
	
	[jrModalNavController release];
	
    [theTokenUrl release];
	
	[delegates release];
	
	[theToken release];
	[theTokenUrlPayload release];
	
	[sessionData release];
		
	[super dealloc];
}


@end
