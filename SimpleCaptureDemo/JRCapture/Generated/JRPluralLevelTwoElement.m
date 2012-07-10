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
#import "JRPluralLevelTwoElement.h"

@interface JRPluralLevelThreeElement (JRPluralLevelThreeElement_InternalMethods)
+ (id)pluralLevelThreeElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPluralLevelThreeElement:(JRPluralLevelThreeElement *)otherPluralLevelThreeElement;
@end

@implementation NSArray (JRArray_PluralLevelThree_ToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeElementsFromPluralLevelThreeDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPluralLevelThreeArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralLevelThreeArray addObject:[JRPluralLevelThreeElement pluralLevelThreeElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPluralLevelThreeArray;
}

- (NSArray*)arrayOfPluralLevelThreeElementsFromPluralLevelThreeDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPluralLevelThreeElementsFromPluralLevelThreeDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThreeElement class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThreeElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeElements
{
    return [self arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeElementsForEncoder:NO];
}

- (NSArray*)arrayOfPluralLevelThreeReplaceDictionariesFromPluralLevelThreeElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThreeElement class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThreeElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralLevelTwoElement_ArrayComparison)
- (BOOL)isEqualToPluralLevelThreeArray:(NSArray *)otherArray;
@end

@implementation NSArray (PluralLevelTwoElement_ArrayComparison)

- (BOOL)isEqualToPluralLevelThreeArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPluralLevelThreeElement *)[self objectAtIndex:i]) isEqualToPluralLevelThreeElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPluralLevelTwoElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRPluralLevelTwoElement
{
    JRObjectId *_pluralLevelTwoElementId;
    NSString *_level;
    NSString *_name;
    NSArray *_pluralLevelThree;
}
@synthesize canBeUpdatedOnCapture;

- (JRObjectId *)pluralLevelTwoElementId
{
    return _pluralLevelTwoElementId;
}

- (void)setPluralLevelTwoElementId:(JRObjectId *)newPluralLevelTwoElementId
{
    [self.dirtyPropertySet addObject:@"pluralLevelTwoElementId"];

    [_pluralLevelTwoElementId autorelease];
    _pluralLevelTwoElementId = [newPluralLevelTwoElementId copy];
}

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    [_level autorelease];
    _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    [_name autorelease];
    _name = [newName copy];
}

- (NSArray *)pluralLevelThree
{
    return _pluralLevelThree;
}

- (void)setPluralLevelThree:(NSArray *)newPluralLevelThree
{
    [_pluralLevelThree autorelease];
    _pluralLevelThree = [newPluralLevelThree copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)pluralLevelTwoElement
{
    return [[[JRPluralLevelTwoElement alloc] init] autorelease];
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.pluralLevelTwoElementId ? [NSNumber numberWithInteger:[self.pluralLevelTwoElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.level ? self.level : [NSNull null])
                   forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.pluralLevelThree ? [self.pluralLevelThree arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pluralLevelThree"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOnCapture] 
                       forKey:@"canBeUpdatedOnCapture"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pluralLevelTwoElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPluralLevelTwoElement *pluralLevelTwoElement = [JRPluralLevelTwoElement pluralLevelTwoElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pluralLevelTwoElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        pluralLevelTwoElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        pluralLevelTwoElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelTwo", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        pluralLevelTwoElement.canBeUpdatedOnCapture = YES;
    }

    pluralLevelTwoElement.pluralLevelTwoElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    pluralLevelTwoElement.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pluralLevelTwoElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pluralLevelTwoElement.pluralLevelThree =
        [dictionary objectForKey:@"pluralLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeElementsFromPluralLevelThreeDictionariesWithPath:pluralLevelTwoElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pluralLevelTwoElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pluralLevelTwoElement.dirtyPropertySet removeAllObjects];
    
    return pluralLevelTwoElement;
}

+ (id)pluralLevelTwoElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPluralLevelTwoElement pluralLevelTwoElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelTwo", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.pluralLevelTwoElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.pluralLevelThree =
        [dictionary objectForKey:@"pluralLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeElementsFromPluralLevelThreeDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"pluralLevelTwoElementId", @"level", @"name", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"pluralLevelTwoElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"pluralLevelTwoElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"pluralLevelTwoElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [dictionary setObject:(self.pluralLevelThree ?
                          [self.pluralLevelThree arrayOfPluralLevelThreeReplaceDictionariesFromPluralLevelThreeElements] :
                          [NSArray array])
                   forKey:@"pluralLevelThree"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replacePluralLevelThreeArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralLevelThree named:@"pluralLevelThree" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPluralLevelTwoElement:(JRPluralLevelTwoElement *)otherPluralLevelTwoElement
{
    if (!self.level && !otherPluralLevelTwoElement.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherPluralLevelTwoElement.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherPluralLevelTwoElement.level]) return NO;

    if (!self.name && !otherPluralLevelTwoElement.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherPluralLevelTwoElement.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherPluralLevelTwoElement.name]) return NO;

    if (!self.pluralLevelThree && !otherPluralLevelTwoElement.pluralLevelThree) /* Keep going... */;
    else if (!self.pluralLevelThree && ![otherPluralLevelTwoElement.pluralLevelThree count]) /* Keep going... */;
    else if (!otherPluralLevelTwoElement.pluralLevelThree && ![self.pluralLevelThree count]) /* Keep going... */;
    else if (![self.pluralLevelThree isEqualToPluralLevelThreeArray:otherPluralLevelTwoElement.pluralLevelThree]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"pluralLevelTwoElementId"];
    [dictionary setObject:@"NSString" forKey:@"level"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"NSArray" forKey:@"pluralLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_pluralLevelTwoElementId release];
    [_level release];
    [_name release];
    [_pluralLevelThree release];

    [super dealloc];
}
@end
