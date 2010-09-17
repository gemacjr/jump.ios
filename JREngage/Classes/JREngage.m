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


#import "JREngage.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
// TODO: Take this out of the production app
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation JREngage

static JREngage* singletonJREngage = nil;
+ (JREngage*)jrEngage
{
	return singletonJREngage;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self jrEngage] retain];
}

// TODO: Change this to accept the baseUrl instead of the appId to save time in initialization
- (JREngage*)initWithAppID:(NSString*)appId 
               andTokenUrl:(NSString*)tokenUrl 
                  delegate:(id<JREngageDelegate>)delegate
{
	DLog(@"");
    DLog(@"appID:    %@", appId);
	DLog(@"tokenURL: %@", tokenUrl);
    
	if (self = [super init])
	{
		singletonJREngage = self;
		
        // TODO: Add a way to add delegates, or receive notifications automatically
		delegates = [[NSMutableArray alloc] initWithObjects:delegate, nil];
		
        sessionData = [JRSessionData jrSessionDataWithAppId:appId tokenUrl:tokenUrl andDelegate:self];
        interfaceMaestro = [JRUserInterfaceMaestro jrUserInterfaceMaestroWithSessionData:sessionData];
    }	
	
	return self;
}

+ (JREngage*)jrEngageWithAppID:(NSString*)appId 
                   andTokenUrl:(NSString*)tokenUrl
                      delegate:(id<JREngageDelegate>)delegate
{
	if(singletonJREngage)
		return singletonJREngage;
	
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

- (void)addDelegate:(id<JREngageDelegate>)delegate
{
    // TODO: Implement me!
}

- (void)removeDelegate:(id<JREngageDelegate>)delegate
{
    // TODO: Implement me!    
}

//- (void)showJRAuthenticateDialog
//{
//    DLog(@"");
//    
//    /* If there was error configuring the library, sessionData.error will not be null. */
//    if (sessionData.error)
//    {
//        /* If there was an error, send a message to the delegates, release the error, then attemp to restart the 
//         configuration.  If, for example, the error was temporary (network issues, etc.) reattempting to configure the 
//         librabry could end successfully.  Since configuration may happen before the user attempts to use the library, 
//         if the user attempts to use the library at all, we only try to reconfigure when the library is needed. */
//        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
//        {
//            // TODO: This should really be changed to configurationDidFailWithError, as it could happen for auth and publishing.
//            [self authenticationDidFailWithError:[sessionData.error retain] forProvider:nil];
//            [sessionData reconfigure];
//            [sessionData.error release];
//            return;
//        }
//    }
//    
//    [interfaceMaestro showAuthenticationDialog];
//}

- (void)showAuthenticationDialog
{
    DLog(@"");
    
    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {
        /* If there was an error, send a message to the delegates, release the error, then attemp to restart the 
         configuration.  If, for example, the error was temporary (network issues, etc.) reattempting to configure the 
         librabry could end successfully.  Since configuration may happen before the user attempts to use the library, 
         if the user attempts to use the library at all, we only try to reconfigure when the library is needed. */
        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData reconfigure];
            [sessionData.error release];
            return;
        }
    }
    
    [interfaceMaestro showAuthenticationDialog];
}

- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity
{
    DLog(@"");
    
    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {
        /* If there was an error, send a message to the delegates, release the error, then attemp to restart the 
         configuration.  If, for example, the error was temporary (network issues, etc.) reattempting to configure the 
         librabry could end successfully.  Since configuration may happen before the user attempts to use the library, 
         if the user attempts to use the library at all, we only try to reconfigure when the library is needed. */
        if ([[[sessionData.error userInfo] objectForKey:@"severity"] isEqualToString:JRErrorSeverityConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData reconfigure];
            [sessionData.error release];
            return;
        }
    }
    
	[sessionData setActivity:activity];
    
    [interfaceMaestro showPublishingDialogWithActivity];
}

//- (void)unloadModalViewControllerWithTransitionStyle:(UIModalTransitionStyle)style
//{
//	DLog(@"");
//    [jrModalNavController dismissModalNavigationController:style];   
//  	[jrModalNavController release];
//	jrModalNavController = nil;	    
//}

- (void)authenticationDidRestart
{
    [interfaceMaestro authenticationRestarted];
}

- (void)engageDidFailWithError:(NSError*)error
{
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrEngageDialogDidFailToShowWithError:error];
	}
    
	[interfaceMaestro authenticationFailed];
}

- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider
{
	DLog(@"");
    DLog(@"token: %@", token);
	
	for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticationReceivedAuthenticationTokenForProvider:provider];
	}
    
	[interfaceMaestro authenticationCompleted];
}

- (void)authenticateDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider
{
    DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationDidReachTokenUrl:tokenUrl withPayload:tokenUrlPayload forProvider:provider];
    }    
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
	DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticationDidFailWithError:error forProvider:provider];
	}
    
	[interfaceMaestro authenticationFailed];
}


- (void)authenticateCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationCallToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
    }
}

- (void)authenticationDidCancel
{
	DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticationDidNotComplete];
	}
    
    [interfaceMaestro authenticationCanceled];
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

- (void)publishingDidRestart
{
    [interfaceMaestro publishingRestarted];
}

- (void)publishingDidCancel 
{ 
	DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrSocialDidNotCompletePublishing];
	}
    
	[interfaceMaestro publishingCanceled];
}

- (void)publishingDidComplete
{
	DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrSocialDidCompletePublishing];
	}
    
    [interfaceMaestro publishingCompleted];
}

- (void)publishingDidFailWithError:(NSError*)error forProvider:(NSString*)provider { DLog(@""); }
- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error { }

- (void)cancelAuthentication
{	
	DLog(@"");
    
	for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticationDidNotComplete];
	}
    
    [interfaceMaestro authenticationCanceled];
}

- (void)cancelPublishing
{
    // TODO: Implement me!
}

- (void)cancelAuthenticationWithError:(NSError*)error
{
	DLog(@"");
    
	for (id<JREngageDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticationDidFailWithError:error forProvider:nil];
	}	
    
	[interfaceMaestro authenticationCanceled];
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

- (void)updateTokenUrl:(NSString*)newTokenUrl
{
    // TODO: Implement me!
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

- (void)setCustomNavigationController:(UINavigationController*)navigationController
{
    [interfaceMaestro pushToCustomNavigationController:navigationController];
}

- (void)setCustomNavigationControllerShouldPopToViewController:(UIViewController*)viewController
{
    //    [interfaceMaestro popCustomNavigationControllerToViewController:viewController];
}

// TODO: What are the pros/cons of making this class pseudo-singleton?  That is, what if I make it a singleton
// object after it's instantiated with the correct baseUrl/tokenUrl/etc., but give users the ability to dealloc
// it if they want to free up the memory.  If freed, all subsequent messages will just be sent to a nil instance
// until reinstantiated.
- (void)dealloc 
{
	DLog(@"");
    
	if (singletonJREngage == self)
		singletonJREngage = nil;
    
	[delegates release];
    
	[super dealloc];
}

@end
