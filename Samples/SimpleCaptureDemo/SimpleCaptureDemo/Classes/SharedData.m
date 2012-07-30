/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

 Author: ${USER}
 Date:   ${DATE}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "SharedData.h"

#define cJRCurrentEmailAddr @"simpleCaptureDemo.currentEmailAddr"
#define cJRCurrentProvider    @"simpleCaptureDemo.currentProvider"
#define cJRCaptureUser        @"simpleCaptureDemo.captureUser"

@interface SharedData ()
@property (strong) NSUserDefaults     *prefs;
@property (strong) JRCaptureUser      *captureUser;
@property          BOOL                isNew;
@property          BOOL                notYetCreated;
@property (strong) NSString           *currentEmailAddr;
@property (strong) NSString           *currentProvider;
@property (weak)   id<SignInDelegate>  signInDelegate;

@end

@implementation SharedData
static SharedData *singleton = nil;

static NSString *appId              = @"appcfamhnpkagijaeinl";
static NSString *captureApidDomain  = @"mobile.dev.janraincapture.com";
static NSString *captureUIDomain    = @"mobile.dev.janraincapture.com";
static NSString *clientId           = @"zc7tx83fqy68mper69mxbt5dfvd7c2jh";
static NSString *entityTypeName     = @"sample_user";

///* Carl's local instance */
//static NSString *appId             = @"pgfjodcppiaifejikhmh";
//static NSString *captureApidDomain = @"http://10.0.10.47:8000";
//static NSString *captureUIDomain   = @"http://10.0.10.47:5000";
//static NSString *clientId          = @"puh6d29gb94mn9ek4v3w8f7w9hp58g2z";
//static NSString *entityTypeName    = @"user2";

//static NSString *appId          = @"mlfeingbenjalleljkpo";
//static NSString *captureDomain  = @"https://demo.staging.janraincapture.com/";
//static NSString *clientId       = @"svaf3gxsmcvyfpx5vcrdwyv2axvy9zqg";
//static NSString *entityTypeName = @"demo_user";

@synthesize captureUser;
@synthesize prefs;
@synthesize currentEmailAddr;
@synthesize currentProvider;
@synthesize signInDelegate;
@synthesize isNew;
@synthesize notYetCreated;
@synthesize engageSigninWasCanceled;


- (id)init
{
    if ((self = [super init]))
    {
        [JRCapture setEngageAppId:appId captureApidDomain:captureApidDomain
                  captureUIDomain:captureUIDomain clientId:clientId
                andEntityTypeName:entityTypeName];

        prefs = [NSUserDefaults standardUserDefaults];
        currentEmailAddr = [prefs objectForKey:cJRCurrentEmailAddr];
        currentProvider  = [prefs objectForKey:cJRCurrentProvider];

        NSData *archivedCaptureUser = [prefs objectForKey:cJRCaptureUser];
        if (archivedCaptureUser)
        {
            captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
        }
    }

    return self;
}

