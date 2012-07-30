/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


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
