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

@interface a5_DateTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
    NSDate *currentDate;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSDate *currentDate;
@end

@implementation a5_DateTests
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

/* Set a date with a date object */
- (void)test_a501_dateWithDate
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDate = currentDate;
    GHAssertTrue([captureUser.basicDate isEqualToDate:currentDate], nil);
    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], [currentDate stringFromISO8601Date], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a date with an ISO8601 date string*/
- (void)test_a502_dateWithValidISO8601String
{
    DLog(@"");
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"2012-03-12"];
    GHAssertNotNil(captureUser.basicDate, nil);
    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a502a_dateWithValidISO8601Strings
{
    DLog(@"");
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"20120312"];
    GHAssertNotNil(captureUser.basicDate, nil);
    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

- (void)test_a502b_dateWithValidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDate, nil);
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

- (void)test_a502c_dateWithValidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDate, nil);
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

- (void)test_a502d_dateWithValidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//    GHAssertFalse(TRUE, @"You have more tests to implement!!");

//    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"TODO"];
//    GHAssertNotNil(captureUser.basicDate, nil);
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

// TODO:...

/* Set a date with a non-ISO8601 date string */
- (void)test_a503_dateWithInvalidISO8601Strings
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"3-12-2012"];
    GHAssertNil(captureUser.basicDate, nil);

    captureUser.basicDate = [NSDate dateFromISO8601DateString:@"abcdefghijklmnopqrstuvwxyz"];
    GHAssertNil(captureUser.basicDate, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a date with a datetime */
- (void)test_a504_dateWithDateTime
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ"];
    NSDate *date = [dateFormatter dateFromString:@"2012-03-12 01:33:20.122198 +0000"];

    captureUser.basicDate = date;
    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a date to null */
- (void)test_a505_dateWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDate = nil;
    GHAssertNil(captureUser.basicDate, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Test various dates to verify stringFromISO8601Date */
- (void)test_a506a_iso8601DateStringWithDate
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
//    captureUser.basicDate = date;
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

- (void)test_a506b_iso8601DateStringWithDate
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
//    captureUser.basicDate = date;
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

- (void)test_a506c_iso8601DateStringWithDate
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
//    captureUser.basicDate = date;
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
}

- (void)test_a506d_iso8601DateStringWithDate
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
//    captureUser.basicDate = date;
//    GHAssertEqualStrings([captureUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
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
        if ([testSelectorString isEqualToString:@"test_a501_dateWithDate"])
        {
            GHAssertEqualStrings([newUser.basicDate stringFromISO8601Date], [currentDate stringFromISO8601Date], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a502_dateWithValidISO8601String"])
        {
            DLog(@"");
            GHAssertEqualStrings([newUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a503_dateWithInvalidISO8601Strings"])
        {
            GHAssertNil(newUser.basicDate, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a504_dateWithDateTime"])
        {
            GHAssertEqualStrings([newUser.basicDate stringFromISO8601Date], @"2012-03-12", nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a505_dateWithNil"])
        {
            GHAssertNil(newUser.basicDate, nil);
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
