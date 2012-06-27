//
// Created by lillialexis on 6/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"

@interface AcmeTest : GHAsyncTestCase <SharedDataDelegate>
{ }
@end

@implementation AcmeTest

- (void)testGetUserFromCapture {

  [self prepare];

  [SharedData getCaptureUserForDelegate:self];

  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)getCaptureUserDidSucceedWithUser:(JRCaptureUser *)user
{
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetUserFromCapture)];
}

- (void)getCaptureUserDidFailWithResult:(NSString *)result
{
    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetUserFromCapture)];
}
@end
