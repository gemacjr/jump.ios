#import "JRActivityObject.h"
#import "JRCaptureUser.h"
#import "JREngage.h"

typedef enum
{
    JRCaptureRecordCreated,
    JRCaptureRecordExists,
    JRCaptureRecordMissingRequiredFields,
} JRCaptureAuthenticationStatus;

typedef enum
{
    JRNativeSigninNone = 0,
    JRNativeSigninUsernamePassword,
    JRNativeSigninEmailPassword,
} JRNativeSigninState;

@class JRCaptureUser;
@protocol JRCaptureAuthenticationDelegate <NSObject>
@optional
/**
 * Sent if the application tries to show a JREngage dialog, and JREngage failed to show.  May
 * occur if the JREngage library failed to configure, or if the activity object was nil, etc.
 *
 * @param error
 *   The error that occurred during configuration
 *
 * @note
 * This message is only sent if your application tries to show a JREngage dialog, and not necessarily
 * when an error occurs, if, say, the error occurred during the library's configuration.  The raison d'etre
 * is based on the possibility that your application may preemptively configure JREngage, but never actually
 * use it.  If that is the case, then you won't get any error.
 **/
- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error;
/*@}*/

/**
 * @name Authentication
 * Messages sent by JREngage during authentication
 **/
/*@{*/

/**
 * Sent if the authentication was canceled for any reason other than an error.  For example,
 * the user hits the "Cancel" button, any class (e.g., the %JREngage delegate) calls the
 * cancelAuthentication message, or if configuration of the library is taking more than about
 * 16 seconds (rare) to download.
 **/
- (void)jrAuthenticationDidNotComplete;

/**
// * Tells the delegate that the user has successfully authenticated with the given provider, passing to
// * the delegate an \e NSDictionary object with the user's profile data.
// *
// * @param auth_info
// *   An \e NSDictionary of fields containing all the information Janrain Engage knows about the user
// *   logging into your application.  Includes the field \c "profile" which contains the user's profile information
// *
// * @param provider
// *   The name of the provider on which the user authenticated.  For a list of possible strings,
// *   please see the \ref basicProviders "List of Providers"
// *
// * @par Example:
// *   The structure of the auth_info dictionary (represented here in json) should look something like
// *   the following:
// * @code
// "auth_info":
// {
// "profile":
// {
// "displayName": "brian",
// "preferredUsername": "brian",
// "url": "http:\/\/brian.myopenid.com\/",
// "providerName": "Other",
// "identifier": "http:\/\/brian.myopenid.com\/"
// }
// }
// * @endcode
// *
// *
// * @sa
// * For a full description of the dictionary and its fields, please see the
// * <a href="http://documentation.janrain.com/engage/api/auth_info">auth_info response</a>
// * section of the Janrain Engage API documentation.
 **/
- (void)jrAuthenticationDidSucceedForUser:(JRCaptureUser*)captureUser withToken:(NSString *)captureToken
                                andStatus:(JRCaptureAuthenticationStatus)status;

/**
 * Sent when authentication failed and could not be recovered by the library.
 *
 * @param error
 *   The error that occurred during authentication
 *
 * @param provider
 *   The name of the provider on which the user tried to authenticate.  For a list of possible strings,
 *   please see the \ref basicProviders "List of Providers"
 *
 * @note
 * This message is not sent if authentication was canceled.  To be notified of a canceled authentication,
 * see jrAuthenticationDidNotComplete().
 **/
- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;
@end

@protocol JRCaptureSocialSharingDelegate <NSObject>
@optional
/**
 * @name SocialPublishing
 * Messages sent by JREngage during social publishing
 **/
/*@{*/

/**
 * Sent if social publishing was canceled for any reason other than an error.  For example,
 * the user hits the "Cancel" button, any class (e.g., the %JREngage delegate) calls the cancelPublishing
 * message, or if configuration of the library is taking more than about 16 seconds (rare) to download.
 **/
- (void)jrSocialDidNotCompletePublishing;

/**
 * Sent after the social publishing dialog is closed (e.g., the user hits the "Close" button) and publishing
 * is complete. You can receive multiple jrSocialDidPublishActivity:forProvider:()
 * messages before the dialog is closed and publishing is complete.
 **/
- (void)jrSocialDidCompletePublishing;

/**
 * Sent after the user successfully shares an activity on the given provider.
 *
 * @param activity
 *   The shared activity
 *
 * @param provider
 *   The name of the provider on which the user published the activity.  For a list of possible strings,
 *   please see the \ref socialProviders "List of Social Providers"
 **/
- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider;

/**
 * Sent when publishing an activity failed and could not be recovered by the library.
 *
 * @param activity
 *   The activity the user was trying to share
 *
 * @param error
 *   The error that occurred during publishing
 *
 * @param provider
 *   The name of the provider on which the user attempted to publish the activity.  For a list of possible strings,
 *   please see the \ref socialProviders "List of Social Providers"
 **/
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider;
/*@}*/


/**
 * Sent if the authentication was canceled for any reason other than an error.  For example,
 * the user hits the "Cancel" button, any class (e.g., the %JREngage delegate) calls the
 * cancelAuthentication message, or if configuration of the library is taking more than about
 * 16 seconds (rare) to download.
 **/
- (void)jrAuthenticationDidNotComplete;
@end


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
