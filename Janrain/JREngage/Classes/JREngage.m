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

 File:   JRAuthenticate.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JREngage.h"
#import "JRSessionData.h"
#import "JRUserInterfaceMaestro.h"
#import "JREngageError.h"


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface JREngageError (JREngageError_setError)
+ (NSError*)setError:(NSString*)message withCode:(NSInteger)code;
@end

@interface JREngage () <JRSessionDelegate>
@property (nonatomic, retain) JRUserInterfaceMaestro *interfaceMaestro; /*< \internal Class that handles customizations to the library's UI */
@property (nonatomic, retain) JRSessionData          *sessionData;      /*< \internal Holds configuration and state for the JREngage library */
@property (nonatomic, retain) NSMutableArray         *delegates;        /*< \internal Array of JREngageDelegate objects */
@end

@implementation JREngage
@synthesize interfaceMaestro;
@synthesize sessionData;
@synthesize delegates;

static JREngage* singleton = nil;

- (id)init
{
    if ((self = [super init]))
    {
    }

    return self;
}

+ (JREngage *)singletonInstance
{
    if (singleton == nil) {
        singleton = [((JREngage*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (JREngage*)jrEngage
{
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singletonInstance] retain];
}

- (void)setEngageAppID:(NSString*)appId tokenUrl:(NSString*)tokenUrl andDelegate:(id<JREngageSigninDelegate>)delegate
{
    ALog (@"Initialize JREngage library with appID: %@, and tokenUrl: %@", appId, tokenUrl);

    if (!delegates)
        self.delegates = [NSMutableArray arrayWithObjects:delegate, nil];
    else
        [delegates addObject:delegate];

    if (!sessionData)
        self.sessionData = [JRSessionData jrSessionDataWithAppId:appId tokenUrl:tokenUrl andDelegate:self];
    else
        [sessionData reconfigureWithAppId:appId tokenUrl:tokenUrl];

    if (!interfaceMaestro)
        interfaceMaestro = [JRUserInterfaceMaestro jrUserInterfaceMaestroWithSessionData:sessionData];
}

+ (void)setEngageAppId:(NSString*)appId tokenUrl:(NSString*)tokenUrl andDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] setEngageAppID:appId tokenUrl:tokenUrl andDelegate:delegate];
}

- (id)reconfigureWithAppID:(NSString*)appId andTokenUrl:(NSString*)tokenUrl delegate:(id<JREngageSigninDelegate>)delegate
{
    [delegates removeAllObjects];
    [delegates addObject:delegate];

    [sessionData reconfigureWithAppId:appId tokenUrl:tokenUrl];

    return self;
}

// TODO: Should we fail right away if appId is null?
- (id)initWithAppID:(NSString*)appId andTokenUrl:(NSString*)tokenUrl delegate:(id<JREngageSigninDelegate>)delegate
{
    ALog (@"Initialize JREngage library with appID: %@, and tokenUrl: %@", appId, tokenUrl);

    if ((self = [super init]))
    {
        singleton = self;

        self.delegates = [NSMutableArray arrayWithObjects:delegate, nil];

        sessionData = [JRSessionData jrSessionDataWithAppId:appId tokenUrl:tokenUrl andDelegate:self];
        interfaceMaestro = [JRUserInterfaceMaestro jrUserInterfaceMaestroWithSessionData:sessionData];
    }

    return self;
}

+ (id)jrEngageWithAppId:(NSString*)appId andTokenUrl:(NSString*)tokenUrl delegate:(id<JREngageSigninDelegate>)delegate
{
    if (appId == nil || appId.length == 0)
        return nil;

    if (singleton)
        return [singleton reconfigureWithAppID:appId andTokenUrl:tokenUrl delegate:delegate];

    return [[((JREngage *)[super allocWithZone:nil]) /* autoreleasing to stop IDE warnings; does nothing for singleton objects. */
             initWithAppID:appId andTokenUrl:tokenUrl delegate:delegate] autorelease];
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
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

- (void)addDelegate:(id<JREngageSigninDelegate>)delegate
{
    if (![delegates containsObject:delegate])
        [delegates addObject:delegate];
}

+ (void)addDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] addDelegate:delegate];
}

