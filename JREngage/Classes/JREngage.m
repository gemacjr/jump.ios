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
    [delegates addObject:delegate];
}

- (void)removeDelegate:(id<JREngageDelegate>)delegate
{
    [delegates removeObject:delegate];
}

- (NSError*)setError:(NSString*)message withCode:(NSInteger)code andType:(NSString*)type
{
    DLog(@"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, NSLocalizedDescriptionKey,
                              type, @"type", nil];
    
    return [[NSError alloc] initWithDomain:@"JREngage"
                                      code:code
                                  userInfo:userInfo];
}

- (void)engageDidFailWithError:(NSError*)error
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrEngageDialogDidFailToShowWithError:)])
            [delegate jrEngageDialogDidFailToShowWithError:error];
	}
    
//	[interfaceMaestro authenticationFailed];
}

- (void)showAuthenticationDialogWithCustomViews:(NSDictionary*)views// andDelegate:id<JREngageCustomInterfaceDelegate>delegate
{
    DLog(@"");
    
    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {
        
        /* Since configuration should happen long before the user attempts to use the library and because the user may not
         attempt to use the library at all, we shouldn’t notify the calling application of the error until the library 
         is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues), 
         a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the 
         user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).  
         This gives the calling application an ad hoc way to reconfigure the library, and doesn’t waste the limited 
         resources by trying to reconfigure itself if it doesn’t know if it’s actually needed. */
        
        if ([[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData tryToReconfigureLibrary];
            
            return;
        }
    }
    
    [interfaceMaestro showAuthenticationDialogWithCustomViews:views];// andDelegate:delegate];    
}

- (void)showAuthenticationDialog
{
//    DLog(@"");
//    
//    /* If there was error configuring the library, sessionData.error will not be null. */
//    if (sessionData.error)
//    {
//        
//     /* Since configuration should happen long before the user attempts to use the library and because the user may not
//        attempt to use the library at all, we shouldn’t notify the calling application of the error until the library 
//        is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues), 
//        a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the 
//        user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).  
//        This gives the calling application an ad hoc way to reconfigure the library, and doesn’t waste the limited 
//        resources by trying to reconfigure itself if it doesn’t know if it’s actually needed. */
//        
//        if ([[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
//        {
//            [self engageDidFailWithError:sessionData.error];
//            [sessionData tryToReconfigureLibrary];
//
//            return;
//        }
//    }
//    
//    [interfaceMaestro showAuthenticationDialog];
    [self showAuthenticationDialogWithCustomViews:nil];// andDelegate:nil];
}

- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity andCustomViews:(NSDictionary*)views
{
    DLog(@"");
    
    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {
        
        /* Since configuration should happen long before the user attempts to use the library and because the user may not
         attempt to use the library at all, we shouldn’t notify the calling application of the error until the library 
         is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues), 
         a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the 
         user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).  
         This gives the calling application an ad hoc way to reconfigure the library, and doesn’t waste the limited 
         resources by trying to reconfigure itself if it doesn’t know if it’s actually needed. */
        
        if ([[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData tryToReconfigureLibrary];
            
            return;
        }
    }
    
    if (!activity)
    {
        [self engageDidFailWithError:[self setError:@"Activity object can't be nil" 
                                           withCode:JRPublishErrorAcivityNil 
                                            andType:JRErrorTypePublishFailed]];
    }
    
	[sessionData setActivity:activity];
    
    [interfaceMaestro showPublishingDialogForActivityWithCustomViews:views];    
}

- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity
{
//    DLog(@"");
//    
//    /* If there was error configuring the library, sessionData.error will not be null. */
//    if (sessionData.error)
//    {
//        
//     /* Since configuration should happen long before the user attempts to use the library and because the user may not
//        attempt to use the library at all, we shouldn’t notify the calling application of the error until the library 
//        is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues), 
//        a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the 
//        user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).  
//        This gives the calling application an ad hoc way to reconfigure the library, and doesn’t waste the limited 
//        resources by trying to reconfigure itself if it doesn’t know if it’s actually needed. */
//        
//        if ([[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
//        {
//            [self engageDidFailWithError:sessionData.error];
//            [sessionData tryToReconfigureLibrary];
//
//            return;
//        }
//    }
//    
//    if (!activity)
//    {
//        [self engageDidFailWithError:[self setError:@"Activity object can't be nil" 
//                                           withCode:JRPublishErrorAcivityNil 
//                                            andType:JRErrorTypePublishFailed]];
//    }
//    
//	[sessionData setActivity:activity];
//
//    [interfaceMaestro showPublishingDialogForActivityWithCustomViews:nil];
    [self showSocialPublishingDialogWithActivity:activity andCustomViews:nil];
}

- (void)authenticationDidRestart
{
    [interfaceMaestro authenticationRestarted];
}

- (void)authenticationDidCancel
{
	DLog(@"");
    
    // TODO:Copy delegate array after adding function bodies for addDelegate and removeDelegate
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
        if ([delegate respondsToSelector:@selector(jrAuthenticationDidNotComplete)])
            [delegate jrAuthenticationDidNotComplete];
	}
    
    [interfaceMaestro authenticationCanceled];
}

//- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider
//{
//	DLog(@"");
//    DLog(@"token:%@", token);
//	
//    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
//    for (id<JREngageDelegate> delegate in delegatesCopy) 
//	{
//        if ([delegate respondsToSelector:@selector(jrAuthenticationReceivedAuthenticationTokenForProvider:)])
//            [delegate jrAuthenticationReceivedAuthenticationTokenForProvider:provider];
//	}
//    
//	[interfaceMaestro authenticationCompleted];
//}

- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
        if ([delegate respondsToSelector:@selector(jrAuthenticationDidSucceedForUser:forProvider:)])
            [delegate jrAuthenticationDidSucceedForUser:profile forProvider:provider];
	}
    
	[interfaceMaestro authenticationCompleted];
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
	DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
        if ([delegate respondsToSelector:@selector(jrAuthenticationDidFailWithError:forProvider:)])
            [delegate jrAuthenticationDidFailWithError:error forProvider:provider];
	}
    
	[interfaceMaestro authenticationFailed];
}

