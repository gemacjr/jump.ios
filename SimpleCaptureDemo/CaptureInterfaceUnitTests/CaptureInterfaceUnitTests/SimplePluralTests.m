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

#define _sel       NSStringFromSelector(_cmd)
#define _csel      [NSString stringWithFormat:@"%@%@%@", @"continue", @".", _sel]
#define _fsel      [NSString stringWithFormat:@"%@%@%@", @"finish", @".", _sel]
#define _esel      [NSString stringWithFormat:@"%@%@%@", @"fail", @".", _sel]
#define _ctel(str) [NSString stringWithFormat:@"%@%@%@", @"continue", @".", str]
#define _cnel(n,s) [NSString stringWithFormat:@"%@%@%@%@", @"continue", n, @".", s]
#define _ftel(str) [NSString stringWithFormat:@"%@%@%@", @"finish", @".", str]
#define _nsel(str) NSSelectorFromString(str)

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "JRCaptureUser+Extras.h"
#import "JRStringPluralElement.h"

@interface b1_SimplePluralTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser         *captureUser;

    /* Variables to hold pointers to objects/plurals/plural elements we may be interested in checking */
    NSArray               *currentPlural;
    JRStringPluralElement *currentElement;

    NSArray *fillerFodder;
}
@property (retain) JRCaptureUser         *captureUser;
@property (retain) NSArray               *currentPlural;
@property (retain) JRStringPluralElement *currentElement;
@end

@implementation b1_SimplePluralTests
@synthesize captureUser;
@synthesize currentPlural;
@synthesize currentElement;

- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];

    fillerFodder = [[NSArray alloc] initWithObjects:
                                    @"apples", @"bananas", @"coconuts",
                                    @"alameda", @"beaumont", @"concordia",
                                    @"asteroids", @"battlezone", @"centipede",
                                    @"amnesia", @"bridgeport", @"cascade",
                                    @"akita", @"bulldog", @"collie",
                                    @"andromeda", @"bootes", @"capricorn",
                                    nil];
}

- (void)tearDownClass
{
    DLog(@"");
    self.captureUser    = nil;
    self.currentPlural  = nil;
    self.currentElement = nil;
}

- (void)setUp
{
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.currentPlural  = nil;
    self.currentElement = nil;
}

- (NSArray *)arrayOfStringPluralElementsWithType:(NSString *)type fillerFodderOffset:(NSUInteger)offset
{
    GHAssertLessThan(offset+3, [fillerFodder count], nil);

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];

    for (NSUInteger i = 0; i < 3; i++)
    {
        JRStringPluralElement *element = [JRStringPluralElement stringElementWithType:type];
        element.value = [fillerFodder objectAtIndex:i+offset];
        [array addObject:element];
    }

    return [[array copy] autorelease];
}

- (id)elementOfType:(NSString *)type fillerFodderOffset:(NSUInteger)offset
{
    GHAssertLessThan(offset+3, [fillerFodder count], nil);

    JRStringPluralElement *element = [JRStringPluralElement stringElementWithType:type];
    element.value = [fillerFodder objectAtIndex:0 + offset];

    return element;
}

- (void)updateElementValue:(JRStringPluralElement*)element toFillerFodderIndex:(NSUInteger)index
{
    element.value = [fillerFodder objectAtIndex:index];
}

/* Set value string with an NSString */
- (void)test_b101_simplePluralElement_WithString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set value string with a mutable string, change, verify copy */
- (void)test_b101_simplePluralElement_WithMutableString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set/Update value string to nil, [NSNull null] */
- (void)test_b101_simplePluralElement_WithNilValue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_b101_simplePluralElement_WithNSNullValue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Create/Update with type */
- (void)test_b101_simplePluralElement_WithType
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Create/Update without type */
- (void)test_b101_simplePluralElement_WithoutType
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set array with an array of strings */
/* Set array with an array of simple objects */
/* Set array with an array of strings and simple objects w correct type */
/* Set array with an array of strings and simple objects w correct type and other objects, verify only strings and simple objects present */
/* Set array with a mutable array, change original, verify copy: pointer changed, values didn’t */
/* Set array to array of mutable strings, changes strings, verify the new array’s strings are also changed */

