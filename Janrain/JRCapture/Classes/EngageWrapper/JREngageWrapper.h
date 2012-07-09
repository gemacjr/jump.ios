#import "JRCapture.h"
#import "JREngage.h"
#import "JRNativeSigninViewController.h"

@interface JREngageWrapper : NSObject <JREngageDelegate, JRNativeSigninViewControllerDelegate>
+ (void)configureEngageWithCaptureMobileEndpointUrlAndAppId:(NSString *)appId;

+ (void)startAuthenticationDialogWithNativeSignin:(JRConventionalSigninType)nativeSigninType
                      andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                      forDelegate:(id<JRCaptureSigninDelegate>)delegate;

+ (void)startAuthenticationDialogOnProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                forDelegate:(id<JRCaptureSigninDelegate>)delegate;

+ (void)startSocialPublishingDialogWithActivity:(JRActivityObject*)activity
                   withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;
@end
