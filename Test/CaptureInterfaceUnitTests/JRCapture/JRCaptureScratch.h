

#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureUser.h"
#import "JRCaptureError.h"

typedef enum
{
    JRConventionalSigninNone = 0,
    JRConventionalSigninUsernamePassword,
    JRConventionalSigninEmailPassword,
} JRConventionalSigninType;

typedef enum
{
    JRCaptureRecordNewlyCreated,           // now it exists, and it is new
    JRCaptureRecordExists,                //IsExisting, // present?? // already created, not new
    JRCaptureRecordMissingRequiredFields, // not created, does not exist
} JRCaptureRecordStatus;

@class JRActivityObject;

//- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context;
//- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context;

@protocol JRCaptureSigninDelegate <NSObject>
@optional

- (void)engageSigninDialogDidFailToShowWithError:(NSError*)error;

- (void)engageSigninDidNotComplete;


- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider;

- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)captureUser status:(JRCaptureRecordStatus)captureRecordStatus;

- (void)engageAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;

- (void)captureAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider;

@end

@protocol JRCaptureSocialSharingDelegate <JRCaptureSigninDelegate>
@optional
- (void)engageSharingDialogDidFailToShowWithError:(NSError*)error;

//- (void)jrSocialDidNotCompletePublishing;
- (void)socialSharingDidNotComplete;

//- (void)jrSocialDidCompletePublishing;
- (void)socialSharingDidComplete;

//- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider;
- (void)socialSharingDidSucceedForActivity:(JRActivityObject*)activity onProvider:(NSString*)provider;

- (void)socialSharingDidFailForActivity:(JRActivityObject*)activity withError:(NSError*)error onProvider:(NSString*)provider;

@end

@interface JRCapture : NSObject

+ (void)setEngageAppId:(NSString *)appId captureApidDomain:(NSString *)newCaptureApidDomain captureUIDomain:(NSString *)newCaptureUIDomain clientId:(NSString *)newClientId andEntityTypeName:(NSString *)newEntityTypeName;

+ (void)setEngageAppId:(NSString *)appId;

+ (void)setEngageAppId:(NSString *)appId captureApiDomain:(NSString *)newCaptureApidDomain
       captureUIDomain:(NSString *)newCaptureUIDomain clientId:(NSString *)newClientId
     andEntityTypeName:(NSString *)newEntityTypeName;

+ (NSString *)captureMobileEndpointUrl;
+ (void)setAccessToken:(NSString *)newAccessToken;
+ (void)setCreationToken:(NSString *)newCreationToken;


+ (void)startEngageSigninForDelegate:(id<JRCaptureSigninDelegate>)delegate;

+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninState
                                forDelegate:(id<JRCaptureSigninDelegate>)delegate;

+ (void)startEngageSigninDialogOnProvider:(NSString*)provider
                                forDelegate:(id<JRCaptureSigninDelegate>)delegate;


+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninState
                      andCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                      forDelegate:(id<JRCaptureSigninDelegate>)delegate;

+ (void)startEngageSigninDialogOnProvider:(NSString*)provider
               withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                forDelegate:(id<JRCaptureSigninDelegate>)delegate;

+ (void)startEngageSharingDialogWithActivity:(JRActivityObject*)activity
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;

+ (void)startEngageSharingDialogWithActivity:(JRActivityObject*)activity
                   withCustomInterfaceOverrides:(NSDictionary*)customInterfaceOverrides
                                    forDelegate:(id<JRCaptureSocialSharingDelegate>)delegate;

@end
