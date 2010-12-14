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
    ALog (@"Initialize JREngage library with appID: %@, and tokenUrl: %@", appId, tokenUrl);
    
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

- (void)engageDidFailWithError:(NSError*)error
{
    ALog (@"JREngage failed to load with error: %@", [error localizedDescription]);
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrEngageDialogDidFailToShowWithError:)])
            [delegate jrEngageDialogDidFailToShowWithError:error];
	}
}

- (void)showAuthenticationDialogWithForcedReauthenticationOnLastUsedProvider
{
    ALog (@"");
    
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
        
        if (sessionData.error.code / 100 == ConfigurationError)//[[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData tryToReconfigureLibrary];
            
            return;
        }
    }
    
    [interfaceMaestro showAuthenticationDialogWithForcedReauth];    
}


- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations
{
    ALog (@"");
    
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

        if (sessionData.error.code / 100 == ConfigurationError)//[[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData tryToReconfigureLibrary];
            
            return;
        }
    }
    
    [interfaceMaestro showAuthenticationDialogWithCustomInterface:customizations];
}

- (void)showAuthenticationDialog
{
    [self showAuthenticationDialogWithCustomInterface:nil];
}

- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity andCustomInterface:(NSDictionary*)customizations
{
    ALog (@"");
    
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
        
        if (sessionData.error.code / 100 == ConfigurationError)//[[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
        {
            [self engageDidFailWithError:sessionData.error];
            [sessionData tryToReconfigureLibrary];
            
            return;
        }
    }
    
    if (!activity)
    {
        [self engageDidFailWithError:[JRError setError:@"Activity object can't be nil" 
                                              withCode:JRPublishErrorAcivityNil]]; 
                                            //andType:JRErrorTypePublishFailed]];
    }
    
	[sessionData setActivity:activity];
    
    [interfaceMaestro showPublishingDialogForActivityWithCustomInterface:customizations];    
}

- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity
{
    [self showSocialPublishingDialogWithActivity:activity andCustomInterface:nil];
}

- (void)authenticationDidRestart
{
    DLog (@"");
    [interfaceMaestro authenticationRestarted];
}

- (void)authenticationDidCancel
{
	DLog (@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
        if ([delegate respondsToSelector:@selector(jrAuthenticationDidNotComplete)])
            [delegate jrAuthenticationDidNotComplete];
	}
    
    [interfaceMaestro authenticationCanceled];
}

- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider
{
    ALog (@"Signing complete for %@", provider);
    
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
	ALog (@"Signing failed for %@", provider);
    
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
    ALog (@"Token URL reached for %@: %@", provider, tokenUrl);
    
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
    ALog (@"Token URL failed for %@: %@", provider, tokenUrl);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(jrAuthenticationCallToTokenUrl:didFailWithError:forProvider:)])
            [delegate jrAuthenticationCallToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
    }
}

- (void)publishingDidRestart
{
    DLog (@"");
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
    ALog (@"Activity shared on %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageDelegate> delegate in delegatesCopy) 
	{
		if ([delegate respondsToSelector:@selector(jrSocialDidPublishActivity:forProvider:)])
            [delegate jrSocialDidPublishActivity:activity forProvider:provider];
	}
}

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    ALog (@"Sharing activity failed for %@", provider);
    
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

- (void)setCustomInterface:(NSDictionary*)customizations
{
    [interfaceMaestro setCustomViews:customizations];
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
    DLog(@"");
    [sessionData triggerAuthenticationDidCancel];
}

- (void)cancelPublishing
{
    DLog(@"");
    [sessionData triggerPublishingDidCancel];
}

- (void)updateTokenUrl:(NSString*)newTokenUrl
{
    DLog(@"");
    [sessionData setTokenUrl:newTokenUrl];
}
@end