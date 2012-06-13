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


#import "JRCaptureUser.h"

@interface NSArray (BasicPluralToFromDictionary)
- (NSArray*)arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfBasicPluralDictionariesFromBasicPluralElements;
- (NSArray*)arrayOfBasicPluralReplaceDictionariesFromBasicPluralElements;
@end

@implementation NSArray (BasicPluralToFromDictionary)
- (NSArray*)arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredBasicPluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredBasicPluralArray addObject:[JRBasicPluralElement basicPluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredBasicPluralArray;
}

- (NSArray*)arrayOfBasicPluralDictionariesFromBasicPluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRBasicPluralElement class]])
            [filteredDictionaryArray addObject:[(JRBasicPluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfBasicPluralReplaceDictionariesFromBasicPluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRBasicPluralElement class]])
            [filteredDictionaryArray addObject:[(JRBasicPluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralTestUniqueToFromDictionary)
- (NSArray*)arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElements;
- (NSArray*)arrayOfPluralTestUniqueReplaceDictionariesFromPluralTestUniqueElements;
@end

@implementation NSArray (PluralTestUniqueToFromDictionary)
- (NSArray*)arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPluralTestUniqueArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralTestUniqueArray addObject:[JRPluralTestUniqueElement pluralTestUniqueElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPluralTestUniqueArray;
}

- (NSArray*)arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralTestUniqueElement class]])
            [filteredDictionaryArray addObject:[(JRPluralTestUniqueElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralTestUniqueReplaceDictionariesFromPluralTestUniqueElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralTestUniqueElement class]])
            [filteredDictionaryArray addObject:[(JRPluralTestUniqueElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralTestAlphabeticToFromDictionary)
- (NSArray*)arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElements;
- (NSArray*)arrayOfPluralTestAlphabeticReplaceDictionariesFromPluralTestAlphabeticElements;
@end

@implementation NSArray (PluralTestAlphabeticToFromDictionary)
- (NSArray*)arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPluralTestAlphabeticArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralTestAlphabeticArray addObject:[JRPluralTestAlphabeticElement pluralTestAlphabeticElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPluralTestAlphabeticArray;
}

- (NSArray*)arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralTestAlphabeticElement class]])
            [filteredDictionaryArray addObject:[(JRPluralTestAlphabeticElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralTestAlphabeticReplaceDictionariesFromPluralTestAlphabeticElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralTestAlphabeticElement class]])
            [filteredDictionaryArray addObject:[(JRPluralTestAlphabeticElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (SimpleStringPluralOneToFromDictionary)
- (NSArray*)arrayOfSimpleStringPluralOneElementsFromSimpleStringPluralOneDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfSimpleStringPluralOneDictionariesFromSimpleStringPluralOneElements;
- (NSArray*)arrayOfSimpleStringPluralOneReplaceDictionariesFromSimpleStringPluralOneElements;
@end

@implementation NSArray (SimpleStringPluralOneToFromDictionary)
- (NSArray*)arrayOfSimpleStringPluralOneElementsFromSimpleStringPluralOneDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredSimpleStringPluralOneArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredSimpleStringPluralOneArray addObject:[JRSimpleStringPluralOneElement simpleStringPluralOneElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredSimpleStringPluralOneArray;
}

- (NSArray*)arrayOfSimpleStringPluralOneDictionariesFromSimpleStringPluralOneElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSimpleStringPluralOneElement class]])
            [filteredDictionaryArray addObject:[(JRSimpleStringPluralOneElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfSimpleStringPluralOneReplaceDictionariesFromSimpleStringPluralOneElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSimpleStringPluralOneElement class]])
            [filteredDictionaryArray addObject:[(JRSimpleStringPluralOneElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (SimpleStringPluralTwoToFromDictionary)
- (NSArray*)arrayOfSimpleStringPluralTwoElementsFromSimpleStringPluralTwoDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfSimpleStringPluralTwoDictionariesFromSimpleStringPluralTwoElements;
- (NSArray*)arrayOfSimpleStringPluralTwoReplaceDictionariesFromSimpleStringPluralTwoElements;
@end

@implementation NSArray (SimpleStringPluralTwoToFromDictionary)
- (NSArray*)arrayOfSimpleStringPluralTwoElementsFromSimpleStringPluralTwoDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredSimpleStringPluralTwoArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredSimpleStringPluralTwoArray addObject:[JRSimpleStringPluralTwoElement simpleStringPluralTwoElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredSimpleStringPluralTwoArray;
}

- (NSArray*)arrayOfSimpleStringPluralTwoDictionariesFromSimpleStringPluralTwoElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSimpleStringPluralTwoElement class]])
            [filteredDictionaryArray addObject:[(JRSimpleStringPluralTwoElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfSimpleStringPluralTwoReplaceDictionariesFromSimpleStringPluralTwoElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSimpleStringPluralTwoElement class]])
            [filteredDictionaryArray addObject:[(JRSimpleStringPluralTwoElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinapL1PluralDictionariesFromPinapL1PluralElements;
- (NSArray*)arrayOfPinapL1PluralReplaceDictionariesFromPinapL1PluralElements;
@end

@implementation NSArray (PinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinapL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapL1PluralArray addObject:[JRPinapL1PluralElement pinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinapL1PluralArray;
}

- (NSArray*)arrayOfPinapL1PluralDictionariesFromPinapL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapL1PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapL1PluralReplaceDictionariesFromPinapL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapL1PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OnipL1PluralToFromDictionary)
- (NSArray*)arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipL1PluralDictionariesFromOnipL1PluralElements;
- (NSArray*)arrayOfOnipL1PluralReplaceDictionariesFromOnipL1PluralElements;
@end

@implementation NSArray (OnipL1PluralToFromDictionary)
- (NSArray*)arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOnipL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipL1PluralArray addObject:[JROnipL1PluralElement onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOnipL1PluralArray;
}

- (NSArray*)arrayOfOnipL1PluralDictionariesFromOnipL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipL1PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipL1PluralReplaceDictionariesFromOnipL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipL1PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinapinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElements;
- (NSArray*)arrayOfPinapinapL1PluralReplaceDictionariesFromPinapinapL1PluralElements;
@end

@implementation NSArray (PinapinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinapinapL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapinapL1PluralArray addObject:[JRPinapinapL1PluralElement pinapinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinapinapL1PluralArray;
}

- (NSArray*)arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL1PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapinapL1PluralReplaceDictionariesFromPinapinapL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL1PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinonipL1PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElements;
- (NSArray*)arrayOfPinonipL1PluralReplaceDictionariesFromPinonipL1PluralElements;
@end

@implementation NSArray (PinonipL1PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinonipL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinonipL1PluralArray addObject:[JRPinonipL1PluralElement pinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinonipL1PluralArray;
}

- (NSArray*)arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL1PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinonipL1PluralReplaceDictionariesFromPinonipL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL1PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OnipinapL1PluralToFromDictionary)
- (NSArray*)arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElements;
- (NSArray*)arrayOfOnipinapL1PluralReplaceDictionariesFromOnipinapL1PluralElements;
@end

@implementation NSArray (OnipinapL1PluralToFromDictionary)
- (NSArray*)arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOnipinapL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipinapL1PluralArray addObject:[JROnipinapL1PluralElement onipinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOnipinapL1PluralArray;
}

- (NSArray*)arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipinapL1PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipinapL1PluralReplaceDictionariesFromOnipinapL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipinapL1PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OinonipL1PluralToFromDictionary)
- (NSArray*)arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElements;
- (NSArray*)arrayOfOinonipL1PluralReplaceDictionariesFromOinonipL1PluralElements;
@end

@implementation NSArray (OinonipL1PluralToFromDictionary)
- (NSArray*)arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOinonipL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOinonipL1PluralArray addObject:[JROinonipL1PluralElement oinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOinonipL1PluralArray;
}

- (NSArray*)arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROinonipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROinonipL1PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOinonipL1PluralReplaceDictionariesFromOinonipL1PluralElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROinonipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROinonipL1PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (CaptureUser_ArrayComparison)

- (BOOL)isEqualToOtherBasicPluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRBasicPluralElement *)[self objectAtIndex:i]) isEqualToBasicPluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherPluralTestUniqueArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPluralTestUniqueElement *)[self objectAtIndex:i]) isEqualToPluralTestUniqueElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherPluralTestAlphabeticArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPluralTestAlphabeticElement *)[self objectAtIndex:i]) isEqualToPluralTestAlphabeticElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherSimpleStringPluralOneArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRSimpleStringPluralOneElement *)[self objectAtIndex:i]) isEqualToSimpleStringPluralOneElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherSimpleStringPluralTwoArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRSimpleStringPluralTwoElement *)[self objectAtIndex:i]) isEqualToSimpleStringPluralTwoElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherPinapL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinapL1PluralElement *)[self objectAtIndex:i]) isEqualToPinapL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherOnipL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROnipL1PluralElement *)[self objectAtIndex:i]) isEqualToOnipL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherPinapinapL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinapinapL1PluralElement *)[self objectAtIndex:i]) isEqualToPinapinapL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherPinonipL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinonipL1PluralElement *)[self objectAtIndex:i]) isEqualToPinonipL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherOnipinapL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROnipinapL1PluralElement *)[self objectAtIndex:i]) isEqualToOnipinapL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOtherOinonipL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROinonipL1PluralElement *)[self objectAtIndex:i]) isEqualToOinonipL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRCaptureUser ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRCaptureUser
{
    NSString *_email;
    JRBoolean *_basicBoolean;
    NSString *_basicString;
    JRInteger *_basicInteger;
    NSNumber *_basicDecimal;
    JRDate *_basicDate;
    JRDateTime *_basicDateTime;
    JRIpAddress *_basicIpAddress;
    JRPassword *_basicPassword;
    JRJsonObject *_jsonNumber;
    JRJsonObject *_jsonString;
    JRJsonObject *_jsonArray;
    JRJsonObject *_jsonDictionary;
    NSString *_stringTestJson;
    NSString *_stringTestEmpty;
    NSString *_stringTestNull;
    NSString *_stringTestInvalid;
    NSString *_stringTestNSNull;
    NSString *_stringTestAlphanumeric;
    NSString *_stringTestUnicodeLetters;
    NSString *_stringTestUnicodePrintable;
    NSString *_stringTestEmailAddress;
    NSString *_stringTestLength;
    NSString *_stringTestCaseSensitive;
    NSString *_stringTestFeatures;
    NSArray *_basicPlural;
    JRBasicObject *_basicObject;
    JRObjectTestRequired *_objectTestRequired;
    NSArray *_pluralTestUnique;
    JRObjectTestRequiredUnique *_objectTestRequiredUnique;
    NSArray *_pluralTestAlphabetic;
    NSArray *_simpleStringPluralOne;
    NSArray *_simpleStringPluralTwo;
    NSArray *_pinapL1Plural;
    JRPinoL1Object *_pinoL1Object;
    NSArray *_onipL1Plural;
    JROinoL1Object *_oinoL1Object;
    NSArray *_pinapinapL1Plural;
    NSArray *_pinonipL1Plural;
    JRPinapinoL1Object *_pinapinoL1Object;
    JRPinoinoL1Object *_pinoinoL1Object;
    NSArray *_onipinapL1Plural;
    NSArray *_oinonipL1Plural;
    JROnipinoL1Object *_onipinoL1Object;
    JROinoinoL1Object *_oinoinoL1Object;
}
@dynamic email;
@dynamic basicBoolean;
@dynamic basicString;
@dynamic basicInteger;
@dynamic basicDecimal;
@dynamic basicDate;
@dynamic basicDateTime;
@dynamic basicIpAddress;
@dynamic basicPassword;
@dynamic jsonNumber;
@dynamic jsonString;
@dynamic jsonArray;
@dynamic jsonDictionary;
@dynamic stringTestJson;
@dynamic stringTestEmpty;
@dynamic stringTestNull;
@dynamic stringTestInvalid;
@dynamic stringTestNSNull;
@dynamic stringTestAlphanumeric;
@dynamic stringTestUnicodeLetters;
@dynamic stringTestUnicodePrintable;
@dynamic stringTestEmailAddress;
@dynamic stringTestLength;
@dynamic stringTestCaseSensitive;
@dynamic stringTestFeatures;
@dynamic basicPlural;
@dynamic basicObject;
@dynamic objectTestRequired;
@dynamic pluralTestUnique;
@dynamic objectTestRequiredUnique;
@dynamic pluralTestAlphabetic;
@dynamic simpleStringPluralOne;
@dynamic simpleStringPluralTwo;
@dynamic pinapL1Plural;
@dynamic pinoL1Object;
@dynamic onipL1Plural;
@dynamic oinoL1Object;
@dynamic pinapinapL1Plural;
@dynamic pinonipL1Plural;
@dynamic pinapinoL1Object;
@dynamic pinoinoL1Object;
@dynamic onipinapL1Plural;
@dynamic oinonipL1Plural;
@dynamic onipinoL1Object;
@dynamic oinoinoL1Object;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)email
{
    return _email;
}

