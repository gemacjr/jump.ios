/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRCaptureObject+Internal.h"
#import "JRPinonipL2Object.h"

@interface JRPinonipL3PluralElement (PinonipL3PluralElementInternalMethods)
+ (id)pinonipL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinonipL3PluralElement:(JRPinonipL3PluralElement *)otherPinonipL3PluralElement;
@end

@interface NSArray (PinonipL3PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElements;
- (NSArray*)arrayOfPinonipL3PluralReplaceDictionariesFromPinonipL3PluralElements;
@end

@implementation NSArray (PinonipL3PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinonipL3PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinonipL3PluralArray addObject:[JRPinonipL3PluralElement pinonipL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinonipL3PluralArray;
}

- (NSArray*)arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL3PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL3PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElements
{
    return [self arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElementsForEncoder:NO];
}

- (NSArray*)arrayOfPinonipL3PluralReplaceDictionariesFromPinonipL3PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL3PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL3PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinonipL2Object_ArrayComparison)
- (BOOL)isEqualToPinonipL3PluralArray:(NSArray *)otherArray;
@end

@implementation NSArray (PinonipL2Object_ArrayComparison)

- (BOOL)isEqualToPinonipL3PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinonipL3PluralElement *)[self objectAtIndex:i]) isEqualToPinonipL3PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPinonipL2Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinonipL2Object
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_pinonipL3Plural;
}
@synthesize canBeUpdatedOrReplaced;

- (NSString *)string1
{
    return _string1;
}

- (void)setString1:(NSString *)newString1
{
    [self.dirtyPropertySet addObject:@"string1"];

    [_string1 autorelease];
    _string1 = [newString1 copy];
}

- (NSString *)string2
{
    return _string2;
}

- (void)setString2:(NSString *)newString2
{
    [self.dirtyPropertySet addObject:@"string2"];

    [_string2 autorelease];
    _string2 = [newString2 copy];
}

- (NSArray *)pinonipL3Plural
{
    return _pinonipL3Plural;
}

- (void)setPinonipL3Plural:(NSArray *)newPinonipL3Plural
{
    [_pinonipL3Plural autorelease];
    _pinonipL3Plural = [newPinonipL3Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)pinonipL2Object
{
    return [[[JRPinonipL2Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinonipL2Object *pinonipL2ObjectCopy = (JRPinonipL2Object *)[super copyWithZone:zone];

    pinonipL2ObjectCopy.string1 = self.string1;
    pinonipL2ObjectCopy.string2 = self.string2;
    pinonipL2ObjectCopy.pinonipL3Plural = self.pinonipL3Plural;

    return pinonipL2ObjectCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.pinonipL3Plural ? [self.pinonipL3Plural arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinonipL3Plural"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] 
                       forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pinonipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinonipL2Object *pinonipL2Object = [JRPinonipL2Object pinonipL2Object];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinonipL2Object.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        pinonipL2Object.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        pinonipL2Object.captureObjectPath      = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinonipL2Object"];
        pinonipL2Object.canBeUpdatedOrReplaced = YES;
    }

    pinonipL2Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinonipL2Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinonipL2Object.pinonipL3Plural =
        [dictionary objectForKey:@"pinonipL3Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL3Plural"] arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:pinonipL2Object.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pinonipL2Object.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinonipL2Object.dirtyPropertySet removeAllObjects];
    
    return pinonipL2Object;
}

+ (id)pinonipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinonipL2Object pinonipL2ObjectObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinonipL2Object"];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinonipL2Object"];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    self.pinonipL3Plural =
        [dictionary objectForKey:@"pinonipL3Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL3Plural"] arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"string1", @"string2", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet setByAddingObjectsFromSet:[self updatablePropertySet]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"pinonipL2Object"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"pinonipL2Object"])
        [self.dirtyPropertySet setByAddingObjectsFromSet:[snapshotDictionary objectForKey:@"pinonipL2Object"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [dictionary setObject:(self.pinonipL3Plural ?
                          [self.pinonipL3Plural arrayOfPinonipL3PluralReplaceDictionariesFromPinonipL3PluralElements] :
                          [NSArray array])
                   forKey:@"pinonipL3Plural"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replacePinonipL3PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinonipL3Plural named:@"pinonipL3Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinonipL2Object:(JRPinonipL2Object *)otherPinonipL2Object
{
    if (!self.string1 && !otherPinonipL2Object.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPinonipL2Object.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPinonipL2Object.string1]) return NO;

    if (!self.string2 && !otherPinonipL2Object.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPinonipL2Object.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPinonipL2Object.string2]) return NO;

    if (!self.pinonipL3Plural && !otherPinonipL2Object.pinonipL3Plural) /* Keep going... */;
    else if (!self.pinonipL3Plural && ![otherPinonipL2Object.pinonipL3Plural count]) /* Keep going... */;
    else if (!otherPinonipL2Object.pinonipL3Plural && ![self.pinonipL3Plural count]) /* Keep going... */;
    else if (![self.pinonipL3Plural isEqualToPinonipL3PluralArray:otherPinonipL2Object.pinonipL3Plural]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"NSArray" forKey:@"pinonipL3Plural"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinonipL3Plural release];

    [super dealloc];
}
@end
