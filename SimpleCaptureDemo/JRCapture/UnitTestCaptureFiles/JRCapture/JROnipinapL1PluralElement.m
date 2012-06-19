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


#import "JROnipinapL1PluralElement.h"

@interface NSArray (OnipinapL2PluralToFromDictionary)
- (NSArray*)arrayOfOnipinapL2PluralElementsFromOnipinapL2PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipinapL2PluralDictionariesFromOnipinapL2PluralElements;
- (NSArray*)arrayOfOnipinapL2PluralReplaceDictionariesFromOnipinapL2PluralElements;
@end

@implementation NSArray (OnipinapL2PluralToFromDictionary)
- (NSArray*)arrayOfOnipinapL2PluralElementsFromOnipinapL2PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOnipinapL2PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipinapL2PluralArray addObject:[JROnipinapL2PluralElement onipinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOnipinapL2PluralArray;
}

- (NSArray*)arrayOfOnipinapL2PluralDictionariesFromOnipinapL2PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipinapL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipinapL2PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipinapL2PluralReplaceDictionariesFromOnipinapL2PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipinapL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipinapL2PluralElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (OnipinapL1PluralElement_ArrayComparison)

- (BOOL)isEqualToOtherOnipinapL2PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROnipinapL2PluralElement *)[self objectAtIndex:i]) isEqualToOnipinapL2PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JROnipinapL1PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipinapL1PluralElement
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_onipinapL2Plural;
}
@dynamic string1;
@dynamic string2;
@dynamic onipinapL2Plural;
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

- (NSArray *)onipinapL2Plural
{
    return _onipinapL2Plural;
}

- (void)setOnipinapL2Plural:(NSArray *)newOnipinapL2Plural
{
    [self.dirtyArraySet addObject:@"onipinapL2Plural"];

    [_onipinapL2Plural autorelease];
    _onipinapL2Plural = [newOnipinapL2Plural copy];
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

+ (id)onipinapL1PluralElement
{
    return [[[JROnipinapL1PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipinapL1PluralElement *onipinapL1PluralElementCopy = (JROnipinapL1PluralElement *)[super copyWithZone:zone];

    onipinapL1PluralElementCopy.string1 = self.string1;
    onipinapL1PluralElementCopy.string2 = self.string2;
    onipinapL1PluralElementCopy.onipinapL2Plural = self.onipinapL2Plural;

    return onipinapL1PluralElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.onipinapL2Plural ? [self.onipinapL2Plural arrayOfOnipinapL2PluralDictionariesFromOnipinapL2PluralElements] : [NSNull null])
             forKey:@"onipinapL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)onipinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROnipinapL1PluralElement *onipinapL1PluralElement = [JROnipinapL1PluralElement onipinapL1PluralElement];

    onipinapL1PluralElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinapL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    onipinapL1PluralElement.canBeUpdatedOrReplaced = YES;

    onipinapL1PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    onipinapL1PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    onipinapL1PluralElement.onipinapL2Plural =
        [dictionary objectForKey:@"onipinapL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL2Plural"] arrayOfOnipinapL2PluralElementsFromOnipinapL2PluralDictionariesWithPath:onipinapL1PluralElement.captureObjectPath] : nil;

    [onipinapL1PluralElement.dirtyPropertySet removeAllObjects];
    [onipinapL1PluralElement.dirtyArraySet removeAllObjects];
    
    return onipinapL1PluralElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinapL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

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
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinapL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    self.onipinapL2Plural =
        [dictionary objectForKey:@"onipinapL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL2Plural"] arrayOfOnipinapL2PluralElementsFromOnipinapL2PluralDictionariesWithPath:self.captureObjectPath] : nil;

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
        [dict setObject:(self.onipinapL2Plural ?
                          [self.onipinapL2Plural arrayOfOnipinapL2PluralReplaceDictionariesFromOnipinapL2PluralElements] :
                          [NSArray array])
                 forKey:@"onipinapL2Plural"];

    return dict;
}

- (void)replaceOnipinapL2PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.onipinapL2Plural named:@"onipinapL2Plural"
                    forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToOnipinapL1PluralElement:(JROnipinapL1PluralElement *)otherOnipinapL1PluralElement
{
    if (!self.string1 && !otherOnipinapL1PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherOnipinapL1PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherOnipinapL1PluralElement.string1]) return NO;

    if (!self.string2 && !otherOnipinapL1PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherOnipinapL1PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherOnipinapL1PluralElement.string2]) return NO;

    if (!self.onipinapL2Plural && !otherOnipinapL1PluralElement.onipinapL2Plural) /* Keep going... */;
    else if (!self.onipinapL2Plural && ![otherOnipinapL1PluralElement.onipinapL2Plural count]) /* Keep going... */;
    else if (!otherOnipinapL1PluralElement.onipinapL2Plural && ![self.onipinapL2Plural count]) /* Keep going... */;
    else if (![self.onipinapL2Plural isEqualToOtherOnipinapL2PluralArray:otherOnipinapL1PluralElement.onipinapL2Plural]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"NSArray" forKey:@"onipinapL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_onipinapL2Plural release];

    [super dealloc];
}
@end