/* Set/Update array with an null element */
- (void)test_b101_simplePlural_WithNSNullElement
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Update with a basic string */
/* Update with a string containing a json object string (what happens? should be nothing) */
/* Update with an empty string */
/* Update with null */
/* Update with a string of invalid characters */
/* Update with [NSNull null] */
/* Update with simple plural element that has the wrong type, verify error from Capture */
/* Update with simple plural element that has no type, verify error from Capture */
/* Update with simple plural element that has no ‘id’, verify error from Capture */
/* Replace with a basic string */
/* Replace with array set to null, [NSNull null] */
/* Replace with array set to an array of strings */
/* Replace with array set to an array of simple objects */
/* Replace with array set to an array of strings and simple objects w correct type */
/* Replace with array set to an array of strings and simple objects w correct type and other objects, verify only strings and simple objects present */





-(void)callSelectorPrefixed:(NSString *)prefixed withArguments:(NSObject *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    DLog(@"testSelectorString: %@", testSelectorString);

    NSString *newSelector = [NSString stringWithFormat:@"%@%@",
                                           [testSelectorString stringByReplacingOccurrencesOfString:@"test" withString:prefixed],
                                           @"_withArguments:andTestSelectorString:"];

    [self performSelector:_nsel(newSelector) withObject:arguments withObject:testSelectorString];
}

- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object
didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSArray      *resultArray      = [resultDictionary objectForKey:@"result"];

    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                newArray, @"newArray",
                                                                resultArray, @"resultArray",
                                                                object, @"captureObject",
                                                                result, @"result", nil];

    NSString *nextMethodPrefix   = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];
    @try
    {
        if ([nextMethodPrefix hasPrefix:@"continue"])
        {
            [self callSelectorPrefixed:nextMethodPrefix withArguments:arguments andTestSelectorString:testSelectorString];
            return;
        }
        else if ([nextMethodPrefix hasPrefix:@"finish"])
        {
            [self callSelectorPrefixed:nextMethodPrefix withArguments:arguments andTestSelectorString:testSelectorString];
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

- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object
        didFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *nextMethodPrefix   = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];

    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    if ([testSelectorString hasSuffix:@"FailCase"])
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
        return;
    }

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary        = [result objectFromJSONString];
    NSDictionary *captureObjectDictionary = [resultDictionary objectForKey:@"result"];

    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    object, @"captureObject",
                                                    captureObjectDictionary, @"captureObjectDictionary",
                                                    result, @"result", nil];

    NSString *nextMethodPrefix   = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];
    @try
    {
        if ([nextMethodPrefix hasPrefix:@"continue"])
        {
            [self callSelectorPrefixed:nextMethodPrefix withArguments:arguments andTestSelectorString:testSelectorString];
            return;
        }
        if ([nextMethodPrefix hasPrefix:@"finish"])
        {
            [self callSelectorPrefixed:nextMethodPrefix withArguments:arguments andTestSelectorString:testSelectorString];
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
    NSString *nextMethodPrefix   = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];

    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    if ([testSelectorString hasSuffix:@"FailCase"])
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
        return;
    }

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary        = [result objectFromJSONString];
    NSDictionary *captureObjectDictionary = [resultDictionary objectForKey:@"result"];

    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    object, @"captureObject",
                                                    captureObjectDictionary, @"captureObjectDictionary",
                                                    result, @"result", nil];

    NSString *nextMethodPrefix   = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];
    @try
    {
        if ([nextMethodPrefix hasPrefix:@"continue"])
        {
            [self callSelectorPrefixed:nextMethodPrefix withArguments:arguments andTestSelectorString:testSelectorString];
            return;
        }
        if ([nextMethodPrefix hasPrefix:@"finish"])
        {
            [self callSelectorPrefixed:nextMethodPrefix withArguments:arguments andTestSelectorString:testSelectorString];
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

- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *nextMethodPrefix   = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];

    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)dealloc
{
    [captureUser release];
    [currentElement release];
    [currentPlural release];
    [fillerFodder release];
    [super dealloc];
}
@end
