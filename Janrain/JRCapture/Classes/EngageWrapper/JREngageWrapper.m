


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRNativeSigninViewController.h"
#import "JREngage.h"
#import "JREngage+CustomInterface.h"

#import "JRCaptureUser.h"
#import "JRCaptureData.h"

#import "JREngageWrapper.h"
#import "JRCaptureUser+Extras.h"

@interface JREngageWrapperErrorWriter : NSObject
@end

@implementation JREngageWrapperErrorWriter
+ (NSError *)invalidPayloadError:(NSObject *)payload
{
    return [JRCaptureError errorFromResult:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"error", @"stat",
                                                     @"invalid_endpoint_response", @"error",
                                                     [NSString stringWithFormat:@"The Capture Mobile Endpoint Url did not have the expected data: %@", [payload description]], @"error_description",
                                                     [NSNumber numberWithInteger:JRCaptureWrappedEngageErrorInvalidEndpointPayload], @"code", nil]];
}
@end

typedef enum
{
    JREngageDialogStateAuthentication,
    JREngageDialogStateSharing,
} JREngageDialogState;


@interface JREngageWrapper ()
@property (retain) id<JRCaptureAuthenticationDelegate> delegate;
@property          JREngageDialogState dialogState;
//@property (retain) id<JRCaptureAuthenticationDelegate> authenticationDelegate;
//@property (retain) id<JRCaptureSocialSharingDelegate>  socialSharingDelegate;
@end

@implementation JREngageWrapper
@synthesize delegate;
@synthesize dialogState;
//@synthesize authenticationDelegate;
//@synthesize socialSharingDelegate;

static JREngageWrapper *singleton = nil;

- (JREngageWrapper *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (JREngageWrapper *)singletonInstance
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
    [JREngage setEngageAppId:appId tokenUrl:[JRCaptureData captureMobileEndpointUrl] andDelegate:[JREngageWrapper singletonInstance]];
}

+ (void)startAuthenticationDialogWithNativeSignin:(JRNativeSigninState)nativeSigninState
                      andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                      forDelegate:(id <JRCaptureAuthenticationDelegate>)delegate
{
    [[JREngageWrapper singletonInstance] setDelegate:delegate];
    [[JREngageWrapper singletonInstance] setDialogState:JREngageDialogStateAuthentication];

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
    [[JREngageWrapper singletonInstance] setDelegate:delegate];
    [[JREngageWrapper singletonInstance] setDialogState:JREngageDialogStateAuthentication];

    [JREngage showAuthenticationDialogForProvider:provider withCustomInterfaceOverrides:customInterfaceOverrides];
}

+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject *)activity
                   withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                    forDelegate:(id <JRCaptureSocialSharingDelegate>)delegate
{
    [[JREngageWrapper singletonInstance] setDelegate:delegate];
    [[JREngageWrapper singletonInstance] setDialogState:JREngageDialogStateSharing];

    [JREngage showSocialPublishingDialogWithActivity:activity withCustomInterfaceOverrides:customInterfaceOverrides];
}


- (void)jrAuthenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    if ([delegate respondsToSelector:@selector(captureAuthenticationDidFailWithError:)])
        [delegate captureAuthenticationDidFailWithError:error];
}

- (void)jrAuthenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    if ([delegate respondsToSelector:@selector(engageAuthenticationDidFailWithError:forProvider:)])
        [delegate engageAuthenticationDidFailWithError:error forProvider:provider];
}

