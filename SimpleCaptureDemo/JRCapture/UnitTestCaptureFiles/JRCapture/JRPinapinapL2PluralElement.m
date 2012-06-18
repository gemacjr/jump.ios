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


#import "JRPinapinapL2PluralElement.h"

@interface NSArray (PinapinapL3PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL3PluralElementsFromPinapinapL3PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinapinapL3PluralDictionariesFromPinapinapL3PluralElements;
- (NSArray*)arrayOfPinapinapL3PluralReplaceDictionariesFromPinapinapL3PluralElements;
@end

@implementation NSArray (PinapinapL3PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL3PluralElementsFromPinapinapL3PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinapinapL3PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapinapL3PluralArray addObject:[JRPinapinapL3PluralElement pinapinapL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinapinapL3PluralArray;
}

- (NSArray*)arrayOfPinapinapL3PluralDictionariesFromPinapinapL3PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL3PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL3PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapinapL3PluralReplaceDictionariesFromPinapinapL3PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL3PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL3PluralElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (PinapinapL2PluralElement_ArrayComparison)

- (BOOL)isEqualToOtherPinapinapL3PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinapinapL3PluralElement *)[self objectAtIndex:i]) isEqualToPinapinapL3PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPinapinapL2PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinapinapL2PluralElement
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_pinapinapL3Plural;
}
@dynamic string1;
@dynamic string2;
@dynamic pinapinapL3Plural;
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

- (NSArray *)pinapinapL3Plural
{
    return _pinapinapL3Plural;
}

- (void)setPinapinapL3Plural:(NSArray *)newPinapinapL3Plural
{
    [self.dirtyArraySet addObject:@"pinapinapL3Plural"];

    [_pinapinapL3Plural autorelease];
    _pinapinapL3Plural = [newPinapinapL3Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", nil]];
    }
    return self;
}

+ (id)pinapinapL2PluralElement
{
    return [[[JRPinapinapL2PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinapinapL2PluralElement *pinapinapL2PluralElementCopy = (JRPinapinapL2PluralElement *)[super copy];

    pinapinapL2PluralElementCopy.string1 = self.string1;
    pinapinapL2PluralElementCopy.string2 = self.string2;
    pinapinapL2PluralElementCopy.pinapinapL3Plural = self.pinapinapL3Plural;

    return pinapinapL2PluralElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.pinapinapL3Plural ? [self.pinapinapL3Plural arrayOfPinapinapL3PluralDictionariesFromPinapinapL3PluralElements] : [NSNull null])
             forKey:@"pinapinapL3Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinapinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinapinapL2PluralElement *pinapinapL2PluralElement = [JRPinapinapL2PluralElement pinapinapL2PluralElement];

    pinapinapL2PluralElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinapL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    pinapinapL2PluralElement.canBeUpdatedOrReplaced = YES;

    pinapinapL2PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinapinapL2PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinapinapL2PluralElement.pinapinapL3Plural =
        [dictionary objectForKey:@"pinapinapL3Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL3Plural"] arrayOfPinapinapL3PluralElementsFromPinapinapL3PluralDictionariesWithPath:pinapinapL2PluralElement.captureObjectPath] : nil;

    [pinapinapL2PluralElement.dirtyPropertySet removeAllObjects];
    [pinapinapL2PluralElement.dirtyArraySet removeAllObjects];
    
    return pinapinapL2PluralElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinapL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

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
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinapL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    self.pinapinapL3Plural =
        [dictionary objectForKey:@"pinapinapL3Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL3Plural"] arrayOfPinapinapL3PluralElementsFromPinapinapL3PluralDictionariesWithPath:self.captureObjectPath] : nil;

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
        [dict setObject:(self.pinapinapL3Plural ?
                          [self.pinapinapL3Plural arrayOfPinapinapL3PluralReplaceDictionariesFromPinapinapL3PluralElements] :
                          [NSArray array])
                 forKey:@"pinapinapL3Plural"];

    return dict;
}

- (void)replacePinapinapL3PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapinapL3Plural named:@"pinapinapL3Plural"
                    forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinapinapL2PluralElement:(JRPinapinapL2PluralElement *)otherPinapinapL2PluralElement
{
    if (!self.string1 && !otherPinapinapL2PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPinapinapL2PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPinapinapL2PluralElement.string1]) return NO;

    if (!self.string2 && !otherPinapinapL2PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPinapinapL2PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPinapinapL2PluralElement.string2]) return NO;

    if (!self.pinapinapL3Plural && !otherPinapinapL2PluralElement.pinapinapL3Plural) /* Keep going... */;
    else if (!self.pinapinapL3Plural && ![otherPinapinapL2PluralElement.pinapinapL3Plural count]) /* Keep going... */;
    else if (!otherPinapinapL2PluralElement.pinapinapL3Plural && ![self.pinapinapL3Plural count]) /* Keep going... */;
    else if (![self.pinapinapL3Plural isEqualToOtherPinapinapL3PluralArray:otherPinapinapL2PluralElement.pinapinapL3Plural]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"NSArray" forKey:@"pinapinapL3Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinapinapL3Plural release];

    [super dealloc];
}
@end
