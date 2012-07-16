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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCaptureError.h"
#import "JSONKit.h"

@implementation JRCaptureError
{

}

NSString * JRCaptureErrorDomain = @"JRCapture.ErrorDomain";


+ (NSError*)setError:(NSString*)error withCode:(NSInteger)code description:(NSString *)description andExtraFields:(NSDictionary *)extraFields
{
    ALog (@"An error occured (%d): %@", code, description);

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   error, NSLocalizedDescriptionKey,
                                                   description, NSLocalizedFailureReasonErrorKey, nil];

    for (NSString *key in [extraFields allKeys])
        [userInfo setObject:[extraFields objectForKey:key] forKey:key];

    return [[[NSError alloc] initWithDomain:JRCaptureErrorDomain
                                       code:code
                                   userInfo:[NSDictionary dictionaryWithDictionary:userInfo]] autorelease];
}

#define btwn(a, b, c) ((a >= b && a < c) ? YES : NO)

+ (NSError *)errorFromResult:(NSObject *)result
{
    /* {"error_description":"/basicIpAddress was not a valid ip address.","stat":"error","code":200,"error":"invalid_argument","argument_name":"/basicIpAddress"} */
    NSDictionary *resultDictionary;

    if ([result isKindOfClass:[NSDictionary class]])
        resultDictionary = (NSDictionary *) result;
    else if ([result isKindOfClass:[NSString class]])
        resultDictionary = [(NSString *)result objectFromJSONString];
    else /* Uh-oh!! */
        return nil;

    NSString *errorDescription = [resultDictionary objectForKey:@"error_description"];
    NSString *error            = [resultDictionary objectForKey:@"error"];
    NSNumber *code             = [resultDictionary objectForKey:@"code"];

    NSDictionary *extraFields = nil;

    if (btwn([code integerValue], GENERIC_ERROR_RANGE, LOCAL_APID_ERROR_RANGE))
        return [self setError:error withCode:[code integerValue]
                  description:errorDescription andExtraFields:nil];

    if (btwn([code integerValue], LOCAL_APID_ERROR_RANGE, APID_ERROR_RANGE))
        return [self setError:error withCode:[code integerValue]
                  description:errorDescription andExtraFields:[resultDictionary objectForKey:@"extraFields"]];

    if (btwn([code integerValue], CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE, CAPTURE_WRAPPED_WEBVIEW_ERROR_RANGE))
        return [self setError:error withCode:[code integerValue]
                  description:errorDescription andExtraFields:nil];

    if ([code integerValue] > CAPTURE_WRAPPED_WEBVIEW_ERROR_RANGE)
        return [self setError:error withCode:[code integerValue]
                  description:errorDescription andExtraFields:nil];

    /* else if (btwn([code integerValue], APID_ERROR_RANGE, CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE)) */

    switch ([code integerValue])
    {
        case 100: /* 'missing_argument' A required argument was not supplied. Extra fields: 'argument_name' */
        case 200: /* 'invalid_argument' The argument was malformed, or its value was invalid for some other reason. Extra fields: 'argument_name' */
            extraFields = [NSDictionary dictionaryWithObjectsAndKeys:[resultDictionary objectForKey:@"argument_name"], @"argument_name", nil];
            break;

        case 223: /* 'unknown_attribute' An attribute does not exist. This can occur when trying to create or update a record, or when modifying an attribute. Extra fields: 'attribute_name' */
        case 233: /* 'attribute_exists' Attempted to create an attribute that already exists. Extra fields: 'attribute_name' */
        case 234: /* 'reserved_attribute' Attempted to modify a reserved attribute; can occur if you try to delete, rename, or write to a reserved attribute. Extra fields: 'attribute_name' */
            extraFields = [NSDictionary dictionaryWithObjectsAndKeys:[resultDictionary objectForKey:@"attribute_name"], @"attribute_name", nil];
            break;

        case 221: /* 'unknown_application' The application id does not exist. Extra fields: 'application_id' */
            extraFields = [NSDictionary dictionaryWithObjectsAndKeys:[resultDictionary objectForKey:@"application_id"], @"applicaiton_id", nil];
            break;

        case 222: /* 'unknown_entity_type' The entity type does not exist. Extra fields: 'type_name' */
        case 232: /* 'entity_type_exists' Attempted to create an entity type that already exists. Extra fields: 'type_name' */
            extraFields = [NSDictionary dictionaryWithObjectsAndKeys:[resultDictionary objectForKey:@"type_name"], @"type_name", nil];
            break;


        case 330: /* 'timestamp_mismatch' The created or lastUpdated value does not match the supplied argument. Extra fields: 'attribute_name', 'actual_value', 'supplied_value' */
            extraFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [resultDictionary objectForKey:@"attribute_name"], @"attribute_name",
                                                [resultDictionary objectForKey:@"actual_value"], @"actual_value",
                                                [resultDictionary objectForKey:@"supplied_value"], @"supplied_value", nil];
            break;

        case 420: /* 'redirect_uri_mismatch' The redirectUri did not match. Occurs in the oauth/token API call with the authorization_code grant type. Extra fields: 'expected_value', 'supplied_value' */
            extraFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [resultDictionary objectForKey:@"expected_value"], @"expected_value",
                                                [resultDictionary objectForKey:@"supplied_value"], @"supplied_value", nil];
            break;

        case 201: /* 'duplicate_argument' Two or more supplied arguments may not have been included in the same call; for example, both id and uuid in entity.update. */
        case 205: /* 'invalid_auth_method' The request used an http auth method other than Basic or OAuth. */
        case 310: /* 'record_not_found' Referred to an entity or plural element that does not exist. */
        case 320: /* 'id_in_new_record' Attempted to specify a record id in a new entity or plural element. */
        case 340: /* 'invalid_data_format' A JSON value was not formatted correctly according to the attribute type in the schema. */
        case 341: /* 'invalid_json_type' A value did not match the expected JSON type according to the schema. */
        case 342: /* 'invalid_date_time' A date or dateTime value was not valid, for example if it was not formatted correctly or was out of range. */
        case 360: /* 'constraint_violation' A constraint was violated. */
        case 361: /* 'unique_violation' A unique or locally-unique constraint was violated. */
        case 362: /* 'missing_required_attribute' An attribute with the required constraint was either missing or set to null. */
        case 363: /* 'length_violation' A string value violated an attribute’s length constraint. */
        case 402: /* 'invalid_client_credentials' The client id does not exist or the client secret was wrong. */
        case 403: /* 'client_permission_error' The client does not have permission to perform the action; needs a feature. */
        case 414: /* 'access_token_expired' The supplied access_token has expired. */
        case 415: /* 'authorization_code_expired' The supplied authorization_code has expired. */
        case 416: /* 'verification_code_expired' The supplied verification_code has expired. */
        case 417: /* 'creation_token_expired' The supplied creation_token has expired. */
        case 480: /* 'api_feature_disabled' The API call was temporarily disabled for maintenance, and will be available again shortly. */
        case 500: /* 'unexpected_error' An unexpected internal error; Janrain is notified when this occurs. */
        case 510: /* 'api_limit_error' The limit on total number of simultaneous API calls has been reached. */
        default:
            break;
    }

    return [self setError:error withCode:([code integerValue] + APID_ERROR_RANGE)
              description:errorDescription andExtraFields:extraFields];
}

