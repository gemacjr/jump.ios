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

@interface b3_NestedPluralObjectTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser *captureUser;
    NSArray  *currentPlural;
    NSObject *currentObject;

    NSArray *fillerFodder;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSArray  *currentPlural;
@property (retain) NSObject *currentObject;
@end

@implementation b3_NestedPluralObjectTests
@synthesize captureUser;
@synthesize currentPlural;
@synthesize currentObject;

- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];

    fillerFodder = [[NSArray alloc] initWithObjects:
                                    @"apples", @"bananas", @"coconuts",
                                    @"alameda", @"beaumont", @"concordia",
                                    @"asteroids", @"battlezone", @"centipede",
                                    @"amnesia", @"bridgeport", @"cascade",
                                    @"akita", @"bulldog", @"collie",
                                    @"andromeda", @"bootes", @"capricorn",

                                    nil];
}

- (void)tearDownClass
{
    DLog(@"");
    self.captureUser = nil;
    self.currentPlural = nil;
    self.currentObject = nil;
}

- (void)setUp
{
//    self.captureUser  = [JRCaptureUser captureUser];
//    captureUser.email = @"lilli@janrain.com";
}

- (void)tearDown
{
//    self.captureUser = nil;
//    self.currentPlural = nil;
//    self.currentObject = nil;
}

- (void)newTestCluster
{
    self.captureUser  = [JRCaptureUser captureUser];
    captureUser.email = @"lilli@janrain.com";

    self.currentPlural = nil;
    self.currentObject = nil;
}

- (NSArray *)arrayWithElementsOfType:(Class)klass withConstructor:(SEL)constructor fillerFodderOffset:(NSUInteger)offset
{
//    if (offset+3 > [fillerFodder count])
//    {
        GHAssertLessThan(offset+3, [fillerFodder count], nil);
//        return nil;
//    }

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];

    for (NSUInteger i = 0; i < 3; i++)
    {
        id element = [klass performSelector:constructor];
        ((JRPinapL1PluralElement*)element).string1 = [fillerFodder objectAtIndex:i+offset];
        ((JRPinapL1PluralElement*)element).string2 = [fillerFodder objectAtIndex:i+offset+3];

        [array addObject:element];
    }

    return [[array copy] autorelease];
}

- (id)objectOfType:(Class)klass withConstructor:(SEL)constructor
{
    id object = [klass performSelector:constructor];
    ((JROinoL1Object*)object).string1 = [fillerFodder objectAtIndex:0];
    ((JROinoL1Object*)object).string2 = [fillerFodder objectAtIndex:3];

    return object;
}

- (void)updateObjectProperties:(id)object toFillerFodderIndex:(NSUInteger)index
{
    ((JROinoL1Object*)object).string1 = [fillerFodder objectAtIndex:index];
    ((JROinoL1Object*)object).string2 = [fillerFodder objectAtIndex:index+3];
}

/* Plural in a plural (300-304) */
// pinap
- (void)test_b300_pinapCreate
{
    [self newTestCluster];

    captureUser.pinapL1Plural = [self arrayWithElementsOfType:[JRPinapL1PluralElement class]
                                              withConstructor:@selector(pinapL1PluralElement)
                                           fillerFodderOffset:0];

    ((JRPinapL1PluralElement *)[captureUser.pinapL1Plural objectAtIndex:1]).pinapL2Plural =
            [self arrayWithElementsOfType:[JRPinapL2PluralElement class]
                          withConstructor:@selector(pinapL2PluralElement)
                       fillerFodderOffset:3];

    ((JRPinapL1PluralElement *)[captureUser.pinapL1Plural objectAtIndex:2]).pinapL2Plural =
            [self arrayWithElementsOfType:[JRPinapL2PluralElement class]
                          withConstructor:@selector(pinapL2PluralElement)
                       fillerFodderOffset:6];

    self.currentPlural = captureUser.pinapL1Plural;
}

