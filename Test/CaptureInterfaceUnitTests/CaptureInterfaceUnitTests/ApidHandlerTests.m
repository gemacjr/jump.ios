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
#import "JSONKit.h"

@interface JRCaptureObject (TestCategory)
+ (void)testCaptureObjectApidHandlerUpdateCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureArrayDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
@end

@interface JRCaptureUser (TestCategory)
+ (void)testCaptureUserApidHandlerCreateCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;
+ (void)testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;
@end

@interface e2_ApidHandlerTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate, JRCaptureUserTesterDelegate>
{
    JRCaptureUser *captureUser;
    NSMutableDictionary *defaultContext;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSMutableDictionary *defaultContext;
@end

@implementation e2_ApidHandlerTests
@synthesize captureUser;
@synthesize defaultContext;
@synthesize logWriter;

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
    self.defaultContext = [NSMutableDictionary dictionaryWithObjectsAndKeys:self, @"delegate",
                                               NSStringFromSelector(self.currentSelector), @"callerContext", nil];
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set a boolean with an NSNumber boolean */
- (void)test_e201_foo
{
    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:@"fjdkjfkldjaklfjdal;dfa" context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    GHTestLog(result);
    GHTestLog(context);
    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(@"test_e201_foo")];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)createCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)createCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{

}

- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context
{

}

- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context
{

}

- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context
{

}

- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context
{

}

- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context
{

}

- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context
{

}

- (void)replaceArrayDidFailForObject:(JRCaptureObject *)object arrayNamed:(NSString *)arrayName withError:(NSError *)error context:(NSObject *)context
{

}

- (void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object newArray:(NSArray *)replacedArray named:(NSString *)arrayName context:(NSObject *)context
{

}

- (void)replaceDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{

}

- (void)replaceDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{

}

- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{

}

- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{

}


- (void)dealloc
{
    [captureUser release];
    [defaultContext release];
    [super dealloc];
}
@end

