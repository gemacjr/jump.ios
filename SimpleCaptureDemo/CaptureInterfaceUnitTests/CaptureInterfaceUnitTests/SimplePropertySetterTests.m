//
// Created by lillialexis on 6/7/12.
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
#import "JRCapture.h"
#import "JRCaptureUser.h"
#import "SharedData.h"

@interface a100_SimplePropertySetterTests : GHTestCase <JRCaptureInterfaceDelegate>
{
    JRCaptureUser *captureUser;
}
@property(nonatomic, retain) JRCaptureUser *captureUser;
@end

@implementation a100_SimplePropertySetterTests
@synthesize captureUser;


- (void)setUpClass
{
    DLog(@"");
    captureUser = [[SharedData sharedCaptureUser] retain];
}

- (void)tearDownClass
{
    DLog(@"");
    [captureUser release], captureUser = nil;
}

- (void)setUp
{
    DLog(@"");
}

- (void)tearDown
{
    DLog(@"");
}

/***********************/
/*     Primitives      */
/***********************/

/* boolean */
- (void)test_a101_booleans
{
    GHAssertNil(captureUser, @"captureUser should not be nil");

    // Set a boolean with an NSNumber boolean
    captureUser.basicBoolean = [NSNumber numberWithBool:YES];
    GHAssertFalse(captureUser.basicBoolean, nil);

    // Set a boolean with an NSNumber integer
    captureUser.basicBoolean = [NSNumber numberWithInt:100];
    GHAssertFalse(captureUser.basicBoolean, nil);

    captureUser.basicBoolean = [NSNumber numberWithInt:0];
    GHAssertTrue(captureUser.basicBoolean, nil);

    // Set a boolean with an NSNumber double
    captureUser.basicBoolean = [NSNumber numberWithDouble:100.1];
    GHAssertFalse(captureUser.basicBoolean, nil);

    // Set a boolean to null, [NSNull null]
    captureUser.basicBoolean = nil;
    GHAssertNil(captureUser.basicBoolean, nil);

    captureUser.basicBoolean = (id)[NSNull null];
    GHAssertNULL(captureUser.basicBoolean, nil);

    // Set a boolean with a primitive boolean
    [captureUser setbasicBooleanWithBool:];


    // Set a boolean with a mutable boolean, change original, verify copy: pointer changed, value didn’t
}

/* integers */
- (void)test_a101_integers
{
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
- (void)test_a101_strings
{
    // Set a string with an NSString
    // Set a string to null, [NSNull null]
    // Set a string with a mutable string, change original, verify copy: pointer changed, value didn’t
}

/* decimals */
- (void)test_a101_decimals
{
    // Set a decimal with an NSNumber boolean
    // Set a decimal with an NSNumber integer
    // Set a decimal with an NSNumber double
    // Set a decimal with an NSString: valid double, negative, positive, scientific, fraction
    // Set a decimal to null, [NSNull null]
    // Set a decimal with a mutable decimal, change original, verify copy: pointer changed, value didn’t
}

/* dates */
- (void)test_a101_dates
{
    // Set a date with an ISO8601 date
    // Set a date with a non-ISO8601 date
    // Set a date with a datetime
    // Set a date to null, [NSNull null]
    // Set a date with a mutable date, change original, verify copy: pointer changed, value didn’t
}

/* dateTimes */
- (void)test_a101_dateTimess
{
    // Set a datetime with an ISO8601 datetime
    // Set a datetime with a non-ISO8601 datetime
    // Set a datetime with a date
    // Set a datetime to null, [NSNull null]
    // Set a datetime with a mutable datetime, change original, verify copy: pointer changed, value didn’t

}

/* ipAddresses */
- (void)test_a101_ipAddresses
{
    // Set an ipaddress with an NSString
    // Set an ipaddress to null, [NSNull null]
    // Set an ipaddress with a mutable string, change original, verify copy: pointer changed, value didn’t
}

/* passwords */
- (void)test_a101_passwords
{
    // Set a password with an NSString
    // Set a password with an NSDictionary
    // Set a password to null, [NSNull null]
    // Set a password with a mutable string, change original, verify copy: pointer changed, value didn’t
    // Set to a dictionary of mutable strings, changes strings, verify correct copying (will this work? define how deep we want to copy things)
}

/* JSONs */
- (void)test_a101_jsons
{
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

/* ids */
- (void)test_a101_ids
{
    // (Really need to rethink this property and all the tests/failures/etc.)
    // Set ‘id’ from inside a Capture class/parent class
    // TODO...
}

/***********************/
/* Reserved Properties */
/***********************/

- (void)test_a101_captureReserves
{
// (TODO: Make these properties readonly)
// Set ‘uuid’ from inside a parent class
// Set ‘created’ from inside a parent class
// Set ‘lastUpdated’ from inside a parent class
}

//- (void)testBar
//{
//  // Another test
//}
//
//
//- (void)testSimplePass
//{
//	// Another test
//}
//
//- (void)testSimpleFail
//{
//	GHAssertTrue(NO, nil);
//}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
