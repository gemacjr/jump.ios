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

 File:   JREngagePhonegapPlugin.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, January 4th, 2012
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/JSONKit.h>
#import "JREngagePhonegapPlugin.h"

@interface NSString (NSString_JSON_ESCAPING)
- (NSString*)JSONEscape;
@end

@implementation NSString (NSString_JSON_ESCAPING)
- (NSString*)JSONEscape
{

    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL,
                                (CFStringRef)self,
                                NULL,
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    return encodedString;
}
@end


@interface JREngagePhonegapPlugin ()
@property (nonatomic, retain) NSMutableDictionary *fullAuthenticationResponse;
@end

@implementation JREngagePhonegapPlugin
@synthesize callbackID;
@synthesize fullAuthenticationResponse;

- (id)init
{
    if ((self = [super init])) { }
    return self;
}

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    DLog(@"[arguments pop]: %@", callbackID);

    NSString     *printString  = [arguments objectAtIndex:0];
    PluginResult *pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:[printString JSONEscape]];

    if([printString isEqualToString:@"HelloWorld"] == YES)
    {
        [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    }
    else
    {
        [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
    }
}

- (void)sendSuccessMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:[message JSONEscape]];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)sendFailureMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                                messageAsString:[message JSONEscape]];

    [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
}

- (NSString *)stringFromError:(NSError*)error
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionaryWithCapacity:2];

    [errorResponse setObject:[NSString stringWithFormat:@"%d", error.code] forKey:@"code"];
    [errorResponse setObject:error.localizedDescription forKey:@"message"];
    [errorResponse setObject:@"fail" forKey:@"stat"];

    return [errorResponse JSONString];
}

- (void)initializeJREngage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    NSString *appId;
    if ([arguments count])
        appId = [arguments objectAtIndex:0];
    else
    {
        PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                              messageAsString:@"Missing appId in call to initialize"];

        [self writeJavascript:[result toErrorCallbackString:self.callbackID]];
        return;
    }

    NSString *tokenUrl = nil;
    if ([arguments count] > 1)
        tokenUrl = [arguments objectAtIndex:1];

    jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:tokenUrl delegate:self];

    // TODO: Check jrEngage result
    // TODO: Standardize returned objects

    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:@"Initializing JREngage..."];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)showAuthenticationDialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    [jrEngage showAuthenticationDialog];
}

- (void)showSharingDialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    NSString *activityString;
    if ([arguments count])
        activityString = [arguments objectAtIndex:0];
    else
    {
        PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                              messageAsString:@"Missing appId in call to initialize"];

        [self writeJavascript:[result toErrorCallbackString:self.callbackID]];
        return;
    }

    NSDictionary *activityDictionary = (NSDictionary*)[activityString objectFromJSONString];
    JRActivityObject *activityObject = [JRActivityObject activityObjectFromDictionary:activityDictionary];

    [jrEngage showSocialPublishingDialogWithActivity:activityObject];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    [self sendFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationDidNotComplete
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                                messageAsString:@"User canceled authentication"];
    [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info
                              forProvider:(NSString*)provider
{
    NSMutableDictionary *newAuthInfo = [NSMutableDictionary dictionaryWithDictionary:auth_info];
    [newAuthInfo removeObjectForKey:@"stat"];

    if (!fullAuthenticationResponse)
        self.fullAuthenticationResponse = [NSMutableDictionary dictionaryWithCapacity:5];

    [fullAuthenticationResponse setObject:newAuthInfo forKey:@"auth_info"];
    [fullAuthenticationResponse setObject:provider forKey:@"provider"];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error
                             forProvider:(NSString*)provider
{
    [self sendFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl
                            withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload
                             forProvider:(NSString*)provider
{
    if (!fullAuthenticationResponse) /* That's not right! */;

    NSString *payloadString = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSASCIIStringEncoding] autorelease];

    [fullAuthenticationResponse setObject:tokenUrl forKey:@"tokenUrl"];
    [fullAuthenticationResponse setObject:(payloadString ? payloadString : (void *) kCFNull)
                                   forKey:@"tokenUrlPayload"];
    [fullAuthenticationResponse setObject:@"ok" forKey:@"stat"];

    NSString *authResponseString = [fullAuthenticationResponse JSONString];

    [self sendSuccessMessage:authResponseString];

    self.fullAuthenticationResponse = nil;
}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl
                      didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider
{
    // TODO: Should we also send a success with just partial (i.e., auth_info) data?
    [self sendFailureMessage:[self stringFromError:error]];
}

//- (void)jrSocialDidNotCompletePublishing { }
//
//- (void)jrSocialDidCompletePublishing { }
//
//- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
//                       forProvider:(NSString*)provider { }
//
//- (void)jrSocialPublishingActivity:(JRActivityObject*)activity
//                  didFailWithError:(NSError*)error
//                       forProvider:(NSString*)provider { }

- (void)dealloc
{
    [fullAuthenticationResponse release];
    [super dealloc];
}
@end
#endif























