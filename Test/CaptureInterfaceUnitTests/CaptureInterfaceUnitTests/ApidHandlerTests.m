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

#define _sel       NSStringFromSelector(_cmd)
#define _csel      [NSString stringWithFormat:@"%@%@%@", @"continue", @".", _sel]
#define _fsel      [NSString stringWithFormat:@"%@%@%@", @"finish", @".", _sel]
#define _esel      [NSString stringWithFormat:@"%@%@%@", @"fail", @".", _sel]
#define _ctel(str) [NSString stringWithFormat:@"%@%@%@", @"continue", @".", str]
#define _cnel(n,s) [NSString stringWithFormat:@"%@%@%@%@", @"continue", n, @".", s]
#define _ftel(str) [NSString stringWithFormat:@"%@%@%@", @"finish", @".", str]
#define _nsel(str) NSSelectorFromString(str)

#define cJRCallerContext @"callerContext"

#define resultNil                       nil
#define resultNonJson                   @"not a json string"
#define resultBadJson                   @"{:\"()bad json \t string]"
#define resultEmptyString               @""
#define resultNonString                 [NSNull null]
#define resultMissingStat               @"{\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultBadStat                   @"{\"stat\":\"uhoh\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultEmptyStat                 @"{\"stat\":\"\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultMissing                   @"{\"stat\":\"ok\"}"
#define resultBad                       @"{\"stat\":\"ok\",\"result\":\"not a good result\"}"
#define resultEmpty                     @"{\"stat\":\"ok\",\"result\":\"\"}"
#define resultExpected                  @"{\"stat\":\"ok\",\"result\":{\"basicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultUnexpected                @"{\"stat\":\"ok\",\"result\":{\"notTheBasicObject\":{\"string1\":\"string1\",\"string2\":\"string2\"},\"notTheBasicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}],\"notTheSimpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultArrayExpected             @"{\"stat\":\"ok\",\"result\":{\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":11},{\"string1\":\"string1\",\"string2\":\"string2\",\"id\":12}]}}"
#define resultArrayUnexpected           @"{\"stat\":\"ok\",\"result\":{\"notTheBasicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\",\"extraString\":\"extraString\",\"id\":11},{\"string1\":\"string1\",\"noString2\":\"noString2\",\"id\":12}]}}"
#define resultArrayMissingIds           @"{\"stat\":\"ok\",\"result\":{\"basicPlural\":[{\"string1\":\"string1\",\"string2\":\"string2\"},{\"string1\":\"string1\",\"string2\":\"string2\"}]}}"
#define resultStringArrayExpected       @"{\"stat\":\"ok\",\"result\":{\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultStringArrayUnexpected     @"{\"stat\":\"ok\",\"result\":{\"notTheSimpleStringPluralOne\":[{\"notTheSimpleTypeOne\":\"string1\",\"id\":21},{\"simpleTypeOne\":\"string2\",\"id\":22},{\"simpleTypeOne\":\"string3\",\"id\":23}]}}"
#define resultStringArrayMissingIds     @"{\"stat\":\"ok\",\"result\":{\"simpleStringPluralOne\":[{\"simpleTypeOne\":\"string1\"},{\"simpleTypeOne\":\"string2\"},{\"simpleTypeOne\":\"string3\"}]}}"
#define resultUserExpected              @""
#define resultUserUnexpected            @""
#define resultUserMissingIds            @""

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
    NSMutableDictionary *defaultArrayContext;
    NSMutableDictionary *defaultStringArrayContext;

    NSMutableDictionary *finisherArguments;
}
@property (retain) JRCaptureUser       *captureUser;
@property (retain) NSMutableDictionary *defaultContext;
@property (retain) NSMutableDictionary *defaultArrayContext;
@property (retain) NSMutableDictionary *defaultStringArrayContext;
@property (retain) NSMutableDictionary *finisherArguments;
@end

@implementation e2_ApidHandlerTests
@synthesize captureUser;
@synthesize defaultContext;
@synthesize defaultArrayContext;
@synthesize defaultStringArrayContext;
@synthesize finisherArguments;

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
//    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
//    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
//    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
//    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
//    NSString        *elementType   = [myContext objectForKey:@"elementType"];
//    BOOL             isStringArray = [((NSNumber *)[myContext objectForKey:@"isStringArray"]) boolValue];