- (void)setEmail:(NSString *)newEmail
{
    [self.dirtyPropertySet addObject:@"email"];
    _email = [newEmail copy];
}

- (JRBoolean *)basicBoolean
{
    return _basicBoolean;
}

- (void)setBasicBoolean:(JRBoolean *)newBasicBoolean
{
    [self.dirtyPropertySet addObject:@"basicBoolean"];
    _basicBoolean = [newBasicBoolean copy];
}

- (BOOL)getBasicBooleanBoolValue
{
    return [_basicBoolean boolValue];
}

- (void)setBasicBooleanWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"basicBoolean"];
    _basicBoolean = [NSNumber numberWithBool:boolVal];
}

- (NSString *)basicString
{
    return _basicString;
}

- (void)setBasicString:(NSString *)newBasicString
{
    [self.dirtyPropertySet addObject:@"basicString"];
    _basicString = [newBasicString copy];
}

- (JRInteger *)basicInteger
{
    return _basicInteger;
}

- (void)setBasicInteger:(JRInteger *)newBasicInteger
{
    [self.dirtyPropertySet addObject:@"basicInteger"];
    _basicInteger = [newBasicInteger copy];
}

- (NSInteger)getBasicIntegerIntegerValue
{
    return [_basicInteger integerValue];
}

- (void)setBasicIntegerWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"basicInteger"];
    _basicInteger = [NSNumber numberWithInteger:integerVal];
}

- (NSNumber *)basicDecimal
{
    return _basicDecimal;
}

- (void)setBasicDecimal:(NSNumber *)newBasicDecimal
{
    [self.dirtyPropertySet addObject:@"basicDecimal"];
    _basicDecimal = [newBasicDecimal copy];
}

- (JRDate *)basicDate
{
    return _basicDate;
}

- (void)setBasicDate:(JRDate *)newBasicDate
{
    [self.dirtyPropertySet addObject:@"basicDate"];
    _basicDate = [newBasicDate copy];
}

- (JRDateTime *)basicDateTime
{
    return _basicDateTime;
}

- (void)setBasicDateTime:(JRDateTime *)newBasicDateTime
{
    [self.dirtyPropertySet addObject:@"basicDateTime"];
    _basicDateTime = [newBasicDateTime copy];
}

- (JRIpAddress *)basicIpAddress
{
    return _basicIpAddress;
}

- (void)setBasicIpAddress:(JRIpAddress *)newBasicIpAddress
{
    [self.dirtyPropertySet addObject:@"basicIpAddress"];
    _basicIpAddress = [newBasicIpAddress copy];
}

- (JRPassword *)basicPassword
{
    return _basicPassword;
}

- (void)setBasicPassword:(JRPassword *)newBasicPassword
{
    [self.dirtyPropertySet addObject:@"basicPassword"];
    _basicPassword = [newBasicPassword copy];
}

- (JRJsonObject *)jsonNumber
{
    return _jsonNumber;
}

- (void)setJsonNumber:(JRJsonObject *)newJsonNumber
{
    [self.dirtyPropertySet addObject:@"jsonNumber"];
    _jsonNumber = [newJsonNumber copy];
}

- (JRJsonObject *)jsonString
{
    return _jsonString;
}

- (void)setJsonString:(JRJsonObject *)newJsonString
{
    [self.dirtyPropertySet addObject:@"jsonString"];
    _jsonString = [newJsonString copy];
}

- (JRJsonObject *)jsonArray
{
    return _jsonArray;
}

- (void)setJsonArray:(JRJsonObject *)newJsonArray
{
    [self.dirtyPropertySet addObject:@"jsonArray"];
    _jsonArray = [newJsonArray copy];
}

- (JRJsonObject *)jsonDictionary
{
    return _jsonDictionary;
}

- (void)setJsonDictionary:(JRJsonObject *)newJsonDictionary
{
    [self.dirtyPropertySet addObject:@"jsonDictionary"];
    _jsonDictionary = [newJsonDictionary copy];
}

- (NSString *)stringTestJson
{
    return _stringTestJson;
}

- (void)setStringTestJson:(NSString *)newStringTestJson
{
    [self.dirtyPropertySet addObject:@"stringTestJson"];
    _stringTestJson = [newStringTestJson copy];
}

- (NSString *)stringTestEmpty
{
    return _stringTestEmpty;
}

- (void)setStringTestEmpty:(NSString *)newStringTestEmpty
{
    [self.dirtyPropertySet addObject:@"stringTestEmpty"];
    _stringTestEmpty = [newStringTestEmpty copy];
}

- (NSString *)stringTestNull
{
    return _stringTestNull;
}

- (void)setStringTestNull:(NSString *)newStringTestNull
{
    [self.dirtyPropertySet addObject:@"stringTestNull"];
    _stringTestNull = [newStringTestNull copy];
}

- (NSString *)stringTestInvalid
{
    return _stringTestInvalid;
}

- (void)setStringTestInvalid:(NSString *)newStringTestInvalid
{
    [self.dirtyPropertySet addObject:@"stringTestInvalid"];
    _stringTestInvalid = [newStringTestInvalid copy];
}

- (NSString *)stringTestNSNull
{
    return _stringTestNSNull;
}

- (void)setStringTestNSNull:(NSString *)newStringTestNSNull
{
    [self.dirtyPropertySet addObject:@"stringTestNSNull"];
    _stringTestNSNull = [newStringTestNSNull copy];
}

- (NSString *)stringTestAlphanumeric
{
    return _stringTestAlphanumeric;
}

- (void)setStringTestAlphanumeric:(NSString *)newStringTestAlphanumeric
{
    [self.dirtyPropertySet addObject:@"stringTestAlphanumeric"];
    _stringTestAlphanumeric = [newStringTestAlphanumeric copy];
}

- (NSString *)stringTestUnicodeLetters
{
    return _stringTestUnicodeLetters;
}

- (void)setStringTestUnicodeLetters:(NSString *)newStringTestUnicodeLetters
{
    [self.dirtyPropertySet addObject:@"stringTestUnicodeLetters"];
    _stringTestUnicodeLetters = [newStringTestUnicodeLetters copy];
}

- (NSString *)stringTestUnicodePrintable
{
    return _stringTestUnicodePrintable;
}

- (void)setStringTestUnicodePrintable:(NSString *)newStringTestUnicodePrintable
{
    [self.dirtyPropertySet addObject:@"stringTestUnicodePrintable"];
    _stringTestUnicodePrintable = [newStringTestUnicodePrintable copy];
}

- (NSString *)stringTestEmailAddress
{
    return _stringTestEmailAddress;
}

- (void)setStringTestEmailAddress:(NSString *)newStringTestEmailAddress
{
    [self.dirtyPropertySet addObject:@"stringTestEmailAddress"];
    _stringTestEmailAddress = [newStringTestEmailAddress copy];
}

- (NSString *)stringTestLength
{
    return _stringTestLength;
}

- (void)setStringTestLength:(NSString *)newStringTestLength
{
    [self.dirtyPropertySet addObject:@"stringTestLength"];
    _stringTestLength = [newStringTestLength copy];
}

- (NSString *)stringTestCaseSensitive
{
    return _stringTestCaseSensitive;
}

- (void)setStringTestCaseSensitive:(NSString *)newStringTestCaseSensitive
{
    [self.dirtyPropertySet addObject:@"stringTestCaseSensitive"];
    _stringTestCaseSensitive = [newStringTestCaseSensitive copy];
}

- (NSString *)stringTestFeatures
{
    return _stringTestFeatures;
}

- (void)setStringTestFeatures:(NSString *)newStringTestFeatures
{
    [self.dirtyPropertySet addObject:@"stringTestFeatures"];
    _stringTestFeatures = [newStringTestFeatures copy];
}

- (NSArray *)basicPlural
{
    return _basicPlural;
}

- (void)setBasicPlural:(NSArray *)newBasicPlural
{
    [self.dirtyArraySet addObject:@"basicPlural"];
    _basicPlural = [newBasicPlural copy];
}

- (JRBasicObject *)basicObject
{
    return _basicObject;
}

- (void)setBasicObject:(JRBasicObject *)newBasicObject
{
    [self.dirtyPropertySet addObject:@"basicObject"];
    _basicObject = [newBasicObject copy];
}

- (JRObjectTestRequired *)objectTestRequired
{
    return _objectTestRequired;
}

- (void)setObjectTestRequired:(JRObjectTestRequired *)newObjectTestRequired
{
    [self.dirtyPropertySet addObject:@"objectTestRequired"];
    _objectTestRequired = [newObjectTestRequired copy];
}

- (NSArray *)pluralTestUnique
{
    return _pluralTestUnique;
}

- (void)setPluralTestUnique:(NSArray *)newPluralTestUnique
{
    [self.dirtyArraySet addObject:@"pluralTestUnique"];
    _pluralTestUnique = [newPluralTestUnique copy];
}

- (JRObjectTestRequiredUnique *)objectTestRequiredUnique
{
    return _objectTestRequiredUnique;
}

- (void)setObjectTestRequiredUnique:(JRObjectTestRequiredUnique *)newObjectTestRequiredUnique
{
    [self.dirtyPropertySet addObject:@"objectTestRequiredUnique"];
    _objectTestRequiredUnique = [newObjectTestRequiredUnique copy];
}

- (NSArray *)pluralTestAlphabetic
{
    return _pluralTestAlphabetic;
}

- (void)setPluralTestAlphabetic:(NSArray *)newPluralTestAlphabetic
{
    [self.dirtyArraySet addObject:@"pluralTestAlphabetic"];
    _pluralTestAlphabetic = [newPluralTestAlphabetic copy];
}

- (NSArray *)simpleStringPluralOne
{
    return _simpleStringPluralOne;
}

- (void)setSimpleStringPluralOne:(NSArray *)newSimpleStringPluralOne
{
    [self.dirtyArraySet addObject:@"simpleStringPluralOne"];
    _simpleStringPluralOne = [newSimpleStringPluralOne copy];
}

- (NSArray *)simpleStringPluralTwo
{
    return _simpleStringPluralTwo;
}

- (void)setSimpleStringPluralTwo:(NSArray *)newSimpleStringPluralTwo
{
    [self.dirtyArraySet addObject:@"simpleStringPluralTwo"];
    _simpleStringPluralTwo = [newSimpleStringPluralTwo copy];
}

- (NSArray *)pinapL1Plural
{
    return _pinapL1Plural;
}

- (void)setPinapL1Plural:(NSArray *)newPinapL1Plural
{
    [self.dirtyArraySet addObject:@"pinapL1Plural"];
    _pinapL1Plural = [newPinapL1Plural copy];
}

- (JRPinoL1Object *)pinoL1Object
{
    return _pinoL1Object;
}

- (void)setPinoL1Object:(JRPinoL1Object *)newPinoL1Object
{
    [self.dirtyPropertySet addObject:@"pinoL1Object"];
    _pinoL1Object = [newPinoL1Object copy];
}

- (NSArray *)onipL1Plural
{
    return _onipL1Plural;
}

- (void)setOnipL1Plural:(NSArray *)newOnipL1Plural
{
    [self.dirtyArraySet addObject:@"onipL1Plural"];
    _onipL1Plural = [newOnipL1Plural copy];
}

- (JROinoL1Object *)oinoL1Object
{
    return _oinoL1Object;
}

- (void)setOinoL1Object:(JROinoL1Object *)newOinoL1Object
{
    [self.dirtyPropertySet addObject:@"oinoL1Object"];
    _oinoL1Object = [newOinoL1Object copy];
}

- (NSArray *)pinapinapL1Plural
{
    return _pinapinapL1Plural;
}

- (void)setPinapinapL1Plural:(NSArray *)newPinapinapL1Plural
{
    [self.dirtyArraySet addObject:@"pinapinapL1Plural"];
    _pinapinapL1Plural = [newPinapinapL1Plural copy];
}

