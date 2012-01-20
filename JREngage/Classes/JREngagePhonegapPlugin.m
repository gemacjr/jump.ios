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
@property (nonatomic, retain) NSMutableDictionary *fullSharingResponse;
@property (nonatomic, retain) NSMutableArray      *authenticationBlobs;
@property (nonatomic, retain) NSMutableArray      *shareBlobs;
@end

@implementation JREngagePhonegapPlugin
@synthesize callbackID;
@synthesize fullAuthenticationResponse;
@synthesize fullSharingResponse;
@synthesize authenticationBlobs;
@synthesize shareBlobs;

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
                                                messageAsString:printString];

    if([printString isEqualToString:@"Hello World }]%20"] == YES)
    {
        [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    }
    else
    {
        [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
    }
}

- (void)thenFinish
{
    weAreSharing                    = NO;
    self.fullAuthenticationResponse = nil;
    self.fullSharingResponse        = nil;
    self.authenticationBlobs        = nil;
    self.shareBlobs                 = nil;
}

- (void)finishWithSuccessMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:message];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    [self thenFinish];
}

- (void)finishWithFailureMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                                messageAsString:message];

    [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
    [self thenFinish];
}

- (NSString*)stringFromError:(NSError*)error
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionaryWithCapacity:2];

    [errorResponse setObject:[NSString stringWithFormat:@"%d", error.code] forKey:@"code"];
    [errorResponse setObject:error.localizedDescription forKey:@"message"];
    [errorResponse setObject:@"fail" forKey:@"stat"];

    return [errorResponse JSONString];
}

- (NSString*)stringFromCode:(NSInteger)code andMessage:(NSString*)message
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionaryWithCapacity:2];

    [errorResponse setObject:[NSString stringWithFormat:@"%d", code] forKey:@"code"];
    [errorResponse setObject:message forKey:@"message"];
    [errorResponse setObject:@"fail" forKey:@"stat"];

    return [errorResponse JSONString];
}

- (void)saveTheAuthenticationBlobForLater
{
    if (!authenticationBlobs)
        self.authenticationBlobs = [NSMutableArray arrayWithCapacity:5];

    [authenticationBlobs addObject:fullAuthenticationResponse];

    self.fullAuthenticationResponse = nil;
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
        // TODO: Standardize this error
        PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                              messageAsString:@"Missing activity"];

        [self writeJavascript:[result toErrorCallbackString:self.callbackID]];
        return;
    }

    weAreSharing = YES;

    NSDictionary *activityDictionary = (NSDictionary*)[activityString objectFromJSONString];
    JRActivityObject *activityObject = [JRActivityObject activityObjectFromDictionary:activityDictionary];

    [jrEngage showSocialPublishingDialogWithActivity:activityObject];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationDidNotComplete
{
    [self finishWithFailureMessage:[self stringFromCode:JRAuthenticationCanceledError
                                       andMessage:@"User canceled authentication"]];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error
                             forProvider:(NSString*)provider
{
    // TODO: What if they fail during sharing??
    // TODO: Make sure the dialog doesn't close in this case if there's an error during sharing
    if (!weAreSharing)
        [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl
                      didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider
{
    // TODO: Should we also send a success with just partial (i.e., auth_info) data?
    if (!weAreSharing)
        [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info
                              forProvider:(NSString*)provider
{
    // TODO: What if they authenticate during sharing?  Should we include this stuff with the sharing response?
    // Or are we hijacking the sharing callback with the auth call backs??? (Looks like it this is the case; adding
    // a boolean to stop the hijacking)

    NSMutableDictionary *newAuthInfo = [NSMutableDictionary dictionaryWithDictionary:auth_info];
    [newAuthInfo removeObjectForKey:@"stat"];

    if (!fullAuthenticationResponse)
        self.fullAuthenticationResponse = [NSMutableDictionary dictionaryWithCapacity:5];

    [fullAuthenticationResponse setObject:newAuthInfo forKey:@"auth_info"];
    [fullAuthenticationResponse setObject:provider forKey:@"provider"];
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

    if (weAreSharing)
        [self saveTheAuthenticationBlobForLater];
    else
        [self finishWithSuccessMessage:authResponseString];

//    self.fullAuthenticationResponse = nil;
}


- (void)jrSocialDidNotCompletePublishing
{
    [self finishWithFailureMessage:[self stringFromCode:JRPublishCanceledError
                                       andMessage:@"User canceled sharing"]];
}

- (void)jrSocialPublishingActivity:(JRActivityObject*)activity
                  didFailWithError:(NSError*)error
                       forProvider:(NSString*)provider
{
    NSDictionary *shareBlob =
            [NSDictionary dictionaryWithObjectsAndKeys:
                    provider, @"provider",
                    @"fail", @"stat",
                    [NSString stringWithFormat:@"%d", error.code], @"code",
                    error.localizedDescription, @"message", nil];

    if (!shareBlobs)
        self.shareBlobs = [NSMutableArray arrayWithCapacity:5];

    [shareBlobs addObject:shareBlob];
}

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
                       forProvider:(NSString*)provider
{
//    if (!fullSharingResponse)
//        self.fullSharingResponse = [NSMutableDictionary dictionaryWithCapacity:5];

//    if (![fullSharingResponse objectForKey:@"activity"])
//        [fullSharingResponse setObject:activity forKey:@"activity"];

    NSDictionary *shareBlob = [NSDictionary dictionaryWithObjectsAndKeys:provider, @"provider", @"ok", @"stat", nil];

    if (!shareBlobs)
        self.shareBlobs = [NSMutableArray arrayWithCapacity:5];

    [shareBlobs addObject:shareBlob];

//    [fullSharingResponse setObject:provider forKey:@"provider"];
}

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
                       forProvider:(NSString*)provider
{
//    if (!fullSharingResponse)
//        self.fullSharingResponse = [NSMutableDictionary dictionaryWithCapacity:5];

//    if (![fullSharingResponse objectForKey:@"activity"])
//        [fullSharingResponse setObject:activity forKey:@"activity"];

    NSDictionary *shareBlob = [NSDictionary dictionaryWithObjectsAndKeys:provider, @"provider", @"ok", @"stat", nil];

    if (!shareBlobs)
        self.shareBlobs = [NSMutableArray arrayWithCapacity:5];

    [shareBlobs addObject:shareBlob];

//    [fullSharingResponse setObject:provider forKey:@"provider"];
}

- (void)jrSocialDidCompletePublishing
{
    if (!fullSharingResponse)
        self.fullSharingResponse = [NSMutableDictionary dictionaryWithCapacity:5];

    if (authenticationBlobs)
        [fullSharingResponse setObject:authenticationBlobs forKey:@"sign-ins"];

    if (shareBlobs)
        [fullSharingResponse setObject:shareBlobs forKey:@"shares"];

    [self finishWithSuccessMessage:[fullSharingResponse JSONString]];

//    self.fullSharingResponse = nil;
}

- (void)dealloc
{
    [fullAuthenticationResponse release];
    [fullSharingResponse release];
    [authenticationBlobs release];
    [super dealloc];
}
@end
#endif























