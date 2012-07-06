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
#import "JRPluralLevelOneElement.h"

@interface JRPluralLevelTwoElement (PluralLevelTwoElementInternalMethods)
+ (id)pluralLevelTwoElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPluralLevelTwoElement:(JRPluralLevelTwoElement *)otherPluralLevelTwoElement;
@end

@interface NSArray (PluralLevelTwoToFromDictionary)
- (NSArray*)arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoElements;
- (NSArray*)arrayOfPluralLevelTwoReplaceDictionariesFromPluralLevelTwoElements;
@end

@implementation NSArray (PluralLevelTwoToFromDictionary)
- (NSArray*)arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPluralLevelTwoArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralLevelTwoArray addObject:[JRPluralLevelTwoElement pluralLevelTwoElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPluralLevelTwoArray;
}

- (NSArray*)arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelTwoElement class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelTwoElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoElements
{
    return [self arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoElementsForEncoder:NO];
}

- (NSArray*)arrayOfPluralLevelTwoReplaceDictionariesFromPluralLevelTwoElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelTwoElement class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelTwoElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralLevelOneElement_ArrayComparison)
- (BOOL)isEqualToPluralLevelTwoArray:(NSArray *)otherArray;
@end

@implementation NSArray (PluralLevelOneElement_ArrayComparison)

- (BOOL)isEqualToPluralLevelTwoArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPluralLevelTwoElement *)[self objectAtIndex:i]) isEqualToPluralLevelTwoElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPluralLevelOneElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRPluralLevelOneElement
{
    JRObjectId *_pluralLevelOneElementId;
    NSString *_level;
    NSString *_name;
    NSArray *_pluralLevelTwo;
}
@synthesize canBeUpdatedOnCapture;

- (JRObjectId *)pluralLevelOneElementId
{
    return _pluralLevelOneElementId;
}

- (void)setPluralLevelOneElementId:(JRObjectId *)newPluralLevelOneElementId
{
    [self.dirtyPropertySet addObject:@"pluralLevelOneElementId"];

    [_pluralLevelOneElementId autorelease];
    _pluralLevelOneElementId = [newPluralLevelOneElementId copy];
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

- (NSArray *)pluralLevelTwo
{
    return _pluralLevelTwo;
}

- (void)setPluralLevelTwo:(NSArray *)newPluralLevelTwo
{
    [_pluralLevelTwo autorelease];
    _pluralLevelTwo = [newPluralLevelTwo copy];
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

+ (id)pluralLevelOneElement
{
    return [[[JRPluralLevelOneElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPluralLevelOneElement *pluralLevelOneElementCopy = (JRPluralLevelOneElement *)[super copyWithZone:zone];

    pluralLevelOneElementCopy.pluralLevelOneElementId = self.pluralLevelOneElementId;
    pluralLevelOneElementCopy.level = self.level;
    pluralLevelOneElementCopy.name = self.name;
    pluralLevelOneElementCopy.pluralLevelTwo = self.pluralLevelTwo;

    return pluralLevelOneElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.pluralLevelOneElementId ? [NSNumber numberWithInteger:[self.pluralLevelOneElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.level ? self.level : [NSNull null])
                   forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.pluralLevelTwo ? [self.pluralLevelTwo arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pluralLevelTwo"];

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

+ (id)pluralLevelOneElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPluralLevelOneElement *pluralLevelOneElement = [JRPluralLevelOneElement pluralLevelOneElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pluralLevelOneElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        pluralLevelOneElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        pluralLevelOneElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        pluralLevelOneElement.canBeUpdatedOnCapture = YES;
    }

    pluralLevelOneElement.pluralLevelOneElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    pluralLevelOneElement.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pluralLevelOneElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pluralLevelOneElement.pluralLevelTwo =
        [dictionary objectForKey:@"pluralLevelTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelTwo"] arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:pluralLevelOneElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pluralLevelOneElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pluralLevelOneElement.dirtyPropertySet removeAllObjects];
    
    return pluralLevelOneElement;
}

+ (id)pluralLevelOneElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPluralLevelOneElement pluralLevelOneElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.pluralLevelOneElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.pluralLevelOneElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.pluralLevelTwo =
        [dictionary objectForKey:@"pluralLevelTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelTwo"] arrayOfPluralLevelTwoElementsFromPluralLevelTwoDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"pluralLevelOneElementId", @"level", @"name", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"pluralLevelOneElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"pluralLevelOneElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"pluralLevelOneElement"] allObjects]];

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

    [dictionary setObject:(self.pluralLevelTwo ?
                          [self.pluralLevelTwo arrayOfPluralLevelTwoReplaceDictionariesFromPluralLevelTwoElements] :
                          [NSArray array])
                   forKey:@"pluralLevelTwo"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replacePluralLevelTwoArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralLevelTwo named:@"pluralLevelTwo" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPluralLevelOneElement:(JRPluralLevelOneElement *)otherPluralLevelOneElement
{
    if (!self.level && !otherPluralLevelOneElement.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherPluralLevelOneElement.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherPluralLevelOneElement.level]) return NO;

    if (!self.name && !otherPluralLevelOneElement.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherPluralLevelOneElement.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherPluralLevelOneElement.name]) return NO;

    if (!self.pluralLevelTwo && !otherPluralLevelOneElement.pluralLevelTwo) /* Keep going... */;
    else if (!self.pluralLevelTwo && ![otherPluralLevelOneElement.pluralLevelTwo count]) /* Keep going... */;
    else if (!otherPluralLevelOneElement.pluralLevelTwo && ![self.pluralLevelTwo count]) /* Keep going... */;
    else if (![self.pluralLevelTwo isEqualToPluralLevelTwoArray:otherPluralLevelOneElement.pluralLevelTwo]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"pluralLevelOneElementId"];
    [dictionary setObject:@"NSString" forKey:@"level"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"NSArray" forKey:@"pluralLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_pluralLevelOneElementId release];
    [_level release];
    [_name release];
    [_pluralLevelTwo release];

    [super dealloc];
}
@end
