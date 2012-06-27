//
// Created by lillialexis on 6/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"

@interface a7_IPAddressTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a7_IPAddressTests
@synthesize captureUser;

- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];
}

- (void)tearDownClass
{
    DLog(@"");
    self.captureUser = nil;
}

- (void)setUp
{
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.captureUser = nil;
}


/* Set an ipaddress with an NSString */
- (void)test_a701_ipAddressWithString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicIpAddress = @"127.0.0.1";
    GHAssertEqualStrings(captureUser.basicIpAddress, @"127.0.0.1", nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an ipaddress to null */
- (void)test_a702_ipAddressWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicIpAddress = nil;
    GHAssertNil(captureUser.basicIpAddress, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an ipaddress to a string that isn't an ipaddress */
- (void)test_a703_ipAddressWithNonIpAddress_FailCase
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicIpAddress = @"abcdefghijklmnopqrstuvwxyz";
    GHAssertEqualStrings(captureUser.basicIpAddress, @"abcdefghijklmnopqrstuvwxyz", nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_a701_ipAddressWithString"])
        {
            GHAssertEqualStrings(newUser.basicIpAddress, @"127.0.0.1", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a702_ipAddressWithNil"])
        {
            GHAssertNil(newUser.basicIpAddress, nil);
        }
        /* Test succeeds if Capture sends back an error */
        else if ([testSelectorString isEqualToString:@"test_a703_ipAddressWithNonIpAddress"])
        {
            GHAssertFalse(TRUE, @"Updating basicIpAddress to a non-ipAdress should fail on Capture");
        }
        else
        {
            GHAssertFalse(TRUE, @"Missing test result comparison for %@ in %@", testSelectorString, NSStringFromSelector(_cmd));
        }
    }
    @catch (NSException *exception)
    {
        GHTestLog([exception description]);
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];

        return;
    }

    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSString     *argument_name    = [resultDictionary objectForKey:@"argument_name"];
    NSString     *error            = [resultDictionary objectForKey:@"error"];
    NSNumber     *code             = [resultDictionary objectForKey:@"code"];

    NSString *testSelectorString = (NSString *)context;

    if ([testSelectorString isEqualToString:@"test_a703_ipAddressWithNonIpAddress_FailCase"])
    {   /* {"error_description":"/basicIpAddress was not a valid ip address.","stat":"error","code":200,"error":"invalid_argument","argument_name":"/basicIpAddress"} */
        if ([error isEqualToString:@"invalid_argument"] &&
            [argument_name isEqualToString:@"/basicIpAddress"] &&
            [code isEqualToNumber:[NSNumber numberWithInteger:200]])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
    }

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