- (void)removeDelegate:(id<JREngageSigninDelegate>)delegate
{
    [delegates removeObject:delegate];
}

+ (void)removeDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] removeDelegate:delegate];
}

- (void)engageDidFailWithError:(NSError*)error
{
    ALog (@"JREngage failed to load with error: %@", [error localizedDescription]);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(engageDialogDidFailToShowWithError:)])
            [delegate engageDialogDidFailToShowWithError:error];
    }
}

//- (void)showAuthenticationDialogWithForcedReauthenticationOnLastUsedProvider
//{
//    ALog (@"");
//
//    /* If there was error configuring the library, sessionData.error will not be null. */
//    if (sessionData.error)
//    {
//
//        /* Since configuration should happen long before the user attempts to use the library and because the user may not
//         attempt to use the library at all, we shouldn’t notify the calling application of the error until the library
//         is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues),
//         a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the
//         user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).
//         This gives the calling application an ad hoc way to reconfigure the library, and doesn’t waste the limited
//         resources by trying to reconfigure itself if it doesn’t know if it’s actually needed. */
//
//        if (sessionData.error.code / 100 == ConfigurationError)//[[[sessionData.error userInfo] objectForKey:@"type"] isEqualToString:JRErrorTypeConfigurationFailed])
//        {
//            [self engageDidFailWithError:sessionData.error];
//            [sessionData tryToReconfigureLibrary];
//
//            return;
//        }
//    }
//
//    [interfaceMaestro showAuthenticationDialogWithForcedReauth];
//}