+ (NSDictionary *)invalidClassErrorForResult:(NSObject *)result
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                             @"error", @"stat",
                             @"invalid_result", @"error",
                             [NSString stringWithFormat:@"The result object was not a string or dictionary: %@", [result description]], @"error_description",
                             [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidResultClass], @"code", nil];
}

+ (NSDictionary *)invalidStatErrorForResult:(NSObject *)result
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                             @"error", @"stat",
                             @"invalid_result", @"error",
                             [NSString stringWithFormat:@"The result object did not have the expected stat: %@", [result description]], @"error_description",
                             [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidResultStat], @"code", nil];
}

+ (NSDictionary *)invalidDataErrorForResult:(NSObject *)result
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                             @"error", @"stat",
                             @"invalid_result", @"error",
                             [NSString stringWithFormat:@"The result object did not have the expected data: %@", [result description]], @"error_description",
                             [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidResultData], @"code", nil];
}

+ (NSDictionary *)missingAccessTokenInResult:(NSObject *)result
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                             @"error", @"stat",
                             @"missing_access_token", @"error",
                             @"The result object did not have the access_token where the access token was expected", @"error_description",
                             [NSNumber numberWithInteger:JRCaptureLocalApidErrorMissingAccessToken], @"code", nil];
}

+ (NSDictionary *)lastUpdatedSelectorNotAvailable
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                             @"error", @"stat",
                             @"selector_unavailable", @"error",
                             @"The result object did not have the access_token where the access token was expected", @"error_description",
                             [NSNumber numberWithInteger:JRCaptureLocalApidErrorSelectorNotAvailable], @"code",
                             @"lastUpdated", @"selectorName", nil];
}
@end
