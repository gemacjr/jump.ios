//
// Created by lillialexis on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharedData.h"
#import "JRCaptureUser+Extras.h"

@interface SharedData ()
@property (retain) JRCaptureUser *captureUser;
@property (retain) id<SharedDataDelegate> delegate;
@end

@implementation SharedData
@synthesize captureUser;
@synthesize delegate;

static SharedData *singleton = nil;

static NSString *captureApidDomain  = @"https://mobile.dev.janraincapture.com";
static NSString *captureUIDomain    = @"https://mobile.dev.janraincapture.com";
static NSString *clientId           = @"zc7tx83fqy68mper69mxbt5dfvd7c2jh";
static NSString *entityTypeName     = @"test_user1";
static NSString *accessToken        = @"ve5agstyyb9gqzjm";

- (id)init
{
    if ((self = [super init]))
    {
        [JRCapture setCaptureApiDomain:captureApidDomain captureUIDomain:captureUIDomain
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
    return [self sharedData];
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
    [JRCaptureApidInterface getCaptureUserWithToken:accessToken forDelegate:[SharedData sharedData] withContext:nil];
}

- (void)getCaptureUserDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate getCaptureUserDidFailWithResult:result];
    [self setDelegate:nil];
}

- (void)getCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    [self setCaptureUser:[JRCaptureUser captureUserObjectFromDictionary:captureProfile]];

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

    return captureUser;
}


- (void)dealloc
{
    [captureUser release];
    [delegate release];
    [super dealloc];
}
@end
