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
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.captureUser = nil;
}


/* Set an integer with an NSNumber boolean */
- (void)test_a201_integerWithBoolTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a202_integerWithBoolFalse
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:NO];
    GHAssertEquals([captureUser.basicInteger integerValue], 0, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer with an NSNumber integer */
- (void)test_a203_integerWithIntPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithInt:100];
    GHAssertEquals([captureUser.basicInteger integerValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a204_integerWithIntNegative
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithInt:-100];
    GHAssertEquals([captureUser.basicInteger integerValue], -100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer with an NSNumber double */
- (void)test_a205_integerWithDoublePositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithDouble:100.1];
    GHAssertEquals([captureUser.basicInteger integerValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a206_integerWithDoubleScientific
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithDouble:1.0e-3];
    GHAssertEquals([captureUser.basicInteger integerValue], 0, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer with an NSString */
- (void)test_a207_integerWithStringPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithInteger:[@"100" integerValue]];
    GHAssertEquals([captureUser.basicInteger integerValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a208_integerWithStringInvalid
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithInteger:[@"badf00d" integerValue]];
    GHAssertEquals([captureUser.basicInteger integerValue], 0, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer to null, [NSNull null] */
- (void)test_a209_integerWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = nil;
    GHAssertNil(captureUser.basicInteger, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a210_integerWithNSNull
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = (id)[NSNull null];
    GHAssertEqualObjects(captureUser.basicInteger, [NSNull null], nil);

//    [self prepare];
//    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set an integer with a primitive integer setters/getters */
- (void)test_a211_primitiveSetterPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    [captureUser setBasicIntegerWithInteger:100];
    GHAssertEquals([captureUser.basicInteger integerValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a212_primitiveSetterNegative
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    [captureUser setBasicIntegerWithInteger:-100];
    GHAssertEquals([captureUser.basicInteger integerValue], -100, nil);

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
        if ([testSelectorString isEqualToString:@"test_a201_integerWithBoolTrue"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 1, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a202_integerWithBoolFalse"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 0, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a203_integerWithIntPositive"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a204_integerWithIntNegative"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], -100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a205_integerWithDoublePositive"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a206_integerWithDoubleScientific"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 0, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a207_integerWithStringPositive"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a208_integerWithStringInvalid"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 0, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a209_integerWithNil"])
        {
            GHAssertNil(newUser.basicInteger, nil);
        }
//        else if ([testSelectorString isEqualToString:@"test_a210_integerWithNSNull"])
//        {
//            GHAssertNil(newUser.basicInteger, nil);
//        }
        else if ([testSelectorString isEqualToString:@"test_a211_primitiveSetterPositive"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], 100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a212_primitiveSetterNegative"])
        {
            GHAssertEquals([newUser.basicInteger integerValue], -100, nil);
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
