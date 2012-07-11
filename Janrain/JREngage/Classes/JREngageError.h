//
// Created by lillialexis on 7/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum
{
    ConfigurationError = 1,
    AuthenticationError = 2,
    SocialSharingError = 3,
} JRErrorCategory;

typedef enum
{
    JRUrlError = 100,
    JRDataParsingError,
    JRJsonError,
    JRConfigurationInformationError,
    JRSessionDataFinishGetProvidersError,
    JRDialogShowingError,
    JRProviderNotConfiguredError,
    JRMissingAppIdError,
    JRGenericConfigurationError,
} JREngageConfigurationError;

typedef enum
{
    JRAuthenticationFailedError = 200,
    JRAuthenticationTokenUrlFailedError,
    JRAuthenticationCanceledError,
    // TODO: Add the token url error where appropriate
} JREngageAuthenticationError;

typedef enum
{
    JRPublishFailedError = 300,
    JRPublishErrorActivityNil,
    JRPublishErrorBadActivityJson,
    JRPublishCanceledError,
    JRPublishErrorBadConnection,
    JRPublishErrorMissingParameter,
    JRPublishErrorMissingApiKey,
    JRPublishErrorCharacterLimitExceeded,
    JRPublishErrorFacebookGeneric,
    JRPublishErrorInvalidFacebookSession,
    JRPublishErrorInvalidFacebookMedia,
    //JRPublishErrorInvalidFacebookActionLinks/Properties,
    JRPublishErrorTwitterGeneric,
    JRPublishErrorDuplicateTwitter,
    JRPublishErrorLinkedInGeneric,
    JRPublishErrorMyspaceGeneric,
    JRPublishErrorYahooGeneric,
    JRPublishErrorFeedActionRequestLimit, // TODO: Add a test for this
    JRPublishErrorInvalidOauthKey, /* Will be deprecating */
    JRPublishErrorLinkedInCharacterExceeded, /* Will be deprecating */
} JREngageSocialPublishingError;

extern NSString * JREngageErrorDomain;

@interface JREngageError : NSObject
@end
