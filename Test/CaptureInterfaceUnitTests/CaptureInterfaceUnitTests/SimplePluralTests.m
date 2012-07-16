/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

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
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"

@interface b1_StringPluralTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
    NSArray       *currentPlural;
    NSArray       *previousPlural;

    NSArray *fillerFodder;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSArray       *currentPlural;
@property (copy)   NSArray       *previousPlural;
@end

@implementation b1_StringPluralTests
@synthesize captureUser;
@synthesize currentPlural;
@synthesize previousPlural;

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
    self.captureUser   = nil;
    self.currentPlural = nil;

}

- (void)setUp
{
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.currentPlural = nil;
}

- (NSArray *)arrayOfStringsWithfillerFodderOffset:(NSUInteger)offset
{
    GHAssertLessThan(offset+3, [fillerFodder count], nil);

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];

    for (NSUInteger i = 0; i < 3; i++)
        [array addObject:[NSString stringWithString:[fillerFodder objectAtIndex:i+offset]]];

    return [[array copy] autorelease];
}

/* Make an array of strings */
- (void)test_b101_stringPluralWithStrings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.simpleStringPluralOne = [self arrayOfStringsWithfillerFodderOffset:0];
    NSArray *dummyArray = [NSArray arrayWithObjects:@"apples", @"bananas", @"coconuts", nil];
    GHAssertTrue([captureUser.simpleStringPluralOne isEqualToArray:dummyArray], nil);

    // Wah wah! Not equal!
    //GHAssertEquals(captureUser.simpleStringPluralOne, dummyArray, nil);
}

// Maybe if we baby-proof against mutable elements in arrays we'll reinstate this test, but as it's written it fails
// because it assumes the properties do deep copies
///* Make an array of mutable strings, change strings, verify copy */
//- (void)test_b102_stringPluralWithMutableStrings
//{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//
//    NSArray *comparisonArray       = [self arrayOfStringsWithfillerFodderOffset:0];
//    NSArray *arrayOfMutableStrings = [NSArray arrayWithObjects:
//                                                      [NSMutableString stringWithString:@"apples"],
//                                                      [NSMutableString stringWithString:@"bananas"],
//                                                      [NSMutableString stringWithString:@"coconuts"], nil];
//
//    captureUser.simpleStringPluralOne = arrayOfMutableStrings;
//
//    for (NSMutableString *mutableString in arrayOfMutableStrings)
//        [mutableString appendString:@"_mutated"];
//
//    DLog(@"%@", [captureUser.simpleStringPluralOne description]);
//
//    // TODO: Is this ok??
//    GHAssertTrue([captureUser.simpleStringPluralOne isEqualToArray:comparisonArray], nil);
//    GHAssertNotEquals(captureUser.simpleStringPluralOne, arrayOfMutableStrings, nil);
//}

/* Make array with a mutable array, change original, verify copy: pointer changed, values didn't */
- (void)test_b103_stringPluralWithMutableArray
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSArray *comparisonArray     = [self arrayOfStringsWithfillerFodderOffset:0];
    NSArray *additionalArray     = [self arrayOfStringsWithfillerFodderOffset:3];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:comparisonArray];

    captureUser.simpleStringPluralOne = mutableArray;

    [mutableArray addObjectsFromArray:additionalArray];

    GHAssertTrue([captureUser.simpleStringPluralOne isEqualToArray:comparisonArray], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:mutableArray], nil);
}

/* Replace array of strings. */
- (void)test_b104_stringPluralReplace
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.simpleStringPluralOne = self.currentPlural = [self arrayOfStringsWithfillerFodderOffset:0];

    [self prepare];
    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_b104_stringPluralReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHAssertTrue([captureUser.simpleStringPluralOne isEqualToArray:currentPlural], nil);
}

/* Make with array with NSNull strings. Replace on Capture. */
- (void)test_b105_stringPluralReplace_WithNSNullElement
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSArray *arrayWithNulls = [NSArray arrayWithObjects:
                                       @"apples", @"bananas", @"coconuts",
                                       [NSNull null], [NSNull null], [NSNull null], nil];

    captureUser.simpleStringPluralOne = self.currentPlural = arrayWithNulls;

    [self prepare];
    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_b105_stringPluralReplace_WithNSNullElement_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHAssertTrue([captureUser.simpleStringPluralOne isEqualToArray:currentPlural], nil);
}

/* Make array with non-strings. Replace on Capture. */
- (void)test_b106_stringPluralReplace_WithNonStrings_FailCase
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicInteger = [NSNumber numberWithBool:YES];
    GHAssertEquals([captureUser.basicInteger integerValue], 1, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)stringPluralReset_ReplaceWithCurrentTestString:(NSString *)currentTestString
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    NSMutableArray *resetArray = [NSMutableArray arrayWithArray:[self arrayOfStringsWithfillerFodderOffset:0]];
    [resetArray addObjectsFromArray:[self arrayOfStringsWithfillerFodderOffset:3]];

    captureUser.simpleStringPluralOne = self.currentPlural = self.previousPlural = [NSArray arrayWithArray:resetArray];

    [self prepare];
    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ctel(currentTestString)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
}

