//
// Created by lillialexis on 6/27/12.
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
#import "JRCaptureObject+Internal.h"
#import "ClassCategories.h"

@interface d1_CaptureUserTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate, JRCaptureUserTesterDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation d1_CaptureUserTests
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
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set a boolean with an NSNumber boolean */
- (void)test_d101_booleanWithBoolTrue
{
    GHAssertNotNil(captureUser, @"captureUser should not be nil");

    captureUser.basicBoolean = [NSNumber numberWithBool:YES];
    GHAssertTrue([captureUser.basicBoolean boolValue], nil);

    [self prepare];
    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_d102_fetchLastUpdated
{
    [self prepare];
    [captureUser fetchLastUpdatedFromServerForDelegate:self context:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_d111_codingEmptyUser
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:captureUser];
    JRCaptureUser *t = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    GHAssertTrue([captureUser isEqualToCaptureUser:t], nil);
    GHAssertTrue([captureUser isEqualByPrivateProperties:t], nil);
}

- (void)test_d112_codingFetchedUser
{
    // capture path dirty property set can be updated or replaced
    [self prepare];
    void (^t)(JRCaptureUser *, NSError *) = ^(JRCaptureUser *u, NSError *e) {
            if (u)
            {
                self.captureUser = u;
                [self test_d111_codingEmptyUser];
                DLog("success");
                [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(test_d112_codingFetchedUser)];
            }
            else GHFail(nil);
        };
    t = [t copy];
    [JRCaptureUser fetchCaptureUserFromServerForDelegate:self context:t];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
    [t release];
    DLog("finished");
}

- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context
{
    void (^block)(JRCaptureUser *, NSError *) = (void (^)(JRCaptureUser *, NSError *)) context;
    if ([context isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        block(fetchedUser, nil);
        return;
    }

    GHFail(nil);
}

- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context
{
    void (^block)(JRCaptureUser *, NSError *) = (void (^)(JRCaptureUser *, NSError *)) context;
    if ([context isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        block(nil, error);
        return;
    }

    GHFail(nil);
}


- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context
{
    DLog("e: %@", [error description]);

    GHAssertFalse([captureUser respondsToSelector:NSSelectorFromString(@"lastUpdated")], nil);

    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated
                        isOutdated:(BOOL)isOutdated
                           context:(NSObject *)context
{
    DLog("lu: %@ io: %d", [serverLastUpdated description], isOutdated);
    GHAssertTrue([captureUser respondsToSelector:NSSelectorFromString(@"lastUpdated")], nil);

    //GHAssertTrue(isOutdated != [serverLastUpdated isEqual:[captureUser lastUpdated]]);

    //[self notify:kGHUnitWaitStatusSuccess];
    [self notify:kGHUnitWaitStatusFailure];
}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
