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

@interface a4_DecimalTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation a4_DecimalTests
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
    [captureUser toUpdateDictionary];
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set a decimal with an NSNumber boolean */
- (void)test_a401_decimalWithBoolFalse_FailCase
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithBool:NO];
    GHAssertEquals([captureUser.basicDecimal boolValue], NO, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// Needs the update delegate fixed to work
//- (void)test_a401a_decimalWithNaN_FailCase
//{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");
//
//    captureUser.basicDecimal = [NSNumber numberWithDouble:NAN];
//    //GHAssertEquals([captureUser.basicDecimal doubleValue], NAN, nil);
//
//    [self prepare];
//    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
//}

/* Set a decimal with an NSNumber integer */
- (void)test_a402_decimalWithIntPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithInt:100];
    GHAssertEquals([captureUser.basicDecimal intValue], 100, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a403_decimalWithIntNegative
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithInt:-100];
    GHAssertEquals([captureUser.basicDecimal intValue], -100, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a decimal with an NSNumber double */
- (void)test_a404_decimalWithDoublePositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithDouble:100.1];
    GHAssertEquals([captureUser.basicDecimal doubleValue], 100.1, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a405_decimalWithDoubleScientific
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithDouble:1.0e-3];
    GHAssertEquals([captureUser.basicDecimal doubleValue], 1.0e-3, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a decimal with an NSString */
- (void)test_a406_decimalWithStringPositive
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithDouble:[@"0.25" doubleValue]];
    GHAssertEquals([captureUser.basicDecimal doubleValue], 0.25, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_a407_decimalWithStringInvalid
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = [NSNumber numberWithDouble:[@"badf00d" doubleValue]];
    GHAssertEquals([captureUser.basicDecimal intValue], 0, nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Set a decimal to null, [NSNull null] */
- (void)test_a408_decimalWithNil
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicDecimal = nil;
    GHAssertNil(captureUser.basicDecimal, nil);

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
        if ([testSelectorString isEqualToString:@"test_a401_decimalWithBoolFalse_FailCase"])
        {
            GHAssertFalse(TRUE, @"Test case %@ should have resulted in a Capture error, but didn't", testSelectorString);
        }
        else if ([testSelectorString isEqualToString:@"test_a402_decimalWithIntPositive"])
        {
            GHAssertEquals([newUser.basicDecimal intValue], 100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a403_decimalWithIntNegative"])
        {
            GHAssertEquals([newUser.basicDecimal intValue], -100, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a404_decimalWithDoublePositive"])
        {
            GHAssertEquals([newUser.basicDecimal doubleValue], 100.1, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a405_decimalWithDoubleScientific"])
        {
            GHAssertEquals([newUser.basicDecimal doubleValue], 1.0e-3, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a406_decimalWithStringPositive"])
        {
            GHAssertEquals([newUser.basicDecimal doubleValue], 0.25, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a407_decimalWithStringInvalid"])
        {
            GHAssertEquals([newUser.basicDecimal intValue], 0, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_a408_decimalWithNil"])
        {
            GHAssertNil(newUser.basicDecimal, nil);
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
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSString     *error            = [resultDictionary objectForKey:@"error"];
    NSNumber     *code             = [resultDictionary objectForKey:@"code"];

    NSString *testSelectorString = (NSString *)context;

    if ([testSelectorString isEqualToString:@"test_a401_decimalWithBoolFalse_FailCase"])
    {   /* ... "code":341,"error":"invalid_json_type" */
        if ([error isEqualToString:@"invalid_json_type"] &&
            [code isEqualToNumber:[NSNumber numberWithInteger:341]])
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