- (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                          orAuthenticatingOnJustThisProvider:(NSString*)provider
{
    ALog (@"");

    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {

        /* Since configuration should happen long before the user attempts to use the library and because the user may not
         attempt to use the library at all, we shouldn't notify the calling application of the error until the library
         is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues),
         a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the
         user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).
         This gives the calling application an ad hoc way to reconfigure the library, and doesn't waste the limited
         resources by trying to reconfigure itself if it doesn't know if it’s actually needed. */

        if (sessionData.error.code / 100 == ConfigurationError)
        {
            [self engageDidFailWithError:[[sessionData.error copy] autorelease]];
            [sessionData tryToReconfigureLibrary];

            return;
        }
        else
        {   // TODO: The session data error doesn't get reset here.  When will this happen and what will be the expected behavior?
            [self engageDidFailWithError:[[sessionData.error copy] autorelease]];
            return;
        }
    }

    if (sessionData.dialogIsShowing)
    {
        [self engageDidFailWithError:
              [JREngageError setError:@"The dialog failed to show because there is already a JREngage dialog loaded."
                             withCode:JRDialogShowingError]];
        return;
    }

    if (provider && ![sessionData.allProviders objectForKey:provider])
    {
        [self engageDidFailWithError:
              [JREngageError setError:@"You tried to authenticate on a specific provider, but this provider has not yet been configured."
                             withCode:JRProviderNotConfiguredError]];
        return;
    }

    if (provider)
        interfaceMaestro.directProvider = provider;

//  [sessionData setSkipReturningUserLandingPage:skipReturningUserLandingPage];
    [interfaceMaestro showAuthenticationDialogWithCustomInterface:customInterfaceOverrides];
}

- (void)showAuthenticationDialogForProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
{
    [self showAuthenticationDialogWithCustomInterfaceOverrides:customInterfaceOverrides /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:provider];
}

+ (void)showAuthenticationDialogForProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
{
    [[JREngage singletonInstance] showAuthenticationDialogWithCustomInterfaceOverrides:customInterfaceOverrides /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:provider];
}

- (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
{
    [self showAuthenticationDialogWithCustomInterfaceOverrides:customInterfaceOverrides /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:nil];
}

+ (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
{
    [[JREngage singletonInstance] showAuthenticationDialogWithCustomInterfaceOverrides:customInterfaceOverrides /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:nil];
}

- (void)showAuthenticationDialogForProvider:(NSString*)provider
{
    [self showAuthenticationDialogWithCustomInterfaceOverrides:nil                      /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:provider];
}

+ (void)showAuthenticationDialogForProvider:(NSString*)provider
{
    [[JREngage singletonInstance] showAuthenticationDialogWithCustomInterfaceOverrides:nil                      /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:provider];
}

- (void)showAuthenticationDialog
{
    [self showAuthenticationDialogWithCustomInterfaceOverrides:nil                      /*skippingReturningUserLandingPage:NO*/
                            orAuthenticatingOnJustThisProvider:nil];
}

+ (void)showAuthenticationDialog
{
    [[JREngage singletonInstance] showAuthenticationDialogWithCustomInterfaceOverrides:nil                      /*skippingReturningUserLandingPage:NO*/
                                                    orAuthenticatingOnJustThisProvider:nil];
}

//- (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
//                            skippingReturningUserLandingPage:(BOOL)skipReturningUserLandingPage
//{
//    [[JREngage singletonInstance] showAuthenticationDialogWithCustomInterfaceOverrides:customInterfaceOverrides
//                                                      skippingReturningUserLandingPage:skipReturningUserLandingPage
//                                                    orAuthenticatingOnJustThisProvider:nil];
//}

//+ (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
//                            skippingReturningUserLandingPage:(BOOL)skipReturningUserLandingPage
//{
//    [self showAuthenticationDialogWithCustomInterfaceOverrides:customInterfaceOverrides
//                              skippingReturningUserLandingPage:skipReturningUserLandingPage
//                            orAuthenticatingOnJustThisProvider:nil];
//}

//- (void)showAuthenticationDialogSkippingReturningUserLandingPage:(BOOL)skipReturningUserLandingPage
//{
//    [self showAuthenticationDialogWithCustomInterfaceOverrides:nil
//                              skippingReturningUserLandingPage:skipReturningUserLandingPage
//                            orAuthenticatingOnJustThisProvider:nil];
//}

//+ (void)showAuthenticationDialogSkippingReturningUserLandingPage:(BOOL)skipReturningUserLandingPage
//{
//    [[JREngage singletonInstance] showAuthenticationDialogWithCustomInterfaceOverrides:nil
//                                                      skippingReturningUserLandingPage:skipReturningUserLandingPage
//                                                    orAuthenticatingOnJustThisProvider:nil];
//}

- (void)showSharingDialogWithActivity:(JRActivityObject*)activity withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
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

        if (sessionData.error.code / 100 == ConfigurationError)
        {
            [self engageDidFailWithError:[[sessionData.error copy] autorelease]];
            [sessionData tryToReconfigureLibrary];

            return;
        }
        else
        {
            [self engageDidFailWithError:[[sessionData.error copy] autorelease]];
            return;
        }
    }

    if (sessionData.dialogIsShowing)
    {
        [self engageDidFailWithError:
              [JREngageError setError:@"The dialog failed to show because there is already a JREngage dialog loaded."
                             withCode:JRDialogShowingError]];
        return;
    }

    if (!activity)
    {
        [self engageDidFailWithError:
              [JREngageError setError:@"Activity object can't be nil."
                             withCode:JRPublishErrorActivityNil]];
        return;
    }

    [sessionData setActivity:activity];
    [interfaceMaestro showPublishingDialogForActivityWithCustomInterface:customInterfaceOverrides];
}

- (void)showSocialPublishingDialogWithActivity:(JRActivityObject*)activity andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
{
    [self showSharingDialogWithActivity:activity withCustomInterfaceOverrides:customInterfaceOverrides];
}

+ (void)showSharingDialogWithActivity:(JRActivityObject*)activity withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
{
    [[JREngage singletonInstance] showSharingDialogWithActivity:activity withCustomInterfaceOverrides:customInterfaceOverrides];
}

- (void)showSharingDialogWithActivity:(JRActivityObject*)activity
{
    [self showSharingDialogWithActivity:activity withCustomInterfaceOverrides:nil];
}

+ (void)showSharingDialogWithActivity:(JRActivityObject*)activity
{
    [[JREngage singletonInstance] showSharingDialogWithActivity:activity withCustomInterfaceOverrides:nil];
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
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidNotComplete)])
            [delegate authenticationDidNotComplete];
    }

    [interfaceMaestro authenticationCanceled];
}

- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider
{
    ALog (@"Signing complete for %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidSucceedForUser:forProvider:)])
            [delegate authenticationDidSucceedForUser:profile forProvider:provider];
    }

    [interfaceMaestro authenticationCompleted];
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    ALog (@"Signing failed for %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidFailWithError:forProvider:)])
            [delegate authenticationDidFailWithError:error forProvider:provider];
    }

    [interfaceMaestro authenticationFailed];
}

- (void)authenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;
{
    ALog (@"Token URL reached for %@: %@", provider, tokenUrl);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:)])
            [delegate authenticationDidReachTokenUrl:tokenUrl withResponse:response andPayload:tokenUrlPayload forProvider:provider];
    }
}

- (void)authenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    ALog (@"Token URL failed for %@: %@", provider, tokenUrl);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
            [delegate authenticationCallToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
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
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidNotComplete)])
            [delegate sharingDidNotComplete];
    }

    [interfaceMaestro publishingCanceled];
}

- (void)publishingDidComplete
{
    DLog(@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidComplete)])
            [delegate sharingDidComplete];
    }

    [interfaceMaestro publishingCompleted];
}

- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider
{
    ALog (@"Activity shared on %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidSucceedForActivity:forProvider:)])
            [delegate sharingDidSucceedForActivity:activity forProvider:provider];
    }
}

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    ALog (@"Sharing activity failed for %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidFailForActivity:withError:forProvider:)])
            [delegate sharingDidFailForActivity:activity withError:error forProvider:provider];
    }
}

- (void)clearSharingCredentialsForProvider:(NSString*)provider
{
    DLog(@"");
    [sessionData forgetAuthenticatedUserForProvider:provider];
}

+ (void)clearSharingCredentialsForProvider:(NSString*)provider
{
    [[JREngage singletonInstance] clearSharingCredentialsForProvider:provider];
}

- (void)clearSharingCredentialsForAllProviders
{
    DLog(@"");
    [sessionData forgetAllAuthenticatedUsers];
}

+ (void)clearSharingCredentialsForAllProviders
{
    [[JREngage singletonInstance] clearSharingCredentialsForAllProviders];
}

- (void)alwaysForceReauthentication:(BOOL)force
{
    [sessionData setAlwaysForceReauth:force];
}

+ (void)alwaysForceReauthentication:(BOOL)force
{
    [[JREngage singletonInstance] alwaysForceReauthentication:force];
}

- (void)cancelAuthentication
{
    DLog(@"");
    [sessionData triggerAuthenticationDidCancel];
}

+ (void)cancelAuthentication
{
    [[JREngage singletonInstance] cancelAuthentication];
}

- (void)cancelSharing
{
    DLog(@"");
    [sessionData triggerPublishingDidCancel];
}

+ (void)cancelSharing
{
    [[JREngage singletonInstance] cancelSharing];
}

- (void)updateTokenUrl:(NSString*)newTokenUrl
{
    DLog(@"");
    [sessionData setTokenUrl:newTokenUrl];
}

+ (void)updateTokenUrl:(NSString*)newTokenUrl
{
    [[JREngage singletonInstance] updateTokenUrl:newTokenUrl];
}

- (void)setCustomInterfaceDefaults:(NSMutableDictionary*)customInterfaceDefaults
{
    [interfaceMaestro setCustomInterfaceDefaults:customInterfaceDefaults];
}

+ (void)setCustomInterfaceDefaults:(NSMutableDictionary*)customInterfaceDefaults
{
    [[JREngage singletonInstance] setCustomInterfaceDefaults:customInterfaceDefaults];
}
@end
