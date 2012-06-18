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

@interface a3_StringTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a3_StringTests
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

/* Set a string with an NSString */
- (void)test_a301_stringWithString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicString = @"basic string";
    GHAssertEqualStrings(captureUser.basicString, @"basic string", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a string to null, [NSNull null] */
- (void)test_a302_stringWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.stringTestNull = nil;
    GHAssertNil(captureUser.stringTestNull, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a string with a mutable string, change original, verify copy: pointer changed, value didn’t */
- (void)test_a303_stringWithMutableString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSMutableString *mutableString = [NSMutableString stringWithString:@"mutable string"];

    captureUser.basicString = mutableString;
    GHAssertEqualStrings(captureUser.basicString, @"mutable string", nil);

    [mutableString appendString:@"now mutated"];

    GHAssertEqualStrings(captureUser.basicString, @"mutable string", nil);
    GHAssertNotEquals(captureUser.basicString, mutableString, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a string with a json object string (what happens? should be nothing) */
- (void)test_a304_stringWithJsonString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.stringTestJson = @"{\"name\":\"stringTestJson\",\"id\":5,\"somePlural\":[\"one\",\"two\",\"three\"]}";
    GHAssertEqualStrings(captureUser.stringTestJson, @"{\"name\":\"stringTestJson\",\"id\":5,\"somePlural\":[\"one\",\"two\",\"three\"]}", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a string to an empty string */
- (void)test_a305_stringWithEmptyString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.stringTestEmpty = @"";
    GHAssertEqualStrings(captureUser.stringTestEmpty, @"", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a string to invalid characters */
- (void)test_a306_stringWithInvalidCharacters
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.stringTestInvalid = @"!@#$%^&*()<>?/\\;:\'\",.";
    GHAssertEqualStrings(captureUser.stringTestInvalid, @"!@#$%^&*()<>?/\\;:\'\",.", nil);

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
        if ([testSelectorString isEqualToString:@"test_a301_stringWithString"])
        {
            GHAssertEqualStrings(newUser.basicString, @"basic string", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a302_stringWithNil"])
        {
            GHAssertNil(newUser.stringTestNull, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a303_stringWithMutableString"])
        {
            GHAssertEqualStrings(newUser.basicString, @"mutable string", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a304_stringWithJsonString"])
        {
            GHAssertEqualStrings(newUser.stringTestJson, @"{\"name\":\"stringTestJson\",\"id\":5,\"somePlural\":[\"one\",\"two\",\"three\"]}", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a305_stringWithEmptyString"])
        {
            GHAssertEqualStrings(newUser.stringTestEmpty, @"", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a306_stringWithInvalidCharacters"])
        {
            GHAssertEqualStrings(newUser.stringTestInvalid, @"!@#$%^&*()<>?/\\;:\'\",.", nil);
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
