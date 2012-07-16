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

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "ClassCategories.h"
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"

@interface c1_ConstraintsTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
    NSArray  *currentPlural;
    NSObject *currentObject;

    BOOL weArePostReplace;
    BOOL weAreReplacingToTestPostReplace;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSArray  *currentPlural;
@property (retain) NSObject *currentObject;
@end

@implementation c1_ConstraintsTests
@synthesize captureUser, currentPlural, currentObject;

- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];
}

- (void)tearDownClass
{
    DLog(@"");
}

- (void)setUp
{
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.captureUser = nil;
}


/* unique */
- (void)test_c101_pluralUniqueCreateValid
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
    JRPluralTestUniqueElement *jrptue1 = [JRPluralTestUniqueElement pluralTestUniqueElement];
    jrptue1.string1 = @"asteroids";
    jrptue1.string2 = @"battlezone";
    jrptue1.uniqueString = @"centipede";

    JRPluralTestUniqueElement *jrptue2 = [JRPluralTestUniqueElement pluralTestUniqueElement];
    jrptue2.string1 = @"amnesia";
    jrptue2.string2 = @"bridgeport";
    jrptue2.uniqueString = @"cascade";

    self.currentPlural = captureUser.pluralTestUnique = [NSArray arrayWithObjects:jrptue1, jrptue2, nil];

    [self prepare];
    [captureUser replacePluralTestUniqueArrayOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c102_pluralUniqueCreateInvalid
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
    JRPluralTestUniqueElement *jrptue1 = [JRPluralTestUniqueElement pluralTestUniqueElement];
    jrptue1.string1 = @"asteroids";
    jrptue1.string2 = @"battlezone";
    jrptue1.uniqueString = @"centipede";

    JRPluralTestUniqueElement *jrptue2 = [JRPluralTestUniqueElement pluralTestUniqueElement];
    jrptue2.string1 = @"asteroids";
    jrptue2.string2 = @"battlezone";
    jrptue2.uniqueString = @"centipede";

    self.currentPlural = captureUser.pluralTestUnique = [NSArray arrayWithObjects:jrptue1, jrptue2, nil];

    [self prepare];
    [captureUser replacePluralTestUniqueArrayOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// required
- (void)test_c111_objectRequiredCreate
{
    JRObjectTestRequired *jrotr = [JRObjectTestRequired objectTestRequiredWithRequiredString:@"amazon"];
    captureUser.objectTestRequired = jrotr;

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c112_objectRequiredCreateInvalid
{
    JRObjectTestRequired *jrotr = [JRObjectTestRequired objectTestRequired];
    jrotr.requiredString = nil;
    jrotr.string1 = @"antimony";
    jrotr.string2 = @"basalt";
    captureUser.objectTestRequired = jrotr;

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c113_objectRequiredCopy
{
    GHAssertFalse(YES, @"Implement me!");
}

- (void)test_c114_objectRequiredEquals
{
    GHAssertFalse(YES, @"Implement me!");
}

// alphanumeric
- (void)test_c121_stringAlphanumeric
{
    captureUser.stringTestAlphanumeric = @"abc123";

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c122_stringAlphaNumericInvalid
{
    captureUser.stringTestAlphanumeric = @"!@#$%^&*()";

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// alphabetic
- (void)test_c131_stringAlphabetic
{
    JRPluralTestAlphabeticElement *const element = [JRPluralTestAlphabeticElement pluralTestAlphabeticElement];
    element.uniqueString = @"abc";
    self.currentPlural = captureUser.pluralTestAlphabetic = [NSArray arrayWithObject:element];

    [self prepare];
    [captureUser replacePluralTestAlphabeticArrayOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c132_stringAlphabeticInvalid
{
    JRPluralTestAlphabeticElement *const element = [JRPluralTestAlphabeticElement pluralTestAlphabeticElement];
    element.uniqueString = @"abc123";
    self.currentPlural = captureUser.pluralTestAlphabetic = [NSArray arrayWithObject:element];

    [self prepare];
    [captureUser replacePluralTestAlphabeticArrayOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// unicode-letters
- (void)test_c141_stringUnicodeLetters
{
    captureUser.stringTestUnicodeLetters = @"\u0393"; // greek letter gamma

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c142_stringUnicodeLettersInvalid
{
    captureUser.stringTestUnicodeLetters = @"\u2615";

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// unicode-printable
- (void)test_c151_stringUnicodePrintable
{
    captureUser.stringTestUnicodePrintable = @"\u2615";

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

//- (void) test_c152_stringUnicodePrintableInvalid
//{
//    // \u202a ended up being OK
//    //captureUser.stringTestUnicodePrintable = @"\u202a";
//
//    [self prepare];
//    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
//}

- (void)test_c153_stringUnicodePrintableInvalid
{
    captureUser.stringTestUnicodePrintable = @"\x11"; // XON control character

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// email-address
- (void)test_c161_stringEmailValid
{
    captureUser.stringTestEmailAddress = @"Rδοκιμή123abc.def+ghi@a.abπαράδειγμα.δοκιμή";

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_c162_stringEmailInvalid
{
    captureUser.stringTestEmailAddress = @"anemone";

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
        if ([testSelectorString isEqualToString:@"test_c111_objectRequiredCreate"])
        {
            GHAssertTrue([newUser.objectTestRequired isEqualToObjectTestRequired:captureUser.objectTestRequired], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_c121_stringAlphanumeric"])
        {
            GHAssertTrue([newUser.stringTestAlphanumeric isEqualToString:captureUser.stringTestAlphanumeric], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_c141_stringUnicodeLetters"])
        {
            GHAssertTrue([newUser.stringTestUnicodeLetters isEqualToString:captureUser.stringTestUnicodeLetters], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_c151_stringUnicodePrintable"])
        {
            GHAssertTrue([newUser.stringTestUnicodePrintable isEqualToString:captureUser.stringTestUnicodePrintable], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_c161_stringEmailValid"])
        {
            GHAssertTrue([newUser.stringTestEmailAddress isEqualToString:captureUser.stringTestEmailAddress], nil);
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

    @try
    {
        if ([testSelectorString isEqualToString:@"test_c112_objectRequiredCreateInvalid"])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
        else if ([testSelectorString isEqualToString:@"test_c122_stringAlphaNumericInvalid"])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
        else if ([testSelectorString isEqualToString:@"test_c142_stringUnicodeLettersInvalid"])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
        else if ([testSelectorString isEqualToString:@"test_c152_stringUnicodePrintableInvalid"])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
        else if ([testSelectorString isEqualToString:@"test_c153_stringUnicodePrintableInvalid"])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
        else if ([testSelectorString isEqualToString:@"test_c162_stringEmailInvalid"])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
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

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object
didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_c101_pluralUniqueCreateValid"])
        {
            GHAssertTrue([newArray isEqualToPluralTestUniqueArray:currentPlural], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_c131_stringAlphabetic"])
        {
            GHAssertTrue([newArray isEqualToPluralTestAlphabeticArray:currentPlural], nil);
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
//    DLog(@"result: %@", result);
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSString     *error            = [resultDictionary objectForKey:@"error"];
    NSNumber     *code             = [resultDictionary objectForKey:@"code"];

    NSString *testSelectorString = (NSString *)context;

    if ([testSelectorString isEqualToString:@"test_c102_pluralUniqueCreateInvalid"])
    {
        if ([error isEqualToString:@"unique_violation"] && [code isEqualToNumber:[NSNumber numberWithInteger:361]])
        {
            [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
            return;
        }
    }
    else if ([testSelectorString isEqualToString:@"test_c132_stringAlphabeticInvalid"])
    {
        if ([error isEqualToString:@"constraint_violation"] && [code isEqualToNumber:[NSNumber numberWithInteger:360]])
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
