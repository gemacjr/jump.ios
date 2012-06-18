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

#define _sel       NSStringFromSelector(_cmd)
#define _csel      [NSString stringWithFormat:@"%@%@%@", @"continue", @".", _sel]
#define _fsel      [NSString stringWithFormat:@"%@%@%@", @"finish", @".", _sel]
#define _esel      [NSString stringWithFormat:@"%@%@%@", @"fail", @".", _sel]
#define _ctel(str) [NSString stringWithFormat:@"%@%@%@", @"continue", @".", str]
#define _ftel(str) [NSString stringWithFormat:@"%@%@%@", @"finish", @".", str]
#define _nsel(str) NSSelectorFromString(str)

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"

@interface b3_NestedPluralObjectTests : GHAsyncTestCase <JRCaptureObjectDelegate>
{
    JRCaptureUser *captureUser;
    /* Variables to hold pointers to objects/plurals/plural elements we may be interested in checking */
    NSArray  *currentL1Plural, *currentL2Plural, *currentL3Plural;
    JRCaptureObject *currentL1Object, *currentL2Object, *currentL3Object;

    NSArray *fillerFodder;
}
@property (retain) JRCaptureUser *captureUser;
@property (retain) NSArray *currentL1Plural;
@property (retain) NSArray *currentL2Plural;
@property (retain) NSArray *currentL3Plural;
@property (retain) JRCaptureObject *currentL1Object;
@property (retain) JRCaptureObject *currentL2Object;
@property (retain) JRCaptureObject *currentL3Object;
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
    self.captureUser = [SharedData getBlankCaptureUser];
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

- (id)objectOfType:(Class)klass withConstructor:(SEL)constructor fillerFodderOffset:(NSUInteger)offset
{
    GHAssertLessThan(offset+3, [fillerFodder count], nil);

    id object = [klass performSelector:constructor];
    ((JROinoL1Object*)object).string1 = [fillerFodder objectAtIndex:0 + offset];
    ((JROinoL1Object*)object).string2 = [fillerFodder objectAtIndex:3 + offset];

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
    [l2PluralElement updateObjectOnCaptureForDelegate:self withContext:_esel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

/* Now, let's test replacing the parent plural (level 1). This should give the child elements id's/paths. */
- (void)test_b301_pinapReplaceArray
{
    [self pinapCreate];

    [self prepare];
    [captureUser replacePinapL1PluralArrayOnCaptureForDelegate:self withContext:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)finish_b301_pinapReplaceArray_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSArray         *newArray      = [arguments objectForKey:@"newArray"];
    JRCaptureObject *captureObject = [arguments objectForKey:@"captureObject"];
    NSString        *result        = [arguments objectForKey:@"result"];

    GHAssertTrue([currentL1Plural isEqualToOtherPinapL1PluralArray:captureUser.pinapL1Plural], nil);
    GHAssertTrue([currentL1Plural isEqualToOtherPinapL1PluralArray:((JRCaptureUser *)captureObject).pinapL1Plural], nil);
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

/* Lastly, let's replace the array, giving the child elements id's/paths, and then let's update an element on Capture.
   Of course, this one should succeed. */
- (void)test_b302_pinapUpdate_Level2_PostReplace
{
    [self pinapCreate];

    /* First, do the replace... */
    [self prepare];
    [captureUser replacePinapL1PluralArrayOnCaptureForDelegate:self withContext:_csel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
}

- (void)continue_b302_pinapUpdate_Level2_PostReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSArray         *newArray      = [arguments objectForKey:@"newArray"];
    JRCaptureObject *captureObject = [arguments objectForKey:@"captureObject"];
    NSString        *result        = [arguments objectForKey:@"result"];

    JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:0];
    JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:0];

    /* And, yep, they should now be updatable/replaceable! */
    GHAssertTrue(l1PluralElement.canBeUpdatedOrReplaced, nil);
    GHAssertTrue(l2PluralElement.canBeUpdatedOrReplaced, nil);

    /* Let's change the values for our second level object (remember, currentL2Object will still have the old values). */
    [self updateObjectProperties:l2PluralElement toFillerFodderIndex:1];

    /* Then do the update... */
    [l2PluralElement updateObjectOnCaptureForDelegate:self withContext:_ftel(testSelectorString)];
}

- (void)finish_b302_pinapUpdate_Level2_PostReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    JRPinapL1PluralElement *l1PluralElement = [captureUser.pinapL1Plural objectAtIndex:0];
    JRPinapL2PluralElement *l2PluralElement = [l1PluralElement.pinapL2Plural objectAtIndex:0];

    /* What we have in our captureUser should be equal to our result. */
    GHAssertTrue([l2PluralElement isEqualToPinapL2PluralElement:(JRPinapL2PluralElement *)captureObject], nil);
    GHAssertTrue([l2PluralElement isEqualToPinapL2PluralElement:[JRPinapL2PluralElement pinapL2PluralElementFromDictionary:captureObjectDictionary withPath:nil]], nil);

    /* And what we have saved as the old currentL2object should not be the same */
    GHAssertFalse([l2PluralElement isEqualToPinapL2PluralElement:(JRPinapL2PluralElement *)currentL2Object], nil);
}