- (void)test_b301_pinapUpdate_Level2_PreReplace_FailCase
{
    if (!captureUser)
        [self test_b300_pinapCreate];

    JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:1];
    JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:1];

    [self prepare];
    [l2PluralElement updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_b302_pinapReplaceArray
{
    if (!captureUser)
        [self test_b300_pinapCreate];

    [self prepare];
    [captureUser replacePinapL1PluralArrayOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)test_b303_pinapUpdate_Level2_PostReplace
{

}

/* Plural in an object (305-309) */
// pino
- (void)test_b305_pinoCreate
{

}

- (void)test_b306_pinoUpdate_Level1_PreReplace
{

}

- (void)test_b307_pinoReplace_Level1
{

}

- (void)test_b308_pinoUpdate_Level2_PostReplace
{

}


/* Object in a plural (310-314) */
// onip
- (void)test_b310_onipCreate
{

}

- (void)test_b311_onipUpdate_Level2_PreReplace_FailCase
{

}

- (void)test_b312_onipReplaceArray
{

}

- (void)test_b313_onipUpdate_Level2_PostReplace
{

}

/* Object in an object (315-319) */
// oino
- (void)test_b315_onioCreate
{

}

- (void)test_b316_onioUpdate_Level1
{

}

- (void)test_b317_oinoUpdate_Level1_NoChangeL2
{

}

- (void)test_b318_oinoUpdate_Level1_ChangeL2
{

}

/* Plural in a plural in a plural (320-329) */
// pinapinap
- (void)test_b320_pinapinapCreate
{

}

- (void)test_b321_pinapinapUpdate_Level3_PreReplace_FailCase
{

}

- (void)test_b322_pinapinapReplaceArray_Level2_FailCase
{

}

- (void)test_b323_pinapinapReplaceArray_Level1
{

}

/* Plural in an object in a plural (330-339) */
// pinonip
/* Plural in a plural in an object (340-349) */
// pinapino
/* Plural in an object in an object (350-359) */
// pinoino
- (void)test_b350_pinoinoCreate
{

}

- (void)test_b351_pinoinoUpdate_Level1
{

}

- (void)test_b352_pinoinoUpdate_Level2
{

}

- (void)test_b353_pinoinoReplace_Level1
{

}

- (void)test_b354_pinoinoReplace_Level2
{

}

/* Object in a plural in a plural (360-369) */
// onipinap
- (void)test_b360_onipinapCreate
{

}

- (void)test_b361_onipinapUpdate_Level3_PreReplace_FailCase
{

}

- (void)test_b362_onipinapReplaceArray_Level2_FailCase
{

}

- (void)test_b363_onipinapReplaceArray_Level1
{

}

- (void)test_b364_onipinapUpdate_Level3_PostReplace
{

}

/* Object in an object in a plural (370-379) */
// oinonip
- (void)test_b370_oinonipCreate
{

}

- (void)test_b3371_oinonipUpdate_Level3_PreReplace_FailCase
{

}

- (void)test_b372_oinonipUpdate_Level2_PreReplace_FailCase
{

}

- (void)test_b373_oinonipReplaceArray_Level1
{

}

- (void)test_b374_oinonipUpdate_Level3_PostReplace
{

}

/* Object in a plural in an object (380-389) */
// onipino
/* Object in an object (390-399) */
// oinoino
- (void)test_b390_oinoinoCreate
{

}

- (void)test_b391_oinoinoUpdate_Level1_NoChangeL2L3
{

}

- (void)test_b392_oinoinoUpdate_Level1_ChangeL2
{

}

- (void)test_b393_oinoinoUpdate_Level1_ChangeL3
{

}

- (void)test_b394_oinoinoUpdate_Level1_ChangeL2L3
{

}

- (void)test_b395_oinoinoReplace_Level1_ChangeL2L3
{

}

- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
//    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    //JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b302_pinapReplaceArray"])
        {
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:captureUser.pinapL1Plural], nil);
//            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:newUser.pinapL1Plural], nil);
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:((JRCaptureUser *)object).pinapL1Plural], nil);
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

- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *testSelectorString = (NSString *)context;
    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    if ([testSelectorString hasSuffix:@"FailCase"])
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
        return;
    }

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
//    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

//    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b302_pinapReplaceArray"])
        {
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:captureUser.pinapL1Plural], nil);
//            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:newUser.pinapL1Plural], nil);
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:((JRCaptureUser *)object).pinapL1Plural], nil);
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

- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *testSelectorString = (NSString *)context;
    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    if ([testSelectorString hasSuffix:@"FailCase"])
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
        return;
    }

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}


- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];

    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b302_pinapReplaceArray"])
        {
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:captureUser.pinapL1Plural], nil);
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:newUser.pinapL1Plural], nil);
            GHAssertTrue([currentPlural isEqualToOtherPinapL1PluralArray:((JRCaptureUser *)object).pinapL1Plural], nil);
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
    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    if ([testSelectorString hasSuffix:@"FailCase"])
    {
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
        return;
    }

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)dealloc
{
    [captureUser release];
    [currentObject release];
    [currentPlural release];
    [fillerFodder release];
    [super dealloc];
}
@end
