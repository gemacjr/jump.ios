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