/* Plural in an object (305-309) */
// pino
- (void)pinoCreate
{
    captureUser.pinoL1Object = [self objectOfType:[JRPinoL1Object class] withConstructor:@selector(pinoL1Object) fillerFodderOffset:0];

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
    [((JRPinoL1Object *)self.currentL1Object) updateObjectOnCaptureForDelegate:self withContext:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)finish_b305_pinoUpdate_Level1_PreReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    /* Both the content and the pointers of our object should be the same */
    GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)captureObject], nil);
    GHAssertEquals(currentL1Object, captureObject, nil);

    /* The returned dictionary may or may not match our object, as it will have the values from whatever the array was last. */
}

- (void)test_b306_pinoReplace_Level1
{
    [self pinoCreate];

    [self prepare];
    [((JRPinoinoL1Object *)self.currentL1Object) replaceObjectOnCaptureForDelegate:self withContext:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)finish_b306_pinoReplace_Level1_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)captureObject], nil);
    GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1ObjectObjectFromDictionary:captureObjectDictionary withPath:nil]], nil);
}

- (void)test_b307_pinoUpdate_Level1_PostReplace
{
    [self pinoCreate];

    /* First, do the replace... */
    [self prepare];
    [((JRPinoinoL1Object *)self.currentL1Object) replaceObjectOnCaptureForDelegate:self withContext:_csel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)continue_b307_pinoUpdate_Level1_PostReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)captureObject], nil);
    [self updateObjectProperties:self.currentL1Object toFillerFodderIndex:1];

    /* Then do the update... */
    [((JRPinoinoL1Object *)self.currentL1Object) updateObjectOnCaptureForDelegate:self withContext:_ftel(testSelectorString)];
}

- (void)finish_b307_pinoUpdate_Level1_PostReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    /* And since we replaced the object first, both should have equal arrays too. */
    GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:(JRPinoL1Object*)captureObject], nil);
    GHAssertTrue([(JRPinoL1Object *)currentL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1ObjectObjectFromDictionary:captureObjectDictionary withPath:nil]], nil);
}

/* Object in a plural (310-314) */
// onip
- (void)onipCreate
{
   captureUser.onipL1Plural = [self arrayWithElementsOfType:[JROnipL1PluralElement class]
                                              withConstructor:@selector(onipL1PluralElement)
                                           fillerFodderOffset:0];

    ((JROnipL1PluralElement *)[captureUser.onipL1Plural objectAtIndex:0]).onipL2Object =
            [self objectOfType:[JROnipL2Object class] withConstructor:@selector(onipL2Object) fillerFodderOffset:0];

    ((JROnipL1PluralElement *)[captureUser.onipL1Plural objectAtIndex:1]).onipL2Object =
            [self objectOfType:[JROnipL2Object class] withConstructor:@selector(onipL2Object) fillerFodderOffset:0];

    self.currentL1Plural = captureUser.onipL1Plural;
    self.currentL1Object = [currentL1Plural objectAtIndex:0];
    self.currentL2Object = ((JROnipL1PluralElement *)[currentL1Plural objectAtIndex:0]).onipL2Object;
}

