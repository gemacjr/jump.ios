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
#import "JRPinoL1Object.h"

@interface JRPinoL2PluralElement (PinoL2PluralElementInternalMethods)
+ (id)pinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinoL2PluralElement:(JRPinoL2PluralElement *)otherPinoL2PluralElement;
@end

@interface NSArray (PinoL2PluralToFromDictionary)
- (NSArray*)arrayOfPinoL2PluralElementsFromPinoL2PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinoL2PluralDictionariesFromPinoL2PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinoL2PluralReplaceDictionariesFromPinoL2PluralElements;
@end

@implementation NSArray (PinoL2PluralToFromDictionary)
- (NSArray*)arrayOfPinoL2PluralElementsFromPinoL2PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinoL2PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinoL2PluralArray addObject:[JRPinoL2PluralElement pinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinoL2PluralArray;
}

- (NSArray*)arrayOfPinoL2PluralDictionariesFromPinoL2PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinoL2PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoL2PluralReplaceDictionariesFromPinoL2PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinoL2PluralElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinoL1Object_ArrayComparison)
- (BOOL)isEqualToPinoL2PluralArray:(NSArray *)otherArray;
@end

@implementation NSArray (PinoL1Object_ArrayComparison)

- (BOOL)isEqualToPinoL2PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinoL2PluralElement *)[self objectAtIndex:i]) isEqualToPinoL2PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPinoL1Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoL1Object
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_pinoL2Plural;
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

- (NSArray *)pinoL2Plural
{
    return _pinoL2Plural;
}

- (void)setPinoL2Plural:(NSArray *)newPinoL2Plural
{
    [_pinoL2Plural autorelease];
    _pinoL2Plural = [newPinoL2Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoL1Object";
        self.canBeUpdatedOrReplaced = YES;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", nil]];
    }
    return self;
}

+ (id)pinoL1Object
{
    return [[[JRPinoL1Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinoL1Object *pinoL1ObjectCopy = (JRPinoL1Object *)[super copyWithZone:zone];

    pinoL1ObjectCopy.string1 = self.string1;
    pinoL1ObjectCopy.string2 = self.string2;
    pinoL1ObjectCopy.pinoL2Plural = self.pinoL2Plural;

    return pinoL1ObjectCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.pinoL2Plural ? [self.pinoL2Plural arrayOfPinoL2PluralDictionariesFromPinoL2PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinoL2Plural"];

    if (forEncoder)
    {
        [dictionary setObject:[self.dirtyPropertySet allObjects] forKey:@"dirtyPropertySet"];
        [dictionary setObject:self.captureObjectPath forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinoL1Object *pinoL1Object = [JRPinoL1Object pinoL1Object];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinoL1Object.captureObjectPath      = [dictionary objectForKey:@"captureObjectPath"];
    }

    pinoL1Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinoL1Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinoL1Object.pinoL2Plural =
        [dictionary objectForKey:@"pinoL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoL2Plural"] arrayOfPinoL2PluralElementsFromPinoL2PluralDictionariesWithPath:pinoL1Object.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pinoL1Object.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinoL1Object.dirtyPropertySet removeAllObjects];
    
    return pinoL1Object;
}

+ (id)pinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinoL1Object pinoL1ObjectObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
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

    self.pinoL2Plural =
        [dictionary objectForKey:@"pinoL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoL2Plural"] arrayOfPinoL2PluralElementsFromPinoL2PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

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
        [dictionary setObject:(self.pinoL2Plural ?
                          [self.pinoL2Plural arrayOfPinoL2PluralReplaceDictionariesFromPinoL2PluralElements] :
                          [NSArray array])
                       forKey:@"pinoL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replacePinoL2PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinoL2Plural named:@"pinoL2Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinoL1Object:(JRPinoL1Object *)otherPinoL1Object
{
    if (!self.string1 && !otherPinoL1Object.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPinoL1Object.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPinoL1Object.string1]) return NO;

    if (!self.string2 && !otherPinoL1Object.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPinoL1Object.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPinoL1Object.string2]) return NO;

    if (!self.pinoL2Plural && !otherPinoL1Object.pinoL2Plural) /* Keep going... */;
    else if (!self.pinoL2Plural && ![otherPinoL1Object.pinoL2Plural count]) /* Keep going... */;
    else if (!otherPinoL1Object.pinoL2Plural && ![self.pinoL2Plural count]) /* Keep going... */;
    else if (![self.pinoL2Plural isEqualToPinoL2PluralArray:otherPinoL1Object.pinoL2Plural]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"NSArray" forKey:@"pinoL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinoL2Plural release];

    [super dealloc];
}
@end
