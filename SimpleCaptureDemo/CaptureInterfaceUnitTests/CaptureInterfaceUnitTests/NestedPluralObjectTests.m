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
    /* Variables to hold pointers to objects/plurals/plural elements we may be interested in checking */
    NSArray  *currentL1Plural, *currentL2Plural, *currentL3Plural;
    NSObject *currentL1Object, *currentL2Object, *currentL3Object;

    NSArray *fillerFodder;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSArray  *currentL1Plural;
@property (retain) NSArray  *currentL2Plural;
@property (retain) NSArray  *currentL3Plural;
@property (retain) NSObject *currentL1Object;
@property (retain) NSObject *currentL2Object;
@property (retain) NSObject *currentL3Object;
@end

@implementation b3_NestedPluralObjectTests
@synthesize captureUser;
@synthesize currentL1Plural, currentL2Plural, currentL3Plural;
@synthesize currentL1Object, currentL2Object, currentL3Object;

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
    self.currentL1Plural = self.currentL2Plural = self.currentL3Plural = nil;
    self.currentL1Object = self.currentL2Object = self.currentL3Object = nil;
}

- (void)setUp
{
    self.captureUser  = [JRCaptureUser captureUser];
    captureUser.email = @"lilli@janrain.com";
}

- (void)tearDown
{
    self.currentL1Plural = self.currentL2Plural = self.currentL3Plural = nil;
    self.currentL1Object = self.currentL2Object = self.currentL3Object = nil;
}