//    self, @"captureObject",
//    self.captureObjectPath, @"capturePath",
//    delegate, @"delegate",
//    context, @"callerContext", nil];


    self.captureUser = [SharedData getBlankCaptureUser];

    self.captureUser.basicObject = [JRBasicObject basicObject];

    self.captureUser.basicObject.string1 = @"string1";
    self.captureUser.basicObject.string2 = @"string2";

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    JRBasicPluralElement *element1 = [JRBasicPluralElement basicPluralElement];
    JRBasicPluralElement *element2 = [JRBasicPluralElement basicPluralElement];

    element1.string1 = element2.string1 = @"string1";
    element1.string2 = element2.string2 = @"string2";

    [array addObject:element1];
    [array addObject:element2];

    self.captureUser.basicPlural = array;

    self.captureUser.simpleStringPluralOne = [NSArray arrayWithObjects:@"string1", @"string2", @"string3", nil];

    self.defaultContext      = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            self.captureUser, @"captureUser",
                                                            self.captureUser, @"captureObject",
                                                            @"", @"capturePath",
                                                            self, @"delegate", nil];

    self.defaultArrayContext = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @"basicPlural", @"arrayName",
                                                            @"basicPluralElement", @"elementType",
                                                            [NSNumber numberWithBool:NO], @"isStringArray",
                                                            nil];

    [self.defaultArrayContext addEntriesFromDictionary:defaultContext];

    self.defaultStringArrayContext = [NSMutableDictionary dictionaryWithDictionary:defaultArrayContext];

    [self.defaultStringArrayContext setObject:@"simpleStringPluralOne"      forKey:@"arrayName"];
    [self.defaultStringArrayContext setObject:@"simpleTypeOne"              forKey:@"elementType"];
    [self.defaultStringArrayContext setObject:[NSNumber numberWithBool:YES] forKey:@"isStringArray"];

    self.finisherArguments = [NSMutableDictionary dictionaryWithCapacity:10];
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set a boolean with an NSNumber boolean */
- (void)test_e201_foo
{
//    DLog(@"currentSelector: %@", currentSelector_);

    [self.defaultContext setObject:_sel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:@"fjdkjfkldjaklfjdal;dfa" context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_e2_update_resultNil
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultBad
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultStringArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultStringArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultStringArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultStringArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultStringArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultStringArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultUserExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_update_resultUserMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerUpdateCaptureObjectDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_update_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}


- (void)test_e2_replace_resultNil
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultBad
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultStringArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultStringArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultStringArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultStringArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultStringArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultStringArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultUserExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replace_resultUserMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureObjectDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replace_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}


- (void)test_e2_replaceArray_resultNil
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNil context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultNonJson
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonJson context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultBadJson
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadJson context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultEmptyString
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyString context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultNonString
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonString context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultMissingStat
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissingStat context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultBadStat
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadStat context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultEmptyStat
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyStat context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultMissing
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissing context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultBad
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBad context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultEmpty
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmpty context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultExpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultExpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultUnexpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUnexpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultArrayExpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayExpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultArrayUnexpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayUnexpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultArrayMissingIds
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayMissingIds context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultStringArrayExpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayExpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultStringArrayUnexpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayUnexpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultStringArrayMissingIds
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayMissingIds context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultUserExpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUserExpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultUserUnexpected
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUserUnexpected context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceArray_resultUserMissingIds
{
    [self.defaultArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUserMissingIds context:defaultArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceArray_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}


- (void)test_e2_replaceStringArray_resultNil
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNil context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultNonJson
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonJson context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultBadJson
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadJson context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultEmptyString
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyString context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultNonString
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultNonString context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultMissingStat
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissingStat context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultBadStat
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBadStat context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultEmptyStat
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmptyStat context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultMissing
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultMissing context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultBad
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultBad context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultEmpty
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultEmpty context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultExpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultExpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultUnexpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUnexpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultArrayExpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayExpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultArrayUnexpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayUnexpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultArrayMissingIds
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultArrayMissingIds context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultStringArrayExpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayExpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultStringArrayUnexpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayUnexpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultStringArrayMissingIds
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultStringArrayMissingIds context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultUserExpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUserExpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultUserUnexpected
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUserUnexpected context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_replaceStringArray_resultUserMissingIds
{
    [self.defaultStringArrayContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureObject testCaptureObjectApidHandlerReplaceCaptureArrayDidSucceedWithResult:resultUserMissingIds context:defaultStringArrayContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_replaceStringArray_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}


- (void)test_e2_createUser_resultNil
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultBad
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultStringArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultStringArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultStringArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultStringArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultStringArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultStringArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultUserExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_createUser_resultUserMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_createUser_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}


- (void)test_e2_fetchUser_resultNil
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultBad
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultStringArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultStringArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultStringArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultStringArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultStringArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultStringArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultUserExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchUser_resultUserMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchUser_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultNil
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultBad
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultStringArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultStringArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultStringArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultStringArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultStringArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultStringArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultUserExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchObject_resultUserMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchObject_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}


