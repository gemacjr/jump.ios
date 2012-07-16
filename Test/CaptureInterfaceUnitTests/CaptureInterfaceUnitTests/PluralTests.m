#import "debug_log.h"
#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"

@interface z1_PluralTests : GHAsyncTestCase <JRCaptureObjectTesterDelegate>
{
    JRCaptureUser *captureUser;
}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation z1_PluralTests
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

- (void)test_z100_assignInvalidPluralElements
{
    [self prepare];
    captureUser.basicPlural = ([NSArray arrayWithObject:@"asldkjf"]);
    UpdateCallback updateCallback = ^(JRCaptureObject *o, NSError *e)
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:_cmd];
    };
    updateCallback = [updateCallback copy];
    [captureUser updateOnCaptureForDelegate:self context:updateCallback];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
    [updateCallback release];
}

- (void)test_z101_replaceInvalidPluralElements
{
    [self prepare];
    captureUser.basicPlural = ([NSArray arrayWithObject:@"asldkjf"]);
    ReplaceArrayCallback replaceCallback = ^(NSArray *a, NSError *e)
    {
        GHAssertTrue([a count] == 0, nil);
        [self notify:kGHUnitWaitStatusSuccess forSelector:_cmd];
    };
    replaceCallback = [replaceCallback copy];
    [captureUser replaceBasicPluralArrayOnCaptureForDelegate:self withContext:replaceCallback];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
    [replaceCallback release];
}

- (void)replaceArrayDidFailForObject:(JRCaptureObject *)object arrayNamed:(NSString *)arrayName
                           withError:(NSError *)error context:(NSObject *)context
{
    ReplaceArrayCallback block = (ReplaceArrayCallback) context;
    if ([context isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        block(nil, error);
        return;
    }

    GHFail(nil);
}

- (void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object newArray:(NSArray *)replacedArray
                                  named:(NSString *)arrayName context:(NSObject *)context
{
    ReplaceArrayCallback block = (ReplaceArrayCallback) context;
    if ([context isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        block(replacedArray, nil);
        return;
    }

    GHFail(nil);
}

- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    UpdateCallback block = (UpdateCallback) context;
    if ([context isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        block(object, nil);
        return;
    }

    GHFail(nil);
}

- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    UpdateCallback block = (UpdateCallback) context;
    if ([context isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        block(nil, error);
        return;
    }

    GHFail(nil);
}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
