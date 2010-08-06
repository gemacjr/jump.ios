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
	DLog(@"");
    DLog(@"appID:    %@", appId);
	DLog(@"tokenURL: %@", tokenUrl);
    
	if (self = [super init])
	{
		singletonJRAuth = self;
		
        // TODO: Do we need to retain the delegate or does initWithObjects do that for me?
        // TODO: Add a way to add delegates, or receive notifications automatically
		delegates = [[NSMutableArray alloc] initWithObjects:[delegate retain], nil];
		
        sessionData = [JRSessionData jrSessionDataWithAppId:appId tokenUrl:tokenUrl andDelegate:self];
        interfaceMaestro = [JRUserInterfaceMaestro jrUserInterfaceMaestroWithSessionData:sessionData];
        
//        jrModalNavController = [[JRModalNavigationController alloc] init];
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

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    DLog(@"");
//	if (jrModalNavController) 
//		[jrModalNavController dismissModalNavigationController:NO];	
//}

- (void)showJRAuthenticateDialog
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

    [interfaceMaestro showAuthenticationDialog];
// 	UIWindow* window = [UIApplication sharedApplication].keyWindow;
//	if (!window) 
//	{
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}
//	
//	if (!jrModalNavController)
//		jrModalNavController = [[JRModalNavigationController alloc] init];
//	
//	[window addSubview:jrModalNavController.view];
//	
//	[jrModalNavController presentModalNavigationControllerForAuthentication];
}

- (void)showAuthenticationDialog
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
    
    [interfaceMaestro showAuthenticationDialog];
    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//	if (!window) 
//	{
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}
//
//	if (!jrModalNavController)
//		jrModalNavController = [[JRModalNavigationController alloc] init];
//	
//	[window addSubview:jrModalNavController.view];
//	
//	[jrModalNavController presentModalNavigationControllerForAuthentication];
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
    
//	UIWindow* window = [UIApplication sharedApplication].keyWindow;
//	if (!window) 
//	{
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}
//	
//    if (!jrModalNavController)
//		jrModalNavController = [[JRModalNavigationController alloc] init];
//	
//	[window addSubview:jrModalNavController.view];

	[sessionData setActivity:activity];
//	[jrModalNavController presentModalNavigationControllerForPublishingActivity];
    
    [interfaceMaestro showPublishingDialogWithActivity];
}

//- (void)unloadModalViewControllerWithTransitionStyle:(UIModalTransitionStyle)style
//{
//	DLog(@"");
//    [jrModalNavController dismissModalNavigationController:style];   
//  	[jrModalNavController release];
//	jrModalNavController = nil;	    
//}

- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider
{
	DLog(@"");
    DLog(@"token: %@", token);
	
	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didReceiveToken:token forProvider:provider];
	}

	[interfaceMaestro authenticationCompleted];
//    if (![sessionData social])
//        [self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCrossDissolve];//[jrModalNavController dismissModalNavigationController:YES];
}

- (void)authenticateDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSString*)tokenUrlPayload forProvider:(NSString*)provider
{
    DLog(@"");
    for (id<JRAuthenticateDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticate:self didReachTokenUrl:tokenUrl withPayload:tokenUrlPayload forProvider:provider];
    }    
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
	DLog(@"");
    for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticate:self didFailWithError:error forProvider:provider];
	}

	[interfaceMaestro authenticationFailed];
//	[self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:NO];
}


- (void)authenticateCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    for (id<JRAuthenticateDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticate:self callToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
    }
}

- (void)authenticationDidCancel
{
	DLog(@"");
    for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}
    
    [interfaceMaestro authenticationCanceled];
//	[self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:NO];
}

//- (void)authenticationDidCancelForProvider:(NSString*)provider
//{
//	DLog(@"");
//    for (id<JRAuthenticateDelegate> delegate in delegates) 
//	{
//		[delegate jrAuthenticateDidNotCompleteAuthentication:self forProvider:(NSString*)provider];
//	}
//
//	[interfaceMaestro authenticationCanceled];
////	[self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:NO];
//}

- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider
{
    
}

- (void)publishingActivityDidFail:(JRActivityObject*)activity forProvider:(NSString*)provider
{
    
}

- (void)publishingDidCancel 
{ 
	DLog(@"");
    for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self];
	}

	[interfaceMaestro publishingCanceled];
//	[self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCrossDissolve];//[jrModalNavController dismissModalNavigationController:YES];   
//  	[jrModalNavController release];
//	jrModalNavController = nil;	
//    [self unloadModalViewController];
}

- (void)publishingDidComplete
{
    [interfaceMaestro publishingCompleted];
}

- (void)publishingDidFailWithError:(NSError*)error forProvider:(NSString*)provider { DLog(@""); }
- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error { }

- (void)cancelAuthentication
{	
	DLog(@"");

	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticateDidNotCompleteAuthentication:self forProvider:nil];
	}

    [interfaceMaestro authenticationCanceled];
//  [self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCrossDissolve];//[jrModalNavController dismissModalNavigationController:YES];
}

- (void)cancelAuthenticationWithError:(NSError*)error
{
	DLog(@"");

	for (id<JRAuthenticateDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticate:self didFailWithError:error forProvider:nil];
	}	

	[interfaceMaestro authenticationCanceled];
//	[self unloadModalViewControllerWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:NO];
}

//- (void)unloadModalViewController
//{
//	DLog(@"");
//
//	[[jrModalNavController view] removeFromSuperview];
//	[jrModalNavController release];
//	jrModalNavController = nil;	
//}

- (void)makeCallToTokenUrl:(NSString*)tokenUrl withToken:(NSString *)token
{
	DLog(@"");
    DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", tokenUrl);
    
	[sessionData makeCallToTokenUrl:tokenUrl withToken:token forProvider:nil];
}

- (void)signoutUserForProvider:(NSString*)provider
{
    DLog(@"");
    [sessionData forgetAuthenticatedUserForProvider:provider];
}

- (void)signoutUserForAllProviders
{
    DLog(@"");
    [sessionData forgetAllAuthenticatedUsers];
}


- (void)dealloc 
{
	DLog(@"");

	if (singletonJRAuth == self)
		singletonJRAuth = nil;
	
//	[jrModalNavController release];
	[delegates release];
		
	[super dealloc];
}

@end
