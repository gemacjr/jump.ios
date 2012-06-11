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
#import "JRCaptureUser+Extras.h"

@interface a4_StringTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a4_StringTests
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
    self.captureUser  = [JRCaptureUser captureUser];
    captureUser.email = @"lilli@janrain.com";
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set an integer with an NSNumber boolean */
- (void)test_a401_integerWithBoolTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a string with an NSString */
/* Set a string to null, [NSNull null] */
/* Set a string with a mutable string, change original, verify copy: pointer changed, value didn’t */
/* Set a string with a json object string (what happens? should be nothing) */
/* Set a string to an empty string */
/* Set a string to invalid characters */

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_a401_integerWithBoolTrue"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 1, nil);
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
    NSString *testSelectorString = (NSString *)context;
    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
