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

@interface a8_JSONPropertyTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a8_JSONPropertyTests
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

/* Set a json object with an NSNumber boolean */
- (void)test_a801_jsonWithBoolTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonNumber = [NSNumber numberWithBool:YES];
    GHAssertEquals([((NSNumber*)captureUser.jsonNumber) boolValue], YES, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json object with an NSNumber integer */
- (void)test_a802_jsonWithIntPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonNumber = [NSNumber numberWithInt:100];
    GHAssertEquals([((NSNumber *)captureUser.jsonNumber) intValue], 100, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json object with an NSNumber double */
- (void)test_a803_jsonWithDoublePositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonNumber = [NSNumber numberWithDouble:100.1];
    GHAssertEquals([((NSNumber *)captureUser.jsonNumber) intValue], 100.1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json object with an NSString */
- (void)test_a804_jsonWithString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonString = @"basic string";
    GHAssertEqualStrings(captureUser.jsonString, @"basic string", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json with an NSArray */
- (void)test_a805_jsonWithArrayObject
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSArray *array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];

    captureUser.jsonArray = array;
    GHAssertTrue([((NSArray *)captureUser.jsonArray) isEqualToArray:array], nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a806_jsonWithArrayString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonArray = @"[\"one\",\"two\",\"three\"]";
    GHAssertEqualStrings(captureUser.jsonArray, @"[\"one\",\"two\",\"three\"]", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json with an NSDictionary */
- (void)test_a807_jsonWithDictionaryObject
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"jsonDictionary", @"name",
                                                     [NSNumber numberWithInt:5], @"id",
                                                     [NSArray arrayWithObjects:@"one", @"two", @"three", nil], @"somePlural", nil];

    captureUser.jsonDictionary = dictionary;
    GHAssertTrue([((NSDictionary *)captureUser.jsonDictionary) isEqualToDictionary:dictionary], nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a808_jsonWithDictionaryString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonDictionary = @"{\"name\":\"stringTestJson\",\"id\":5,\"somePlural\":[\"one\",\"two\",\"three\"]}";
    GHAssertEqualStrings(captureUser.jsonDictionary, @"{\"name\":\"stringTestJson\",\"id\":5,\"somePlural\":[\"one\",\"two\",\"three\"]}", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json object to null */
- (void)test_a809_jsonWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonString = nil;
    GHAssertNil(captureUser.jsonString, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json object to an empty string */
- (void)test_a810_jsonWithEmptyString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonString = @"";
    GHAssertEqualStrings(captureUser.jsonString, @"", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json object to invalid characters */
- (void)test_a811_jsonWithInvalidCharacters
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonString = @"!@#$%^&*()<>?/\\;:\'\",.";
    GHAssertEqualStrings(captureUser.jsonString, @"!@#$%^&*()<>?/\\;:\'\",.", nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set to a dictionary of mutable strings, changes strings, verify correct copying (will this work? define how deep we want to copy things) */
- (void)test_a812_jsonWithMutableSubStrings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSMutableString *mutableString1 = [NSMutableString stringWithString:@"mutable string 1"];
    NSMutableString *mutableString2 = [NSMutableString stringWithString:@"mutable string 2"];

    NSArray *arrayOfMutableStrings  = [NSArray arrayWithObjects:mutableString1, mutableString2, nil];

    captureUser.jsonArray = arrayOfMutableStrings;
    GHAssertTrue([((NSArray *)captureUser.jsonArray) isEqualToArray:arrayOfMutableStrings], nil);

    [mutableString1 appendString:@"now mutated"];
    [mutableString1 appendString:@"now mutated too"];

    NSArray *newArray = [NSArray arrayWithObjects:@"mutable string 1", @"mutable string 2", nil];

    GHAssertTrue([((NSArray *)captureUser.jsonArray) isEqualToArray:arrayOfMutableStrings], nil);
    GHAssertTrue([((NSArray *)captureUser.jsonArray) isEqualToArray:newArray], nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a json with an NSObject that is not a number, string, array, or dictionary, verify not changed */
- (void)test_a813_jsonWithInvalidObject
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.jsonString = [NSBundle mainBundle];
    // TODO
    //GHAssertEqualStrings(captureUser.jsonString, @"!@#$%^&*()<>?/\\;:\'\",.", nil);

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
        if ([testSelectorString isEqualToString:@"test_a801_jsonWithBoolTrue"])
        {

            GHAssertEquals([((NSNumber*)newUser.jsonNumber) boolValue], YES, nil);

        }
        else if ([testSelectorString isEqualToString:@"test_a802_jsonWithIntPositive"])
        {
            GHAssertEquals([((NSNumber *)newUser.jsonNumber) intValue], 100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a803_jsonWithDoublePositive"])
        {
            GHAssertEquals([((NSNumber *)newUser.jsonNumber) intValue], 100.1, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a804_jsonWithString"])
        {
            GHAssertEqualStrings(newUser.jsonString, @"basic string", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a805_jsonWithArrayObject"])
        {
            NSArray *array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
            GHAssertTrue([((NSArray *)newUser.jsonArray) isEqualToArray:array], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a806_jsonWithArrayString"])
        {
            GHAssertEqualStrings(newUser.jsonArray, @"[\"one\",\"two\",\"three\"]", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a807_jsonWithDictionaryObject"])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             @"jsonDictionary", @"name",
                                                             [NSNumber numberWithInt:5], @"id",
                                                             [NSArray arrayWithObjects:@"one", @"two", @"three", nil], @"somePlural", nil];

            GHAssertTrue([((NSDictionary *)newUser.jsonDictionary) isEqualToDictionary:dictionary], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a808_jsonWithDictionaryString"])
        {
            GHAssertEqualStrings(newUser.jsonDictionary, @"{\"name\":\"stringTestJson\",\"id\":5,\"somePlural\":[\"one\",\"two\",\"three\"]}", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a809_jsonWithNil"])
        {
            GHAssertNil(newUser.jsonString, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a810_jsonWithEmptyString"])
        {
            GHAssertEqualStrings(newUser.jsonString, @"", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a811_jsonWithInvalidCharacters"])
        {
            GHAssertEqualStrings(newUser.jsonString, @"!@#$%^&*()<>?/\\;:\'\",.", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a812_jsonWithMutableSubStrings"])
        {
            NSArray *newArray = [NSArray arrayWithObjects:@"mutable string 1", @"mutable string 2", nil];

            GHAssertTrue([((NSArray *)newUser.jsonArray) isEqualToArray:newArray], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a813_jsonWithInvalidObject"])
        {
            GHAssertNil(newUser.jsonString, nil);
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