- (void)test_b310_onipUpdate_Level2_PreReplace_FailCase
{
    [self onipCreate];

    [self prepare];
    [currentL2Object updateObjectOnCaptureForDelegate:self withContext:_esel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

//- (void)test_b311_onipReplaceArray
//{
//    // Leaving this out because 312 also tests the replace
//}

- (void)test_b312_onipUpdate_Level2_PostReplace
{
    [self onipCreate];

    [self prepare];
    [captureUser replaceOnipL1PluralArrayOnCaptureForDelegate:self withContext:_csel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:120.0];
}

- (void)continue_b312_onipUpdate_Level2_PostReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSArray         *newArray      = [arguments objectForKey:@"newArray"];
    JRCaptureObject *captureObject = [arguments objectForKey:@"captureObject"];
    NSString        *result        = [arguments objectForKey:@"result"];

    JROnipL2Object  *onipL2Object  = ((JROnipL1PluralElement *)[newArray objectAtIndex:0]).onipL2Object;

    [self updateObjectProperties:onipL2Object toFillerFodderIndex:5];
    [onipL2Object updateObjectOnCaptureForDelegate:self withContext:_ftel(testSelectorString)];
}

- (void)finish_b312_onipUpdate_Level2_PostReplace_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    JROnipL2Object  *onipL2Object = [JROnipL2Object onipL2ObjectObjectFromDictionary:captureObjectDictionary withPath:nil];

    GHAssertTrue([onipL2Object isEqualToOnipL2Object:((JROnipL2Object *)captureObject)], nil);
    GHAssertFalse([onipL2Object isEqualToOnipL2Object:((JROnipL2Object *)currentL2Object)], nil);
}

/* Object in an object (315-319) */
// oino
- (void)onioCreate
{
    self.currentL1Object = captureUser.oinoL1Object =
            [self objectOfType:[JROinoL1Object class] withConstructor:@selector(oinoL1Object) fillerFodderOffset:0];
    self.currentL2Object = captureUser.oinoL1Object.oinoL2Object =
            [self objectOfType:[JROinoL2Object class] withConstructor:@selector(oinoL2Object) fillerFodderOffset:6];
}

- (void)test_b315_onioUpdate_Level1
{
    [self onioCreate];

    [self prepare];
    [currentL1Object updateObjectOnCaptureForDelegate:self withContext:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_b315_onioUpdate_Level1_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    JROinoL1Object  *oinoL1Object = [JROinoL1Object oinoL1ObjectObjectFromDictionary:captureObjectDictionary withPath:nil];

    GHAssertTrue([oinoL1Object isEqualToOinoL1Object:((JROinoL1Object *)currentL1Object)], nil);
}

- (void)test_b316_oinoUpdate_Level1_NoChangeL2
{

}

- (void)test_b317_oinoUpdate_Level1_ChangeL2
{

}

- (void)onioPreparatoryUpdateWithContext:(NSString *)finisher
{
    [self onioCreate];

    [self prepare];
    [currentL1Object updateObjectOnCaptureForDelegate:self withContext:_ctel(finisher)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_b318_oinoUpdate_Level1_NewL2
{
    [self onioPreparatoryUpdateWithContext:_sel];
}

- (void)continue_b318_oinoUpdate_Level1_NewL2_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    JROinoL2Object *oinoL2Object = [JROinoL2Object oinoL2Object];
    captureUser.oinoL1Object.oinoL2Object = oinoL2Object;
    [captureUser.oinoL1Object updateObjectOnCaptureForDelegate:self withContext:_ftel(testSelectorString)];
}

- (void)finish_b318_oinoUpdate_Level1_NewL2_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    JROinoL1Object  *oinoL1Object = [JROinoL1Object oinoL1ObjectObjectFromDictionary:captureObjectDictionary withPath:nil];

    GHAssertTrue([oinoL1Object isEqualToOinoL1Object:captureUser.oinoL1Object], nil);
}

- (void)test_b319_oinoUpdate_Level2_NewL2
{
    [self onioPreparatoryUpdateWithContext:_sel];
}

- (void)continue_b319_oinoUpdate_Level2_NewL2_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    JROinoL2Object *oinoL2Object = [JROinoL2Object oinoL2Object];
    captureUser.oinoL1Object.oinoL2Object = oinoL2Object;

    [captureUser.oinoL1Object.oinoL2Object updateObjectOnCaptureForDelegate:self withContext:_ftel(testSelectorString)];
}

