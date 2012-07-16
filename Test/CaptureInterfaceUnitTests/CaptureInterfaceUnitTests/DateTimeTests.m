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
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"

@interface a6_DateTimeTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
    NSDate *currentDate;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSDate *currentDate;
@end

@implementation a6_DateTimeTests
@synthesize captureUser;
@synthesize currentDate;

- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];

    self.currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (void)tearDownClass
{
    DLog(@"");
    self.captureUser = nil;
    self.currentDate = nil;
}

- (void)setUp
{
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set a dateTime with a date object */
- (void)test_a601_dateTimeWithDate
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDateTime = currentDate;
    GHAssertTrue([captureUser.basicDateTime isEqualToDate:currentDate], nil);
    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], [currentDate stringFromISO8601DateTime], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a date with an ISO8601 date string*/
- (void)test_a602_dateTimeWithValidISO8601String
{
    DLog(@"");
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    /* yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ */
    captureUser.basicDateTime = [NSDate dateFromISO8601DateTimeString:@"2012-03-12 01:23:45.123000 +0000"];
    GHAssertNotNil(captureUser.basicDateTime, nil);
    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12 01:23:45.123000 +0000", nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a602a_dateTimeWithValidISO8601Strings
{
    DLog(@"");
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDateTime = [NSDate dateFromISO8601DateTimeString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDateTime, nil);
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"TODO", nil);
}

- (void)test_a602b_dateTimeWithValidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDateTime = [NSDate dateFromISO8601DateTimeString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDateTime, nil);
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

- (void)test_a602c_dateTimeWithValidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDateTime = [NSDate dateFromISO8601DateTimeString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDateTime, nil);
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

- (void)test_a602d_dateTimeWithValidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDateTime = [NSDate dateFromISO8601DateTimeString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDateTime, nil);
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

// TODO:...

/* Set a date with a non-ISO8601 date string */
- (void)test_a603_dateTimeWithInvalidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDateTime = [NSDate dateFromISO8601DateTimeString:@"abcdefghijklmnopqrstuvwxyz"];
    GHAssertNil(captureUser.basicDateTime, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a date with a datetime */
- (void)test_a604_dateTimeWithDate
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:@"2012-03-12"];

    captureUser.basicDateTime = date;
    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12 00:00:00.000000 +0000", nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a date to null */
- (void)test_a605_dateTimeWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDateTime = nil;
    GHAssertNil(captureUser.basicDateTime, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Test various dates to verify stringFromISO8601DateTime */
- (void)test_a606a_iso8601DateTimeStringWithDateTime
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    static NSDateFormatter *dateFormatter = nil;
//    if (!dateFormatter)
//    {
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    }
//
//    [dateFormatter setDateFormat:@"TODO yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:@"2012-03-12"];
//
//    captureUser.basicDateTime = date;
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

- (void)test_a606b_iso8601DateTimeStringWithDateTime
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    static NSDateFormatter *dateFormatter = nil;
//    if (!dateFormatter)
//    {
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    }
//
//    [dateFormatter setDateFormat:@"TODO yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:@"2012-03-12"];
//
//    captureUser.basicDateTime = date;
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

- (void)test_a606c_iso8601DateTimeStringWithDateTime
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    static NSDateFormatter *dateFormatter = nil;
//    if (!dateFormatter)
//    {
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    }
//
//    [dateFormatter setDateFormat:@"TODO yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:@"2012-03-12"];
//
//    captureUser.basicDateTime = date;
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

- (void)test_a606d_iso8601DateTimeStringWithDateTime
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    static NSDateFormatter *dateFormatter = nil;
//    if (!dateFormatter)
//    {
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    }
//
//    [dateFormatter setDateFormat:@"TODO yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:@"2012-03-12"];
//
//    captureUser.basicDateTime = date;
//    GHAssertEqualStrings([captureUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12", nil);
}

// TODO...

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_a601_dateTimeWithDate"])
        {
            GHAssertEqualStrings([newUser.basicDateTime stringFromISO8601DateTime], [currentDate stringFromISO8601DateTime], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a602_dateTimeWithValidISO8601String"])
        {
            GHAssertEqualStrings([newUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12 01:23:45.123000 +0000", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a603_dateTimeWithInvalidISO8601Strings"])
        {
            GHAssertNil(newUser.basicDateTime, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a604_dateTimeWithDate"])
        {
            GHAssertEqualStrings([newUser.basicDateTime stringFromISO8601DateTime], @"2012-03-12 00:00:00.000000 +0000", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a605_dateTimeWithNil"])
        {
            GHAssertNil(newUser.basicDateTime, nil);
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
    [currentDate release];
    [super dealloc];
}
@end