- (void)authenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;
{
    DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(jrAuthenticationDidReachTokenUrl:withPayload:forProvider:)])
            [delegate jrAuthenticationDidReachTokenUrl:tokenUrl withPayload:tokenUrlPayload forProvider:provider];
    
        if ([delegate respondsToSelector:@selector(jrAuthenticationDidReachTokenUrl:withResponse:andPayload:forProvider:)])
            [delegate jrAuthenticationDidReachTokenUrl:tokenUrl withResponse:response andPayload:tokenUrlPayload forProvider:provider];
    }    
}

- (void)authenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(jrAuthenticationCallToTokenUrl:didFailWithError:forProvider:)])
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
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrSocialDidNotCompletePublishing)])
            [delegate jrSocialDidNotCompletePublishing];
	}
    
	[interfaceMaestro publishingCanceled];
}

- (void)publishingDidComplete
{
	DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrSocialDidCompletePublishing)])
            [delegate jrSocialDidCompletePublishing];
	}
    
    [interfaceMaestro publishingCompleted];
}

- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider
{
    DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrSocialDidPublishActivity:forProvider:)])
            [delegate jrSocialDidPublishActivity:activity forProvider:provider];
	}
}

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrSocialPublishingActivity:didFailWithError:forProvider:)])
            [delegate jrSocialPublishingActivity:activity didFailWithError:error forProvider:provider];
	}    
}

- (void)setCustomNavigationController:(UINavigationController*)navigationController
{
    [interfaceMaestro pushToCustomNavigationController:navigationController];
}

- (void)setCustomViews:(NSDictionary*)views
{
    [interfaceMaestro setCustomViews:views];
}

// TODO:Figure out if we need the method setCustomNavigationControllerShouldPopToViewController
// and implement it if we do
- (void)setCustomNavigationControllerShouldPopToViewController:(UIViewController*)viewController
{
    //    [interfaceMaestro popCustomNavigationControllerToViewController:viewController];
}

- (NSDictionary*)getUserForProvider:(NSString*)provider
{
    return [[sessionData authenticatedUserForProviderNamed:provider] auth_info];
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

- (void)signoutUserForSocialProvider:(NSString*)provider
{
    DLog(@"");
    [sessionData forgetAuthenticatedUserForProvider:provider];
}

- (void)signoutUserForAllSocialProviders
{
    DLog(@"");
    [sessionData forgetAllAuthenticatedUsers];
}

- (void)alwaysForceReauthentication:(BOOL)force
{
    DLog(@"");
    [sessionData setAlwaysForceReauth:force];
}

- (void)cancelAuthentication
{	
    [sessionData triggerAuthenticationDidCancel];
}

- (void)cancelPublishing
{
    [sessionData triggerPublishingDidCancel];
}

// TODO:Rework token url flow and if we need makeCallToTokenUrl in engage API
//- (void)makeCallToTokenUrl:(NSString*)tokenUrl withToken:(NSString *)token
//{
//	DLog(@"");
//    DLog(@"token:   %@", token);
//	DLog(@"tokenURL:%@", tokenUrl);
//    
//	[sessionData makeCallToTokenUrl:tokenUrl withToken:token forProvider:nil];
//}

- (void)updateTokenUrl:(NSString*)newTokenUrl
{
    [sessionData setTokenUrl:newTokenUrl];
}
@end