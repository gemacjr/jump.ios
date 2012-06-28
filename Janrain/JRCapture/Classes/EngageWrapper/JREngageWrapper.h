#import "JRCapture.h"
#import "JREngage.h"

//@class JRActivityObject;
//@protocol JREngageDelegate;
@interface JREngageWrapper : NSObject <JREngageDelegate>
+ (void)configureEngageWithCaptureMobileEndpointUrlAndAppId:(NSString *)appId;

+ (void)startAuthenticationDialogWithNativeSignin:(JRNativeSigninState)nativeSigninState
                      andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                      forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

+ (void)startAuthenticationDialogOnProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject*)activity
                   withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;
@end