- (void)test_e2_fetchLastUpdated_resultNil
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNil context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultNil_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultNonJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNonJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultNonJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultBadJson
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBadJson context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultBadJson_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultEmptyString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmptyString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultEmptyString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultNonString
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultNonString context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultNonString_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultMissingStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultMissingStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultMissingStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultBadStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBadStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultBadStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultEmptyStat
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmptyStat context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultEmptyStat_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultMissing
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultMissing context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultMissing_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultBad
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultBad context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultBad_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultEmpty
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultEmpty context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultEmpty_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultStringArrayExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultStringArrayExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultStringArrayExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultStringArrayUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultStringArrayUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultStringArrayUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultStringArrayMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultStringArrayMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultStringArrayMissingIds_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultUserExpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUserExpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultUserExpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultUserUnexpected
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUserUnexpected context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultUserUnexpected_withArguments:(NSDictionary *)arguments
{

}

- (void)test_e2_fetchLastUpdated_resultUserMissingIds
{
    [self.defaultContext setObject:_fsel forKey:cJRCallerContext];

    [self prepare];
    [JRCaptureUser testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:resultUserMissingIds context:defaultContext];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_e2_fetchLastUpdated_resultUserMissingIds_withArguments:(NSDictionary *)arguments
{

}



typedef enum
{
    ApidStatusSuccess,
    ApidStatusFail,
} ApidStatus;

- (void)notifyFinisher:(NSString *)finisherString ofStatus:(ApidStatus)apidStatus withArguments:(NSDictionary *)arguments
          originalTest:(NSString *)testSelectorString
{
    DLog(@"%@", finisherString);
    [finisherArguments setObject:(apidStatus == ApidStatusFail ? @"fail" : @"success") forKey:@"apidResult"];

    @try
    {
        if ([self respondsToSelector:_nsel(finisherString)])
            [self performSelector:_nsel(finisherString) withObject:arguments];
        else
            GHAssertFalse(TRUE, @"Missing test result comparison for %@", testSelectorString);
    }
    @catch (NSException *exception)
    {
        GHTestLog([exception description]);
        [self notify:kGHUnitWaitStatusFailure forSelector:_nsel(testSelectorString)];

        return;
    }

    [self notify:kGHUnitWaitStatusSuccess forSelector:_nsel(testSelectorString)];
}

- (NSString *)getTestSelectorStringFromContext:(NSObject *)context
{
    NSArray *const splitContext  = [((NSString *) context) componentsSeparatedByString:@"."];
    return [splitContext objectAtIndex:1];
}

- (NSString *)getFinisherFromTestSelectorString:(NSString *)testSelectorString
{
    return [NSString stringWithFormat:@"%@%@",
                   [testSelectorString stringByReplacingOccurrencesOfString:@"test" withString:@"finish"],
                   @"_withArguments:"];
}

/******* Update Object *******/
/* Tester Delegate Fail */
- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Fail */
- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:@"captureObject"];
    [finisherArguments setObject:error forKey:@"error"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Succeed */
- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:@"captureObject"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Replace Object *******/
/* Tester Delegate Fail */
- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Fail */
- (void)replaceDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:@"captureObject"];
    [finisherArguments setObject:error forKey:@"error"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Succeed */
- (void)replaceDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:@"captureObject"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Replace Array *******/
/* Tester Delegate Fail */
- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Fail */
- (void)replaceArrayDidFailForObject:(JRCaptureObject *)object arrayNamed:(NSString *)arrayName withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:@"captureObject"];
    [finisherArguments setObject:error forKey:@"error"];

    [finisherArguments setObject:arrayName forKey:@"arrayName"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Succeed */
- (void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object newArray:(NSArray *)replacedArray named:(NSString *)arrayName context:(NSObject *)context
{
    [finisherArguments setObject:object forKey:@"captureObject"];
    [finisherArguments setObject:replacedArray forKey:@"newArray"];
    [finisherArguments setObject:arrayName forKey:@"arrayName"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}


/******* Create User *******/
/* Tester Delegate Fail */
- (void)createCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Fail */
- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:user forKey:@"captureObject"];
    [finisherArguments setObject:error forKey:@"error"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Tester Delegate Succeed */
- (void)createCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [finisherArguments setObject:result forKey:@"testerDelegateResult"];
}

/* Real Delegate Succeed */
- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context
{
    [finisherArguments setObject:user forKey:@"captureObject"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Fetch User *******/
/* Real Delegate Fail */
- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:error forKey:@"error"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Real Delegate Succeed */
- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context
{
    [finisherArguments setObject:fetchedUser forKey:@"captureObject"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/******* Fetch LastUpdated *******/
/* Real Delegate Fail */
- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context
{
    [finisherArguments setObject:error forKey:@"error"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusFail
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}

/* Real Delegate Succeed */
- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context
{
    [finisherArguments setObject:serverLastUpdated forKey:@"serverLastUpdated"];
    [finisherArguments setObject:[NSNumber numberWithBool:isOutdated] forKey:@"isOutdated"];

    [self notifyFinisher:[self getFinisherFromTestSelectorString:[self getTestSelectorStringFromContext:context]]
                ofStatus:ApidStatusSuccess
           withArguments:finisherArguments
            originalTest:[self getTestSelectorStringFromContext:context]];
}


- (void)dealloc
{
    [captureUser release];
    [defaultContext release];
    [defaultArrayContext release];
    [defaultStringArrayContext release];
    [finisherArguments release];
    [super dealloc];
}
@end