- (NSArray *)arrayWithElementsOfType:(Class)klass withConstructor:(SEL)constructor fillerFodderOffset:(NSUInteger)offset
{
    GHAssertLessThan(offset+3, [fillerFodder count], nil);

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
- (void)pinapCreate
{
   captureUser.pinapL1Plural = [self arrayWithElementsOfType:[JRPinapL1PluralElement class]
                                              withConstructor:@selector(pinapL1PluralElement)
                                           fillerFodderOffset:0];

    ((JRPinapL1PluralElement *)[captureUser.pinapL1Plural objectAtIndex:0]).pinapL2Plural =
            [self arrayWithElementsOfType:[JRPinapL2PluralElement class]
                          withConstructor:@selector(pinapL2PluralElement)
                       fillerFodderOffset:6];

    ((JRPinapL1PluralElement *)[captureUser.pinapL1Plural objectAtIndex:1]).pinapL2Plural =
            [self arrayWithElementsOfType:[JRPinapL2PluralElement class]
                          withConstructor:@selector(pinapL2PluralElement)
                       fillerFodderOffset:9];

    self.currentL1Plural = captureUser.pinapL1Plural;
    self.currentL1Object = [currentL1Plural objectAtIndex:0];
    self.currentL2Plural = ((JRPinapL1PluralElement *)currentL1Object).pinapL2Plural;
    self.currentL2Object = [currentL2Plural objectAtIndex:0];
}

/* Try and update a plural element (level 2) before the parent plural (level 1) has been replaced. As the level 2
   element won't yet have an id/capturePath, this should fail. */
- (void)test_b300_pinapUpdate_Level2_PreReplace_FailCase
{
    [self pinapCreate];

    JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:0];
    JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:0];

    /* See, they can't yet be updated or replaced! */
    GHAssertFalse(l1PluralElement.canBeUpdatedOrReplaced, nil);
    GHAssertFalse(l2PluralElement.canBeUpdatedOrReplaced, nil);

    [self prepare];
    [l2PluralElement updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Now, let's test replacing the parent plural (level 1). This should give the child elements id's/paths. */
- (void)test_b301_pinapReplaceArray
{
    [self pinapCreate];

    [self prepare];
    [captureUser replacePinapL1PluralArrayOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

/* Lastly, let's replace the array, giving the child elements id's/paths, and then let's update an element on Capture.
   Of course, this one should succeed. */
- (void)test_b302_pinapUpdate_Level2_PostReplace
{
    [self pinapCreate];

    /* First, do the replace... */
    [self prepare];
    [captureUser replacePinapL1PluralArrayOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
}

/* Plural in an object (305-309) */
// pino
- (void)pinoCreate
{
    captureUser.pinoL1Object = [self objectOfType:[JRPinoL1Object class]
                                  withConstructor:@selector(pinoL1Object)];

    captureUser.pinoL1Object.pinoL2Plural = [self arrayWithElementsOfType:[JRPinoL2PluralElement class]
                                                          withConstructor:@selector(pinoL2PluralElement)
                                                       fillerFodderOffset:0];

    self.currentL1Object = captureUser.pinoL1Object;
    self.currentL2Plural = captureUser.pinoL1Object.pinoL2Plural;
    self.currentL2Object = [currentL2Plural objectAtIndex:0];
}

/* Update the parent object (level 1) after creating a new plural. The update should work, though the plural elements
   (level 2) will still not yet have an id/capturePath, and will not be updated/replaced. Depending on the state of
    the tests, they may still hold the same content as what's returned from Capture. */
- (void)test_b305_pinoUpdate_Level1_PreReplace
{
    [self pinoCreate];

    GHAssertFalse(((JRPinoL2PluralElement *)currentL2Object).canBeUpdatedOrReplaced, nil);

    [self prepare];
    [((JRPinoL1Object *)self.currentL1Object) updateObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)test_b306_pinoReplace_Level1
{
    [self pinoCreate];

    [self prepare];
    [((JRPinoinoL1Object *)self.currentL1Object) replaceObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)test_b307_pinoUpdate_Level1_PostReplace
{
    [self pinoCreate];

    /* First, do the replace... */
    [self prepare];
    [((JRPinoinoL1Object *)self.currentL1Object) replaceObjectOnCaptureForDelegate:self withContext:NSStringFromSelector(_cmd)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
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
    NSArray      *resultArray      = [resultDictionary objectForKey:@"result"];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b301_pinapReplaceArray"])
        {
            GHAssertTrue([currentL1Plural isEqualToOtherPinapL1PluralArray:captureUser.pinapL1Plural], nil);
            GHAssertTrue([currentL1Plural isEqualToOtherPinapL1PluralArray:((JRCaptureUser *)object).pinapL1Plural], nil);
            GHAssertTrue([currentL1Plural isEqualToOtherPinapL1PluralArray:newArray], nil);

            /* Let's grab the elements that are now in our captureUser */
            JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:0];
            JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:0];

            /* We can compare our new elements to our saved elements. They should be the same in their content, but
               have different pointers. */
            GHAssertTrue([l1PluralElement isEqualToPinapL1PluralElement:((JRPinapL1PluralElement *)currentL1Object)], nil);
            GHAssertNotEquals(l1PluralElement, currentL1Object, nil);
            GHAssertTrue([l2PluralElement isEqualToPinapL2PluralElement:((JRPinapL2PluralElement *)currentL2Object)], nil);
            GHAssertNotEquals(l2PluralElement, currentL2Object, nil);
        }
        else if ([testSelectorString isEqualToString:@"test_b302_pinapUpdate_Level2_PostReplace"])
        {
            JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:0];
            JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:0];

            /* And, yep, they should now be updatable/replaceable! */
            GHAssertTrue(l1PluralElement.canBeUpdatedOrReplaced, nil);
            GHAssertTrue(l2PluralElement.canBeUpdatedOrReplaced, nil);

            /* Let's change the values for our second level object (remember, currentL2Object will still have the old values). */
            [self updateObjectProperties:l2PluralElement toFillerFodderIndex:1];

            /* Then do the update... */
            [l2PluralElement updateObjectOnCaptureForDelegate:self withContext:context];

            return;
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

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary        = [result objectFromJSONString];
    NSDictionary *captureObjectDictionary = [resultDictionary objectForKey:@"result"];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b302_pinapUpdate_Level2_PostReplace"])
        {
            JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:0];
            JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:0];

            /* What we have in our captureUser should be equal to our result. */
            GHAssertTrue([l2PluralElement isEqualToPinapL2PluralElement:(JRPinapL2PluralElement *)object], nil);
            GHAssertTrue([l2PluralElement isEqualToPinapL2PluralElement:[JRPinapL2PluralElement pinapL2PluralElementFromDictionary:captureObjectDictionary withPath:nil]], nil);

            /* And what we have saved as the old currentL2object should not be the same */
            GHAssertFalse([l2PluralElement isEqualToPinapL2PluralElement:(JRPinapL2PluralElement *)currentL2Object], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_b305_pinoUpdate_Level1_PreReplace"])
        {
            /* Both the content and the pointers of our object should be the same */
            GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)object], nil);
            GHAssertEquals(currentL1Object, object, nil);

            /* The returned dictionary may or may not match our object, as it will have the values from whatever the array was last. */
        }
        else if ([testSelectorString isEqualToString:@"test_b307_pinoUpdate_Level1_PostReplace"])
        {
            /* And since we replaced the object first, both should have equal arrays too. */
            GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)object], nil);
            GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1ObjectObjectFromDictionary:captureObjectDictionary withPath:nil]], nil);
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

- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary        = [result objectFromJSONString];
    NSDictionary *captureObjectDictionary = [resultDictionary objectForKey:@"result"];

    NSString *testSelectorString = (NSString *)context;
    @try
    {
        if ([testSelectorString isEqualToString:@"test_b306_pinoReplace_Level1"])
        {
            GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)object], nil);
            GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1ObjectObjectFromDictionary:captureObjectDictionary withPath:nil]], nil);
        }
        else if ([testSelectorString isEqualToString:@"test_b307_pinoUpdate_Level1_PostReplace"])
        {
            GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)object], nil);
            [self updateObjectProperties:self.currentL1Object toFillerFodderIndex:1];

            /* Then do the update... */
            [((JRPinoinoL1Object *)self.currentL1Object) updateObjectOnCaptureForDelegate:self withContext:context];

            return;
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

- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSString *testSelectorString = (NSString *)context;
    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)dealloc
{
    [captureUser release];
    [currentL1Plural release];
    [currentL2Plural release];
    [currentL3Plural release];
    [currentL1Object release];
    [currentL2Object release];
    [currentL3Object release];
    [fillerFodder release];

    [super dealloc];
}
@end
