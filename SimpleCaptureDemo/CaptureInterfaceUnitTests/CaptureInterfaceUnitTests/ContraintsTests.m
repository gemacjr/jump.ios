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

@interface c1_ConstraintsTests : GHAsyncTestCase <JRCaptureObjectDelegate>
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
    self.captureUser  = [JRCaptureUser captureUser];
    captureUser.email = @"lilli@janrain.com";
}

- (void)tearDown
{
    self.captureUser = nil;
}


/*  */
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
    [captureUser replacePluralTestUniqueArrayOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
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
    [captureUser replacePluralTestUniqueArrayOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}


// unique

// required
- (void)test_c111_objectRequiredCreate
{
    JRObjectTestRequired *jrotr = [JRObjectTestRequired objectTestRequiredWithRequiredString:@"amazon"];
    captureUser.objectTestRequired = jrotr;

    [self prepare];
    [captureUser updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

// alphabetic

// alphanumeric

// unicode-letters

// unicode-printable

// email-address

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
//            newUser.objectTestRequired.requiredString
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

- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object
didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_c101_createPluralWithValidElements"])
        {
            GHAssertTrue([newArray isEqualToOtherPluralTestUniqueArray:currentPlural], nil);
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

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}


- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
