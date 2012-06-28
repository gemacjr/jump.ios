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

@interface a1_BooleanTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a1_BooleanTests
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

/* Set a boolean with an NSNumber boolean */
- (void)test_a101_booleanWithBoolTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithBool:YES];
    GHAssertTrue([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a102_booleanWithBoolFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithBool:NO];
    GHAssertFalse([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a boolean with an NSNumber integer */
- (void)test_a103_booleanWithIntTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithInt:100];
    GHAssertTrue([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a104_booleanWithIntFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithInt:0];
    GHAssertFalse([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a boolean with an NSNumber double */
- (void)test_a105_booleanWithDoubleTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithDouble:100.1];
    GHAssertTrue([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a106_booleanWithDoubleFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithDouble:0.0];
    GHAssertFalse([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a boolean to null, [NSNull null] */
- (void)test_a107_booleanWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = nil;
    GHAssertNil(captureUser.basicBoolean, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a108_booleanWithNSNull
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = (id)[NSNull null];
    GHAssertEqualObjects(captureUser.basicBoolean, [NSNull null], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a boolean with a primitive boolean setters/getters */
- (void)test_a109_primitiveSetterTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    [captureUser setBasicBooleanWithBool:YES];
    GHAssertTrue([captureUser getBasicBooleanBoolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a110_primitiveSetterFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    [captureUser setBasicBooleanWithBool:NO];
    GHAssertFalse([captureUser getBasicBooleanBoolValue],  nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_a101_booleanWithBoolTrue"])
        {
            GHAssertTrue([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a102_booleanWithBoolFalse"])
        {
            GHAssertFalse([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a103_booleanWithIntTrue"])
        {
            GHAssertTrue([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a104_booleanWithIntFalse"])
        {
            GHAssertFalse([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a105_booleanWithDoubleTrue"])
        {
            GHAssertTrue([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a106_booleanWithDoubleFalse"])
        {
            GHAssertFalse([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a107_booleanWithNil"])
        {
            GHAssertNil(newUser.basicBoolean, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a108_booleanWithNSNull"])
        {
            GHAssertNil(newUser.basicBoolean, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a109_primitiveSetterTrue"])
        {
            GHAssertTrue([newUser getBasicBooleanBoolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a110_primitiveSetterFalse"])
        {
            GHAssertFalse([newUser getBasicBooleanBoolValue], nil);
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
    NSString *testSelectorString = (NSString *)context;
    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
