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

#import "JREngagePhonegapPlugin.h"

#ifdef PHONEGAP_OR_CORDOVA
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

    return [encodedString autorelease];
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

    DLog(@"print arguments: %@", callbackID);

    NSString     *printString  = [arguments objectAtIndex:0];

    PCPluginResult *pluginResult = [PCPluginResult resultWithStatus:PCCommandStatus_OK
                                                    messageAsString:printString];

    // TODO: Nathan, what were you testing here?
    // if([printString isEqualToString:@"Hello World }]%20"] == YES)
    if([printString isEqualToString:@"Hello World"] == YES)
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
    PCPluginResult* pluginResult = [PCPluginResult resultWithStatus:PCCommandStatus_OK
                                                    messageAsString:message];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    [self thenFinish];
}

- (void)finishWithFailureMessage:(NSString *)message
{
    PCPluginResult* pluginResult = [PCPluginResult resultWithStatus:PCCommandStatus_ERROR
                                                    messageAsString:message];

    [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
    [self thenFinish];
}

- (NSString*)stringFromError:(NSError*)error
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionaryWithCapacity:2];

    [errorResponse setObject:[NSNumber numberWithInt:error.code] forKey:@"code"];
    [errorResponse setObject:error.localizedDescription forKey:@"message"];
    [errorResponse setObject:@"fail" forKey:@"stat"];

    return [errorResponse JSONString];
}

- (NSString*)stringFromCode:(NSInteger)code andMessage:(NSString*)message
{
    NSMutableDictionary *errorResponse = [NSMutableDictionary dictionaryWithCapacity:2];

    [errorResponse setObject:[NSNumber numberWithInt:code] forKey:@"code"];
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
    DLog(@"");

    self.callbackID = [arguments pop];

    NSString *appId;
    if ([arguments count])
        appId = [arguments objectAtIndex:0];
    else
    {
        [self finishWithFailureMessage:[self stringFromCode:JRMissingAppIdError
                                                 andMessage:@"Missing appId in call to initialize"]];

        return;
    }

    NSString *tokenUrl = nil;
    if ([arguments count] > 1)
        tokenUrl = [arguments objectAtIndex:1];

    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/JREngage-Info.plist"];
    NSMutableDictionary *infoPlist =
            [NSMutableDictionary dictionaryWithDictionary:
                    [NSDictionary dictionaryWithContentsOfFile:path]];

    NSMutableString *version = [NSMutableString stringWithString:[infoPlist objectForKey:@"CFBundleShortVersionString"]];
    //NSString *newVersion = @"";

#ifdef PHONEGAP_FRAMEWORK
    if (![version hasSuffix:@":phonegap"])
        [version appendString:@":phonegap"];////newVersion = [NSString stringWithFormat:@"%@:%@", version, @":phonegap"];
#else
#ifdef CORDOVA_FRAMEWORK
    if (![version hasSuffix:@":cordova"])
        [version appendString:@":cordova"];//newVersion = [NSString stringWithFormat:@"%@:%@", version, @"cordova"];
#endif
#endif

    [infoPlist setObject:version forKey:@"CFBundleShortVersionString"];
    [infoPlist writeToFile:path atomically:YES];

    jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:tokenUrl delegate:self];
    if (!jrEngage)
    {
        [self finishWithFailureMessage:[self stringFromCode:JRGenericConfigurationError
                                                 andMessage:@"There was an error initializing JREngage: returned JREngage object was null"]];

        return;
    }

    [self finishWithSuccessMessage:@"{'stat':'ok','message':'Initializing JREngage...'}"];
}

- (void)showAuthenticationDialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    DLog(@"");

    self.callbackID = [arguments pop];

    [jrEngage showAuthenticationDialog];
}

- (void)showSharingDialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    DLog(@"");

    self.callbackID = [arguments pop];
    weAreSharing    = YES;

    NSString *activityString;
    if ([arguments count])
        activityString = [arguments objectAtIndex:0];
    else
    {
        [self finishWithFailureMessage:[self stringFromCode:JRPublishErrorActivityNil
                                                 andMessage:@"Activity object is required and cannot be null"]];

        return;
    }

    NSDictionary *activityDictionary = (NSDictionary*)[activityString objectFromJSONString];
    if (!activityDictionary)
    {
        [self finishWithFailureMessage:[self stringFromCode:JRPublishErrorBadActivityJson
                                                 andMessage:@"The activity object passed was not valid JSON"]];

        return;
    }

    JRActivityObject *activityObject = [JRActivityObject activityObjectFromDictionary:activityDictionary];
    if (!activityObject)
    {
        [self finishWithFailureMessage:[self stringFromCode:JRPublishErrorBadActivityJson
                                                 andMessage:@"The JSON passed was not a valid activity object"]];

        return;
    }

    [jrEngage showSocialPublishingDialogWithActivity:activityObject];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    DLog(@"");
    [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationDidNotComplete
{
    DLog(@"");
    [self finishWithFailureMessage:[self stringFromCode:JRAuthenticationCanceledError
                                             andMessage:@"User canceled authentication"]];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");

    if (!weAreSharing)
        [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider
{
    DLog(@"");

    if (!weAreSharing)
        [self finishWithFailureMessage:[self stringFromError:error]];
}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider
{
    DLog(@"");

    NSMutableDictionary *newAuthInfo = [NSMutableDictionary dictionaryWithDictionary:auth_info];
    [newAuthInfo removeObjectForKey:@"stat"];

    if (!fullAuthenticationResponse)
        self.fullAuthenticationResponse = [NSMutableDictionary dictionaryWithCapacity:5];

    [fullAuthenticationResponse setObject:newAuthInfo forKey:@"auth_info"];
    [fullAuthenticationResponse setObject:provider forKey:@"provider"];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider
{
    DLog(@"");

    if (!fullAuthenticationResponse) /* That's not right! */; // TODO: Will this ever happen, and if so, what should we do?

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
}

- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error
                       forProvider:(NSString*)provider
{
    DLog(@"");

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

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider
{
    DLog(@"");

    NSDictionary *shareBlob = [NSDictionary dictionaryWithObjectsAndKeys:provider, @"provider", @"ok", @"stat", nil];

    if (!shareBlobs)
        self.shareBlobs = [NSMutableArray arrayWithCapacity:5];

    [shareBlobs addObject:shareBlob];
}

- (void)jrSocialDidCompletePublishing
{
    DLog(@"");

    if (!fullSharingResponse)
        self.fullSharingResponse = [NSMutableDictionary dictionaryWithCapacity:5];

    if (authenticationBlobs)
        [fullSharingResponse setObject:authenticationBlobs forKey:@"signIns"];

    if (shareBlobs)
        [fullSharingResponse setObject:shareBlobs forKey:@"shares"];

    [self finishWithSuccessMessage:[fullSharingResponse JSONString]];
}

- (void)jrSocialDidNotCompletePublishing
{
    DLog(@"");

    /* If there have been ANY shares (successful or otherwise) or any auths, call jrSocialDidCompletePublishing */
    if (authenticationBlobs || shareBlobs)
        return [self jrSocialDidCompletePublishing];


    [self finishWithFailureMessage:[self stringFromCode:JRPublishCanceledError
                                             andMessage:@"User canceled sharing"]];
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