- (void)finish_b319_oinoUpdate_Level2_NewL2_withArguments:(NSDictionary *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSDictionary    *captureObjectDictionary = [arguments objectForKey:@"captureObjectDictionary"];
    JRCaptureObject *captureObject           = [arguments objectForKey:@"captureObject"];

    JROinoL2Object  *oinoL2Object = [JROinoL2Object oinoL2ObjectObjectFromDictionary:captureObjectDictionary withPath:nil];

    GHAssertTrue([oinoL2Object isEqualToOinoL2Object:captureUser.oinoL1Object.oinoL2Object], nil);
}

- (void)pinapinapCreate
{
    self.currentL1Plural = captureUser.pinapinapL1Plural =
            [self arrayWithElementsOfType:[JRPinapinapL1PluralElement class]
                  withConstructor:@selector(pinapinapL1PluralElement) fillerFodderOffset:0];
    self.currentL1Object = [currentL1Plural objectAtIndex:1];

    self.currentL2Plural = ((JRPinapinapL1PluralElement *) currentL1Object).pinapinapL2Plural =
            [self arrayWithElementsOfType:[JRPinapinapL2PluralElement class]
                          withConstructor:@selector(pinapinapL2PluralElement)
                       fillerFodderOffset:6];
    self.currentL2Object = [currentL2Plural objectAtIndex:1];

    self.currentL3Plural = ((JRPinapinapL2PluralElement *) currentL2Object).pinapinapL3Plural =
            [self arrayWithElementsOfType:[JRPinapinapL3PluralElement class]
                          withConstructor:@selector(pinapinapL3PluralElement)
                       fillerFodderOffset:9];
    self.currentL3Object = [currentL3Plural objectAtIndex:1];
}

