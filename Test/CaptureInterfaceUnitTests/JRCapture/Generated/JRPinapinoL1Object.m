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
#import "JRPinapinoL1Object.h"

@interface JRPinapinoL2PluralElement (PinapinoL2PluralElementInternalMethods)
+ (id)pinapinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinapinoL2PluralElement:(JRPinapinoL2PluralElement *)otherPinapinoL2PluralElement;
@end

@interface NSArray (PinapinoL2PluralToFromDictionary)
- (NSArray*)arrayOfPinapinoL2PluralElementsFromPinapinoL2PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinapinoL2PluralDictionariesFromPinapinoL2PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinapinoL2PluralReplaceDictionariesFromPinapinoL2PluralElements;
@end

@implementation NSArray (PinapinoL2PluralToFromDictionary)
- (NSArray*)arrayOfPinapinoL2PluralElementsFromPinapinoL2PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinapinoL2PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapinoL2PluralArray addObject:[JRPinapinoL2PluralElement pinapinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinapinoL2PluralArray;
}

- (NSArray*)arrayOfPinapinoL2PluralDictionariesFromPinapinoL2PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinoL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinoL2PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapinoL2PluralReplaceDictionariesFromPinapinoL2PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinoL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinoL2PluralElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinapinoL1Object_ArrayComparison)
- (BOOL)isEqualToPinapinoL2PluralArray:(NSArray *)otherArray;
@end

@implementation NSArray (PinapinoL1Object_ArrayComparison)

- (BOOL)isEqualToPinapinoL2PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinapinoL2PluralElement *)[self objectAtIndex:i]) isEqualToPinapinoL2PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPinapinoL1Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinapinoL1Object
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_pinapinoL2Plural;
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

- (NSArray *)pinapinoL2Plural
{
    return _pinapinoL2Plural;
}

- (void)setPinapinoL2Plural:(NSArray *)newPinapinoL2Plural
{
    [_pinapinoL2Plural autorelease];
    _pinapinoL2Plural = [newPinapinoL2Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinapinoL1Object";
        self.canBeUpdatedOrReplaced = YES;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", nil]];
    }
    return self;
}

+ (id)pinapinoL1Object
{
    return [[[JRPinapinoL1Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinapinoL1Object *pinapinoL1ObjectCopy = (JRPinapinoL1Object *)[super copyWithZone:zone];

    pinapinoL1ObjectCopy.string1 = self.string1;
    pinapinoL1ObjectCopy.string2 = self.string2;
    pinapinoL1ObjectCopy.pinapinoL2Plural = self.pinapinoL2Plural;

    return pinapinoL1ObjectCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.pinapinoL2Plural ? [self.pinapinoL2Plural arrayOfPinapinoL2PluralDictionariesFromPinapinoL2PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinapinoL2Plural"];

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

+ (id)pinapinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinapinoL1Object *pinapinoL1Object = [JRPinapinoL1Object pinapinoL1Object];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinapinoL1Object.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    pinapinoL1Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinapinoL1Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinapinoL1Object.pinapinoL2Plural =
        [dictionary objectForKey:@"pinapinoL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinoL2Plural"] arrayOfPinapinoL2PluralElementsFromPinapinoL2PluralDictionariesWithPath:pinapinoL1Object.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pinapinoL1Object.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinapinoL1Object.dirtyPropertySet removeAllObjects];
    
    return pinapinoL1Object;
}

+ (id)pinapinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

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

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    self.pinapinoL2Plural =
        [dictionary objectForKey:@"pinapinoL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinoL2Plural"] arrayOfPinapinoL2PluralElementsFromPinapinoL2PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if (includingArrays)
        [dictionary setObject:(self.pinapinoL2Plural ?
                          [self.pinapinoL2Plural arrayOfPinapinoL2PluralReplaceDictionariesFromPinapinoL2PluralElements] :
                          [NSArray array])
                       forKey:@"pinapinoL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replacePinapinoL2PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapinoL2Plural named:@"pinapinoL2Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinapinoL1Object:(JRPinapinoL1Object *)otherPinapinoL1Object
{
    if (!self.string1 && !otherPinapinoL1Object.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPinapinoL1Object.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPinapinoL1Object.string1]) return NO;

    if (!self.string2 && !otherPinapinoL1Object.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPinapinoL1Object.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPinapinoL1Object.string2]) return NO;

    if (!self.pinapinoL2Plural && !otherPinapinoL1Object.pinapinoL2Plural) /* Keep going... */;
    else if (!self.pinapinoL2Plural && ![otherPinapinoL1Object.pinapinoL2Plural count]) /* Keep going... */;
    else if (!otherPinapinoL1Object.pinapinoL2Plural && ![self.pinapinoL2Plural count]) /* Keep going... */;
    else if (![self.pinapinoL2Plural isEqualToPinapinoL2PluralArray:otherPinapinoL1Object.pinapinoL2Plural]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"NSArray" forKey:@"pinapinoL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinapinoL2Plural release];

    [super dealloc];
}
@end
