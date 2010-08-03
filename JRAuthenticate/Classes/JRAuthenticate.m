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
#if FOO
    return nil;
#endif
	DLog(@"appID:    %@", appId);
	DLog(@"tokenURL: %@", tokenUrl);

    
	if (self = [super init])
	{
		singletonJRAuth = self;
		
        // TODO: Do we need to retain the delegate or does initWithObjects do that for me?
        // TODO: Add a way to add delegates, or receive notifications automatically
		delegates = [[NSMutableArray alloc] initWithObjects:[delegate retain], nil];
		
        sessionData = [JRSessionData jrSessionDataWithAppId:appId tokenUrl:tokenUrl andDelegate:self];
        jrModalNavController = [[JRModalNavigationController alloc] init];
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
            [self authenticationDidFailWithError:[sessionData.error retain] forProvider:nil];
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
		jrModalNavController = [[JRModalNavigationController alloc] init];
	
	[window addSubview:jrModalNavController.view];
	
	[jrModalNavController presentModalNavigationControllerForAuthentication];
}

- (void)showAuthenticationDialog
{
    if (sessionData.error)
    {
        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
        {
            [self authenticationDidFailWithError:[sessionData.error retain] forProvider:nil];
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
		jrModalNavController = [[JRModalNavigationController alloc] init];
	
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
            [self authenticationDidFailWithError:[sessionData.error retain] forProvider:nil];
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
		jrModalNavController = [[JRModalNavigationController alloc] init];
	
	[window addSubview:jrModalNavController.view];

	[sessionData setActivity:activity];
	[jrModalNavController presentModalNavigationControllerForPublishingActivity];
}

- (void)makeCallToTokenUrl:(NSString*)tokenUrl withToken:(NSString *)token
{
	DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", tokenUrl);

	[sessionData makeCallToTokenUrl:tokenUrl WithToken:token];
}

- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider
{
	DLog(@"token: %@", token);
	
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didReceiveToken:token forProvider:provider];
	}
	
    if ([sessionData isSocial])
        [jrModalNavController dismissModalNavigationController:YES];
}

- (void)authenticateDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSString*)tokenUrlPayload forProvider:(NSString*)provider
{
    for (id<JRAuthenticateDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticate:self didReachTokenUrl:tokenUrl withPayload:tokenUrlPayload forProvider:provider];
    }    
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didFailWithError:error forProvider:provider];
	}
	
	[jrModalNavController dismissModalNavigationController:NO];
}


- (void)authenticateCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    for (id<JRAuthenticateDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticate:self callToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
    }
}

- (void)authenticationDidCancel
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}
	
	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)authenticationDidCancelForProvider:(NSString*)provider
{
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self forProvider:(NSString*)provider];
	}
	
	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)publishingDidCancel { }
- (void)publishingDidCancelForProvider:(NSString*)provider { }
- (void)publishingDidCompleteWithActivity:(JRActivityObject*)activity forProvider:(NSString*)provider { }
- (void)publishingDidFailWithError:(NSError*)error forProvider:(NSString*)provider { }


- (void)cancelAuthentication
{	
	DLog(@"");

	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self forProvider:nil];
	}

	[jrModalNavController dismissModalNavigationController:NO];
}

- (void)cancelAuthenticationWithError:(NSError*)error
{
	DLog(@"");

	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didFailWithError:error forProvider:nil];
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
    [sessionData forgetAuthenticatedUserForProvider:provider];
}

- (void)signoutUserForAllProviders
{
    [sessionData forgetAllAuthenticatedUsers];
}


- (void)dealloc 
{
	DLog(@"");

	if (singletonJRAuth == self)
		singletonJRAuth = nil;
	
	[jrModalNavController release];
	[delegates release];
	[sessionData release];
		
	[super dealloc];
}


@end