/* Return the singleton instance of this class. */
+ (SharedData *)singletonInstance
{
    if (singleton == nil) {
        singleton = (SharedData *) [[super allocWithZone:NULL] init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self singletonInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (JRCaptureUser *)captureUser
{
    return [[SharedData singletonInstance] captureUser];
}

+ (BOOL)isNew
{
    return [[SharedData singletonInstance] isNew];
}

+ (BOOL)notYetCreated
{
    return [[SharedData singletonInstance] notYetCreated];
}

+ (NSString *)currentEmailAddr
{
    return [[SharedData singletonInstance] currentEmailAddr];
}

+ (NSString *)currentProvider
{
    return [[SharedData singletonInstance] currentProvider];
}

- (void)signoutCurrentUser
{
    self.currentEmailAddr = nil;
    self.currentProvider  = nil;
    self.captureUser      = nil;

    self.isNew         = NO;
    self.notYetCreated = NO;

    [prefs setObject:nil forKey:cJRCurrentEmailAddr];
    [prefs setObject:nil forKey:cJRCurrentProvider];
    [prefs setObject:nil forKey:cJRCaptureUser];

    self.engageSigninWasCanceled = NO;
}

+ (void)signoutCurrentUser
{
    [[SharedData singletonInstance] signoutCurrentUser];
}

+ (void)startAuthenticationWithCustomInterface:(NSDictionary *)customInterface forDelegate:(id<SignInDelegate>)delegate
{
    [SharedData signoutCurrentUser];
    [[SharedData singletonInstance] setSignInDelegate:delegate];

    [JRCapture startEngageSigninDialogWithConventionalSignin:JRConventionalSigninEmailPassword
                             andCustomInterfaceOverrides:customInterface
                                             forDelegate:[SharedData singletonInstance]];
}

//+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile
//{
//    NSString *name = nil;
//
//    if ([profile objectForKey:@"preferredUsername"])
//        name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
//    else if ([[profile objectForKey:@"name"] objectForKey:@"formatted"])
//        name = [NSString stringWithFormat:@"%@",
//                [[profile objectForKey:@"name"] objectForKey:@"formatted"]];
//    else
//        name = [NSString stringWithFormat:@"%@%@%@%@%@",
//                ([[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"givenName"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"givenName"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"middleName"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"middleName"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"familyName"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"familyName"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]] : @""];
//
//    return name;
//}

- (void)resaveCaptureUser
{
    self.currentEmailAddr = captureUser.email;
    [prefs setObject:currentEmailAddr forKey:cJRCurrentEmailAddr];

    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
              forKey:cJRCaptureUser];
}

+ (void)resaveCaptureUser
{
    [[SharedData singletonInstance] resaveCaptureUser];
}

- (void)postEngageErrorToDelegate:(NSError *)error
{
    if ([signInDelegate respondsToSelector:@selector(engageSignInDidFailWithError:)])
        [signInDelegate engageSignInDidFailWithError:error];
}

- (void)postCaptureErrorToDelegate:(NSError *)error
{
    if ([signInDelegate respondsToSelector:@selector(captureSignInDidFailWithError:)])
        [signInDelegate captureSignInDidFailWithError:error];
}

- (void)engageSigninDidNotComplete
{
    self.engageSigninWasCanceled = YES;

    [self postEngageErrorToDelegate:nil];
}

- (void)engageSigninDialogDidFailToShowWithError:(NSError *)error
{
    [self postEngageErrorToDelegate:error];
}

- (void)engageAuthenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    [self postEngageErrorToDelegate:error];
}

- (void)captureAuthenticationDidFailWithError:(NSError *)error
{
    [self postCaptureErrorToDelegate:error];
}

//- (void)setEmailAddr:(NSString *)displayName andProvider:(NSString *)provider
//{
//    self.currentEmailAddr = displayName;
//    self.currentProvider  = provider;
//
//    [prefs setObject:currentEmailAddr forKey:cJRCurrentEmailAddr];
//    [prefs setObject:currentProvider forKey:cJRCurrentProvider];
//}

- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider
{
    self.currentProvider = provider;
    [prefs setObject:currentProvider forKey:cJRCurrentProvider];

    if ([signInDelegate respondsToSelector:@selector(engageSignInDidSucceed)])
        [signInDelegate engageSignInDidSucceed];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser status:(JRCaptureRecordStatus)captureRecordStatus
{
    DLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

//    if (engageSigninWasCanceled) /* Then we logged in directly with the Capture server */
//        [self setEmailAddr:captureUser.email
//               andProvider:nil];

    self.currentEmailAddr = newCaptureUser.email;
    [prefs setObject:currentEmailAddr forKey:cJRCurrentEmailAddr];

    if (captureRecordStatus == JRCaptureRecordNewlyCreated)
        self.isNew = YES;
    else
        self.isNew = NO;

    if (captureRecordStatus == JRCaptureRecordMissingRequiredFields)
        self.notYetCreated = YES;
    else
        self.notYetCreated = NO;

    self.captureUser = newCaptureUser;

    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
              forKey:cJRCaptureUser];

    if ([signInDelegate respondsToSelector:@selector(captureSignInDidSucceed)])
        [signInDelegate captureSignInDidSucceed];

    engageSigninWasCanceled = NO;
}
@end
