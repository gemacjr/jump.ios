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

// TODO: Check in on changing tokenUrl to serverAuthenticationUrl
- (JREngage*)initWithAppID:(NSString*)appId 
               andTokenUrl:(NSString*)tokenUrl 
                  delegate:(id<JREngageDelegate>)delegate
{
    // TODO: Fix all the DLogs and ALogs
	DLog(@"");
    DLog(@"appID:    %@", appId);
	DLog(@"tokenURL: %@", tokenUrl);
    
	if (self = [super init])
	{
		singletonJREngage = self;
		
		delegates = [[NSMutableArray alloc] initWithObjects:delegate, nil];
		
        sessionData = [JRSessionData jrSessionDataWithAppId:appId tokenUrl:tokenUrl andDelegate:self];
        interfaceMaestro = [JRUserInterfaceMaestro jrUserInterfaceMaestroWithSessionData:sessionData];
    }	
	
	return self;
}

+ (JREngage*)jrEngageWithAppId:(NSString*)appId 
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

- (void)engageDidFailWithError:(NSError*)error
{
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrEngageDialogDidFailToShowWithError:error];
	}
    
	[interfaceMaestro authenticationFailed];
}

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

- (void)authenticationDidRestart
{
    [interfaceMaestro authenticationRestarted];
}

- (void)authenticationDidCancel
{
	DLog(@"");

    // TODO: Copy delegate array after adding function bodies for addDelegate and removeDelegate
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrAuthenticationDidNotComplete];
	}
    
    [interfaceMaestro authenticationCanceled];
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

- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider
{
	for (id<JREngageDelegate> delegate in delegates) 
	{
        [delegate jrAuthenticationDidSucceedForUser:profile forProvider:provider];
	}
    
	[interfaceMaestro authenticationCompleted];
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

- (void)authenticateDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider
{
    DLog(@"");

    for (id<JREngageDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationDidReachTokenUrl:tokenUrl withPayload:tokenUrlPayload forProvider:provider];
    }    
}

- (void)authenticateCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    for (id<JREngageDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationCallToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
    }
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

- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider
{
    DLog(@"");
    
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrSocialDidPublishActivity:activity forProvider:provider];
	}
}

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    
    for (id<JREngageDelegate> delegate in delegates) 
	{
		[delegate jrSocialPublishingActivity:activity didFailWithError:error forProvider:provider];
	}    
}

//- (void)publishingActivityDidFail:(JRActivityObject*)activity forProvider:(NSString*)provider
//- (void)publishingDidFailWithError:(NSError*)error forProvider:(NSString*)provider { DLog(@""); }
//- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error { }

- (void)setCustomNavigationController:(UINavigationController*)navigationController
{
    [interfaceMaestro pushToCustomNavigationController:navigationController];
}

- (void)setCustomNavigationControllerShouldPopToViewController:(UIViewController*)viewController
{
    //    [interfaceMaestro popCustomNavigationControllerToViewController:viewController];
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

- (void)cancelAuthentication
{	
    [sessionData triggerAuthenticationDidCancel];
}

- (void)cancelPublishing
{
    [sessionData triggerPublishingDidCancel];
}

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


// TODO: What are the pros/cons of making this class pseudo-singleton?  That is, what if I make it a singleton
// object after it's instantiated with the correct baseUrl/tokenUrl/etc., but give users the ability to dealloc
// it if they want to free up the memory.  If freed, all subsequent messages will just be sent to a nil instance
// until reinstantiated.
// ANSWER: Minimal memory... should just use regular singleton paradigm
- (void)dealloc 
{
	DLog(@"");
    
	if (singletonJREngage == self)
		singletonJREngage = nil;
    
	[delegates release];
    
	[super dealloc];
}

@end
