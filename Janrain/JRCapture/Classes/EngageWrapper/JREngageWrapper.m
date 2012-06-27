


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JREngageWrapper.h"
#import "JRNativeSigninViewController.h"
#import "JREngage+CustomInterface.h"

@interface JREngageWrapper ()
@property (retain) id<JRCaptureAuthenticationDelegate> authenticationDelegate;
@property (retain) id<JRCaptureSocialSharingDelegate>  socialSharingDelegate;
@end

@implementation JREngageWrapper
@synthesize authenticationDelegate;
@synthesize socialSharingDelegate;

static JREngageWrapper *singleton = nil;

- (JREngageWrapper *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)singletonInstance
{
    if (singleton == nil) {
        singleton = [((JREngageWrapper*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singletonInstance] retain];
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

+ (void)configureEngageWithCaptureMobileEndpointUrlAndAppId:(NSString *)appId
{
    [JREngage setEngageAppId:appId tokenUrl:[JRCaptureData captureMobileEndpointUrl] andDelegate:self];
}

+ (void)startAuthenticationDialogWithNativeSignin:(JRNativeSigninState)nativeSigninState
                      andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                      forDelegate:(id <JRCaptureAuthenticationDelegate>)delegate
{
    [[JREngageWrapper singletonInstance] setAuthenticationDelegate:delegate];


    NSMutableDictionary *expandedCustomInterfaceOverrides =
                                [NSMutableDictionary dictionaryWithDictionary:customInterfaceOverrides];

//    switch (nativeSigninState)
//    {
//        case JRNativeSigninUsernamePassword:
//        case JRNativeSigninEmailPassword:

            JRNativeSigninViewController *nativeSigninViewController =
                                                 [[[JRNativeSigninViewController alloc] init] autorelease];

//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            {
//                UINavigationController *navigationController = [[[UINavigationController alloc] init] autorelease];
//                navigationController.navigationBar.barStyle = UIBarStyleBlack;
//            }

            [expandedCustomInterfaceOverrides setObject:nativeSigninViewController.view forKey:kJRProviderTableHeaderView];

//            moreCustomizations = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                        embeddedTable.view, kJRProviderTableHeaderView,
//                                        @"Sign in with a social provider", kJRProviderTableSectionHeaderTitleString,
//                                        navigationController, ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
//                                                   kJRCustomModalNavigationController : kJRApplicationNavigationController),
//                                        nil] autorelease];

//            break;
//        default:
//            break;
//    }

    [JREngage showAuthenticationDialogWithCustomInterfaceOverrides:
                      [NSDictionary dictionaryWithDictionary:expandedCustomInterfaceOverrides]];
}

+ (void)startAuthenticationDialogOnProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                forDelegate:(id <JRCaptureAuthenticationDelegate>)delegate
{
    [[JREngageWrapper singletonInstance] setAuthenticationDelegate:delegate];
    [JREngage showAuthenticationDialogForProvider:provider withCustomInterfaceOverrides:customInterfaceOverrides];
}

+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject *)activity
                   withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                    forDelegate:(id <JRCaptureSocialSharingDelegate>)delegate
{
    [[JREngageWrapper singletonInstance] setSocialSharingDelegate:delegate];
    [JREngage showSocialPublishingDialogWithActivity:activity withCustomInterfaceOverrides:customInterfaceOverrides];
}


- (void)jrAuthenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error forProvider:(NSString *)provider
{

}

- (void)jrAuthenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{

}

- (void)jrAuthenticationDidNotComplete
{

}

- (void)jrAuthenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
{

}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary *)auth_info forProvider:(NSString *)provider
{

}

- (void)jrEngageDialogDidFailToShowWithError:(NSError *)error
{

}

- (void)jrSocialDidCompletePublishing
{

}

- (void)jrSocialDidNotCompletePublishing
{

}

- (void)jrSocialDidPublishActivity:(JRActivityObject *)activity forProvider:(NSString *)provider
{

}

- (void)jrSocialPublishingActivity:(JRActivityObject *)activity didFailWithError:(NSError *)error forProvider:(NSString *)provider
{

}

- (void)dealloc
{
    [socialSharingDelegate release];
    [authenticationDelegate release];
    [super dealloc];
}

@end