- (NSArray *)pinonipL1Plural
{
    return _pinonipL1Plural;
}

- (void)setPinonipL1Plural:(NSArray *)newPinonipL1Plural
{
    [self.dirtyArraySet addObject:@"pinonipL1Plural"];
    _pinonipL1Plural = [newPinonipL1Plural copy];
}

- (JRPinapinoL1Object *)pinapinoL1Object
{
    return _pinapinoL1Object;
}

- (void)setPinapinoL1Object:(JRPinapinoL1Object *)newPinapinoL1Object
{
    [self.dirtyPropertySet addObject:@"pinapinoL1Object"];
    _pinapinoL1Object = [newPinapinoL1Object copy];
}

- (JRPinoinoL1Object *)pinoinoL1Object
{
    return _pinoinoL1Object;
}

- (void)setPinoinoL1Object:(JRPinoinoL1Object *)newPinoinoL1Object
{
    [self.dirtyPropertySet addObject:@"pinoinoL1Object"];
    _pinoinoL1Object = [newPinoinoL1Object copy];
}

- (NSArray *)onipinapL1Plural
{
    return _onipinapL1Plural;
}

- (void)setOnipinapL1Plural:(NSArray *)newOnipinapL1Plural
{
    [self.dirtyArraySet addObject:@"onipinapL1Plural"];
    _onipinapL1Plural = [newOnipinapL1Plural copy];
}

- (NSArray *)oinonipL1Plural
{
    return _oinonipL1Plural;
}

- (void)setOinonipL1Plural:(NSArray *)newOinonipL1Plural
{
    [self.dirtyArraySet addObject:@"oinonipL1Plural"];
    _oinonipL1Plural = [newOinonipL1Plural copy];
}

- (JROnipinoL1Object *)onipinoL1Object
{
    return _onipinoL1Object;
}

- (void)setOnipinoL1Object:(JROnipinoL1Object *)newOnipinoL1Object
{
    [self.dirtyPropertySet addObject:@"onipinoL1Object"];
    _onipinoL1Object = [newOnipinoL1Object copy];
}

- (JROinoinoL1Object *)oinoinoL1Object
{
    return _oinoinoL1Object;
}

- (void)setOinoinoL1Object:(JROinoinoL1Object *)newOinoinoL1Object
{
    [self.dirtyPropertySet addObject:@"oinoinoL1Object"];
    _oinoinoL1Object = [newOinoinoL1Object copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = YES;
    }
    return self;
}