/* Plural in a plural in a plural (320-329) */
// pinapinap
- (void)test_b320a_pinapinapCreate
{
    [self pinapinapCreate];

    [self prepare];
    [captureUser replacePinapinapL1PluralArrayOnCaptureForDelegate:self withContext:_fsel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)finish_b320a_pinapinapCreate_withArguments:(NSDictionary *)arguments
                             andTestSelectorString:(NSString *)testSelectorString
{
    NSArray *newArray = [arguments objectForKey:@"newArray"];
    JRCaptureObject *captureObject = [arguments objectForKey:@"captureObject"];

    GHAssertTrue([newArray isEqualToOtherPinapinapL1PluralArray:currentL1Plural], nil);
}

- (void)test_b320_pinapinapUpdate_Level3_PreReplace_FailCase
{
    [self pinapinapCreate];

    [self prepare];
    [currentL3Object updateObjectOnCaptureForDelegate:self withContext:_esel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_b321_pinapinapReplaceArray_Level2_FailCase
{
    [self pinapinapCreate];

    [self prepare];
    [((JRPinapinapL1PluralElement *)currentL1Object) replacePinapinapL2PluralArrayOnCaptureForDelegate:self
                                                                                           withContext:_esel];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)test_b322_pinapinapReplaceArray_Level1
{

}

/* Plural in an object in a plural (330-339) */
// pinonip
/* Plural in a plural in an object (340-349) */
// pinapino
/* Plural in an object in an object (350-359) */
// pinoino
- (void)pinoinoCreate
{

}

- (void)test_b350_pinoinoUpdate_Level1
{

}

- (void)test_b351_pinoinoUpdate_Level2
{

}

- (void)test_b352_pinoinoReplace_Level1
{

}

- (void)test_b353_pinoinoReplace_Level2
{

}

/* Object in a plural in a plural (360-369) */
// onipinap
- (void)onipinapCreate
{

}

- (void)test_b360_onipinapUpdate_Level3_PreReplace_FailCase
{

}

- (void)test_b361_onipinapReplaceArray_Level2_FailCase
{

}

- (void)test_b362_onipinapReplaceArray_Level1
{

}

- (void)test_b363_onipinapUpdate_Level3_PostReplace
{

}

/* Object in an object in a plural (370-379) */
// oinonip
- (void)oinonipCreate
{

}

- (void)test_b370_oinonipUpdate_Level3_PreReplace_FailCase
{

}

- (void)test_b371_oinonipUpdate_Level2_PreReplace_FailCase
{

}

- (void)test_b372_oinonipReplaceArray_Level1
{

}

- (void)test_b373_oinonipUpdate_Level3_PostReplace
{

}

/* Object in a plural in an object (380-389) */
// onipino
/* Object in an object (390-399) */
// oinoino
- (void)oinoinoCreate
{

}

- (void)test_b390_oinoinoUpdate_Level1_NoChangeL2L3
{

}

- (void)test_b391_oinoinoUpdate_Level1_ChangeL2
{

}

- (void)test_b392_oinoinoUpdate_Level1_ChangeL3
{

}

- (void)test_b393_oinoinoUpdate_Level1_ChangeL2L3
{

}

- (void)test_b394_oinoinoReplace_Level1_ChangeL2L3
{

}

-(void)callSelectorPrefixed:(NSString *)prefixed withArguments:(NSObject *)arguments andTestSelectorString:(NSString *)testSelectorString
{
    NSString *newSelector = [NSString stringWithFormat:@"%@%@",
                                           [testSelectorString stringByReplacingOccurrencesOfString:@"test" withString:prefixed],
                                           @"_withArguments:andTestSelectorString:"];

    [self performSelector:_nsel(newSelector) withObject:arguments withObject:testSelectorString];
}

- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object
didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary = [result objectFromJSONString];
    NSArray      *resultArray      = [resultDictionary objectForKey:@"result"];

    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                newArray, @"newArray",
                                                                resultArray, @"resultArray",
                                                                object, @"captureObject",
                                                                result, @"result", nil];

    NSString *status             = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];
    @try
    {
        if ([status isEqualToString:@"continue"])
        {
            [self callSelectorPrefixed:@"continue" withArguments:arguments andTestSelectorString:testSelectorString];
            return;
        }
        else if ([status isEqualToString:@"finish"])
        {
            [self callSelectorPrefixed:@"finish" withArguments:arguments andTestSelectorString:testSelectorString];
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
    NSString *status             = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];

    GHTestLog(@"%@ %@", NSStringFromSelector(_cmd), result);

    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary *resultDictionary        = [result objectFromJSONString];
    NSDictionary *captureObjectDictionary = [resultDictionary objectForKey:@"result"];

    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    object, @"captureObject",
                                                    captureObjectDictionary, @"captureObjectDictionary",
                                                    result, @"result", nil];

    NSString *status             = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];
    @try
    {
        if ([status isEqualToString:@"continue"])
        {
            [self callSelectorPrefixed:@"continue" withArguments:arguments andTestSelectorString:testSelectorString];
            return;
        }
        if ([status isEqualToString:@"finish"])
        {
            [self callSelectorPrefixed:@"finish" withArguments:arguments andTestSelectorString:testSelectorString];
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
    NSString *status             = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];

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

    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    object, @"captureObject",
                                                    captureObjectDictionary, @"captureObjectDictionary",
                                                    result, @"result", nil];

    NSString *status             = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];
    @try
    {
        if ([status isEqualToString:@"continue"])
        {
            [self callSelectorPrefixed:@"continue" withArguments:arguments andTestSelectorString:testSelectorString];
            return;
        }
        if ([status isEqualToString:@"finish"])
        {
            [self callSelectorPrefixed:@"finish" withArguments:arguments andTestSelectorString:testSelectorString];
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
    NSString *status             = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *testSelectorString = [[((NSString *)context) componentsSeparatedByString:@"."] objectAtIndex:1];

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
