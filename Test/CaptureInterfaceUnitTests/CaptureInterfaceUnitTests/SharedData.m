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

#import "SharedData.h"
#import "JRCapture.h"
#import "JRCaptureObject+Internal.h"

@interface SharedData ()
@property (retain) JRCaptureUser *captureUser;
@property (retain) id<SharedDataDelegate> delegate;
@end

@implementation SharedData
@synthesize captureUser;
@synthesize delegate;

static SharedData *singleton = nil;

static NSString *captureApidDomain  = @"mobile.dev.janraincapture.com";
static NSString *captureUIDomain    = @"mobile.dev.janraincapture.com";
static NSString *clientId           = @"zc7tx83fqy68mper69mxbt5dfvd7c2jh";
static NSString *entityTypeName     = @"test_user1";
static NSString *accessToken        = @"nh4re48an3eqn6c9";

- (id)init
{
    if ((self = [super init]))
    {
        [JRCapture setEngageAppId:nil captureApidDomain:captureApidDomain captureUIDomain:captureUIDomain
                         clientId:clientId andEntityTypeName:entityTypeName];
        [JRCapture setAccessToken:accessToken];
    }

    return self;
}

/* Return the singleton instance of this class. */
+ (SharedData *)sharedData
{
    if (singleton == nil) {
        singleton = (SharedData *) [[super allocWithZone:NULL] init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedData] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (JRCaptureUser *)sharedCaptureUser
{
    return [[SharedData sharedData] captureUser];
}

+ (void)getCaptureUserForDelegate:(id<SharedDataDelegate>)delegate
{
    [[SharedData sharedData] setDelegate:delegate];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [JRCaptureUser fetchCaptureUserFromServerForDelegate:[SharedData sharedData] context:nil];
}

- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate getCaptureUserDidFailWithResult:[error localizedFailureReason]];
    [self setDelegate:nil];
}

- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context
{
    [self setCaptureUser:fetchedUser];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate getCaptureUserDidSucceedWithUser:captureUser];
    [self setDelegate:nil];
}

+ (void)initializeCapture
{
    // Simply calling this will call the constructor if sharedData's singleton is null which will init Capture
    [SharedData sharedData];
}

+ (JRCaptureUser *)getBlankCaptureUser
{
    JRCaptureUser *captureUser  = [JRCaptureUser captureUser];
    captureUser.email = @"lilli@janrain.com";
    captureUser.objectTestRequired.requiredString = @"required";
    captureUser.objectTestRequiredUnique.requiredString = @"required";
    captureUser.objectTestRequiredUnique.requiredUniqueString = @"requiredUnique";

    [captureUser toReplaceDictionary];
    return captureUser;
}

- (void)dealloc
{
    [captureUser release];
    [delegate release];
    [super dealloc];
}
@end
