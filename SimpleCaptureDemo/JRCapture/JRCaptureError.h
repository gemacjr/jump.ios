//
// Created by lillialexis on 6/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define GENERIC_ERROR_RANGE 1000
#define LOCAL_APID_ERROR_RANGE 2000
#define APID_ERROR_RANGE 3000
#define CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE 4000
#define CAPTURE_WRAPPED_WEBVIEW_ERROR_RANGE 5000

typedef enum
{
    JRCaptureErrorGeneric = GENERIC_ERROR_RANGE,
} JRCaptureGenericError;

typedef enum
{
    JRCaptureLocalApidErrorGeneric              = LOCAL_APID_ERROR_RANGE,
    JRCaptureLocalApidErrorInvalidArrayElement  = JRCaptureLocalApidErrorGeneric + 101,
    JRCaptureLocalApidErrorUrlConnection        = JRCaptureLocalApidErrorGeneric + 201,
    JRCaptureLocalApidErrorConnectionDidFail    = JRCaptureLocalApidErrorGeneric + 202,
    JRCaptureLocalApidErrorInvalidResultClass   = JRCaptureLocalApidErrorGeneric + 301,
    JRCaptureLocalApidErrorInvalidResultStat    = JRCaptureLocalApidErrorGeneric + 302,
    JRCaptureLocalApidErrorInvalidResultData    = JRCaptureLocalApidErrorGeneric + 303,
    JRCaptureLocalApidErrorMissingAccessToken   = JRCaptureLocalApidErrorGeneric + 400,
    JRCaptureLocalApidErrorSelectorNotAvailable = JRCaptureLocalApidErrorGeneric + 500,
} JRCaptureLocalApidError;

typedef enum
{
    JRCaptureApidErrorGeneric                  = APID_ERROR_RANGE,
    JRCaptureApidErrorMissingArgument          = JRCaptureApidErrorGeneric + 100,
    JRCaptureApidErrorInvalidArgument          = JRCaptureApidErrorGeneric + 200,
    JRCaptureApidErrorDuplicateArgument        = JRCaptureApidErrorGeneric + 201,
    JRCaptureApidErrorInvalidAuthMethod        = JRCaptureApidErrorGeneric + 205,
    JRCaptureApidErrorUnknownApplication       = JRCaptureApidErrorGeneric + 221,
    JRCaptureApidErrorUnknownEntityType        = JRCaptureApidErrorGeneric + 222,
    JRCaptureApidErrorUnknownAttribute         = JRCaptureApidErrorGeneric + 223,
    JRCaptureApidErrorEntityTypeExists         = JRCaptureApidErrorGeneric + 232,
    JRCaptureApidErrorAttributeExists          = JRCaptureApidErrorGeneric + 233,
    JRCaptureApidErrorReservedAttribute        = JRCaptureApidErrorGeneric + 234,
    JRCaptureApidErrorRecordNotFound           = JRCaptureApidErrorGeneric + 310,
    JRCaptureApidErrorIdInNewRecord            = JRCaptureApidErrorGeneric + 320,
    JRCaptureApidErrorTimestampMismatch        = JRCaptureApidErrorGeneric + 330,
    JRCaptureApidErrorInvalidDataFormat        = JRCaptureApidErrorGeneric + 340,
    JRCaptureApidErrorInvalidJsonType          = JRCaptureApidErrorGeneric + 341,
    JRCaptureApidErrorInvalidDateTime          = JRCaptureApidErrorGeneric + 342,
    JRCaptureApidErrorConstraintViolation      = JRCaptureApidErrorGeneric + 360,
    JRCaptureApidErrorUniqueViolation          = JRCaptureApidErrorGeneric + 361,
    JRCaptureApidErrorMissingRequiredAttribute = JRCaptureApidErrorGeneric + 362,
    JRCaptureApidErrorLengthViolation          = JRCaptureApidErrorGeneric + 363,
    JRCaptureApidErrorInvalidClientCredentials = JRCaptureApidErrorGeneric + 402,
    JRCaptureApidErrorClientPermissionError    = JRCaptureApidErrorGeneric + 403,
    JRCaptureApidErrorAccessTokenExpired       = JRCaptureApidErrorGeneric + 414,
    JRCaptureApidErrorAuthorizationCodeExpired = JRCaptureApidErrorGeneric + 415,
    JRCaptureApidErrorVerificationCodeExpired  = JRCaptureApidErrorGeneric + 416,
    JRCaptureApidErrorCreationTokenExpired     = JRCaptureApidErrorGeneric + 417,
    JRCaptureApidErrorRedirectUriMismatch      = JRCaptureApidErrorGeneric + 420,
    JRCaptureApidErrorApiFeatureDisabled       = JRCaptureApidErrorGeneric + 480,
    JRCaptureApidErrorUnexpectedError          = JRCaptureApidErrorGeneric + 500,
    JRCaptureApidErrorApiLimitError            = JRCaptureApidErrorGeneric + 510,
} JRCaptureApidError;

typedef enum
{
    JRCaptureWrappedEngageErrorGeneric                = CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE,
    JRCaptureWrappedEngageErrorInvalidEndpointPayload = JRCaptureWrappedEngageErrorGeneric + 100,
} JRCaptureWrappedEngageError;

typedef enum
{
    JRCaptureWebviewErrorGeneric = CAPTURE_WRAPPED_WEBVIEW_ERROR_RANGE,
} JRCaptureWebviewError;

@interface JRCaptureError : NSObject
+ (NSError *)errorFromResult:(NSObject *)result;
@end
