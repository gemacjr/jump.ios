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

@interface a2_IntegerTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a2_IntegerTests
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
- (void)test_a201_numberWithBoolTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], INT_MAX, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a202_numberWithBoolFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 0, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer with an NSNumber integer */
- (void)test_a203_numberWithIntPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithInt:100];
    GHAssertEquals([captureUser.basicInteger integerValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a204_numberWithIntNegative
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithInt:-100];
    GHAssertEquals([captureUser.basicInteger integerValue], -100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer with an NSNumber double */
- (void)test_a205_numberWithDoublePositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithDouble:100.1];
    GHAssertEquals([captureUser.basicInteger integerValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a206_numberWithDoubleScientific
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithDouble:1.0e-3];
    GHAssertEquals([captureUser.basicInteger integerValue], 0, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer to null, [NSNull null] */
- (void)test_a207_integerFromNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = nil;
    GHAssertNil(captureUser.basicInteger, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a208_booleanFromNSNull
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = (id)[NSNull null];
    GHAssertEqualObjects(captureUser.basicInteger, [NSNull null], nil);

//    [self prepare];
//    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a boolean with a primitive boolean setters/getters */
- (void)test_a209_primitiveSetterTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    [captureUser setBasicBooleanWithBool:YES];
    GHAssertTrue([captureUser getBasicBooleanBoolValue], nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a210_primitiveSetterFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    [captureUser setBasicBooleanWithBool:NO];
    GHAssertFalse([captureUser getBasicBooleanBoolValue],  nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
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
        if ([testSelectorString isEqualToString:@"test_a201_numberWithBoolTrue"])
        {
            GHAssertTrue([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a201_numberWithBoolFalse"])
        {
            GHAssertFalse([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a203_numberWithIntTrue"])
        {
            GHAssertTrue([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a204_numberWithIntFalse"])
        {
            GHAssertFalse([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a205_numberWithDoubleTrue"])
        {
            GHAssertTrue([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a206_numberWithDoubleFalse"])
        {
            GHAssertFalse([newUser.basicBoolean boolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a207_booleanFromNil"])
        {
            GHAssertNil(newUser.basicBoolean, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a208_booleanFromNSNull"])
        {
            GHAssertNil(newUser.basicBoolean, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a209_primitiveSetterTrue"])
        {
            GHAssertTrue([newUser getBasicBooleanBoolValue], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a210_primitiveSetterFalse"])
        {
            GHAssertFalse([newUser getBasicBooleanBoolValue], nil);
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
