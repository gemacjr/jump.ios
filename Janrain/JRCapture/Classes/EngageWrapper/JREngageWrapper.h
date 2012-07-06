#import "JRCapture.h"
#import "JREngage.h"
#import "JRNativeSigninViewController.h"

@interface JREngageWrapper : NSObject <JREngageDelegate, JRNativeSigninViewControllerDelegate>
+ (void)configureEngageWithCaptureMobileEndpointUrlAndAppId:(NSString *)appId;

+ (void)startAuthenticationDialogWithNativeSignin:(JRNativeSigninType)nativeSigninType
                      andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                      forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

+ (void)startAuthenticationDialogOnProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                forDelegate:(id<JRCaptureAuthenticationDelegate>)delegate;

+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject*)activity
                   withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;
@end
