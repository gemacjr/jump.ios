//
// Created by lillialexis on 6/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "JRCaptureUser+Extras.h"

@interface b100_SimplePropertyUpdateTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{ }
@end

@implementation b100_SimplePropertyUpdateTests
/***********************/
/*     Primitives      */
/***********************/

/* boolean */
- (void)test_b101_booleans
{

    [self prepare];

    JRCaptureUser *captureUser = [JRCaptureUser captureUser];

    captureUser.email = @"lilli@janrain.com";
    captureUser.basicBoolean = [NSNumber numberWithBool:YES];

    [captureUser updateObjectOnCaptureForDelegate:self withContext:@"test_b101_booleans"];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* integers */
- (void)test_b102_integers
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set an integer with an NSNumber boolean
    // Set an integer with an NSNumber integer
    // Set an integer with an NSNumber double
    // Set an integer with an NSString: valid integer, negative, positive, scientific
    // Set an integer to null, [NSNull null]
    // Set an integer with a primitive integer
    // Set an integer with a mutable integer, change original, verify copy: pointer changed, value didn’t
}

/***********************/
/*   Non-Primitives    */
/***********************/

/* strings */
- (void)test_b103_strings
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set a string with an NSString
    // Set a string to null, [NSNull null]
    // Set a string with a mutable string, change original, verify copy: pointer changed, value didn’t
}

/* decimals */
- (void)test_b104_decimals
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set a decimal with an NSNumber boolean
    // Set a decimal with an NSNumber integer
    // Set a decimal with an NSNumber double
    // Set a decimal with an NSString: valid double, negative, positive, scientific, fraction
    // Set a decimal to null, [NSNull null]
    // Set a decimal with a mutable decimal, change original, verify copy: pointer changed, value didn’t
}

/* dates */
- (void)test_b105_dates
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set a date with an ISO8601 date
    // Set a date with a non-ISO8601 date
    // Set a date with a datetime
    // Set a date to null, [NSNull null]
    // Set a date with a mutable date, change original, verify copy: pointer changed, value didn’t
}

/* dateTimes */
- (void)test_b106_dateTimess
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set a datetime with an ISO8601 datetime
    // Set a datetime with a non-ISO8601 datetime
    // Set a datetime with a date
    // Set a datetime to null, [NSNull null]
    // Set a datetime with a mutable datetime, change original, verify copy: pointer changed, value didn’t
}

/* ipAddresses */
- (void)test_b107_ipAddresses
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set an ipaddress with an NSString
    // Set an ipaddress to null, [NSNull null]
    // Set an ipaddress with a mutable string, change original, verify copy: pointer changed, value didn’t
}

/* passwords */
- (void)test_b108_passwords
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set a password with an NSString
    // Set a password with an NSDictionary
    // Set a password to null, [NSNull null]
    // Set a password with a mutable string, change original, verify copy: pointer changed, value didn’t
    // Set to a dictionary of mutable strings, changes strings, verify correct copying (will this work? define how deep we want to copy things)
}

/* JSONs */
- (void)test_b109_jsons
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // Set a json with an NSNumber boolean
    // Set a json with an NSNumber integer
    // Set a json with an NSNumber double
    // Set a json with an NSString
    // Set a json with an NSArray
    // Set a json with an NSDictionary
    // Set a json to null, [NSNull null]
    // Set a json with a mutable string, change original, verify copy: pointer changed, value didn’t
    // Set to a dictionary of mutable strings, changes strings, verify correct copying (will this work? define how deep we want to copy things)
}

/***********************/
/* Reserved Properties */
/***********************/

/* ids */
- (void)test_b110_ids
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    // (Really need to rethink this property and all the tests/failures/etc.)
    // Set ‘id’ from inside a Capture class/parent class
    // TODO...
}

/* uuid, created, lastUpdated */
- (void)test_b111_captureReserves
{
//    GHAssertNotNil(captureUser, @"captureUser should not be nil");

// (TODO: Make these properties readonly)
// Set ‘uuid’ from inside a parent class
// Set ‘created’ from inside a parent class
// Set ‘lastUpdated’ from inside a parent class
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b101_booleans"])
        {
            GHAssertTrue(newUser.basicBoolean, nil);
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


//- (void)getCaptureUserDidSucceedWithUser:(JRCaptureUser *)user
//{
//    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetUserFromCapture)];
//}
//
//- (void)getCaptureUserDidFailWithResult:(NSString *)result
//{

//}
@end