- (void)addElementsToArray:(NSMutableArray *)array
{
    [array addObjectsFromArray:[self arrayOfStringsWithfillerFodderOffset:6]];
}

- (void)removeElementsFromArray:(NSMutableArray *)array
{
    [array removeObjectsInArray:[self arrayOfStringsWithfillerFodderOffset:3]];
}

- (void)changeElementsInArray:(NSMutableArray *)array
{
    [array replaceObjectAtIndex:0 withObject:[fillerFodder objectAtIndex:6]];
    [array replaceObjectAtIndex:1 withObject:[fillerFodder objectAtIndex:7]];
    [array replaceObjectAtIndex:2 withObject:[fillerFodder objectAtIndex:8]];
}

/* Replace array of strings. Add strings. Replace again. */
- (void)test_b107_stringPluralReplace_AddedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b107_stringPluralReplace_AddedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self addElementsToArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b107_stringPluralReplace_AddedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 9, nil);
}

/* Replace array of strings. Remove strings. Replace again. */
- (void)test_b108_stringPluralReplace_RemovedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b108_stringPluralReplace_RemovedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self removeElementsFromArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b108_stringPluralReplace_RemovedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 3, nil);
}

/* Replace array of strings. Change strings. Replace again. */
- (void)test_b109_stringPluralReplace_ChangedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b109_stringPluralReplace_ChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self changeElementsInArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b109_stringPluralReplace_ChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 6, nil);
}

/* Replace array of strings. Add and remove strings. Replace again. */
- (void)test_b110_stringPluralReplace_AddedRemovedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b110_stringPluralReplace_AddedRemovedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self addElementsToArray:newArray];
    [self removeElementsFromArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b110_stringPluralReplace_AddedRemovedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 6, nil);
}

/* Replace array of strings. Add and change strings. Replace again. */
- (void)test_b111_stringPluralReplace_AddedChangedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b111_stringPluralReplace_AddedChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self addElementsToArray:newArray];
    [self changeElementsInArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b111_stringPluralReplace_AddedChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 9, nil);
}

/* Replace array of strings. Remove and change strings. Replace again. */
- (void)test_b112_stringPluralReplace_RemovedChangedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b112_stringPluralReplace_RemovedChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self removeElementsFromArray:newArray];
    [self changeElementsInArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b112_stringPluralReplace_RemovedChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 3, nil);
}

/* Replace array of strings. Add and remove and change strings. Replace again. */
- (void)test_b113_stringPluralReplace_AddedRemovedChangedElements
{
    [self stringPluralReset_ReplaceWithCurrentTestString:_sel];
}

- (void)continue_b113_stringPluralReplace_AddedRemovedChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:captureUser.simpleStringPluralOne];
    [self addElementsToArray:newArray];
    [self removeElementsFromArray:newArray];
    [self changeElementsInArray:newArray];

    captureUser.simpleStringPluralOne = self.currentPlural = newArray;

    [captureUser replaceSimpleStringPluralOneArrayOnCaptureForDelegate:self context:_ftel(testSelectorString)];
}

- (void)finish_b113_stringPluralReplace_AddedRemovedChangedElements_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    GHTestLog(@"Test:            %@", testSelectorString);
    GHTestLog(@"Previous plural: %@", [previousPlural description]);
    GHTestLog(@"Current plural:  %@", [currentPlural description]);

    GHAssertTrue([currentPlural isEqualToArray:[arguments objectForKey:@"newArray"]], nil);
    GHAssertFalse([captureUser.simpleStringPluralOne isEqualToArray:previousPlural], nil);
    GHAssertTrue([captureUser.simpleStringPluralOne count] == 6, nil);
}



/* Replace with a string containing a json object string (what happens? should be nothing) */
/* Replace with an empty string */
/* Replace with a string of invalid characters */



-(void)callSelectorPrefixed:(NSString *)prefixed withArguments:(NSObject *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    DLog(@"testSelectorString: %@", testSelectorString);

    NSString *newSelector = [NSString stringWithFormat:@"%@%@",
                                           [testSelectorString stringByReplacingOccurrencesOfString:@"test" withString:prefixed],
                                           @"_withArguments:andTestSelectorString:"];

    if ([self respondsToSelector:_nsel(newSelector)])
        [self performSelector:_nsel(newSelector) withObject:arguments withObject:testSelectorString];
    else
        GHTestLog(@"The selector %@ has not been implemented!!", newSelector);
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
    [currentPlural release];
    [fillerFodder release];
    [previousPlural release];
    [super dealloc];
}
@end