+ (id)captureUser
{
    return [[[JRCaptureUser alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRCaptureUser *captureUserCopy =
                [[JRCaptureUser allocWithZone:zone] init];

    captureUserCopy.captureObjectPath = self.captureObjectPath;

    captureUserCopy.email = self.email;
    captureUserCopy.basicBoolean = self.basicBoolean;
    captureUserCopy.basicString = self.basicString;
    captureUserCopy.basicInteger = self.basicInteger;
    captureUserCopy.basicDecimal = self.basicDecimal;
    captureUserCopy.basicDate = self.basicDate;
    captureUserCopy.basicDateTime = self.basicDateTime;
    captureUserCopy.basicIpAddress = self.basicIpAddress;
    captureUserCopy.basicPassword = self.basicPassword;
    captureUserCopy.jsonNumber = self.jsonNumber;
    captureUserCopy.jsonString = self.jsonString;
    captureUserCopy.jsonArray = self.jsonArray;
    captureUserCopy.jsonDictionary = self.jsonDictionary;
    captureUserCopy.stringTestJson = self.stringTestJson;
    captureUserCopy.stringTestEmpty = self.stringTestEmpty;
    captureUserCopy.stringTestNull = self.stringTestNull;
    captureUserCopy.stringTestInvalid = self.stringTestInvalid;
    captureUserCopy.stringTestNSNull = self.stringTestNSNull;
    captureUserCopy.stringTestAlphanumeric = self.stringTestAlphanumeric;
    captureUserCopy.stringTestUnicodeLetters = self.stringTestUnicodeLetters;
    captureUserCopy.stringTestUnicodePrintable = self.stringTestUnicodePrintable;
    captureUserCopy.stringTestEmailAddress = self.stringTestEmailAddress;
    captureUserCopy.stringTestLength = self.stringTestLength;
    captureUserCopy.stringTestCaseSensitive = self.stringTestCaseSensitive;
    captureUserCopy.stringTestFeatures = self.stringTestFeatures;
    captureUserCopy.basicPlural = self.basicPlural;
    captureUserCopy.basicObject = self.basicObject;
    captureUserCopy.objectTestRequired = self.objectTestRequired;
    captureUserCopy.pluralTestUnique = self.pluralTestUnique;
    captureUserCopy.objectTestRequiredUnique = self.objectTestRequiredUnique;
    captureUserCopy.pluralTestAlphabetic = self.pluralTestAlphabetic;
    captureUserCopy.simpleStringPluralOne = self.simpleStringPluralOne;
    captureUserCopy.simpleStringPluralTwo = self.simpleStringPluralTwo;
    captureUserCopy.pinapL1Plural = self.pinapL1Plural;
    captureUserCopy.pinoL1Object = self.pinoL1Object;
    captureUserCopy.onipL1Plural = self.onipL1Plural;
    captureUserCopy.oinoL1Object = self.oinoL1Object;
    captureUserCopy.pinapinapL1Plural = self.pinapinapL1Plural;
    captureUserCopy.pinonipL1Plural = self.pinonipL1Plural;
    captureUserCopy.pinapinoL1Object = self.pinapinoL1Object;
    captureUserCopy.pinoinoL1Object = self.pinoinoL1Object;
    captureUserCopy.onipinapL1Plural = self.onipinapL1Plural;
    captureUserCopy.oinonipL1Plural = self.oinonipL1Plural;
    captureUserCopy.onipinoL1Object = self.onipinoL1Object;
    captureUserCopy.oinoinoL1Object = self.oinoinoL1Object;
    // TODO: Necessary??
    captureUserCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [captureUserCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [captureUserCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return captureUserCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.email ? self.email : [NSNull null])
             forKey:@"email"];
    [dict setObject:(self.basicBoolean ? [NSNumber numberWithBool:[self.basicBoolean boolValue]] : [NSNull null])
             forKey:@"basicBoolean"];
    [dict setObject:(self.basicString ? self.basicString : [NSNull null])
             forKey:@"basicString"];
    [dict setObject:(self.basicInteger ? [NSNumber numberWithInteger:[self.basicInteger integerValue]] : [NSNull null])
             forKey:@"basicInteger"];
    [dict setObject:(self.basicDecimal ? self.basicDecimal : [NSNull null])
             forKey:@"basicDecimal"];
    [dict setObject:(self.basicDate ? [self.basicDate stringFromISO8601Date] : [NSNull null])
             forKey:@"basicDate"];
    [dict setObject:(self.basicDateTime ? [self.basicDateTime stringFromISO8601DateTime] : [NSNull null])
             forKey:@"basicDateTime"];
    [dict setObject:(self.basicIpAddress ? self.basicIpAddress : [NSNull null])
             forKey:@"basicIpAddress"];
    [dict setObject:(self.basicPassword ? self.basicPassword : [NSNull null])
             forKey:@"basicPassword"];
    [dict setObject:(self.jsonNumber ? self.jsonNumber : [NSNull null])
             forKey:@"jsonNumber"];
    [dict setObject:(self.jsonString ? self.jsonString : [NSNull null])
             forKey:@"jsonString"];
    [dict setObject:(self.jsonArray ? self.jsonArray : [NSNull null])
             forKey:@"jsonArray"];
    [dict setObject:(self.jsonDictionary ? self.jsonDictionary : [NSNull null])
             forKey:@"jsonDictionary"];
    [dict setObject:(self.stringTestJson ? self.stringTestJson : [NSNull null])
             forKey:@"stringTestJson"];
    [dict setObject:(self.stringTestEmpty ? self.stringTestEmpty : [NSNull null])
             forKey:@"stringTestEmpty"];
    [dict setObject:(self.stringTestNull ? self.stringTestNull : [NSNull null])
             forKey:@"stringTestNull"];
    [dict setObject:(self.stringTestInvalid ? self.stringTestInvalid : [NSNull null])
             forKey:@"stringTestInvalid"];
    [dict setObject:(self.stringTestNSNull ? self.stringTestNSNull : [NSNull null])
             forKey:@"stringTestNSNull"];
    [dict setObject:(self.stringTestAlphanumeric ? self.stringTestAlphanumeric : [NSNull null])
             forKey:@"stringTestAlphanumeric"];
    [dict setObject:(self.stringTestUnicodeLetters ? self.stringTestUnicodeLetters : [NSNull null])
             forKey:@"stringTestUnicodeLetters"];
    [dict setObject:(self.stringTestUnicodePrintable ? self.stringTestUnicodePrintable : [NSNull null])
             forKey:@"stringTestUnicodePrintable"];
    [dict setObject:(self.stringTestEmailAddress ? self.stringTestEmailAddress : [NSNull null])
             forKey:@"stringTestEmailAddress"];
    [dict setObject:(self.stringTestLength ? self.stringTestLength : [NSNull null])
             forKey:@"stringTestLength"];
    [dict setObject:(self.stringTestCaseSensitive ? self.stringTestCaseSensitive : [NSNull null])
             forKey:@"stringTestCaseSensitive"];
    [dict setObject:(self.stringTestFeatures ? self.stringTestFeatures : [NSNull null])
             forKey:@"stringTestFeatures"];
    [dict setObject:(self.basicPlural ? [self.basicPlural arrayOfBasicPluralDictionariesFromBasicPluralElements] : [NSNull null])
             forKey:@"basicPlural"];
    [dict setObject:(self.basicObject ? [self.basicObject toDictionary] : [NSNull null])
             forKey:@"basicObject"];
    [dict setObject:(self.objectTestRequired ? [self.objectTestRequired toDictionary] : [NSNull null])
             forKey:@"objectTestRequired"];
    [dict setObject:(self.pluralTestUnique ? [self.pluralTestUnique arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElements] : [NSNull null])
             forKey:@"pluralTestUnique"];
    [dict setObject:(self.objectTestRequiredUnique ? [self.objectTestRequiredUnique toDictionary] : [NSNull null])
             forKey:@"objectTestRequiredUnique"];
    [dict setObject:(self.pluralTestAlphabetic ? [self.pluralTestAlphabetic arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElements] : [NSNull null])
             forKey:@"pluralTestAlphabetic"];
    [dict setObject:(self.simpleStringPluralOne ? [self.simpleStringPluralOne arrayOfSimpleStringPluralOneDictionariesFromSimpleStringPluralOneElements] : [NSNull null])
             forKey:@"simpleStringPluralOne"];
    [dict setObject:(self.simpleStringPluralTwo ? [self.simpleStringPluralTwo arrayOfSimpleStringPluralTwoDictionariesFromSimpleStringPluralTwoElements] : [NSNull null])
             forKey:@"simpleStringPluralTwo"];
    [dict setObject:(self.pinapL1Plural ? [self.pinapL1Plural arrayOfPinapL1PluralDictionariesFromPinapL1PluralElements] : [NSNull null])
             forKey:@"pinapL1Plural"];
    [dict setObject:(self.pinoL1Object ? [self.pinoL1Object toDictionary] : [NSNull null])
             forKey:@"pinoL1Object"];
    [dict setObject:(self.onipL1Plural ? [self.onipL1Plural arrayOfOnipL1PluralDictionariesFromOnipL1PluralElements] : [NSNull null])
             forKey:@"onipL1Plural"];
    [dict setObject:(self.oinoL1Object ? [self.oinoL1Object toDictionary] : [NSNull null])
             forKey:@"oinoL1Object"];
    [dict setObject:(self.pinapinapL1Plural ? [self.pinapinapL1Plural arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElements] : [NSNull null])
             forKey:@"pinapinapL1Plural"];
    [dict setObject:(self.pinonipL1Plural ? [self.pinonipL1Plural arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElements] : [NSNull null])
             forKey:@"pinonipL1Plural"];
    [dict setObject:(self.pinapinoL1Object ? [self.pinapinoL1Object toDictionary] : [NSNull null])
             forKey:@"pinapinoL1Object"];
    [dict setObject:(self.pinoinoL1Object ? [self.pinoinoL1Object toDictionary] : [NSNull null])
             forKey:@"pinoinoL1Object"];
    [dict setObject:(self.onipinapL1Plural ? [self.onipinapL1Plural arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElements] : [NSNull null])
             forKey:@"onipinapL1Plural"];
    [dict setObject:(self.oinonipL1Plural ? [self.oinonipL1Plural arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElements] : [NSNull null])
             forKey:@"oinonipL1Plural"];
    [dict setObject:(self.onipinoL1Object ? [self.onipinoL1Object toDictionary] : [NSNull null])
             forKey:@"onipinoL1Object"];
    [dict setObject:(self.oinoinoL1Object ? [self.oinoinoL1Object toDictionary] : [NSNull null])
             forKey:@"oinoinoL1Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRCaptureUser *captureUser = [JRCaptureUser captureUser];


    captureUser.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    captureUser.basicBoolean =
        [dictionary objectForKey:@"basicBoolean"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"basicBoolean"] boolValue]] : nil;

    captureUser.basicString =
        [dictionary objectForKey:@"basicString"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicString"] : nil;

    captureUser.basicInteger =
        [dictionary objectForKey:@"basicInteger"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"basicInteger"] integerValue]] : nil;

    captureUser.basicDecimal =
        [dictionary objectForKey:@"basicDecimal"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicDecimal"] : nil;

    captureUser.basicDate =
        [dictionary objectForKey:@"basicDate"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"basicDate"]] : nil;

    captureUser.basicDateTime =
        [dictionary objectForKey:@"basicDateTime"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"basicDateTime"]] : nil;

    captureUser.basicIpAddress =
        [dictionary objectForKey:@"basicIpAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicIpAddress"] : nil;

    captureUser.basicPassword =
        [dictionary objectForKey:@"basicPassword"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicPassword"] : nil;

    captureUser.jsonNumber =
        [dictionary objectForKey:@"jsonNumber"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonNumber"] : nil;

    captureUser.jsonString =
        [dictionary objectForKey:@"jsonString"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonString"] : nil;

    captureUser.jsonArray =
        [dictionary objectForKey:@"jsonArray"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonArray"] : nil;

    captureUser.jsonDictionary =
        [dictionary objectForKey:@"jsonDictionary"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonDictionary"] : nil;

    captureUser.stringTestJson =
        [dictionary objectForKey:@"stringTestJson"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestJson"] : nil;

    captureUser.stringTestEmpty =
        [dictionary objectForKey:@"stringTestEmpty"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestEmpty"] : nil;

    captureUser.stringTestNull =
        [dictionary objectForKey:@"stringTestNull"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestNull"] : nil;

    captureUser.stringTestInvalid =
        [dictionary objectForKey:@"stringTestInvalid"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestInvalid"] : nil;

    captureUser.stringTestNSNull =
        [dictionary objectForKey:@"stringTestNSNull"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestNSNull"] : nil;

    captureUser.stringTestAlphanumeric =
        [dictionary objectForKey:@"stringTestAlphanumeric"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestAlphanumeric"] : nil;

    captureUser.stringTestUnicodeLetters =
        [dictionary objectForKey:@"stringTestUnicodeLetters"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestUnicodeLetters"] : nil;

    captureUser.stringTestUnicodePrintable =
        [dictionary objectForKey:@"stringTestUnicodePrintable"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestUnicodePrintable"] : nil;

    captureUser.stringTestEmailAddress =
        [dictionary objectForKey:@"stringTestEmailAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestEmailAddress"] : nil;

    captureUser.stringTestLength =
        [dictionary objectForKey:@"stringTestLength"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestLength"] : nil;

    captureUser.stringTestCaseSensitive =
        [dictionary objectForKey:@"stringTestCaseSensitive"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestCaseSensitive"] : nil;

    captureUser.stringTestFeatures =
        [dictionary objectForKey:@"stringTestFeatures"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestFeatures"] : nil;

    captureUser.basicPlural =
        [dictionary objectForKey:@"basicPlural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"basicPlural"] arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.basicObject =
        [dictionary objectForKey:@"basicObject"] != [NSNull null] ? 
        [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.objectTestRequired =
        [dictionary objectForKey:@"objectTestRequired"] != [NSNull null] ? 
        [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.pluralTestUnique =
        [dictionary objectForKey:@"pluralTestUnique"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestUnique"] arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.objectTestRequiredUnique =
        [dictionary objectForKey:@"objectTestRequiredUnique"] != [NSNull null] ? 
        [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.pluralTestAlphabetic =
        [dictionary objectForKey:@"pluralTestAlphabetic"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestAlphabetic"] arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.simpleStringPluralOne =
        [dictionary objectForKey:@"simpleStringPluralOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralOne"] arrayOfSimpleStringPluralOneElementsFromSimpleStringPluralOneDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.simpleStringPluralTwo =
        [dictionary objectForKey:@"simpleStringPluralTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralTwo"] arrayOfSimpleStringPluralTwoElementsFromSimpleStringPluralTwoDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.pinapL1Plural =
        [dictionary objectForKey:@"pinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapL1Plural"] arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.pinoL1Object =
        [dictionary objectForKey:@"pinoL1Object"] != [NSNull null] ? 
        [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.onipL1Plural =
        [dictionary objectForKey:@"onipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipL1Plural"] arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.oinoL1Object =
        [dictionary objectForKey:@"oinoL1Object"] != [NSNull null] ? 
        [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.pinapinapL1Plural =
        [dictionary objectForKey:@"pinapinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL1Plural"] arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.pinonipL1Plural =
        [dictionary objectForKey:@"pinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL1Plural"] arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.pinapinoL1Object =
        [dictionary objectForKey:@"pinapinoL1Object"] != [NSNull null] ? 
        [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.pinoinoL1Object =
        [dictionary objectForKey:@"pinoinoL1Object"] != [NSNull null] ? 
        [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.onipinapL1Plural =
        [dictionary objectForKey:@"onipinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL1Plural"] arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.oinonipL1Plural =
        [dictionary objectForKey:@"oinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"oinonipL1Plural"] arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.onipinoL1Object =
        [dictionary objectForKey:@"onipinoL1Object"] != [NSNull null] ? 
        [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.oinoinoL1Object =
        [dictionary objectForKey:@"oinoinoL1Object"] != [NSNull null] ? 
        [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:captureUser.captureObjectPath] : nil;

    [captureUser.dirtyPropertySet removeAllObjects];
    [captureUser.dirtyArraySet removeAllObjects];
    
    return captureUser;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"email"])
        self.email = [dictionary objectForKey:@"email"] != [NSNull null] ? 
            [dictionary objectForKey:@"email"] : nil;

    if ([dictionary objectForKey:@"basicBoolean"])
        self.basicBoolean = [dictionary objectForKey:@"basicBoolean"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"basicBoolean"] boolValue]] : nil;

    if ([dictionary objectForKey:@"basicString"])
        self.basicString = [dictionary objectForKey:@"basicString"] != [NSNull null] ? 
            [dictionary objectForKey:@"basicString"] : nil;

    if ([dictionary objectForKey:@"basicInteger"])
        self.basicInteger = [dictionary objectForKey:@"basicInteger"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"basicInteger"] integerValue]] : nil;

    if ([dictionary objectForKey:@"basicDecimal"])
        self.basicDecimal = [dictionary objectForKey:@"basicDecimal"] != [NSNull null] ? 
            [dictionary objectForKey:@"basicDecimal"] : nil;

    if ([dictionary objectForKey:@"basicDate"])
        self.basicDate = [dictionary objectForKey:@"basicDate"] != [NSNull null] ? 
            [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"basicDate"]] : nil;

    if ([dictionary objectForKey:@"basicDateTime"])
        self.basicDateTime = [dictionary objectForKey:@"basicDateTime"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"basicDateTime"]] : nil;

    if ([dictionary objectForKey:@"basicIpAddress"])
        self.basicIpAddress = [dictionary objectForKey:@"basicIpAddress"] != [NSNull null] ? 
            [dictionary objectForKey:@"basicIpAddress"] : nil;

    if ([dictionary objectForKey:@"basicPassword"])
        self.basicPassword = [dictionary objectForKey:@"basicPassword"] != [NSNull null] ? 
            [dictionary objectForKey:@"basicPassword"] : nil;

    if ([dictionary objectForKey:@"jsonNumber"])
        self.jsonNumber = [dictionary objectForKey:@"jsonNumber"] != [NSNull null] ? 
            [dictionary objectForKey:@"jsonNumber"] : nil;

    if ([dictionary objectForKey:@"jsonString"])
        self.jsonString = [dictionary objectForKey:@"jsonString"] != [NSNull null] ? 
            [dictionary objectForKey:@"jsonString"] : nil;

    if ([dictionary objectForKey:@"jsonArray"])
        self.jsonArray = [dictionary objectForKey:@"jsonArray"] != [NSNull null] ? 
            [dictionary objectForKey:@"jsonArray"] : nil;

    if ([dictionary objectForKey:@"jsonDictionary"])
        self.jsonDictionary = [dictionary objectForKey:@"jsonDictionary"] != [NSNull null] ? 
            [dictionary objectForKey:@"jsonDictionary"] : nil;

    if ([dictionary objectForKey:@"stringTestJson"])
        self.stringTestJson = [dictionary objectForKey:@"stringTestJson"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestJson"] : nil;

    if ([dictionary objectForKey:@"stringTestEmpty"])
        self.stringTestEmpty = [dictionary objectForKey:@"stringTestEmpty"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestEmpty"] : nil;

    if ([dictionary objectForKey:@"stringTestNull"])
        self.stringTestNull = [dictionary objectForKey:@"stringTestNull"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestNull"] : nil;

    if ([dictionary objectForKey:@"stringTestInvalid"])
        self.stringTestInvalid = [dictionary objectForKey:@"stringTestInvalid"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestInvalid"] : nil;

    if ([dictionary objectForKey:@"stringTestNSNull"])
        self.stringTestNSNull = [dictionary objectForKey:@"stringTestNSNull"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestNSNull"] : nil;

    if ([dictionary objectForKey:@"stringTestAlphanumeric"])
        self.stringTestAlphanumeric = [dictionary objectForKey:@"stringTestAlphanumeric"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestAlphanumeric"] : nil;

    if ([dictionary objectForKey:@"stringTestUnicodeLetters"])
        self.stringTestUnicodeLetters = [dictionary objectForKey:@"stringTestUnicodeLetters"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestUnicodeLetters"] : nil;

    if ([dictionary objectForKey:@"stringTestUnicodePrintable"])
        self.stringTestUnicodePrintable = [dictionary objectForKey:@"stringTestUnicodePrintable"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestUnicodePrintable"] : nil;

    if ([dictionary objectForKey:@"stringTestEmailAddress"])
        self.stringTestEmailAddress = [dictionary objectForKey:@"stringTestEmailAddress"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestEmailAddress"] : nil;

    if ([dictionary objectForKey:@"stringTestLength"])
        self.stringTestLength = [dictionary objectForKey:@"stringTestLength"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestLength"] : nil;

    if ([dictionary objectForKey:@"stringTestCaseSensitive"])
        self.stringTestCaseSensitive = [dictionary objectForKey:@"stringTestCaseSensitive"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestCaseSensitive"] : nil;

    if ([dictionary objectForKey:@"stringTestFeatures"])
        self.stringTestFeatures = [dictionary objectForKey:@"stringTestFeatures"] != [NSNull null] ? 
            [dictionary objectForKey:@"stringTestFeatures"] : nil;

    if ([dictionary objectForKey:@"basicObject"] == [NSNull null])
        self.basicObject = nil;
    else if ([dictionary objectForKey:@"basicObject"] && !self.basicObject)
        self.basicObject = [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"basicObject"])
        [self.basicObject updateFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"objectTestRequired"] == [NSNull null])
        self.objectTestRequired = nil;
    else if ([dictionary objectForKey:@"objectTestRequired"] && !self.objectTestRequired)
        self.objectTestRequired = [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"objectTestRequired"])
        [self.objectTestRequired updateFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"objectTestRequiredUnique"] == [NSNull null])
        self.objectTestRequiredUnique = nil;
    else if ([dictionary objectForKey:@"objectTestRequiredUnique"] && !self.objectTestRequiredUnique)
        self.objectTestRequiredUnique = [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"objectTestRequiredUnique"])
        [self.objectTestRequiredUnique updateFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"pinoL1Object"] == [NSNull null])
        self.pinoL1Object = nil;
    else if ([dictionary objectForKey:@"pinoL1Object"] && !self.pinoL1Object)
        self.pinoL1Object = [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"pinoL1Object"])
        [self.pinoL1Object updateFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"oinoL1Object"] == [NSNull null])
        self.oinoL1Object = nil;
    else if ([dictionary objectForKey:@"oinoL1Object"] && !self.oinoL1Object)
        self.oinoL1Object = [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"oinoL1Object"])
        [self.oinoL1Object updateFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"pinapinoL1Object"] == [NSNull null])
        self.pinapinoL1Object = nil;
    else if ([dictionary objectForKey:@"pinapinoL1Object"] && !self.pinapinoL1Object)
        self.pinapinoL1Object = [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"pinapinoL1Object"])
        [self.pinapinoL1Object updateFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"pinoinoL1Object"] == [NSNull null])
        self.pinoinoL1Object = nil;
    else if ([dictionary objectForKey:@"pinoinoL1Object"] && !self.pinoinoL1Object)
        self.pinoinoL1Object = [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"pinoinoL1Object"])
        [self.pinoinoL1Object updateFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"onipinoL1Object"] == [NSNull null])
        self.onipinoL1Object = nil;
    else if ([dictionary objectForKey:@"onipinoL1Object"] && !self.onipinoL1Object)
        self.onipinoL1Object = [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"onipinoL1Object"])
        [self.onipinoL1Object updateFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"oinoinoL1Object"] == [NSNull null])
        self.oinoinoL1Object = nil;
    else if ([dictionary objectForKey:@"oinoinoL1Object"] && !self.oinoinoL1Object)
        self.oinoinoL1Object = [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"oinoinoL1Object"])
        [self.oinoinoL1Object updateFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    self.basicBoolean =
        [dictionary objectForKey:@"basicBoolean"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"basicBoolean"] boolValue]] : nil;

    self.basicString =
        [dictionary objectForKey:@"basicString"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicString"] : nil;

    self.basicInteger =
        [dictionary objectForKey:@"basicInteger"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"basicInteger"] integerValue]] : nil;

    self.basicDecimal =
        [dictionary objectForKey:@"basicDecimal"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicDecimal"] : nil;

    self.basicDate =
        [dictionary objectForKey:@"basicDate"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"basicDate"]] : nil;

    self.basicDateTime =
        [dictionary objectForKey:@"basicDateTime"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"basicDateTime"]] : nil;

    self.basicIpAddress =
        [dictionary objectForKey:@"basicIpAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicIpAddress"] : nil;

    self.basicPassword =
        [dictionary objectForKey:@"basicPassword"] != [NSNull null] ? 
        [dictionary objectForKey:@"basicPassword"] : nil;

    self.jsonNumber =
        [dictionary objectForKey:@"jsonNumber"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonNumber"] : nil;

    self.jsonString =
        [dictionary objectForKey:@"jsonString"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonString"] : nil;

    self.jsonArray =
        [dictionary objectForKey:@"jsonArray"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonArray"] : nil;

    self.jsonDictionary =
        [dictionary objectForKey:@"jsonDictionary"] != [NSNull null] ? 
        [dictionary objectForKey:@"jsonDictionary"] : nil;

    self.stringTestJson =
        [dictionary objectForKey:@"stringTestJson"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestJson"] : nil;

    self.stringTestEmpty =
        [dictionary objectForKey:@"stringTestEmpty"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestEmpty"] : nil;

    self.stringTestNull =
        [dictionary objectForKey:@"stringTestNull"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestNull"] : nil;

    self.stringTestInvalid =
        [dictionary objectForKey:@"stringTestInvalid"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestInvalid"] : nil;

    self.stringTestNSNull =
        [dictionary objectForKey:@"stringTestNSNull"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestNSNull"] : nil;

    self.stringTestAlphanumeric =
        [dictionary objectForKey:@"stringTestAlphanumeric"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestAlphanumeric"] : nil;

    self.stringTestUnicodeLetters =
        [dictionary objectForKey:@"stringTestUnicodeLetters"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestUnicodeLetters"] : nil;

    self.stringTestUnicodePrintable =
        [dictionary objectForKey:@"stringTestUnicodePrintable"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestUnicodePrintable"] : nil;

    self.stringTestEmailAddress =
        [dictionary objectForKey:@"stringTestEmailAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestEmailAddress"] : nil;

    self.stringTestLength =
        [dictionary objectForKey:@"stringTestLength"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestLength"] : nil;

    self.stringTestCaseSensitive =
        [dictionary objectForKey:@"stringTestCaseSensitive"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestCaseSensitive"] : nil;

    self.stringTestFeatures =
        [dictionary objectForKey:@"stringTestFeatures"] != [NSNull null] ? 
        [dictionary objectForKey:@"stringTestFeatures"] : nil;

    self.basicPlural =
        [dictionary objectForKey:@"basicPlural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"basicPlural"] arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"basicObject"] || [dictionary objectForKey:@"basicObject"] == [NSNull null])
        self.basicObject = nil;
    else if (!self.basicObject)
        self.basicObject = [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath];
    else
        [self.basicObject replaceFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath];

    if (![dictionary objectForKey:@"objectTestRequired"] || [dictionary objectForKey:@"objectTestRequired"] == [NSNull null])
        self.objectTestRequired = nil;
    else if (!self.objectTestRequired)
        self.objectTestRequired = [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath];
    else
        [self.objectTestRequired replaceFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath];

    self.pluralTestUnique =
        [dictionary objectForKey:@"pluralTestUnique"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestUnique"] arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"objectTestRequiredUnique"] || [dictionary objectForKey:@"objectTestRequiredUnique"] == [NSNull null])
        self.objectTestRequiredUnique = nil;
    else if (!self.objectTestRequiredUnique)
        self.objectTestRequiredUnique = [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath];
    else
        [self.objectTestRequiredUnique replaceFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath];

    self.pluralTestAlphabetic =
        [dictionary objectForKey:@"pluralTestAlphabetic"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestAlphabetic"] arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:self.captureObjectPath] : nil;

    self.simpleStringPluralOne =
        [dictionary objectForKey:@"simpleStringPluralOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralOne"] arrayOfSimpleStringPluralOneElementsFromSimpleStringPluralOneDictionariesWithPath:self.captureObjectPath] : nil;

    self.simpleStringPluralTwo =
        [dictionary objectForKey:@"simpleStringPluralTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralTwo"] arrayOfSimpleStringPluralTwoElementsFromSimpleStringPluralTwoDictionariesWithPath:self.captureObjectPath] : nil;

    self.pinapL1Plural =
        [dictionary objectForKey:@"pinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapL1Plural"] arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"pinoL1Object"] || [dictionary objectForKey:@"pinoL1Object"] == [NSNull null])
        self.pinoL1Object = nil;
    else if (!self.pinoL1Object)
        self.pinoL1Object = [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath];
    else
        [self.pinoL1Object replaceFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath];

    self.onipL1Plural =
        [dictionary objectForKey:@"onipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipL1Plural"] arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"oinoL1Object"] || [dictionary objectForKey:@"oinoL1Object"] == [NSNull null])
        self.oinoL1Object = nil;
    else if (!self.oinoL1Object)
        self.oinoL1Object = [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath];
    else
        [self.oinoL1Object replaceFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath];

    self.pinapinapL1Plural =
        [dictionary objectForKey:@"pinapinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL1Plural"] arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:self.captureObjectPath] : nil;

    self.pinonipL1Plural =
        [dictionary objectForKey:@"pinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL1Plural"] arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"pinapinoL1Object"] || [dictionary objectForKey:@"pinapinoL1Object"] == [NSNull null])
        self.pinapinoL1Object = nil;
    else if (!self.pinapinoL1Object)
        self.pinapinoL1Object = [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath];
    else
        [self.pinapinoL1Object replaceFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath];

    if (![dictionary objectForKey:@"pinoinoL1Object"] || [dictionary objectForKey:@"pinoinoL1Object"] == [NSNull null])
        self.pinoinoL1Object = nil;
    else if (!self.pinoinoL1Object)
        self.pinoinoL1Object = [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath];
    else
        [self.pinoinoL1Object replaceFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath];

    self.onipinapL1Plural =
        [dictionary objectForKey:@"onipinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL1Plural"] arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:self.captureObjectPath] : nil;

    self.oinonipL1Plural =
        [dictionary objectForKey:@"oinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"oinonipL1Plural"] arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"onipinoL1Object"] || [dictionary objectForKey:@"onipinoL1Object"] == [NSNull null])
        self.onipinoL1Object = nil;
    else if (!self.onipinoL1Object)
        self.onipinoL1Object = [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath];
    else
        [self.onipinoL1Object replaceFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath];

    if (![dictionary objectForKey:@"oinoinoL1Object"] || [dictionary objectForKey:@"oinoinoL1Object"] == [NSNull null])
        self.oinoinoL1Object = nil;
    else if (!self.oinoinoL1Object)
        self.oinoinoL1Object = [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath];
    else
        [self.oinoinoL1Object replaceFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"email"])
        [dict setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];

    if ([self.dirtyPropertySet containsObject:@"basicBoolean"])
        [dict setObject:(self.basicBoolean ? [NSNumber numberWithBool:[self.basicBoolean boolValue]] : [NSNull null]) forKey:@"basicBoolean"];

    if ([self.dirtyPropertySet containsObject:@"basicString"])
        [dict setObject:(self.basicString ? self.basicString : [NSNull null]) forKey:@"basicString"];

    if ([self.dirtyPropertySet containsObject:@"basicInteger"])
        [dict setObject:(self.basicInteger ? [NSNumber numberWithInteger:[self.basicInteger integerValue]] : [NSNull null]) forKey:@"basicInteger"];

    if ([self.dirtyPropertySet containsObject:@"basicDecimal"])
        [dict setObject:(self.basicDecimal ? self.basicDecimal : [NSNull null]) forKey:@"basicDecimal"];

    if ([self.dirtyPropertySet containsObject:@"basicDate"])
        [dict setObject:(self.basicDate ? [self.basicDate stringFromISO8601Date] : [NSNull null]) forKey:@"basicDate"];

    if ([self.dirtyPropertySet containsObject:@"basicDateTime"])
        [dict setObject:(self.basicDateTime ? [self.basicDateTime stringFromISO8601DateTime] : [NSNull null]) forKey:@"basicDateTime"];

    if ([self.dirtyPropertySet containsObject:@"basicIpAddress"])
        [dict setObject:(self.basicIpAddress ? self.basicIpAddress : [NSNull null]) forKey:@"basicIpAddress"];

    if ([self.dirtyPropertySet containsObject:@"basicPassword"])
        [dict setObject:(self.basicPassword ? self.basicPassword : [NSNull null]) forKey:@"basicPassword"];

    if ([self.dirtyPropertySet containsObject:@"jsonNumber"])
        [dict setObject:(self.jsonNumber ? self.jsonNumber : [NSNull null]) forKey:@"jsonNumber"];

    if ([self.dirtyPropertySet containsObject:@"jsonString"])
        [dict setObject:(self.jsonString ? self.jsonString : [NSNull null]) forKey:@"jsonString"];

    if ([self.dirtyPropertySet containsObject:@"jsonArray"])
        [dict setObject:(self.jsonArray ? self.jsonArray : [NSNull null]) forKey:@"jsonArray"];

    if ([self.dirtyPropertySet containsObject:@"jsonDictionary"])
        [dict setObject:(self.jsonDictionary ? self.jsonDictionary : [NSNull null]) forKey:@"jsonDictionary"];

    if ([self.dirtyPropertySet containsObject:@"stringTestJson"])
        [dict setObject:(self.stringTestJson ? self.stringTestJson : [NSNull null]) forKey:@"stringTestJson"];

    if ([self.dirtyPropertySet containsObject:@"stringTestEmpty"])
        [dict setObject:(self.stringTestEmpty ? self.stringTestEmpty : [NSNull null]) forKey:@"stringTestEmpty"];

    if ([self.dirtyPropertySet containsObject:@"stringTestNull"])
        [dict setObject:(self.stringTestNull ? self.stringTestNull : [NSNull null]) forKey:@"stringTestNull"];

    if ([self.dirtyPropertySet containsObject:@"stringTestInvalid"])
        [dict setObject:(self.stringTestInvalid ? self.stringTestInvalid : [NSNull null]) forKey:@"stringTestInvalid"];

    if ([self.dirtyPropertySet containsObject:@"stringTestNSNull"])
        [dict setObject:(self.stringTestNSNull ? self.stringTestNSNull : [NSNull null]) forKey:@"stringTestNSNull"];

    if ([self.dirtyPropertySet containsObject:@"stringTestAlphanumeric"])
        [dict setObject:(self.stringTestAlphanumeric ? self.stringTestAlphanumeric : [NSNull null]) forKey:@"stringTestAlphanumeric"];

    if ([self.dirtyPropertySet containsObject:@"stringTestUnicodeLetters"])
        [dict setObject:(self.stringTestUnicodeLetters ? self.stringTestUnicodeLetters : [NSNull null]) forKey:@"stringTestUnicodeLetters"];

    if ([self.dirtyPropertySet containsObject:@"stringTestUnicodePrintable"])
        [dict setObject:(self.stringTestUnicodePrintable ? self.stringTestUnicodePrintable : [NSNull null]) forKey:@"stringTestUnicodePrintable"];

    if ([self.dirtyPropertySet containsObject:@"stringTestEmailAddress"])
        [dict setObject:(self.stringTestEmailAddress ? self.stringTestEmailAddress : [NSNull null]) forKey:@"stringTestEmailAddress"];

    if ([self.dirtyPropertySet containsObject:@"stringTestLength"])
        [dict setObject:(self.stringTestLength ? self.stringTestLength : [NSNull null]) forKey:@"stringTestLength"];

    if ([self.dirtyPropertySet containsObject:@"stringTestCaseSensitive"])
        [dict setObject:(self.stringTestCaseSensitive ? self.stringTestCaseSensitive : [NSNull null]) forKey:@"stringTestCaseSensitive"];

    if ([self.dirtyPropertySet containsObject:@"stringTestFeatures"])
        [dict setObject:(self.stringTestFeatures ? self.stringTestFeatures : [NSNull null]) forKey:@"stringTestFeatures"];

    if ([self.dirtyPropertySet containsObject:@"basicObject"] || [self.basicObject needsUpdate])
        [dict setObject:(self.basicObject ?
                              [self.basicObject toUpdateDictionary] :
                              [[JRBasicObject basicObject] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"basicObject"];

    if ([self.dirtyPropertySet containsObject:@"objectTestRequired"] || [self.objectTestRequired needsUpdate])
        [dict setObject:(self.objectTestRequired ?
                              [self.objectTestRequired toUpdateDictionary] :
                              [[JRObjectTestRequired objectTestRequired] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"objectTestRequired"];

    if ([self.dirtyPropertySet containsObject:@"objectTestRequiredUnique"] || [self.objectTestRequiredUnique needsUpdate])
        [dict setObject:(self.objectTestRequiredUnique ?
                              [self.objectTestRequiredUnique toUpdateDictionary] :
                              [[JRObjectTestRequiredUnique objectTestRequiredUnique] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"objectTestRequiredUnique"];

    if ([self.dirtyPropertySet containsObject:@"pinoL1Object"] || [self.pinoL1Object needsUpdate])
        [dict setObject:(self.pinoL1Object ?
                              [self.pinoL1Object toUpdateDictionary] :
                              [[JRPinoL1Object pinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"pinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"oinoL1Object"] || [self.oinoL1Object needsUpdate])
        [dict setObject:(self.oinoL1Object ?
                              [self.oinoL1Object toUpdateDictionary] :
                              [[JROinoL1Object oinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"oinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"pinapinoL1Object"] || [self.pinapinoL1Object needsUpdate])
        [dict setObject:(self.pinapinoL1Object ?
                              [self.pinapinoL1Object toUpdateDictionary] :
                              [[JRPinapinoL1Object pinapinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"pinapinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"pinoinoL1Object"] || [self.pinoinoL1Object needsUpdate])
        [dict setObject:(self.pinoinoL1Object ?
                              [self.pinoinoL1Object toUpdateDictionary] :
                              [[JRPinoinoL1Object pinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"pinoinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"onipinoL1Object"] || [self.onipinoL1Object needsUpdate])
        [dict setObject:(self.onipinoL1Object ?
                              [self.onipinoL1Object toUpdateDictionary] :
                              [[JROnipinoL1Object onipinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"onipinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"oinoinoL1Object"] || [self.oinoinoL1Object needsUpdate])
        [dict setObject:(self.oinoinoL1Object ?
                              [self.oinoinoL1Object toUpdateDictionary] :
                              [[JROinoinoL1Object oinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"oinoinoL1Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];
    [dict setObject:(self.basicBoolean ? [NSNumber numberWithBool:[self.basicBoolean boolValue]] : [NSNull null]) forKey:@"basicBoolean"];
    [dict setObject:(self.basicString ? self.basicString : [NSNull null]) forKey:@"basicString"];
    [dict setObject:(self.basicInteger ? [NSNumber numberWithInteger:[self.basicInteger integerValue]] : [NSNull null]) forKey:@"basicInteger"];
    [dict setObject:(self.basicDecimal ? self.basicDecimal : [NSNull null]) forKey:@"basicDecimal"];
    [dict setObject:(self.basicDate ? [self.basicDate stringFromISO8601Date] : [NSNull null]) forKey:@"basicDate"];
    [dict setObject:(self.basicDateTime ? [self.basicDateTime stringFromISO8601DateTime] : [NSNull null]) forKey:@"basicDateTime"];
    [dict setObject:(self.basicIpAddress ? self.basicIpAddress : [NSNull null]) forKey:@"basicIpAddress"];
    [dict setObject:(self.basicPassword ? self.basicPassword : [NSNull null]) forKey:@"basicPassword"];
    [dict setObject:(self.jsonNumber ? self.jsonNumber : [NSNull null]) forKey:@"jsonNumber"];
    [dict setObject:(self.jsonString ? self.jsonString : [NSNull null]) forKey:@"jsonString"];
    [dict setObject:(self.jsonArray ? self.jsonArray : [NSNull null]) forKey:@"jsonArray"];
    [dict setObject:(self.jsonDictionary ? self.jsonDictionary : [NSNull null]) forKey:@"jsonDictionary"];
    [dict setObject:(self.stringTestJson ? self.stringTestJson : [NSNull null]) forKey:@"stringTestJson"];
    [dict setObject:(self.stringTestEmpty ? self.stringTestEmpty : [NSNull null]) forKey:@"stringTestEmpty"];
    [dict setObject:(self.stringTestNull ? self.stringTestNull : [NSNull null]) forKey:@"stringTestNull"];
    [dict setObject:(self.stringTestInvalid ? self.stringTestInvalid : [NSNull null]) forKey:@"stringTestInvalid"];
    [dict setObject:(self.stringTestNSNull ? self.stringTestNSNull : [NSNull null]) forKey:@"stringTestNSNull"];
    [dict setObject:(self.stringTestAlphanumeric ? self.stringTestAlphanumeric : [NSNull null]) forKey:@"stringTestAlphanumeric"];
    [dict setObject:(self.stringTestUnicodeLetters ? self.stringTestUnicodeLetters : [NSNull null]) forKey:@"stringTestUnicodeLetters"];
    [dict setObject:(self.stringTestUnicodePrintable ? self.stringTestUnicodePrintable : [NSNull null]) forKey:@"stringTestUnicodePrintable"];
    [dict setObject:(self.stringTestEmailAddress ? self.stringTestEmailAddress : [NSNull null]) forKey:@"stringTestEmailAddress"];
    [dict setObject:(self.stringTestLength ? self.stringTestLength : [NSNull null]) forKey:@"stringTestLength"];
    [dict setObject:(self.stringTestCaseSensitive ? self.stringTestCaseSensitive : [NSNull null]) forKey:@"stringTestCaseSensitive"];
    [dict setObject:(self.stringTestFeatures ? self.stringTestFeatures : [NSNull null]) forKey:@"stringTestFeatures"];
    [dict setObject:(self.basicPlural ? [self.basicPlural arrayOfBasicPluralReplaceDictionariesFromBasicPluralElements] : [NSArray array]) forKey:@"basicPlural"];
    [dict setObject:(self.basicObject ?
                          [self.basicObject toReplaceDictionary] :
                          [[JRBasicObject basicObject] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"basicObject"];
    [dict setObject:(self.objectTestRequired ?
                          [self.objectTestRequired toReplaceDictionary] :
                          [[JRObjectTestRequired objectTestRequired] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"objectTestRequired"];
    [dict setObject:(self.pluralTestUnique ? [self.pluralTestUnique arrayOfPluralTestUniqueReplaceDictionariesFromPluralTestUniqueElements] : [NSArray array]) forKey:@"pluralTestUnique"];
    [dict setObject:(self.objectTestRequiredUnique ?
                          [self.objectTestRequiredUnique toReplaceDictionary] :
                          [[JRObjectTestRequiredUnique objectTestRequiredUnique] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"objectTestRequiredUnique"];
    [dict setObject:(self.pluralTestAlphabetic ? [self.pluralTestAlphabetic arrayOfPluralTestAlphabeticReplaceDictionariesFromPluralTestAlphabeticElements] : [NSArray array]) forKey:@"pluralTestAlphabetic"];
    [dict setObject:(self.simpleStringPluralOne ? [self.simpleStringPluralOne arrayOfSimpleStringPluralOneReplaceDictionariesFromSimpleStringPluralOneElements] : [NSArray array]) forKey:@"simpleStringPluralOne"];
    [dict setObject:(self.simpleStringPluralTwo ? [self.simpleStringPluralTwo arrayOfSimpleStringPluralTwoReplaceDictionariesFromSimpleStringPluralTwoElements] : [NSArray array]) forKey:@"simpleStringPluralTwo"];
    [dict setObject:(self.pinapL1Plural ? [self.pinapL1Plural arrayOfPinapL1PluralReplaceDictionariesFromPinapL1PluralElements] : [NSArray array]) forKey:@"pinapL1Plural"];
    [dict setObject:(self.pinoL1Object ?
                          [self.pinoL1Object toReplaceDictionary] :
                          [[JRPinoL1Object pinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"pinoL1Object"];
    [dict setObject:(self.onipL1Plural ? [self.onipL1Plural arrayOfOnipL1PluralReplaceDictionariesFromOnipL1PluralElements] : [NSArray array]) forKey:@"onipL1Plural"];
    [dict setObject:(self.oinoL1Object ?
                          [self.oinoL1Object toReplaceDictionary] :
                          [[JROinoL1Object oinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"oinoL1Object"];
    [dict setObject:(self.pinapinapL1Plural ? [self.pinapinapL1Plural arrayOfPinapinapL1PluralReplaceDictionariesFromPinapinapL1PluralElements] : [NSArray array]) forKey:@"pinapinapL1Plural"];
    [dict setObject:(self.pinonipL1Plural ? [self.pinonipL1Plural arrayOfPinonipL1PluralReplaceDictionariesFromPinonipL1PluralElements] : [NSArray array]) forKey:@"pinonipL1Plural"];
    [dict setObject:(self.pinapinoL1Object ?
                          [self.pinapinoL1Object toReplaceDictionary] :
                          [[JRPinapinoL1Object pinapinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"pinapinoL1Object"];
    [dict setObject:(self.pinoinoL1Object ?
                          [self.pinoinoL1Object toReplaceDictionary] :
                          [[JRPinoinoL1Object pinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"pinoinoL1Object"];
    [dict setObject:(self.onipinapL1Plural ? [self.onipinapL1Plural arrayOfOnipinapL1PluralReplaceDictionariesFromOnipinapL1PluralElements] : [NSArray array]) forKey:@"onipinapL1Plural"];
    [dict setObject:(self.oinonipL1Plural ? [self.oinonipL1Plural arrayOfOinonipL1PluralReplaceDictionariesFromOinonipL1PluralElements] : [NSArray array]) forKey:@"oinonipL1Plural"];
    [dict setObject:(self.onipinoL1Object ?
                          [self.onipinoL1Object toReplaceDictionary] :
                          [[JROnipinoL1Object onipinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"onipinoL1Object"];
    [dict setObject:(self.oinoinoL1Object ?
                          [self.oinoinoL1Object toReplaceDictionary] :
                          [[JROinoinoL1Object oinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"oinoinoL1Object"];

    return dict;
}

- (void)replaceBasicPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.basicPlural named:@"basicPlural"
                    forDelegate:delegate withContext:context];
}

- (void)replacePluralTestUniqueArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralTestUnique named:@"pluralTestUnique"
                    forDelegate:delegate withContext:context];
}

- (void)replacePluralTestAlphabeticArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralTestAlphabetic named:@"pluralTestAlphabetic"
                    forDelegate:delegate withContext:context];
}

- (void)replaceSimpleStringPluralOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.simpleStringPluralOne named:@"simpleStringPluralOne"
                    forDelegate:delegate withContext:context];
}

- (void)replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.simpleStringPluralTwo named:@"simpleStringPluralTwo"
                    forDelegate:delegate withContext:context];
}

- (void)replacePinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapL1Plural named:@"pinapL1Plural"
                    forDelegate:delegate withContext:context];
}

- (void)replaceOnipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.onipL1Plural named:@"onipL1Plural"
                    forDelegate:delegate withContext:context];
}

- (void)replacePinapinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapinapL1Plural named:@"pinapinapL1Plural"
                    forDelegate:delegate withContext:context];
}

- (void)replacePinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinonipL1Plural named:@"pinonipL1Plural"
                    forDelegate:delegate withContext:context];
}

- (void)replaceOnipinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.onipinapL1Plural named:@"onipinapL1Plural"
                    forDelegate:delegate withContext:context];
}

- (void)replaceOinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.oinonipL1Plural named:@"oinonipL1Plural"
                    forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.basicObject needsUpdate])
        return YES;

    if([self.objectTestRequired needsUpdate])
        return YES;

    if([self.objectTestRequiredUnique needsUpdate])
        return YES;

    if([self.pinoL1Object needsUpdate])
        return YES;

    if([self.oinoL1Object needsUpdate])
        return YES;

    if([self.pinapinoL1Object needsUpdate])
        return YES;

    if([self.pinoinoL1Object needsUpdate])
        return YES;

    if([self.onipinoL1Object needsUpdate])
        return YES;

    if([self.oinoinoL1Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToCaptureUser:(JRCaptureUser *)otherCaptureUser
{
    if (!self.email && !otherCaptureUser.email) /* Keep going... */;
    else if ((self.email == nil) ^ (otherCaptureUser.email == nil)) return NO; // xor
    else if (![self.email isEqualToString:otherCaptureUser.email]) return NO;

    if (!self.basicBoolean && !otherCaptureUser.basicBoolean) /* Keep going... */;
    else if ((self.basicBoolean == nil) ^ (otherCaptureUser.basicBoolean == nil)) return NO; // xor
    else if (![self.basicBoolean isEqualToNumber:otherCaptureUser.basicBoolean]) return NO;

    if (!self.basicString && !otherCaptureUser.basicString) /* Keep going... */;
    else if ((self.basicString == nil) ^ (otherCaptureUser.basicString == nil)) return NO; // xor
    else if (![self.basicString isEqualToString:otherCaptureUser.basicString]) return NO;

    if (!self.basicInteger && !otherCaptureUser.basicInteger) /* Keep going... */;
    else if ((self.basicInteger == nil) ^ (otherCaptureUser.basicInteger == nil)) return NO; // xor
    else if (![self.basicInteger isEqualToNumber:otherCaptureUser.basicInteger]) return NO;

    if (!self.basicDecimal && !otherCaptureUser.basicDecimal) /* Keep going... */;
    else if ((self.basicDecimal == nil) ^ (otherCaptureUser.basicDecimal == nil)) return NO; // xor
    else if (![self.basicDecimal isEqualToNumber:otherCaptureUser.basicDecimal]) return NO;

    if (!self.basicDate && !otherCaptureUser.basicDate) /* Keep going... */;
    else if ((self.basicDate == nil) ^ (otherCaptureUser.basicDate == nil)) return NO; // xor
    else if (![self.basicDate isEqualToDate:otherCaptureUser.basicDate]) return NO;

    if (!self.basicDateTime && !otherCaptureUser.basicDateTime) /* Keep going... */;
    else if ((self.basicDateTime == nil) ^ (otherCaptureUser.basicDateTime == nil)) return NO; // xor
    else if (![self.basicDateTime isEqualToDate:otherCaptureUser.basicDateTime]) return NO;

    if (!self.basicIpAddress && !otherCaptureUser.basicIpAddress) /* Keep going... */;
    else if ((self.basicIpAddress == nil) ^ (otherCaptureUser.basicIpAddress == nil)) return NO; // xor
    else if (![self.basicIpAddress isEqualToString:otherCaptureUser.basicIpAddress]) return NO;

    if (!self.basicPassword && !otherCaptureUser.basicPassword) /* Keep going... */;
    else if ((self.basicPassword == nil) ^ (otherCaptureUser.basicPassword == nil)) return NO; // xor
    else if (![self.basicPassword isEqual:otherCaptureUser.basicPassword]) return NO;

    if (!self.jsonNumber && !otherCaptureUser.jsonNumber) /* Keep going... */;
    else if ((self.jsonNumber == nil) ^ (otherCaptureUser.jsonNumber == nil)) return NO; // xor
    else if (![self.jsonNumber isEqual:otherCaptureUser.jsonNumber]) return NO;

    if (!self.jsonString && !otherCaptureUser.jsonString) /* Keep going... */;
    else if ((self.jsonString == nil) ^ (otherCaptureUser.jsonString == nil)) return NO; // xor
    else if (![self.jsonString isEqual:otherCaptureUser.jsonString]) return NO;

    if (!self.jsonArray && !otherCaptureUser.jsonArray) /* Keep going... */;
    else if ((self.jsonArray == nil) ^ (otherCaptureUser.jsonArray == nil)) return NO; // xor
    else if (![self.jsonArray isEqual:otherCaptureUser.jsonArray]) return NO;

    if (!self.jsonDictionary && !otherCaptureUser.jsonDictionary) /* Keep going... */;
    else if ((self.jsonDictionary == nil) ^ (otherCaptureUser.jsonDictionary == nil)) return NO; // xor
    else if (![self.jsonDictionary isEqual:otherCaptureUser.jsonDictionary]) return NO;

    if (!self.stringTestJson && !otherCaptureUser.stringTestJson) /* Keep going... */;
    else if ((self.stringTestJson == nil) ^ (otherCaptureUser.stringTestJson == nil)) return NO; // xor
    else if (![self.stringTestJson isEqualToString:otherCaptureUser.stringTestJson]) return NO;

    if (!self.stringTestEmpty && !otherCaptureUser.stringTestEmpty) /* Keep going... */;
    else if ((self.stringTestEmpty == nil) ^ (otherCaptureUser.stringTestEmpty == nil)) return NO; // xor
    else if (![self.stringTestEmpty isEqualToString:otherCaptureUser.stringTestEmpty]) return NO;

    if (!self.stringTestNull && !otherCaptureUser.stringTestNull) /* Keep going... */;
    else if ((self.stringTestNull == nil) ^ (otherCaptureUser.stringTestNull == nil)) return NO; // xor
    else if (![self.stringTestNull isEqualToString:otherCaptureUser.stringTestNull]) return NO;

    if (!self.stringTestInvalid && !otherCaptureUser.stringTestInvalid) /* Keep going... */;
    else if ((self.stringTestInvalid == nil) ^ (otherCaptureUser.stringTestInvalid == nil)) return NO; // xor
    else if (![self.stringTestInvalid isEqualToString:otherCaptureUser.stringTestInvalid]) return NO;

    if (!self.stringTestNSNull && !otherCaptureUser.stringTestNSNull) /* Keep going... */;
    else if ((self.stringTestNSNull == nil) ^ (otherCaptureUser.stringTestNSNull == nil)) return NO; // xor
    else if (![self.stringTestNSNull isEqualToString:otherCaptureUser.stringTestNSNull]) return NO;

    if (!self.stringTestAlphanumeric && !otherCaptureUser.stringTestAlphanumeric) /* Keep going... */;
    else if ((self.stringTestAlphanumeric == nil) ^ (otherCaptureUser.stringTestAlphanumeric == nil)) return NO; // xor
    else if (![self.stringTestAlphanumeric isEqualToString:otherCaptureUser.stringTestAlphanumeric]) return NO;

    if (!self.stringTestUnicodeLetters && !otherCaptureUser.stringTestUnicodeLetters) /* Keep going... */;
    else if ((self.stringTestUnicodeLetters == nil) ^ (otherCaptureUser.stringTestUnicodeLetters == nil)) return NO; // xor
    else if (![self.stringTestUnicodeLetters isEqualToString:otherCaptureUser.stringTestUnicodeLetters]) return NO;

    if (!self.stringTestUnicodePrintable && !otherCaptureUser.stringTestUnicodePrintable) /* Keep going... */;
    else if ((self.stringTestUnicodePrintable == nil) ^ (otherCaptureUser.stringTestUnicodePrintable == nil)) return NO; // xor
    else if (![self.stringTestUnicodePrintable isEqualToString:otherCaptureUser.stringTestUnicodePrintable]) return NO;

    if (!self.stringTestEmailAddress && !otherCaptureUser.stringTestEmailAddress) /* Keep going... */;
    else if ((self.stringTestEmailAddress == nil) ^ (otherCaptureUser.stringTestEmailAddress == nil)) return NO; // xor
    else if (![self.stringTestEmailAddress isEqualToString:otherCaptureUser.stringTestEmailAddress]) return NO;

    if (!self.stringTestLength && !otherCaptureUser.stringTestLength) /* Keep going... */;
    else if ((self.stringTestLength == nil) ^ (otherCaptureUser.stringTestLength == nil)) return NO; // xor
    else if (![self.stringTestLength isEqualToString:otherCaptureUser.stringTestLength]) return NO;

    if (!self.stringTestCaseSensitive && !otherCaptureUser.stringTestCaseSensitive) /* Keep going... */;
    else if ((self.stringTestCaseSensitive == nil) ^ (otherCaptureUser.stringTestCaseSensitive == nil)) return NO; // xor
    else if (![self.stringTestCaseSensitive isEqualToString:otherCaptureUser.stringTestCaseSensitive]) return NO;

    if (!self.stringTestFeatures && !otherCaptureUser.stringTestFeatures) /* Keep going... */;
    else if ((self.stringTestFeatures == nil) ^ (otherCaptureUser.stringTestFeatures == nil)) return NO; // xor
    else if (![self.stringTestFeatures isEqualToString:otherCaptureUser.stringTestFeatures]) return NO;

    if (!self.basicPlural && !otherCaptureUser.basicPlural) /* Keep going... */;
    else if (!self.basicPlural && ![otherCaptureUser.basicPlural count]) /* Keep going... */;
    else if (!otherCaptureUser.basicPlural && ![self.basicPlural count]) /* Keep going... */;
    else if (![self.basicPlural isEqualToOtherBasicPluralArray:otherCaptureUser.basicPlural]) return NO;

    if (!self.basicObject && !otherCaptureUser.basicObject) /* Keep going... */;
    else if (!self.basicObject && [otherCaptureUser.basicObject isEqualToBasicObject:[JRBasicObject basicObject]]) /* Keep going... */;
    else if (!otherCaptureUser.basicObject && [self.basicObject isEqualToBasicObject:[JRBasicObject basicObject]]) /* Keep going... */;
    else if (![self.basicObject isEqualToBasicObject:otherCaptureUser.basicObject]) return NO;

    if (!self.objectTestRequired && !otherCaptureUser.objectTestRequired) /* Keep going... */;
    else if (!self.objectTestRequired && [otherCaptureUser.objectTestRequired isEqualToObjectTestRequired:[JRObjectTestRequired objectTestRequired]]) /* Keep going... */;
    else if (!otherCaptureUser.objectTestRequired && [self.objectTestRequired isEqualToObjectTestRequired:[JRObjectTestRequired objectTestRequired]]) /* Keep going... */;
    else if (![self.objectTestRequired isEqualToObjectTestRequired:otherCaptureUser.objectTestRequired]) return NO;

    if (!self.pluralTestUnique && !otherCaptureUser.pluralTestUnique) /* Keep going... */;
    else if (!self.pluralTestUnique && ![otherCaptureUser.pluralTestUnique count]) /* Keep going... */;
    else if (!otherCaptureUser.pluralTestUnique && ![self.pluralTestUnique count]) /* Keep going... */;
    else if (![self.pluralTestUnique isEqualToOtherPluralTestUniqueArray:otherCaptureUser.pluralTestUnique]) return NO;

    if (!self.objectTestRequiredUnique && !otherCaptureUser.objectTestRequiredUnique) /* Keep going... */;
    else if (!self.objectTestRequiredUnique && [otherCaptureUser.objectTestRequiredUnique isEqualToObjectTestRequiredUnique:[JRObjectTestRequiredUnique objectTestRequiredUnique]]) /* Keep going... */;
    else if (!otherCaptureUser.objectTestRequiredUnique && [self.objectTestRequiredUnique isEqualToObjectTestRequiredUnique:[JRObjectTestRequiredUnique objectTestRequiredUnique]]) /* Keep going... */;
    else if (![self.objectTestRequiredUnique isEqualToObjectTestRequiredUnique:otherCaptureUser.objectTestRequiredUnique]) return NO;

    if (!self.pluralTestAlphabetic && !otherCaptureUser.pluralTestAlphabetic) /* Keep going... */;
    else if (!self.pluralTestAlphabetic && ![otherCaptureUser.pluralTestAlphabetic count]) /* Keep going... */;
    else if (!otherCaptureUser.pluralTestAlphabetic && ![self.pluralTestAlphabetic count]) /* Keep going... */;
    else if (![self.pluralTestAlphabetic isEqualToOtherPluralTestAlphabeticArray:otherCaptureUser.pluralTestAlphabetic]) return NO;

    if (!self.simpleStringPluralOne && !otherCaptureUser.simpleStringPluralOne) /* Keep going... */;
    else if (!self.simpleStringPluralOne && ![otherCaptureUser.simpleStringPluralOne count]) /* Keep going... */;
    else if (!otherCaptureUser.simpleStringPluralOne && ![self.simpleStringPluralOne count]) /* Keep going... */;
    else if (![self.simpleStringPluralOne isEqualToOtherSimpleStringPluralOneArray:otherCaptureUser.simpleStringPluralOne]) return NO;

    if (!self.simpleStringPluralTwo && !otherCaptureUser.simpleStringPluralTwo) /* Keep going... */;
    else if (!self.simpleStringPluralTwo && ![otherCaptureUser.simpleStringPluralTwo count]) /* Keep going... */;
    else if (!otherCaptureUser.simpleStringPluralTwo && ![self.simpleStringPluralTwo count]) /* Keep going... */;
    else if (![self.simpleStringPluralTwo isEqualToOtherSimpleStringPluralTwoArray:otherCaptureUser.simpleStringPluralTwo]) return NO;

    if (!self.pinapL1Plural && !otherCaptureUser.pinapL1Plural) /* Keep going... */;
    else if (!self.pinapL1Plural && ![otherCaptureUser.pinapL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.pinapL1Plural && ![self.pinapL1Plural count]) /* Keep going... */;
    else if (![self.pinapL1Plural isEqualToOtherPinapL1PluralArray:otherCaptureUser.pinapL1Plural]) return NO;

    if (!self.pinoL1Object && !otherCaptureUser.pinoL1Object) /* Keep going... */;
    else if (!self.pinoL1Object && [otherCaptureUser.pinoL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.pinoL1Object && [self.pinoL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1Object]]) /* Keep going... */;
    else if (![self.pinoL1Object isEqualToPinoL1Object:otherCaptureUser.pinoL1Object]) return NO;

    if (!self.onipL1Plural && !otherCaptureUser.onipL1Plural) /* Keep going... */;
    else if (!self.onipL1Plural && ![otherCaptureUser.onipL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.onipL1Plural && ![self.onipL1Plural count]) /* Keep going... */;
    else if (![self.onipL1Plural isEqualToOtherOnipL1PluralArray:otherCaptureUser.onipL1Plural]) return NO;

    if (!self.oinoL1Object && !otherCaptureUser.oinoL1Object) /* Keep going... */;
    else if (!self.oinoL1Object && [otherCaptureUser.oinoL1Object isEqualToOinoL1Object:[JROinoL1Object oinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.oinoL1Object && [self.oinoL1Object isEqualToOinoL1Object:[JROinoL1Object oinoL1Object]]) /* Keep going... */;
    else if (![self.oinoL1Object isEqualToOinoL1Object:otherCaptureUser.oinoL1Object]) return NO;

    if (!self.pinapinapL1Plural && !otherCaptureUser.pinapinapL1Plural) /* Keep going... */;
    else if (!self.pinapinapL1Plural && ![otherCaptureUser.pinapinapL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.pinapinapL1Plural && ![self.pinapinapL1Plural count]) /* Keep going... */;
    else if (![self.pinapinapL1Plural isEqualToOtherPinapinapL1PluralArray:otherCaptureUser.pinapinapL1Plural]) return NO;

    if (!self.pinonipL1Plural && !otherCaptureUser.pinonipL1Plural) /* Keep going... */;
    else if (!self.pinonipL1Plural && ![otherCaptureUser.pinonipL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.pinonipL1Plural && ![self.pinonipL1Plural count]) /* Keep going... */;
    else if (![self.pinonipL1Plural isEqualToOtherPinonipL1PluralArray:otherCaptureUser.pinonipL1Plural]) return NO;

    if (!self.pinapinoL1Object && !otherCaptureUser.pinapinoL1Object) /* Keep going... */;
    else if (!self.pinapinoL1Object && [otherCaptureUser.pinapinoL1Object isEqualToPinapinoL1Object:[JRPinapinoL1Object pinapinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.pinapinoL1Object && [self.pinapinoL1Object isEqualToPinapinoL1Object:[JRPinapinoL1Object pinapinoL1Object]]) /* Keep going... */;
    else if (![self.pinapinoL1Object isEqualToPinapinoL1Object:otherCaptureUser.pinapinoL1Object]) return NO;

    if (!self.pinoinoL1Object && !otherCaptureUser.pinoinoL1Object) /* Keep going... */;
    else if (!self.pinoinoL1Object && [otherCaptureUser.pinoinoL1Object isEqualToPinoinoL1Object:[JRPinoinoL1Object pinoinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.pinoinoL1Object && [self.pinoinoL1Object isEqualToPinoinoL1Object:[JRPinoinoL1Object pinoinoL1Object]]) /* Keep going... */;
    else if (![self.pinoinoL1Object isEqualToPinoinoL1Object:otherCaptureUser.pinoinoL1Object]) return NO;

    if (!self.onipinapL1Plural && !otherCaptureUser.onipinapL1Plural) /* Keep going... */;
    else if (!self.onipinapL1Plural && ![otherCaptureUser.onipinapL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.onipinapL1Plural && ![self.onipinapL1Plural count]) /* Keep going... */;
    else if (![self.onipinapL1Plural isEqualToOtherOnipinapL1PluralArray:otherCaptureUser.onipinapL1Plural]) return NO;

    if (!self.oinonipL1Plural && !otherCaptureUser.oinonipL1Plural) /* Keep going... */;
    else if (!self.oinonipL1Plural && ![otherCaptureUser.oinonipL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.oinonipL1Plural && ![self.oinonipL1Plural count]) /* Keep going... */;
    else if (![self.oinonipL1Plural isEqualToOtherOinonipL1PluralArray:otherCaptureUser.oinonipL1Plural]) return NO;

    if (!self.onipinoL1Object && !otherCaptureUser.onipinoL1Object) /* Keep going... */;
    else if (!self.onipinoL1Object && [otherCaptureUser.onipinoL1Object isEqualToOnipinoL1Object:[JROnipinoL1Object onipinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.onipinoL1Object && [self.onipinoL1Object isEqualToOnipinoL1Object:[JROnipinoL1Object onipinoL1Object]]) /* Keep going... */;
    else if (![self.onipinoL1Object isEqualToOnipinoL1Object:otherCaptureUser.onipinoL1Object]) return NO;

    if (!self.oinoinoL1Object && !otherCaptureUser.oinoinoL1Object) /* Keep going... */;
    else if (!self.oinoinoL1Object && [otherCaptureUser.oinoinoL1Object isEqualToOinoinoL1Object:[JROinoinoL1Object oinoinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.oinoinoL1Object && [self.oinoinoL1Object isEqualToOinoinoL1Object:[JROinoinoL1Object oinoinoL1Object]]) /* Keep going... */;
    else if (![self.oinoinoL1Object isEqualToOinoinoL1Object:otherCaptureUser.oinoinoL1Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"email"];
    [dict setObject:@"JRBoolean" forKey:@"basicBoolean"];
    [dict setObject:@"NSString" forKey:@"basicString"];
    [dict setObject:@"JRInteger" forKey:@"basicInteger"];
    [dict setObject:@"NSNumber" forKey:@"basicDecimal"];
    [dict setObject:@"JRDate" forKey:@"basicDate"];
    [dict setObject:@"JRDateTime" forKey:@"basicDateTime"];
    [dict setObject:@"JRIpAddress" forKey:@"basicIpAddress"];
    [dict setObject:@"JRPassword" forKey:@"basicPassword"];
    [dict setObject:@"JRJsonObject" forKey:@"jsonNumber"];
    [dict setObject:@"JRJsonObject" forKey:@"jsonString"];
    [dict setObject:@"JRJsonObject" forKey:@"jsonArray"];
    [dict setObject:@"JRJsonObject" forKey:@"jsonDictionary"];
    [dict setObject:@"NSString" forKey:@"stringTestJson"];
    [dict setObject:@"NSString" forKey:@"stringTestEmpty"];
    [dict setObject:@"NSString" forKey:@"stringTestNull"];
    [dict setObject:@"NSString" forKey:@"stringTestInvalid"];
    [dict setObject:@"NSString" forKey:@"stringTestNSNull"];
    [dict setObject:@"NSString" forKey:@"stringTestAlphanumeric"];
    [dict setObject:@"NSString" forKey:@"stringTestUnicodeLetters"];
    [dict setObject:@"NSString" forKey:@"stringTestUnicodePrintable"];
    [dict setObject:@"NSString" forKey:@"stringTestEmailAddress"];
    [dict setObject:@"NSString" forKey:@"stringTestLength"];
    [dict setObject:@"NSString" forKey:@"stringTestCaseSensitive"];
    [dict setObject:@"NSString" forKey:@"stringTestFeatures"];
    [dict setObject:@"NSArray" forKey:@"basicPlural"];
    [dict setObject:@"JRBasicObject" forKey:@"basicObject"];
    [dict setObject:@"JRObjectTestRequired" forKey:@"objectTestRequired"];
    [dict setObject:@"NSArray" forKey:@"pluralTestUnique"];
    [dict setObject:@"JRObjectTestRequiredUnique" forKey:@"objectTestRequiredUnique"];
    [dict setObject:@"NSArray" forKey:@"pluralTestAlphabetic"];
    [dict setObject:@"NSArray" forKey:@"simpleStringPluralOne"];
    [dict setObject:@"NSArray" forKey:@"simpleStringPluralTwo"];
    [dict setObject:@"NSArray" forKey:@"pinapL1Plural"];
    [dict setObject:@"JRPinoL1Object" forKey:@"pinoL1Object"];
    [dict setObject:@"NSArray" forKey:@"onipL1Plural"];
    [dict setObject:@"JROinoL1Object" forKey:@"oinoL1Object"];
    [dict setObject:@"NSArray" forKey:@"pinapinapL1Plural"];
    [dict setObject:@"NSArray" forKey:@"pinonipL1Plural"];
    [dict setObject:@"JRPinapinoL1Object" forKey:@"pinapinoL1Object"];
    [dict setObject:@"JRPinoinoL1Object" forKey:@"pinoinoL1Object"];
    [dict setObject:@"NSArray" forKey:@"onipinapL1Plural"];
    [dict setObject:@"NSArray" forKey:@"oinonipL1Plural"];
    [dict setObject:@"JROnipinoL1Object" forKey:@"onipinoL1Object"];
    [dict setObject:@"JROinoinoL1Object" forKey:@"oinoinoL1Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_email release];
    [_basicBoolean release];
    [_basicString release];
    [_basicInteger release];
    [_basicDecimal release];
    [_basicDate release];
    [_basicDateTime release];
    [_basicIpAddress release];
    [_basicPassword release];
    [_jsonNumber release];
    [_jsonString release];
    [_jsonArray release];
    [_jsonDictionary release];
    [_stringTestJson release];
    [_stringTestEmpty release];
    [_stringTestNull release];
    [_stringTestInvalid release];
    [_stringTestNSNull release];
    [_stringTestAlphanumeric release];
    [_stringTestUnicodeLetters release];
    [_stringTestUnicodePrintable release];
    [_stringTestEmailAddress release];
    [_stringTestLength release];
    [_stringTestCaseSensitive release];
    [_stringTestFeatures release];
    [_basicPlural release];
    [_basicObject release];
    [_objectTestRequired release];
    [_pluralTestUnique release];
    [_objectTestRequiredUnique release];
    [_pluralTestAlphabetic release];
    [_simpleStringPluralOne release];
    [_simpleStringPluralTwo release];
    [_pinapL1Plural release];
    [_pinoL1Object release];
    [_onipL1Plural release];
    [_oinoL1Object release];
    [_pinapinapL1Plural release];
    [_pinonipL1Plural release];
    [_pinapinoL1Object release];
    [_pinoinoL1Object release];
    [_onipinapL1Plural release];
    [_oinonipL1Plural release];
    [_onipinoL1Object release];
    [_oinoinoL1Object release];

    [super dealloc];
}
@end
