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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCapture.h"

#import "JRActivityObject.h"
#import "JREngageWrapper.h"
#import "JRCaptureData.h"

@implementation JRCapture

+ (void)setEngageAppId:(NSString *)appId
{
    [JREngageWrapper configureEngageWithCaptureMobileEndpointUrlAndAppId:appId];
}

+ (void)setEngageAppId:(NSString *)appId captureApidDomain:(NSString *)captureApidDomain
       captureUIDomain:(NSString *)captureUIDomain clientId:(NSString *)clientId
     andEntityTypeName:(NSString *)entityTypeName
{
    [JRCaptureData setCaptureApidDomain:captureApidDomain captureUIDomain:captureUIDomain
                               clientId:clientId andEntityTypeName:entityTypeName];
    [JREngageWrapper configureEngageWithCaptureMobileEndpointUrlAndAppId:appId];
}

+ (NSString *)captureMobileEndpointUrl
{
    return [JRCaptureData captureMobileEndpointUrl];
}

+ (void)setAccessToken:(NSString *)newAccessToken
{
    [JRCaptureData setAccessToken:newAccessToken forUser:nil];
}

+ (void)setCreationToken:(NSString *)newCreationToken
{
    [JRCaptureData setCreationToken:newCreationToken];
}

+ (void)startEngageSigninDialogForDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithNativeSignin:JRConventionalSigninNone
                                   andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninType
                                          forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithNativeSignin:conventionalSigninType
                                   andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogOnProvider:(NSString *)provider
                                forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninType
                      andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                      forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithNativeSignin:conventionalSigninType
                                   andCustomInterfaceOverrides:customInterfaceOverrides forDelegate:delegate];
}

+ (void)startEngageSigninDialogOnProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:customInterfaceOverrides forDelegate:delegate];
}

#ifdef JRENGAGE_SHARING_WITH_CAPTURE
+ (void)startEngageSharingDialogWithActivity:(JRActivityObject *)activity
                                    forDelegate:(id <JRCaptureSharingDelegate>)delegate
{
    [JREngageWrapper startSocialPublishingDialogWithActivity:activity
                                withCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSharingDialogWithActivity:(JRActivityObject *)activity
                   withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                    forDelegate:(id <JRCaptureSharingDelegate>)delegate
{
    [JREngageWrapper startSocialPublishingDialogWithActivity:activity
                                withCustomInterfaceOverrides:customInterfaceOverrides forDelegate:delegate];
}
#endif // JRENGAGE_SHARING_WITH_CAPTURE

- (void)dealloc
{
    [super dealloc];
}
@end
