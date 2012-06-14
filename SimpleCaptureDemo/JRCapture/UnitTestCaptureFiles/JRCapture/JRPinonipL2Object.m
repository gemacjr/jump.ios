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


#import "JRPinonipL2Object.h"

@interface NSArray (PinonipL3PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElements;
- (NSArray*)arrayOfPinonipL3PluralReplaceDictionariesFromPinonipL3PluralElements;
@end

@implementation NSArray (PinonipL3PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinonipL3PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinonipL3PluralArray addObject:[JRPinonipL3PluralElement pinonipL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinonipL3PluralArray;
}

- (NSArray*)arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL3PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL3PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinonipL3PluralReplaceDictionariesFromPinonipL3PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL3PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL3PluralElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (PinonipL2Object_ArrayComparison)

- (BOOL)isEqualToOtherPinonipL3PluralArray:(NSArray *)otherArray
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
@dynamic string1;
@dynamic string2;
@dynamic pinonipL3Plural;
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
    [self.dirtyArraySet addObject:@"pinonipL3Plural"];

    [_pinonipL3Plural autorelease];
    _pinonipL3Plural = [newPinonipL3Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)pinonipL2Object
{
    return [[[JRPinonipL2Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinonipL2Object *pinonipL2ObjectCopy = (JRPinonipL2Object *)[super copy];

    pinonipL2ObjectCopy.string1 = self.string1;
    pinonipL2ObjectCopy.string2 = self.string2;
    pinonipL2ObjectCopy.pinonipL3Plural = self.pinonipL3Plural;

    return pinonipL2ObjectCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.pinonipL3Plural ? [self.pinonipL3Plural arrayOfPinonipL3PluralDictionariesFromPinonipL3PluralElements] : [NSNull null])
             forKey:@"pinonipL3Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinonipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinonipL2Object *pinonipL2Object = [JRPinonipL2Object pinonipL2Object];

    pinonipL2Object.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinonipL2Object"];
// TODO: Is this safe to assume?
    pinonipL2Object.canBeUpdatedOrReplaced = YES;

    pinonipL2Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinonipL2Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinonipL2Object.pinonipL3Plural =
        [dictionary objectForKey:@"pinonipL3Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL3Plural"] arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:pinonipL2Object.captureObjectPath] : nil;

    [pinonipL2Object.dirtyPropertySet removeAllObjects];
    [pinonipL2Object.dirtyArraySet removeAllObjects];
    
    return pinonipL2Object;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinonipL2Object"];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

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
        [(NSArray*)[dictionary objectForKey:@"pinonipL3Plural"] arrayOfPinonipL3PluralElementsFromPinonipL3PluralDictionariesWithPath:self.captureObjectPath] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    return dict;
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if (includingArrays)
        [dict setObject:(self.pinonipL3Plural ? [self.pinonipL3Plural arrayOfPinonipL3PluralReplaceDictionariesFromPinonipL3PluralElements] : [NSArray array]) forKey:@"pinonipL3Plural"];

    return dict;
}

- (void)replacePinonipL3PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinonipL3Plural named:@"pinonipL3Plural"
                    forDelegate:delegate withContext:context];
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
    else if (![self.pinonipL3Plural isEqualToOtherPinonipL3PluralArray:otherPinonipL2Object.pinonipL3Plural]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"NSArray" forKey:@"pinonipL3Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinonipL3Plural release];

    [super dealloc];
}
@end