- (void)jrAuthenticationDidNotComplete
{
    if ([delegate respondsToSelector:@selector(engageAuthenticationDidNotComplete)])
        [delegate engageAuthenticationDidNotComplete];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
{
    NSString     *payload     = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *payloadDict = [payload objectFromJSONString];

    if (!payloadDict)
        return [self jrAuthenticationCallToTokenUrl:tokenUrl
                                   didFailWithError:[JREngageWrapperErrorWriter invalidPayloadError:payload]
                                        forProvider:provider];

    if (![(NSString *)[payloadDict objectForKey:@"stat"] isEqualToString:@"ok"])
        return [self jrAuthenticationCallToTokenUrl:tokenUrl
                                   didFailWithError:[JREngageWrapperErrorWriter invalidPayloadError:payload]
                                        forProvider:provider];

    NSString *accessToken   = [payloadDict objectForKey:@"access_token"];
    NSString *creationToken = [payloadDict objectForKey:@"creation_token"];
    BOOL      isNew         = [(NSNumber*)[payloadDict objectForKey:@"is_new"] boolValue];
    BOOL      notYetCreated = creationToken ? YES: NO;

    NSDictionary *captureProfile = [payloadDict objectForKey:@"capture_user"];

    if (!captureProfile || !(accessToken || creationToken))
        return [self jrAuthenticationCallToTokenUrl:tokenUrl
                                   didFailWithError:[JREngageWrapperErrorWriter invalidPayloadError:payload]
                                        forProvider:provider];

    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    if (!captureUser)
        return [self jrAuthenticationCallToTokenUrl:tokenUrl
                                   didFailWithError:[JREngageWrapperErrorWriter invalidPayloadError:payload]
                                        forProvider:provider];

    NSString *uuid = [captureUser performSelector:NSSelectorFromString(@"uuid")];

    [JRCaptureData setAccessToken:accessToken forUser:uuid];
    [JRCaptureData setCreationToken:creationToken];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    JRCaptureRecordStatus recordStatus;

    if (notYetCreated)
        recordStatus = JRCaptureRecordMissingRequiredFields;
    else if (isNew)
        recordStatus = JRCaptureRecordNewlyCreated;
    else
        recordStatus = JRCaptureRecordExists;

    if ([delegate respondsToSelector:@selector(captureAuthenticationDidSucceedForUser:withToken:andStatus:)])
        [delegate captureAuthenticationDidSucceedForUser:captureUser
                                                             withToken:(recordStatus == JRCaptureRecordMissingRequiredFields ? creationToken : accessToken)
                                                             andStatus:recordStatus];
}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary *)authInfo forProvider:(NSString *)provider
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    if ([delegate respondsToSelector:@selector(engageAuthenticationDidSucceedForUser:forProvider:)])
            [delegate engageAuthenticationDidSucceedForUser:authInfo forProvider:provider];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError *)error
{
    if (dialogState == JREngageDialogStateAuthentication)
    {
        if ([delegate respondsToSelector:@selector(engageAuthenticationDialogDidFailToShowWithError:)])
            [delegate engageAuthenticationDialogDidFailToShowWithError:error];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(engageSocialSharingDialogDidFailToShowWithError:)])
            [(id<JRCaptureSocialSharingDelegate>)delegate engageSocialSharingDialogDidFailToShowWithError:error];
    }
}

- (void)jrSocialDidCompletePublishing
{
    if ([delegate respondsToSelector:@selector(engageSocialSharingDidComplete)])
        [(id<JRCaptureSocialSharingDelegate>)delegate engageSocialSharingDidComplete];
}

- (void)jrSocialDidNotCompletePublishing
{
    if ([delegate respondsToSelector:@selector(engageSocialSharingDidNotComplete)])
        [(id<JRCaptureSocialSharingDelegate>)delegate engageSocialSharingDidNotComplete];
}

- (void)jrSocialDidPublishActivity:(JRActivityObject *)activity forProvider:(NSString *)provider
{
    if ([delegate respondsToSelector:@selector(engageSocialSharingDidSucceedForActivity:onProvider:)])
        [(id<JRCaptureSocialSharingDelegate>)delegate engageSocialSharingDidSucceedForActivity:activity onProvider:provider];
}

- (void)jrSocialPublishingActivity:(JRActivityObject *)activity didFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    if ([delegate respondsToSelector:@selector(engageSocialSharingDidFailForActivity:withError:onProvider:)])
        [(id<JRCaptureSocialSharingDelegate>)delegate engageSocialSharingDidFailForActivity:activity withError:error onProvider:provider];
}

- (void)dealloc
{
    [delegate release];

    [super dealloc];
}
@end
