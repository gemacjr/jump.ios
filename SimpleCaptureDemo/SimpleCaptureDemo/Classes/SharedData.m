//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "SharedData.h"

#define cJRCurrentDisplayName @"simpleCaptureDemo.currentDisplayName"
#define cJRCurrentProvider    @"simpleCaptureDemo.currentProvider"
#define cJRCaptureUser        @"simpleCaptureDemo.captureUser"

@interface SharedData ()
@property (strong) NSUserDefaults     *prefs;
@property (strong) JRCaptureUser      *captureUser;
@property          BOOL                isNew;
@property          BOOL                notYetCreated;
@property (strong) NSString           *currentDisplayName;
@property (strong) NSString           *currentProvider;
@property (weak)   id<SignInDelegate>  signInDelegate;

@end

@implementation SharedData
static SharedData *singleton = nil;

static NSString *appId              = @"appcfamhnpkagijaeinl";
static NSString *captureApidDomain  = @"https://mobile.dev.janraincapture.com";
static NSString *captureUIDomain    = @"https://mobile.dev.janraincapture.com";
static NSString *clientId           = @"zc7tx83fqy68mper69mxbt5dfvd7c2jh";
static NSString *entityTypeName     = @"user_dev";

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
@synthesize currentDisplayName;
@synthesize currentProvider;
@synthesize signInDelegate;
@synthesize isNew;
@synthesize notYetCreated;


- (id)init
{
    if ((self = [super init]))
    {
        [JRCapture setEngageAppId:nil captureApidDomain:captureApidDomain
                  captureUIDomain:captureUIDomain clientId:clientId
                andEntityTypeName:entityTypeName];

       // [JRCapture setEngageAppId:appId];

        prefs = [NSUserDefaults standardUserDefaults];
        currentDisplayName = [prefs objectForKey:cJRCurrentDisplayName];
        currentProvider    = [prefs objectForKey:cJRCurrentProvider];

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

+ (NSString *)currentDisplayName
{
    return [[SharedData singletonInstance] currentDisplayName];
}

+ (NSString *)currentProvider
{
    return [[SharedData singletonInstance] currentProvider];
}

- (void)signoutCurrentUser
{
    self.currentDisplayName = nil;
    self.currentProvider    = nil;
    self.captureUser        = nil;

    self.isNew         = NO;
    self.notYetCreated = NO;

    [prefs setObject:nil forKey:cJRCurrentDisplayName];
    [prefs setObject:nil forKey:cJRCurrentProvider];
    [prefs setObject:nil forKey:cJRCaptureUser];
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

+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile
{
    NSString *name = nil;

    if ([profile objectForKey:@"preferredUsername"])
        name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
    else if ([[profile objectForKey:@"name"] objectForKey:@"formatted"])
        name = [NSString stringWithFormat:@"%@",
                [[profile objectForKey:@"name"] objectForKey:@"formatted"]];
    else
        name = [NSString stringWithFormat:@"%@%@%@%@%@",
                ([[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"givenName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"givenName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"middleName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"middleName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"familyName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"familyName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]] : @""];

    return name;
}

- (void)resaveCaptureUser
{
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

- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider
{
    self.currentDisplayName = [SharedData getDisplayNameFromProfile:[engageAuthInfo objectForKey:@"profile"]];
    self.currentProvider    = [provider copy];

    [prefs setObject:currentDisplayName forKey:cJRCurrentDisplayName];
    [prefs setObject:currentProvider forKey:cJRCurrentProvider];

    if ([signInDelegate respondsToSelector:@selector(engageSignInDidSucceed)])
        [signInDelegate engageSignInDidSucceed];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser status:(JRCaptureRecordStatus)captureRecordStatus
{
    DLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

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
}
@end
