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
#import "JRCaptureUser.h"

@interface JRBasicPluralElement (BasicPluralElementInternalMethods)
+ (id)basicPluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToBasicPluralElement:(JRBasicPluralElement *)otherBasicPluralElement;
@end

@interface JRBasicObject (BasicObjectInternalMethods)
+ (id)basicObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToBasicObject:(JRBasicObject *)otherBasicObject;
@end

@interface JRObjectTestRequired (ObjectTestRequiredInternalMethods)
+ (id)objectTestRequiredObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToObjectTestRequired:(JRObjectTestRequired *)otherObjectTestRequired;
@end

@interface JRPluralTestUniqueElement (PluralTestUniqueElementInternalMethods)
+ (id)pluralTestUniqueElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPluralTestUniqueElement:(JRPluralTestUniqueElement *)otherPluralTestUniqueElement;
@end

@interface JRObjectTestRequiredUnique (ObjectTestRequiredUniqueInternalMethods)
+ (id)objectTestRequiredUniqueObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToObjectTestRequiredUnique:(JRObjectTestRequiredUnique *)otherObjectTestRequiredUnique;
@end

@interface JRPluralTestAlphabeticElement (PluralTestAlphabeticElementInternalMethods)
+ (id)pluralTestAlphabeticElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPluralTestAlphabeticElement:(JRPluralTestAlphabeticElement *)otherPluralTestAlphabeticElement;
@end

@interface JRPinapL1PluralElement (PinapL1PluralElementInternalMethods)
+ (id)pinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinapL1PluralElement:(JRPinapL1PluralElement *)otherPinapL1PluralElement;
@end

@interface JRPinoL1Object (PinoL1ObjectInternalMethods)
+ (id)pinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinoL1Object:(JRPinoL1Object *)otherPinoL1Object;
@end

@interface JROnipL1PluralElement (OnipL1PluralElementInternalMethods)
+ (id)onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipL1PluralElement:(JROnipL1PluralElement *)otherOnipL1PluralElement;
@end

@interface JROinoL1Object (OinoL1ObjectInternalMethods)
+ (id)oinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOinoL1Object:(JROinoL1Object *)otherOinoL1Object;
@end

@interface JRPinapinapL1PluralElement (PinapinapL1PluralElementInternalMethods)
+ (id)pinapinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinapinapL1PluralElement:(JRPinapinapL1PluralElement *)otherPinapinapL1PluralElement;
@end

@interface JRPinonipL1PluralElement (PinonipL1PluralElementInternalMethods)
+ (id)pinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinonipL1PluralElement:(JRPinonipL1PluralElement *)otherPinonipL1PluralElement;
@end

@interface JRPinapinoL1Object (PinapinoL1ObjectInternalMethods)
+ (id)pinapinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinapinoL1Object:(JRPinapinoL1Object *)otherPinapinoL1Object;
@end

@interface JRPinoinoL1Object (PinoinoL1ObjectInternalMethods)
+ (id)pinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinoinoL1Object:(JRPinoinoL1Object *)otherPinoinoL1Object;
@end

@interface JROnipinapL1PluralElement (OnipinapL1PluralElementInternalMethods)
+ (id)onipinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipinapL1PluralElement:(JROnipinapL1PluralElement *)otherOnipinapL1PluralElement;
@end

@interface JROinonipL1PluralElement (OinonipL1PluralElementInternalMethods)
+ (id)oinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOinonipL1PluralElement:(JROinonipL1PluralElement *)otherOinonipL1PluralElement;
@end

@interface JROnipinoL1Object (OnipinoL1ObjectInternalMethods)
+ (id)onipinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipinoL1Object:(JROnipinoL1Object *)otherOnipinoL1Object;
@end

@interface JROinoinoL1Object (OinoinoL1ObjectInternalMethods)
+ (id)oinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOinoinoL1Object:(JROinoinoL1Object *)otherOinoinoL1Object;
@end

@interface NSArray (BasicPluralToFromDictionary)
- (NSArray*)arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfBasicPluralDictionariesFromBasicPluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfBasicPluralDictionariesFromBasicPluralElements;
- (NSArray*)arrayOfBasicPluralReplaceDictionariesFromBasicPluralElements;
@end

@implementation NSArray (BasicPluralToFromDictionary)
- (NSArray*)arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredBasicPluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredBasicPluralArray addObject:[JRBasicPluralElement basicPluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredBasicPluralArray;
}

- (NSArray*)arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfBasicPluralDictionariesFromBasicPluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRBasicPluralElement class]])
            [filteredDictionaryArray addObject:[(JRBasicPluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfBasicPluralDictionariesFromBasicPluralElements
{
    return [self arrayOfBasicPluralDictionariesFromBasicPluralElementsForEncoder:NO];
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
- (NSArray*)arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElements;
- (NSArray*)arrayOfPluralTestUniqueReplaceDictionariesFromPluralTestUniqueElements;
@end

@implementation NSArray (PluralTestUniqueToFromDictionary)
- (NSArray*)arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPluralTestUniqueArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralTestUniqueArray addObject:[JRPluralTestUniqueElement pluralTestUniqueElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPluralTestUniqueArray;
}

- (NSArray*)arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralTestUniqueElement class]])
            [filteredDictionaryArray addObject:[(JRPluralTestUniqueElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElements
{
    return [self arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElementsForEncoder:NO];
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
- (NSArray*)arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElements;
- (NSArray*)arrayOfPluralTestAlphabeticReplaceDictionariesFromPluralTestAlphabeticElements;
@end

@implementation NSArray (PluralTestAlphabeticToFromDictionary)
- (NSArray*)arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPluralTestAlphabeticArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralTestAlphabeticArray addObject:[JRPluralTestAlphabeticElement pluralTestAlphabeticElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPluralTestAlphabeticArray;
}

- (NSArray*)arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralTestAlphabeticElement class]])
            [filteredDictionaryArray addObject:[(JRPluralTestAlphabeticElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElements
{
    return [self arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElementsForEncoder:NO];
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

@interface NSArray (PinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinapL1PluralDictionariesFromPinapL1PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinapL1PluralDictionariesFromPinapL1PluralElements;
- (NSArray*)arrayOfPinapL1PluralReplaceDictionariesFromPinapL1PluralElements;
@end

@implementation NSArray (PinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinapL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapL1PluralArray addObject:[JRPinapL1PluralElement pinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinapL1PluralArray;
}

- (NSArray*)arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPinapL1PluralDictionariesFromPinapL1PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapL1PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapL1PluralDictionariesFromPinapL1PluralElements
{
    return [self arrayOfPinapL1PluralDictionariesFromPinapL1PluralElementsForEncoder:NO];
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
- (NSArray*)arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipL1PluralDictionariesFromOnipL1PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfOnipL1PluralDictionariesFromOnipL1PluralElements;
- (NSArray*)arrayOfOnipL1PluralReplaceDictionariesFromOnipL1PluralElements;
@end

@implementation NSArray (OnipL1PluralToFromDictionary)
- (NSArray*)arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredOnipL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipL1PluralArray addObject:[JROnipL1PluralElement onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredOnipL1PluralArray;
}

- (NSArray*)arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfOnipL1PluralDictionariesFromOnipL1PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipL1PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipL1PluralDictionariesFromOnipL1PluralElements
{
    return [self arrayOfOnipL1PluralDictionariesFromOnipL1PluralElementsForEncoder:NO];
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
- (NSArray*)arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElements;
- (NSArray*)arrayOfPinapinapL1PluralReplaceDictionariesFromPinapinapL1PluralElements;
@end

@implementation NSArray (PinapinapL1PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinapinapL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapinapL1PluralArray addObject:[JRPinapinapL1PluralElement pinapinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinapinapL1PluralArray;
}

- (NSArray*)arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL1PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElements
{
    return [self arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElementsForEncoder:NO];
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
- (NSArray*)arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElements;
- (NSArray*)arrayOfPinonipL1PluralReplaceDictionariesFromPinonipL1PluralElements;
@end

@implementation NSArray (PinonipL1PluralToFromDictionary)
- (NSArray*)arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPinonipL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinonipL1PluralArray addObject:[JRPinonipL1PluralElement pinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPinonipL1PluralArray;
}

- (NSArray*)arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinonipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinonipL1PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElements
{
    return [self arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElementsForEncoder:NO];
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
- (NSArray*)arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElements;
- (NSArray*)arrayOfOnipinapL1PluralReplaceDictionariesFromOnipinapL1PluralElements;
@end

@implementation NSArray (OnipinapL1PluralToFromDictionary)
- (NSArray*)arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredOnipinapL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipinapL1PluralArray addObject:[JROnipinapL1PluralElement onipinapL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredOnipinapL1PluralArray;
}

- (NSArray*)arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipinapL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROnipinapL1PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElements
{
    return [self arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElementsForEncoder:NO];
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
- (NSArray*)arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder;
- (NSArray*)arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElementsForEncoder:(BOOL)forEncoder;
- (NSArray*)arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElements;
- (NSArray*)arrayOfOinonipL1PluralReplaceDictionariesFromOinonipL1PluralElements;
@end

@implementation NSArray (OinonipL1PluralToFromDictionary)
- (NSArray*)arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredOinonipL1PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOinonipL1PluralArray addObject:[JROinonipL1PluralElement oinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredOinonipL1PluralArray;
}

- (NSArray*)arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROinonipL1PluralElement class]])
            [filteredDictionaryArray addObject:[(JROinonipL1PluralElement*)object toDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElements
{
    return [self arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElementsForEncoder:NO];
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

@interface NSArray (CaptureUser_ArrayComparison)
- (BOOL)isEqualToBasicPluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToPluralTestUniqueArray:(NSArray *)otherArray;
- (BOOL)isEqualToPluralTestAlphabeticArray:(NSArray *)otherArray;
- (BOOL)isEqualToPinapL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToOnipL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToPinapinapL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToPinonipL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToOnipinapL1PluralArray:(NSArray *)otherArray;
- (BOOL)isEqualToOinonipL1PluralArray:(NSArray *)otherArray;
@end

@implementation NSArray (CaptureUser_ArrayComparison)

- (BOOL)isEqualToBasicPluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRBasicPluralElement *)[self objectAtIndex:i]) isEqualToBasicPluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPluralTestUniqueArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPluralTestUniqueElement *)[self objectAtIndex:i]) isEqualToPluralTestUniqueElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPluralTestAlphabeticArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPluralTestAlphabeticElement *)[self objectAtIndex:i]) isEqualToPluralTestAlphabeticElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPinapL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinapL1PluralElement *)[self objectAtIndex:i]) isEqualToPinapL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOnipL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROnipL1PluralElement *)[self objectAtIndex:i]) isEqualToOnipL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPinapinapL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinapinapL1PluralElement *)[self objectAtIndex:i]) isEqualToPinapinapL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPinonipL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinonipL1PluralElement *)[self objectAtIndex:i]) isEqualToPinonipL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOnipinapL1PluralArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROnipinapL1PluralElement *)[self objectAtIndex:i]) isEqualToOnipinapL1PluralElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOinonipL1PluralArray:(NSArray *)otherArray
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
    JRUuid *_uuid;
    JRDateTime *_created;
    JRDateTime *_lastUpdated;
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
    JRStringArray *_simpleStringPluralOne;
    JRStringArray *_simpleStringPluralTwo;
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
@synthesize canBeUpdatedOrReplaced;

- (JRUuid *)uuid
{
    return _uuid;
}

- (void)setUuid:(JRUuid *)newUuid
{
    [self.dirtyPropertySet addObject:@"uuid"];

    [_uuid autorelease];
    _uuid = [newUuid copy];
}

- (JRDateTime *)created
{
    return _created;
}

- (void)setCreated:(JRDateTime *)newCreated
{
    [self.dirtyPropertySet addObject:@"created"];

    [_created autorelease];
    _created = [newCreated copy];
}

- (JRDateTime *)lastUpdated
{
    return _lastUpdated;
}

- (void)setLastUpdated:(JRDateTime *)newLastUpdated
{
    [self.dirtyPropertySet addObject:@"lastUpdated"];

    [_lastUpdated autorelease];
    _lastUpdated = [newLastUpdated copy];
}

- (NSString *)email
{
    return _email;
}

- (void)setEmail:(NSString *)newEmail
{
    [self.dirtyPropertySet addObject:@"email"];

    [_email autorelease];
    _email = [newEmail copy];
}

- (JRBoolean *)basicBoolean
{
    return _basicBoolean;
}

- (void)setBasicBoolean:(JRBoolean *)newBasicBoolean
{
    [self.dirtyPropertySet addObject:@"basicBoolean"];

    [_basicBoolean autorelease];
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

    [_basicString autorelease];
    _basicString = [newBasicString copy];
}

- (JRInteger *)basicInteger
{
    return _basicInteger;
}

- (void)setBasicInteger:(JRInteger *)newBasicInteger
{
    [self.dirtyPropertySet addObject:@"basicInteger"];

    [_basicInteger autorelease];
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

    [_basicDecimal autorelease];
    _basicDecimal = [newBasicDecimal copy];
}

- (JRDate *)basicDate
{
    return _basicDate;
}

- (void)setBasicDate:(JRDate *)newBasicDate
{
    [self.dirtyPropertySet addObject:@"basicDate"];

    [_basicDate autorelease];
    _basicDate = [newBasicDate copy];
}

- (JRDateTime *)basicDateTime
{
    return _basicDateTime;
}

- (void)setBasicDateTime:(JRDateTime *)newBasicDateTime
{
    [self.dirtyPropertySet addObject:@"basicDateTime"];

    [_basicDateTime autorelease];
    _basicDateTime = [newBasicDateTime copy];
}

- (JRIpAddress *)basicIpAddress
{
    return _basicIpAddress;
}

- (void)setBasicIpAddress:(JRIpAddress *)newBasicIpAddress
{
    [self.dirtyPropertySet addObject:@"basicIpAddress"];

    [_basicIpAddress autorelease];
    _basicIpAddress = [newBasicIpAddress copy];
}

- (JRPassword *)basicPassword
{
    return _basicPassword;
}

- (void)setBasicPassword:(JRPassword *)newBasicPassword
{
    [self.dirtyPropertySet addObject:@"basicPassword"];

    [_basicPassword autorelease];
    _basicPassword = [newBasicPassword copy];
}

- (JRJsonObject *)jsonNumber
{
    return _jsonNumber;
}

- (void)setJsonNumber:(JRJsonObject *)newJsonNumber
{
    [self.dirtyPropertySet addObject:@"jsonNumber"];

    [_jsonNumber autorelease];
    _jsonNumber = [newJsonNumber copy];
}

- (JRJsonObject *)jsonString
{
    return _jsonString;
}

- (void)setJsonString:(JRJsonObject *)newJsonString
{
    [self.dirtyPropertySet addObject:@"jsonString"];

    [_jsonString autorelease];
    _jsonString = [newJsonString copy];
}

- (JRJsonObject *)jsonArray
{
    return _jsonArray;
}

- (void)setJsonArray:(JRJsonObject *)newJsonArray
{
    [self.dirtyPropertySet addObject:@"jsonArray"];

    [_jsonArray autorelease];
    _jsonArray = [newJsonArray copy];
}

- (JRJsonObject *)jsonDictionary
{
    return _jsonDictionary;
}

- (void)setJsonDictionary:(JRJsonObject *)newJsonDictionary
{
    [self.dirtyPropertySet addObject:@"jsonDictionary"];

    [_jsonDictionary autorelease];
    _jsonDictionary = [newJsonDictionary copy];
}

- (NSString *)stringTestJson
{
    return _stringTestJson;
}

- (void)setStringTestJson:(NSString *)newStringTestJson
{
    [self.dirtyPropertySet addObject:@"stringTestJson"];

    [_stringTestJson autorelease];
    _stringTestJson = [newStringTestJson copy];
}

- (NSString *)stringTestEmpty
{
    return _stringTestEmpty;
}

- (void)setStringTestEmpty:(NSString *)newStringTestEmpty
{
    [self.dirtyPropertySet addObject:@"stringTestEmpty"];

    [_stringTestEmpty autorelease];
    _stringTestEmpty = [newStringTestEmpty copy];
}

- (NSString *)stringTestNull
{
    return _stringTestNull;
}

- (void)setStringTestNull:(NSString *)newStringTestNull
{
    [self.dirtyPropertySet addObject:@"stringTestNull"];

    [_stringTestNull autorelease];
    _stringTestNull = [newStringTestNull copy];
}

- (NSString *)stringTestInvalid
{
    return _stringTestInvalid;
}

- (void)setStringTestInvalid:(NSString *)newStringTestInvalid
{
    [self.dirtyPropertySet addObject:@"stringTestInvalid"];

    [_stringTestInvalid autorelease];
    _stringTestInvalid = [newStringTestInvalid copy];
}

- (NSString *)stringTestNSNull
{
    return _stringTestNSNull;
}

- (void)setStringTestNSNull:(NSString *)newStringTestNSNull
{
    [self.dirtyPropertySet addObject:@"stringTestNSNull"];

    [_stringTestNSNull autorelease];
    _stringTestNSNull = [newStringTestNSNull copy];
}

- (NSString *)stringTestAlphanumeric
{
    return _stringTestAlphanumeric;
}

- (void)setStringTestAlphanumeric:(NSString *)newStringTestAlphanumeric
{
    [self.dirtyPropertySet addObject:@"stringTestAlphanumeric"];

    [_stringTestAlphanumeric autorelease];
    _stringTestAlphanumeric = [newStringTestAlphanumeric copy];
}

- (NSString *)stringTestUnicodeLetters
{
    return _stringTestUnicodeLetters;
}

- (void)setStringTestUnicodeLetters:(NSString *)newStringTestUnicodeLetters
{
    [self.dirtyPropertySet addObject:@"stringTestUnicodeLetters"];

    [_stringTestUnicodeLetters autorelease];
    _stringTestUnicodeLetters = [newStringTestUnicodeLetters copy];
}

- (NSString *)stringTestUnicodePrintable
{
    return _stringTestUnicodePrintable;
}

- (void)setStringTestUnicodePrintable:(NSString *)newStringTestUnicodePrintable
{
    [self.dirtyPropertySet addObject:@"stringTestUnicodePrintable"];

    [_stringTestUnicodePrintable autorelease];
    _stringTestUnicodePrintable = [newStringTestUnicodePrintable copy];
}

- (NSString *)stringTestEmailAddress
{
    return _stringTestEmailAddress;
}

- (void)setStringTestEmailAddress:(NSString *)newStringTestEmailAddress
{
    [self.dirtyPropertySet addObject:@"stringTestEmailAddress"];

    [_stringTestEmailAddress autorelease];
    _stringTestEmailAddress = [newStringTestEmailAddress copy];
}

- (NSString *)stringTestLength
{
    return _stringTestLength;
}

- (void)setStringTestLength:(NSString *)newStringTestLength
{
    [self.dirtyPropertySet addObject:@"stringTestLength"];

    [_stringTestLength autorelease];
    _stringTestLength = [newStringTestLength copy];
}

- (NSString *)stringTestCaseSensitive
{
    return _stringTestCaseSensitive;
}

- (void)setStringTestCaseSensitive:(NSString *)newStringTestCaseSensitive
{
    [self.dirtyPropertySet addObject:@"stringTestCaseSensitive"];

    [_stringTestCaseSensitive autorelease];
    _stringTestCaseSensitive = [newStringTestCaseSensitive copy];
}

- (NSString *)stringTestFeatures
{
    return _stringTestFeatures;
}

- (void)setStringTestFeatures:(NSString *)newStringTestFeatures
{
    [self.dirtyPropertySet addObject:@"stringTestFeatures"];

    [_stringTestFeatures autorelease];
    _stringTestFeatures = [newStringTestFeatures copy];
}

- (NSArray *)basicPlural
{
    return _basicPlural;
}

- (void)setBasicPlural:(NSArray *)newBasicPlural
{
    [_basicPlural autorelease];
    _basicPlural = [newBasicPlural copy];
}

- (JRBasicObject *)basicObject
{
    return _basicObject;
}

- (void)setBasicObject:(JRBasicObject *)newBasicObject
{
    [self.dirtyPropertySet addObject:@"basicObject"];

    [_basicObject autorelease];
    _basicObject = [newBasicObject retain];

    [_basicObject setAllPropertiesToDirty];
}

- (JRObjectTestRequired *)objectTestRequired
{
    return _objectTestRequired;
}

- (void)setObjectTestRequired:(JRObjectTestRequired *)newObjectTestRequired
{
    [self.dirtyPropertySet addObject:@"objectTestRequired"];

    [_objectTestRequired autorelease];
    _objectTestRequired = [newObjectTestRequired retain];

    [_objectTestRequired setAllPropertiesToDirty];
}

- (NSArray *)pluralTestUnique
{
    return _pluralTestUnique;
}

- (void)setPluralTestUnique:(NSArray *)newPluralTestUnique
{
    [_pluralTestUnique autorelease];
    _pluralTestUnique = [newPluralTestUnique copy];
}

- (JRObjectTestRequiredUnique *)objectTestRequiredUnique
{
    return _objectTestRequiredUnique;
}

- (void)setObjectTestRequiredUnique:(JRObjectTestRequiredUnique *)newObjectTestRequiredUnique
{
    [self.dirtyPropertySet addObject:@"objectTestRequiredUnique"];

    [_objectTestRequiredUnique autorelease];
    _objectTestRequiredUnique = [newObjectTestRequiredUnique retain];

    [_objectTestRequiredUnique setAllPropertiesToDirty];
}

- (NSArray *)pluralTestAlphabetic
{
    return _pluralTestAlphabetic;
}

- (void)setPluralTestAlphabetic:(NSArray *)newPluralTestAlphabetic
{
    [_pluralTestAlphabetic autorelease];
    _pluralTestAlphabetic = [newPluralTestAlphabetic copy];
}

- (JRStringArray *)simpleStringPluralOne
{
    return _simpleStringPluralOne;
}

- (void)setSimpleStringPluralOne:(JRStringArray *)newSimpleStringPluralOne
{
    [_simpleStringPluralOne autorelease];
    _simpleStringPluralOne = [newSimpleStringPluralOne copy];
}

- (JRStringArray *)simpleStringPluralTwo
{
    return _simpleStringPluralTwo;
}

- (void)setSimpleStringPluralTwo:(JRStringArray *)newSimpleStringPluralTwo
{
    [_simpleStringPluralTwo autorelease];
    _simpleStringPluralTwo = [newSimpleStringPluralTwo copy];
}

- (NSArray *)pinapL1Plural
{
    return _pinapL1Plural;
}

- (void)setPinapL1Plural:(NSArray *)newPinapL1Plural
{
    [_pinapL1Plural autorelease];
    _pinapL1Plural = [newPinapL1Plural copy];
}

- (JRPinoL1Object *)pinoL1Object
{
    return _pinoL1Object;
}

- (void)setPinoL1Object:(JRPinoL1Object *)newPinoL1Object
{
    [self.dirtyPropertySet addObject:@"pinoL1Object"];

    [_pinoL1Object autorelease];
    _pinoL1Object = [newPinoL1Object retain];

    [_pinoL1Object setAllPropertiesToDirty];
}

- (NSArray *)onipL1Plural
{
    return _onipL1Plural;
}

- (void)setOnipL1Plural:(NSArray *)newOnipL1Plural
{
    [_onipL1Plural autorelease];
    _onipL1Plural = [newOnipL1Plural copy];
}

- (JROinoL1Object *)oinoL1Object
{
    return _oinoL1Object;
}

- (void)setOinoL1Object:(JROinoL1Object *)newOinoL1Object
{
    [self.dirtyPropertySet addObject:@"oinoL1Object"];

    [_oinoL1Object autorelease];
    _oinoL1Object = [newOinoL1Object retain];

    [_oinoL1Object setAllPropertiesToDirty];
}

- (NSArray *)pinapinapL1Plural
{
    return _pinapinapL1Plural;
}

- (void)setPinapinapL1Plural:(NSArray *)newPinapinapL1Plural
{
    [_pinapinapL1Plural autorelease];
    _pinapinapL1Plural = [newPinapinapL1Plural copy];
}

- (NSArray *)pinonipL1Plural
{
    return _pinonipL1Plural;
}

- (void)setPinonipL1Plural:(NSArray *)newPinonipL1Plural
{
    [_pinonipL1Plural autorelease];
    _pinonipL1Plural = [newPinonipL1Plural copy];
}

- (JRPinapinoL1Object *)pinapinoL1Object
{
    return _pinapinoL1Object;
}

- (void)setPinapinoL1Object:(JRPinapinoL1Object *)newPinapinoL1Object
{
    [self.dirtyPropertySet addObject:@"pinapinoL1Object"];

    [_pinapinoL1Object autorelease];
    _pinapinoL1Object = [newPinapinoL1Object retain];

    [_pinapinoL1Object setAllPropertiesToDirty];
}

- (JRPinoinoL1Object *)pinoinoL1Object
{
    return _pinoinoL1Object;
}

- (void)setPinoinoL1Object:(JRPinoinoL1Object *)newPinoinoL1Object
{
    [self.dirtyPropertySet addObject:@"pinoinoL1Object"];

    [_pinoinoL1Object autorelease];
    _pinoinoL1Object = [newPinoinoL1Object retain];

    [_pinoinoL1Object setAllPropertiesToDirty];
}

- (NSArray *)onipinapL1Plural
{
    return _onipinapL1Plural;
}

- (void)setOnipinapL1Plural:(NSArray *)newOnipinapL1Plural
{
    [_onipinapL1Plural autorelease];
    _onipinapL1Plural = [newOnipinapL1Plural copy];
}

- (NSArray *)oinonipL1Plural
{
    return _oinonipL1Plural;
}

- (void)setOinonipL1Plural:(NSArray *)newOinonipL1Plural
{
    [_oinonipL1Plural autorelease];
    _oinonipL1Plural = [newOinonipL1Plural copy];
}

- (JROnipinoL1Object *)onipinoL1Object
{
    return _onipinoL1Object;
}

- (void)setOnipinoL1Object:(JROnipinoL1Object *)newOnipinoL1Object
{
    [self.dirtyPropertySet addObject:@"onipinoL1Object"];

    [_onipinoL1Object autorelease];
    _onipinoL1Object = [newOnipinoL1Object retain];

    [_onipinoL1Object setAllPropertiesToDirty];
}

- (JROinoinoL1Object *)oinoinoL1Object
{
    return _oinoinoL1Object;
}

- (void)setOinoinoL1Object:(JROinoinoL1Object *)newOinoinoL1Object
{
    [self.dirtyPropertySet addObject:@"oinoinoL1Object"];

    [_oinoinoL1Object autorelease];
    _oinoinoL1Object = [newOinoinoL1Object retain];

    [_oinoinoL1Object setAllPropertiesToDirty];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = YES;

        _basicObject = [[JRBasicObject alloc] init];
        _objectTestRequired = [[JRObjectTestRequired alloc] init];
        _objectTestRequiredUnique = [[JRObjectTestRequiredUnique alloc] init];
        _pinoL1Object = [[JRPinoL1Object alloc] init];
        _oinoL1Object = [[JROinoL1Object alloc] init];
        _pinapinoL1Object = [[JRPinapinoL1Object alloc] init];
        _pinoinoL1Object = [[JRPinoinoL1Object alloc] init];
        _onipinoL1Object = [[JROnipinoL1Object alloc] init];
        _oinoinoL1Object = [[JROinoinoL1Object alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)captureUser
{
    return [[[JRCaptureUser alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCaptureUser *captureUserCopy = (JRCaptureUser *)[super copyWithZone:zone];

    captureUserCopy.uuid = self.uuid;
    captureUserCopy.created = self.created;
    captureUserCopy.lastUpdated = self.lastUpdated;
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

    return captureUserCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.uuid ? self.uuid : [NSNull null])
                   forKey:@"uuid"];
    [dictionary setObject:(self.created ? [self.created stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"created"];
    [dictionary setObject:(self.lastUpdated ? [self.lastUpdated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastUpdated"];
    [dictionary setObject:(self.email ? self.email : [NSNull null])
                   forKey:@"email"];
    [dictionary setObject:(self.basicBoolean ? [NSNumber numberWithBool:[self.basicBoolean boolValue]] : [NSNull null])
                   forKey:@"basicBoolean"];
    [dictionary setObject:(self.basicString ? self.basicString : [NSNull null])
                   forKey:@"basicString"];
    [dictionary setObject:(self.basicInteger ? [NSNumber numberWithInteger:[self.basicInteger integerValue]] : [NSNull null])
                   forKey:@"basicInteger"];
    [dictionary setObject:(self.basicDecimal ? self.basicDecimal : [NSNull null])
                   forKey:@"basicDecimal"];
    [dictionary setObject:(self.basicDate ? [self.basicDate stringFromISO8601Date] : [NSNull null])
                   forKey:@"basicDate"];
    [dictionary setObject:(self.basicDateTime ? [self.basicDateTime stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"basicDateTime"];
    [dictionary setObject:(self.basicIpAddress ? self.basicIpAddress : [NSNull null])
                   forKey:@"basicIpAddress"];
    [dictionary setObject:(self.basicPassword ? self.basicPassword : [NSNull null])
                   forKey:@"basicPassword"];
    [dictionary setObject:(self.jsonNumber ? self.jsonNumber : [NSNull null])
                   forKey:@"jsonNumber"];
    [dictionary setObject:(self.jsonString ? self.jsonString : [NSNull null])
                   forKey:@"jsonString"];
    [dictionary setObject:(self.jsonArray ? self.jsonArray : [NSNull null])
                   forKey:@"jsonArray"];
    [dictionary setObject:(self.jsonDictionary ? self.jsonDictionary : [NSNull null])
                   forKey:@"jsonDictionary"];
    [dictionary setObject:(self.stringTestJson ? self.stringTestJson : [NSNull null])
                   forKey:@"stringTestJson"];
    [dictionary setObject:(self.stringTestEmpty ? self.stringTestEmpty : [NSNull null])
                   forKey:@"stringTestEmpty"];
    [dictionary setObject:(self.stringTestNull ? self.stringTestNull : [NSNull null])
                   forKey:@"stringTestNull"];
    [dictionary setObject:(self.stringTestInvalid ? self.stringTestInvalid : [NSNull null])
                   forKey:@"stringTestInvalid"];
    [dictionary setObject:(self.stringTestNSNull ? self.stringTestNSNull : [NSNull null])
                   forKey:@"stringTestNSNull"];
    [dictionary setObject:(self.stringTestAlphanumeric ? self.stringTestAlphanumeric : [NSNull null])
                   forKey:@"stringTestAlphanumeric"];
    [dictionary setObject:(self.stringTestUnicodeLetters ? self.stringTestUnicodeLetters : [NSNull null])
                   forKey:@"stringTestUnicodeLetters"];
    [dictionary setObject:(self.stringTestUnicodePrintable ? self.stringTestUnicodePrintable : [NSNull null])
                   forKey:@"stringTestUnicodePrintable"];
    [dictionary setObject:(self.stringTestEmailAddress ? self.stringTestEmailAddress : [NSNull null])
                   forKey:@"stringTestEmailAddress"];
    [dictionary setObject:(self.stringTestLength ? self.stringTestLength : [NSNull null])
                   forKey:@"stringTestLength"];
    [dictionary setObject:(self.stringTestCaseSensitive ? self.stringTestCaseSensitive : [NSNull null])
                   forKey:@"stringTestCaseSensitive"];
    [dictionary setObject:(self.stringTestFeatures ? self.stringTestFeatures : [NSNull null])
                   forKey:@"stringTestFeatures"];
    [dictionary setObject:(self.basicPlural ? [self.basicPlural arrayOfBasicPluralDictionariesFromBasicPluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"basicPlural"];
    [dictionary setObject:(self.basicObject ? [self.basicObject toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"basicObject"];
    [dictionary setObject:(self.objectTestRequired ? [self.objectTestRequired toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"objectTestRequired"];
    [dictionary setObject:(self.pluralTestUnique ? [self.pluralTestUnique arrayOfPluralTestUniqueDictionariesFromPluralTestUniqueElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pluralTestUnique"];
    [dictionary setObject:(self.objectTestRequiredUnique ? [self.objectTestRequiredUnique toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"objectTestRequiredUnique"];
    [dictionary setObject:(self.pluralTestAlphabetic ? [self.pluralTestAlphabetic arrayOfPluralTestAlphabeticDictionariesFromPluralTestAlphabeticElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pluralTestAlphabetic"];
    [dictionary setObject:(self.simpleStringPluralOne ? self.simpleStringPluralOne : [NSNull null])
                   forKey:@"simpleStringPluralOne"];
    [dictionary setObject:(self.simpleStringPluralTwo ? self.simpleStringPluralTwo : [NSNull null])
                   forKey:@"simpleStringPluralTwo"];
    [dictionary setObject:(self.pinapL1Plural ? [self.pinapL1Plural arrayOfPinapL1PluralDictionariesFromPinapL1PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinapL1Plural"];
    [dictionary setObject:(self.pinoL1Object ? [self.pinoL1Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinoL1Object"];
    [dictionary setObject:(self.onipL1Plural ? [self.onipL1Plural arrayOfOnipL1PluralDictionariesFromOnipL1PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipL1Plural"];
    [dictionary setObject:(self.oinoL1Object ? [self.oinoL1Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"oinoL1Object"];
    [dictionary setObject:(self.pinapinapL1Plural ? [self.pinapinapL1Plural arrayOfPinapinapL1PluralDictionariesFromPinapinapL1PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinapinapL1Plural"];
    [dictionary setObject:(self.pinonipL1Plural ? [self.pinonipL1Plural arrayOfPinonipL1PluralDictionariesFromPinonipL1PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinonipL1Plural"];
    [dictionary setObject:(self.pinapinoL1Object ? [self.pinapinoL1Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinapinoL1Object"];
    [dictionary setObject:(self.pinoinoL1Object ? [self.pinoinoL1Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinoinoL1Object"];
    [dictionary setObject:(self.onipinapL1Plural ? [self.onipinapL1Plural arrayOfOnipinapL1PluralDictionariesFromOnipinapL1PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipinapL1Plural"];
    [dictionary setObject:(self.oinonipL1Plural ? [self.oinonipL1Plural arrayOfOinonipL1PluralDictionariesFromOinonipL1PluralElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"oinonipL1Plural"];
    [dictionary setObject:(self.onipinoL1Object ? [self.onipinoL1Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipinoL1Object"];
    [dictionary setObject:(self.oinoinoL1Object ? [self.oinoinoL1Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"oinoinoL1Object"];

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

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRCaptureUser *captureUser = [JRCaptureUser captureUser];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        captureUser.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    captureUser.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    captureUser.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    captureUser.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

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
        [(NSArray*)[dictionary objectForKey:@"basicPlural"] arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.basicObject =
        [dictionary objectForKey:@"basicObject"] != [NSNull null] ? 
        [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.objectTestRequired =
        [dictionary objectForKey:@"objectTestRequired"] != [NSNull null] ? 
        [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pluralTestUnique =
        [dictionary objectForKey:@"pluralTestUnique"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestUnique"] arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.objectTestRequiredUnique =
        [dictionary objectForKey:@"objectTestRequiredUnique"] != [NSNull null] ? 
        [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pluralTestAlphabetic =
        [dictionary objectForKey:@"pluralTestAlphabetic"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestAlphabetic"] arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.simpleStringPluralOne =
        [dictionary objectForKey:@"simpleStringPluralOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralOne"] arrayOfStringsFromStringPluralDictionariesWithType:@"simpleTypeOne"] : nil;

    captureUser.simpleStringPluralTwo =
        [dictionary objectForKey:@"simpleStringPluralTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralTwo"] arrayOfStringsFromStringPluralDictionariesWithType:@"simpleTypeTwo"] : nil;

    captureUser.pinapL1Plural =
        [dictionary objectForKey:@"pinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapL1Plural"] arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pinoL1Object =
        [dictionary objectForKey:@"pinoL1Object"] != [NSNull null] ? 
        [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.onipL1Plural =
        [dictionary objectForKey:@"onipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipL1Plural"] arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.oinoL1Object =
        [dictionary objectForKey:@"oinoL1Object"] != [NSNull null] ? 
        [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pinapinapL1Plural =
        [dictionary objectForKey:@"pinapinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL1Plural"] arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pinonipL1Plural =
        [dictionary objectForKey:@"pinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL1Plural"] arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pinapinoL1Object =
        [dictionary objectForKey:@"pinapinoL1Object"] != [NSNull null] ? 
        [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.pinoinoL1Object =
        [dictionary objectForKey:@"pinoinoL1Object"] != [NSNull null] ? 
        [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.onipinapL1Plural =
        [dictionary objectForKey:@"onipinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL1Plural"] arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.oinonipL1Plural =
        [dictionary objectForKey:@"oinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"oinonipL1Plural"] arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.onipinoL1Object =
        [dictionary objectForKey:@"onipinoL1Object"] != [NSNull null] ? 
        [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.oinoinoL1Object =
        [dictionary objectForKey:@"oinoinoL1Object"] != [NSNull null] ? 
        [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [captureUser.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [captureUser.dirtyPropertySet removeAllObjects];
    
    return captureUser;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)decodeFromDictionary:(NSDictionary*)dictionary
{
    NSSet *dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];

    self.captureObjectPath = @"";
    self.canBeUpdatedOrReplaced = YES;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

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
        [(NSArray*)[dictionary objectForKey:@"basicPlural"] arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.basicObject =
        [dictionary objectForKey:@"basicObject"] != [NSNull null] ? 
        [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.objectTestRequired =
        [dictionary objectForKey:@"objectTestRequired"] != [NSNull null] ? 
        [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pluralTestUnique =
        [dictionary objectForKey:@"pluralTestUnique"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestUnique"] arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.objectTestRequiredUnique =
        [dictionary objectForKey:@"objectTestRequiredUnique"] != [NSNull null] ? 
        [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pluralTestAlphabetic =
        [dictionary objectForKey:@"pluralTestAlphabetic"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestAlphabetic"] arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.simpleStringPluralOne =
        [dictionary objectForKey:@"simpleStringPluralOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralOne"] arrayOfStringsFromStringPluralDictionariesWithType:@"simpleTypeOne"] : nil;

    self.simpleStringPluralTwo =
        [dictionary objectForKey:@"simpleStringPluralTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralTwo"] arrayOfStringsFromStringPluralDictionariesWithType:@"simpleTypeTwo"] : nil;

    self.pinapL1Plural =
        [dictionary objectForKey:@"pinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapL1Plural"] arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pinoL1Object =
        [dictionary objectForKey:@"pinoL1Object"] != [NSNull null] ? 
        [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.onipL1Plural =
        [dictionary objectForKey:@"onipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipL1Plural"] arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.oinoL1Object =
        [dictionary objectForKey:@"oinoL1Object"] != [NSNull null] ? 
        [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pinapinapL1Plural =
        [dictionary objectForKey:@"pinapinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL1Plural"] arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pinonipL1Plural =
        [dictionary objectForKey:@"pinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL1Plural"] arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pinapinoL1Object =
        [dictionary objectForKey:@"pinapinoL1Object"] != [NSNull null] ? 
        [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.pinoinoL1Object =
        [dictionary objectForKey:@"pinoinoL1Object"] != [NSNull null] ? 
        [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.onipinapL1Plural =
        [dictionary objectForKey:@"onipinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL1Plural"] arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.oinonipL1Plural =
        [dictionary objectForKey:@"oinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"oinonipL1Plural"] arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.onipinoL1Object =
        [dictionary objectForKey:@"onipinoL1Object"] != [NSNull null] ? 
        [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.oinoinoL1Object =
        [dictionary objectForKey:@"oinoinoL1Object"] != [NSNull null] ? 
        [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"uuid"])
        self.uuid = [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
            [dictionary objectForKey:@"uuid"] : nil;

    if ([dictionary objectForKey:@"created"])
        self.created = [dictionary objectForKey:@"created"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    if ([dictionary objectForKey:@"lastUpdated"])
        self.lastUpdated = [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

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
        self.basicObject = [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"basicObject"])
        [self.basicObject updateFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"objectTestRequired"] == [NSNull null])
        self.objectTestRequired = nil;
    else if ([dictionary objectForKey:@"objectTestRequired"] && !self.objectTestRequired)
        self.objectTestRequired = [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"objectTestRequired"])
        [self.objectTestRequired updateFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"objectTestRequiredUnique"] == [NSNull null])
        self.objectTestRequiredUnique = nil;
    else if ([dictionary objectForKey:@"objectTestRequiredUnique"] && !self.objectTestRequiredUnique)
        self.objectTestRequiredUnique = [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"objectTestRequiredUnique"])
        [self.objectTestRequiredUnique updateFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"pinoL1Object"] == [NSNull null])
        self.pinoL1Object = nil;
    else if ([dictionary objectForKey:@"pinoL1Object"] && !self.pinoL1Object)
        self.pinoL1Object = [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"pinoL1Object"])
        [self.pinoL1Object updateFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"oinoL1Object"] == [NSNull null])
        self.oinoL1Object = nil;
    else if ([dictionary objectForKey:@"oinoL1Object"] && !self.oinoL1Object)
        self.oinoL1Object = [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"oinoL1Object"])
        [self.oinoL1Object updateFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"pinapinoL1Object"] == [NSNull null])
        self.pinapinoL1Object = nil;
    else if ([dictionary objectForKey:@"pinapinoL1Object"] && !self.pinapinoL1Object)
        self.pinapinoL1Object = [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"pinapinoL1Object"])
        [self.pinapinoL1Object updateFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"pinoinoL1Object"] == [NSNull null])
        self.pinoinoL1Object = nil;
    else if ([dictionary objectForKey:@"pinoinoL1Object"] && !self.pinoinoL1Object)
        self.pinoinoL1Object = [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"pinoinoL1Object"])
        [self.pinoinoL1Object updateFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"onipinoL1Object"] == [NSNull null])
        self.onipinoL1Object = nil;
    else if ([dictionary objectForKey:@"onipinoL1Object"] && !self.onipinoL1Object)
        self.onipinoL1Object = [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"onipinoL1Object"])
        [self.onipinoL1Object updateFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"oinoinoL1Object"] == [NSNull null])
        self.oinoinoL1Object = nil;
    else if ([dictionary objectForKey:@"oinoinoL1Object"] && !self.oinoinoL1Object)
        self.oinoinoL1Object = [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"oinoinoL1Object"])
        [self.oinoinoL1Object updateFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

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
        [(NSArray*)[dictionary objectForKey:@"basicPlural"] arrayOfBasicPluralElementsFromBasicPluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"basicObject"] || [dictionary objectForKey:@"basicObject"] == [NSNull null])
        self.basicObject = nil;
    else if (!self.basicObject)
        self.basicObject = [JRBasicObject basicObjectObjectFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.basicObject replaceFromDictionary:[dictionary objectForKey:@"basicObject"] withPath:self.captureObjectPath];

    if (![dictionary objectForKey:@"objectTestRequired"] || [dictionary objectForKey:@"objectTestRequired"] == [NSNull null])
        self.objectTestRequired = nil;
    else if (!self.objectTestRequired)
        self.objectTestRequired = [JRObjectTestRequired objectTestRequiredObjectFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.objectTestRequired replaceFromDictionary:[dictionary objectForKey:@"objectTestRequired"] withPath:self.captureObjectPath];

    self.pluralTestUnique =
        [dictionary objectForKey:@"pluralTestUnique"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestUnique"] arrayOfPluralTestUniqueElementsFromPluralTestUniqueDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"objectTestRequiredUnique"] || [dictionary objectForKey:@"objectTestRequiredUnique"] == [NSNull null])
        self.objectTestRequiredUnique = nil;
    else if (!self.objectTestRequiredUnique)
        self.objectTestRequiredUnique = [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.objectTestRequiredUnique replaceFromDictionary:[dictionary objectForKey:@"objectTestRequiredUnique"] withPath:self.captureObjectPath];

    self.pluralTestAlphabetic =
        [dictionary objectForKey:@"pluralTestAlphabetic"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralTestAlphabetic"] arrayOfPluralTestAlphabeticElementsFromPluralTestAlphabeticDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.simpleStringPluralOne =
        [dictionary objectForKey:@"simpleStringPluralOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralOne"] arrayOfStringsFromStringPluralDictionariesWithType:@"simpleTypeOne"] : nil;

    self.simpleStringPluralTwo =
        [dictionary objectForKey:@"simpleStringPluralTwo"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"simpleStringPluralTwo"] arrayOfStringsFromStringPluralDictionariesWithType:@"simpleTypeTwo"] : nil;

    self.pinapL1Plural =
        [dictionary objectForKey:@"pinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapL1Plural"] arrayOfPinapL1PluralElementsFromPinapL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"pinoL1Object"] || [dictionary objectForKey:@"pinoL1Object"] == [NSNull null])
        self.pinoL1Object = nil;
    else if (!self.pinoL1Object)
        self.pinoL1Object = [JRPinoL1Object pinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.pinoL1Object replaceFromDictionary:[dictionary objectForKey:@"pinoL1Object"] withPath:self.captureObjectPath];

    self.onipL1Plural =
        [dictionary objectForKey:@"onipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipL1Plural"] arrayOfOnipL1PluralElementsFromOnipL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"oinoL1Object"] || [dictionary objectForKey:@"oinoL1Object"] == [NSNull null])
        self.oinoL1Object = nil;
    else if (!self.oinoL1Object)
        self.oinoL1Object = [JROinoL1Object oinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.oinoL1Object replaceFromDictionary:[dictionary objectForKey:@"oinoL1Object"] withPath:self.captureObjectPath];

    self.pinapinapL1Plural =
        [dictionary objectForKey:@"pinapinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL1Plural"] arrayOfPinapinapL1PluralElementsFromPinapinapL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.pinonipL1Plural =
        [dictionary objectForKey:@"pinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinonipL1Plural"] arrayOfPinonipL1PluralElementsFromPinonipL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"pinapinoL1Object"] || [dictionary objectForKey:@"pinapinoL1Object"] == [NSNull null])
        self.pinapinoL1Object = nil;
    else if (!self.pinapinoL1Object)
        self.pinapinoL1Object = [JRPinapinoL1Object pinapinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.pinapinoL1Object replaceFromDictionary:[dictionary objectForKey:@"pinapinoL1Object"] withPath:self.captureObjectPath];

    if (![dictionary objectForKey:@"pinoinoL1Object"] || [dictionary objectForKey:@"pinoinoL1Object"] == [NSNull null])
        self.pinoinoL1Object = nil;
    else if (!self.pinoinoL1Object)
        self.pinoinoL1Object = [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.pinoinoL1Object replaceFromDictionary:[dictionary objectForKey:@"pinoinoL1Object"] withPath:self.captureObjectPath];

    self.onipinapL1Plural =
        [dictionary objectForKey:@"onipinapL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipinapL1Plural"] arrayOfOnipinapL1PluralElementsFromOnipinapL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.oinonipL1Plural =
        [dictionary objectForKey:@"oinonipL1Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"oinonipL1Plural"] arrayOfOinonipL1PluralElementsFromOinonipL1PluralDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"onipinoL1Object"] || [dictionary objectForKey:@"onipinoL1Object"] == [NSNull null])
        self.onipinoL1Object = nil;
    else if (!self.onipinoL1Object)
        self.onipinoL1Object = [JROnipinoL1Object onipinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.onipinoL1Object replaceFromDictionary:[dictionary objectForKey:@"onipinoL1Object"] withPath:self.captureObjectPath];

    if (![dictionary objectForKey:@"oinoinoL1Object"] || [dictionary objectForKey:@"oinoinoL1Object"] == [NSNull null])
        self.oinoinoL1Object = nil;
    else if (!self.oinoinoL1Object)
        self.oinoinoL1Object = [JROinoinoL1Object oinoinoL1ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.oinoinoL1Object replaceFromDictionary:[dictionary objectForKey:@"oinoinoL1Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"uuid", @"created", @"lastUpdated", @"email", @"basicBoolean", @"basicString", @"basicInteger", @"basicDecimal", @"basicDate", @"basicDateTime", @"basicIpAddress", @"basicPassword", @"jsonNumber", @"jsonString", @"jsonArray", @"jsonDictionary", @"stringTestJson", @"stringTestEmpty", @"stringTestNull", @"stringTestInvalid", @"stringTestNSNull", @"stringTestAlphanumeric", @"stringTestUnicodeLetters", @"stringTestUnicodePrintable", @"stringTestEmailAddress", @"stringTestLength", @"stringTestCaseSensitive", @"stringTestFeatures", @"basicObject", @"objectTestRequired", @"objectTestRequiredUnique", @"pinoL1Object", @"oinoL1Object", @"pinapinoL1Object", @"pinoinoL1Object", @"onipinoL1Object", @"oinoinoL1Object", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet setByAddingObjectsFromSet:[self updatablePropertySet]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"captureUser"];

    if (self.basicObject)
        [snapshotDictionary setObject:[self.basicObject snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"basicObject"];

    if (self.objectTestRequired)
        [snapshotDictionary setObject:[self.objectTestRequired snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"objectTestRequired"];

    if (self.objectTestRequiredUnique)
        [snapshotDictionary setObject:[self.objectTestRequiredUnique snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"objectTestRequiredUnique"];

    if (self.pinoL1Object)
        [snapshotDictionary setObject:[self.pinoL1Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"pinoL1Object"];

    if (self.oinoL1Object)
        [snapshotDictionary setObject:[self.oinoL1Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"oinoL1Object"];

    if (self.pinapinoL1Object)
        [snapshotDictionary setObject:[self.pinapinoL1Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"pinapinoL1Object"];

    if (self.pinoinoL1Object)
        [snapshotDictionary setObject:[self.pinoinoL1Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"pinoinoL1Object"];

    if (self.onipinoL1Object)
        [snapshotDictionary setObject:[self.onipinoL1Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"onipinoL1Object"];

    if (self.oinoinoL1Object)
        [snapshotDictionary setObject:[self.oinoinoL1Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"oinoinoL1Object"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"captureUser"])
        [self.dirtyPropertySet setByAddingObjectsFromSet:[snapshotDictionary objectForKey:@"captureUser"]];

    if ([snapshotDictionary objectForKey:@"basicObject"])
        [self.basicObject restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"basicObject"]];

    if ([snapshotDictionary objectForKey:@"objectTestRequired"])
        [self.objectTestRequired restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"objectTestRequired"]];

    if ([snapshotDictionary objectForKey:@"objectTestRequiredUnique"])
        [self.objectTestRequiredUnique restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"objectTestRequiredUnique"]];

    if ([snapshotDictionary objectForKey:@"pinoL1Object"])
        [self.pinoL1Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"pinoL1Object"]];

    if ([snapshotDictionary objectForKey:@"oinoL1Object"])
        [self.oinoL1Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"oinoL1Object"]];

    if ([snapshotDictionary objectForKey:@"pinapinoL1Object"])
        [self.pinapinoL1Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"pinapinoL1Object"]];

    if ([snapshotDictionary objectForKey:@"pinoinoL1Object"])
        [self.pinoinoL1Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"pinoinoL1Object"]];

    if ([snapshotDictionary objectForKey:@"onipinoL1Object"])
        [self.onipinoL1Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"onipinoL1Object"]];

    if ([snapshotDictionary objectForKey:@"oinoinoL1Object"])
        [self.oinoinoL1Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"oinoinoL1Object"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"email"])
        [dictionary setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];

    if ([self.dirtyPropertySet containsObject:@"basicBoolean"])
        [dictionary setObject:(self.basicBoolean ? [NSNumber numberWithBool:[self.basicBoolean boolValue]] : [NSNull null]) forKey:@"basicBoolean"];

    if ([self.dirtyPropertySet containsObject:@"basicString"])
        [dictionary setObject:(self.basicString ? self.basicString : [NSNull null]) forKey:@"basicString"];

    if ([self.dirtyPropertySet containsObject:@"basicInteger"])
        [dictionary setObject:(self.basicInteger ? [NSNumber numberWithInteger:[self.basicInteger integerValue]] : [NSNull null]) forKey:@"basicInteger"];

    if ([self.dirtyPropertySet containsObject:@"basicDecimal"])
        [dictionary setObject:(self.basicDecimal ? self.basicDecimal : [NSNull null]) forKey:@"basicDecimal"];

    if ([self.dirtyPropertySet containsObject:@"basicDate"])
        [dictionary setObject:(self.basicDate ? [self.basicDate stringFromISO8601Date] : [NSNull null]) forKey:@"basicDate"];

    if ([self.dirtyPropertySet containsObject:@"basicDateTime"])
        [dictionary setObject:(self.basicDateTime ? [self.basicDateTime stringFromISO8601DateTime] : [NSNull null]) forKey:@"basicDateTime"];

    if ([self.dirtyPropertySet containsObject:@"basicIpAddress"])
        [dictionary setObject:(self.basicIpAddress ? self.basicIpAddress : [NSNull null]) forKey:@"basicIpAddress"];

    if ([self.dirtyPropertySet containsObject:@"basicPassword"])
        [dictionary setObject:(self.basicPassword ? self.basicPassword : [NSNull null]) forKey:@"basicPassword"];

    if ([self.dirtyPropertySet containsObject:@"jsonNumber"])
        [dictionary setObject:(self.jsonNumber ? self.jsonNumber : [NSNull null]) forKey:@"jsonNumber"];

    if ([self.dirtyPropertySet containsObject:@"jsonString"])
        [dictionary setObject:(self.jsonString ? self.jsonString : [NSNull null]) forKey:@"jsonString"];

    if ([self.dirtyPropertySet containsObject:@"jsonArray"])
        [dictionary setObject:(self.jsonArray ? self.jsonArray : [NSNull null]) forKey:@"jsonArray"];

    if ([self.dirtyPropertySet containsObject:@"jsonDictionary"])
        [dictionary setObject:(self.jsonDictionary ? self.jsonDictionary : [NSNull null]) forKey:@"jsonDictionary"];

    if ([self.dirtyPropertySet containsObject:@"stringTestJson"])
        [dictionary setObject:(self.stringTestJson ? self.stringTestJson : [NSNull null]) forKey:@"stringTestJson"];

    if ([self.dirtyPropertySet containsObject:@"stringTestEmpty"])
        [dictionary setObject:(self.stringTestEmpty ? self.stringTestEmpty : [NSNull null]) forKey:@"stringTestEmpty"];

    if ([self.dirtyPropertySet containsObject:@"stringTestNull"])
        [dictionary setObject:(self.stringTestNull ? self.stringTestNull : [NSNull null]) forKey:@"stringTestNull"];

    if ([self.dirtyPropertySet containsObject:@"stringTestInvalid"])
        [dictionary setObject:(self.stringTestInvalid ? self.stringTestInvalid : [NSNull null]) forKey:@"stringTestInvalid"];

    if ([self.dirtyPropertySet containsObject:@"stringTestNSNull"])
        [dictionary setObject:(self.stringTestNSNull ? self.stringTestNSNull : [NSNull null]) forKey:@"stringTestNSNull"];

    if ([self.dirtyPropertySet containsObject:@"stringTestAlphanumeric"])
        [dictionary setObject:(self.stringTestAlphanumeric ? self.stringTestAlphanumeric : [NSNull null]) forKey:@"stringTestAlphanumeric"];

    if ([self.dirtyPropertySet containsObject:@"stringTestUnicodeLetters"])
        [dictionary setObject:(self.stringTestUnicodeLetters ? self.stringTestUnicodeLetters : [NSNull null]) forKey:@"stringTestUnicodeLetters"];

    if ([self.dirtyPropertySet containsObject:@"stringTestUnicodePrintable"])
        [dictionary setObject:(self.stringTestUnicodePrintable ? self.stringTestUnicodePrintable : [NSNull null]) forKey:@"stringTestUnicodePrintable"];

    if ([self.dirtyPropertySet containsObject:@"stringTestEmailAddress"])
        [dictionary setObject:(self.stringTestEmailAddress ? self.stringTestEmailAddress : [NSNull null]) forKey:@"stringTestEmailAddress"];

    if ([self.dirtyPropertySet containsObject:@"stringTestLength"])
        [dictionary setObject:(self.stringTestLength ? self.stringTestLength : [NSNull null]) forKey:@"stringTestLength"];

    if ([self.dirtyPropertySet containsObject:@"stringTestCaseSensitive"])
        [dictionary setObject:(self.stringTestCaseSensitive ? self.stringTestCaseSensitive : [NSNull null]) forKey:@"stringTestCaseSensitive"];

    if ([self.dirtyPropertySet containsObject:@"stringTestFeatures"])
        [dictionary setObject:(self.stringTestFeatures ? self.stringTestFeatures : [NSNull null]) forKey:@"stringTestFeatures"];

    if ([self.dirtyPropertySet containsObject:@"basicObject"])
        [dictionary setObject:(self.basicObject ?
                              [self.basicObject toUpdateDictionary] :
                              [[JRBasicObject basicObject] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"basicObject"];
    else if ([self.basicObject needsUpdate])
        [dictionary setObject:[self.basicObject toUpdateDictionary]
                       forKey:@"basicObject"];

    if ([self.dirtyPropertySet containsObject:@"objectTestRequired"])
        [dictionary setObject:(self.objectTestRequired ?
                              [self.objectTestRequired toUpdateDictionary] :
                              [[JRObjectTestRequired objectTestRequired] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"objectTestRequired"];
    else if ([self.objectTestRequired needsUpdate])
        [dictionary setObject:[self.objectTestRequired toUpdateDictionary]
                       forKey:@"objectTestRequired"];

    if ([self.dirtyPropertySet containsObject:@"objectTestRequiredUnique"])
        [dictionary setObject:(self.objectTestRequiredUnique ?
                              [self.objectTestRequiredUnique toUpdateDictionary] :
                              [[JRObjectTestRequiredUnique objectTestRequiredUnique] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"objectTestRequiredUnique"];
    else if ([self.objectTestRequiredUnique needsUpdate])
        [dictionary setObject:[self.objectTestRequiredUnique toUpdateDictionary]
                       forKey:@"objectTestRequiredUnique"];

    if ([self.dirtyPropertySet containsObject:@"pinoL1Object"])
        [dictionary setObject:(self.pinoL1Object ?
                              [self.pinoL1Object toUpdateDictionary] :
                              [[JRPinoL1Object pinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"pinoL1Object"];
    else if ([self.pinoL1Object needsUpdate])
        [dictionary setObject:[self.pinoL1Object toUpdateDictionary]
                       forKey:@"pinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"oinoL1Object"])
        [dictionary setObject:(self.oinoL1Object ?
                              [self.oinoL1Object toUpdateDictionary] :
                              [[JROinoL1Object oinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"oinoL1Object"];
    else if ([self.oinoL1Object needsUpdate])
        [dictionary setObject:[self.oinoL1Object toUpdateDictionary]
                       forKey:@"oinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"pinapinoL1Object"])
        [dictionary setObject:(self.pinapinoL1Object ?
                              [self.pinapinoL1Object toUpdateDictionary] :
                              [[JRPinapinoL1Object pinapinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"pinapinoL1Object"];
    else if ([self.pinapinoL1Object needsUpdate])
        [dictionary setObject:[self.pinapinoL1Object toUpdateDictionary]
                       forKey:@"pinapinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"pinoinoL1Object"])
        [dictionary setObject:(self.pinoinoL1Object ?
                              [self.pinoinoL1Object toUpdateDictionary] :
                              [[JRPinoinoL1Object pinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"pinoinoL1Object"];
    else if ([self.pinoinoL1Object needsUpdate])
        [dictionary setObject:[self.pinoinoL1Object toUpdateDictionary]
                       forKey:@"pinoinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"onipinoL1Object"])
        [dictionary setObject:(self.onipinoL1Object ?
                              [self.onipinoL1Object toUpdateDictionary] :
                              [[JROnipinoL1Object onipinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"onipinoL1Object"];
    else if ([self.onipinoL1Object needsUpdate])
        [dictionary setObject:[self.onipinoL1Object toUpdateDictionary]
                       forKey:@"onipinoL1Object"];

    if ([self.dirtyPropertySet containsObject:@"oinoinoL1Object"])
        [dictionary setObject:(self.oinoinoL1Object ?
                              [self.oinoinoL1Object toUpdateDictionary] :
                              [[JROinoinoL1Object oinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"oinoinoL1Object"];
    else if ([self.oinoinoL1Object needsUpdate])
        [dictionary setObject:[self.oinoinoL1Object toUpdateDictionary]
                       forKey:@"oinoinoL1Object"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];
    [dictionary setObject:(self.basicBoolean ? [NSNumber numberWithBool:[self.basicBoolean boolValue]] : [NSNull null]) forKey:@"basicBoolean"];
    [dictionary setObject:(self.basicString ? self.basicString : [NSNull null]) forKey:@"basicString"];
    [dictionary setObject:(self.basicInteger ? [NSNumber numberWithInteger:[self.basicInteger integerValue]] : [NSNull null]) forKey:@"basicInteger"];
    [dictionary setObject:(self.basicDecimal ? self.basicDecimal : [NSNull null]) forKey:@"basicDecimal"];
    [dictionary setObject:(self.basicDate ? [self.basicDate stringFromISO8601Date] : [NSNull null]) forKey:@"basicDate"];
    [dictionary setObject:(self.basicDateTime ? [self.basicDateTime stringFromISO8601DateTime] : [NSNull null]) forKey:@"basicDateTime"];
    [dictionary setObject:(self.basicIpAddress ? self.basicIpAddress : [NSNull null]) forKey:@"basicIpAddress"];
    [dictionary setObject:(self.basicPassword ? self.basicPassword : [NSNull null]) forKey:@"basicPassword"];
    [dictionary setObject:(self.jsonNumber ? self.jsonNumber : [NSNull null]) forKey:@"jsonNumber"];
    [dictionary setObject:(self.jsonString ? self.jsonString : [NSNull null]) forKey:@"jsonString"];
    [dictionary setObject:(self.jsonArray ? self.jsonArray : [NSNull null]) forKey:@"jsonArray"];
    [dictionary setObject:(self.jsonDictionary ? self.jsonDictionary : [NSNull null]) forKey:@"jsonDictionary"];
    [dictionary setObject:(self.stringTestJson ? self.stringTestJson : [NSNull null]) forKey:@"stringTestJson"];
    [dictionary setObject:(self.stringTestEmpty ? self.stringTestEmpty : [NSNull null]) forKey:@"stringTestEmpty"];
    [dictionary setObject:(self.stringTestNull ? self.stringTestNull : [NSNull null]) forKey:@"stringTestNull"];
    [dictionary setObject:(self.stringTestInvalid ? self.stringTestInvalid : [NSNull null]) forKey:@"stringTestInvalid"];
    [dictionary setObject:(self.stringTestNSNull ? self.stringTestNSNull : [NSNull null]) forKey:@"stringTestNSNull"];
    [dictionary setObject:(self.stringTestAlphanumeric ? self.stringTestAlphanumeric : [NSNull null]) forKey:@"stringTestAlphanumeric"];
    [dictionary setObject:(self.stringTestUnicodeLetters ? self.stringTestUnicodeLetters : [NSNull null]) forKey:@"stringTestUnicodeLetters"];
    [dictionary setObject:(self.stringTestUnicodePrintable ? self.stringTestUnicodePrintable : [NSNull null]) forKey:@"stringTestUnicodePrintable"];
    [dictionary setObject:(self.stringTestEmailAddress ? self.stringTestEmailAddress : [NSNull null]) forKey:@"stringTestEmailAddress"];
    [dictionary setObject:(self.stringTestLength ? self.stringTestLength : [NSNull null]) forKey:@"stringTestLength"];
    [dictionary setObject:(self.stringTestCaseSensitive ? self.stringTestCaseSensitive : [NSNull null]) forKey:@"stringTestCaseSensitive"];
    [dictionary setObject:(self.stringTestFeatures ? self.stringTestFeatures : [NSNull null]) forKey:@"stringTestFeatures"];

    [dictionary setObject:(self.basicPlural ?
                          [self.basicPlural arrayOfBasicPluralReplaceDictionariesFromBasicPluralElements] :
                          [NSArray array])
                   forKey:@"basicPlural"];

    [dictionary setObject:(self.basicObject ?
                          [self.basicObject toReplaceDictionary] :
                          [[JRBasicObject basicObject] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"basicObject"];

    [dictionary setObject:(self.objectTestRequired ?
                          [self.objectTestRequired toReplaceDictionary] :
                          [[JRObjectTestRequired objectTestRequired] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"objectTestRequired"];

    [dictionary setObject:(self.pluralTestUnique ?
                          [self.pluralTestUnique arrayOfPluralTestUniqueReplaceDictionariesFromPluralTestUniqueElements] :
                          [NSArray array])
                   forKey:@"pluralTestUnique"];

    [dictionary setObject:(self.objectTestRequiredUnique ?
                          [self.objectTestRequiredUnique toReplaceDictionary] :
                          [[JRObjectTestRequiredUnique objectTestRequiredUnique] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"objectTestRequiredUnique"];

    [dictionary setObject:(self.pluralTestAlphabetic ?
                          [self.pluralTestAlphabetic arrayOfPluralTestAlphabeticReplaceDictionariesFromPluralTestAlphabeticElements] :
                          [NSArray array])
                   forKey:@"pluralTestAlphabetic"];

    [dictionary setObject:(self.simpleStringPluralOne ?
                          self.simpleStringPluralOne :
                          [NSArray array])
                   forKey:@"simpleStringPluralOne"];

    [dictionary setObject:(self.simpleStringPluralTwo ?
                          self.simpleStringPluralTwo :
                          [NSArray array])
                   forKey:@"simpleStringPluralTwo"];

    [dictionary setObject:(self.pinapL1Plural ?
                          [self.pinapL1Plural arrayOfPinapL1PluralReplaceDictionariesFromPinapL1PluralElements] :
                          [NSArray array])
                   forKey:@"pinapL1Plural"];

    [dictionary setObject:(self.pinoL1Object ?
                          [self.pinoL1Object toReplaceDictionary] :
                          [[JRPinoL1Object pinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"pinoL1Object"];

    [dictionary setObject:(self.onipL1Plural ?
                          [self.onipL1Plural arrayOfOnipL1PluralReplaceDictionariesFromOnipL1PluralElements] :
                          [NSArray array])
                   forKey:@"onipL1Plural"];

    [dictionary setObject:(self.oinoL1Object ?
                          [self.oinoL1Object toReplaceDictionary] :
                          [[JROinoL1Object oinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"oinoL1Object"];

    [dictionary setObject:(self.pinapinapL1Plural ?
                          [self.pinapinapL1Plural arrayOfPinapinapL1PluralReplaceDictionariesFromPinapinapL1PluralElements] :
                          [NSArray array])
                   forKey:@"pinapinapL1Plural"];

    [dictionary setObject:(self.pinonipL1Plural ?
                          [self.pinonipL1Plural arrayOfPinonipL1PluralReplaceDictionariesFromPinonipL1PluralElements] :
                          [NSArray array])
                   forKey:@"pinonipL1Plural"];

    [dictionary setObject:(self.pinapinoL1Object ?
                          [self.pinapinoL1Object toReplaceDictionary] :
                          [[JRPinapinoL1Object pinapinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"pinapinoL1Object"];

    [dictionary setObject:(self.pinoinoL1Object ?
                          [self.pinoinoL1Object toReplaceDictionary] :
                          [[JRPinoinoL1Object pinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"pinoinoL1Object"];

    [dictionary setObject:(self.onipinapL1Plural ?
                          [self.onipinapL1Plural arrayOfOnipinapL1PluralReplaceDictionariesFromOnipinapL1PluralElements] :
                          [NSArray array])
                   forKey:@"onipinapL1Plural"];

    [dictionary setObject:(self.oinonipL1Plural ?
                          [self.oinonipL1Plural arrayOfOinonipL1PluralReplaceDictionariesFromOinonipL1PluralElements] :
                          [NSArray array])
                   forKey:@"oinonipL1Plural"];

    [dictionary setObject:(self.onipinoL1Object ?
                          [self.onipinoL1Object toReplaceDictionary] :
                          [[JROnipinoL1Object onipinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"onipinoL1Object"];

    [dictionary setObject:(self.oinoinoL1Object ?
                          [self.oinoinoL1Object toReplaceDictionary] :
                          [[JROinoinoL1Object oinoinoL1Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"oinoinoL1Object"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replaceBasicPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.basicPlural named:@"basicPlural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePluralTestUniqueArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralTestUnique named:@"pluralTestUnique" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePluralTestAlphabeticArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralTestAlphabetic named:@"pluralTestAlphabetic" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceSimpleStringPluralOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.simpleStringPluralOne named:@"simpleStringPluralOne" isArrayOfStrings:YES
                       withType:@"simpleTypeOne" forDelegate:delegate withContext:context];
}

- (void)replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.simpleStringPluralTwo named:@"simpleStringPluralTwo" isArrayOfStrings:YES
                       withType:@"simpleTypeTwo" forDelegate:delegate withContext:context];
}

- (void)replacePinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapL1Plural named:@"pinapL1Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceOnipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.onipL1Plural named:@"onipL1Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePinapinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapinapL1Plural named:@"pinapinapL1Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinonipL1Plural named:@"pinonipL1Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceOnipinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.onipinapL1Plural named:@"onipinapL1Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceOinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.oinonipL1Plural named:@"oinonipL1Plural" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.basicObject needsUpdate])
        return YES;

    if ([self.objectTestRequired needsUpdate])
        return YES;

    if ([self.objectTestRequiredUnique needsUpdate])
        return YES;

    if ([self.pinoL1Object needsUpdate])
        return YES;

    if ([self.oinoL1Object needsUpdate])
        return YES;

    if ([self.pinapinoL1Object needsUpdate])
        return YES;

    if ([self.pinoinoL1Object needsUpdate])
        return YES;

    if ([self.onipinoL1Object needsUpdate])
        return YES;

    if ([self.oinoinoL1Object needsUpdate])
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
    else if (![self.basicPlural isEqualToBasicPluralArray:otherCaptureUser.basicPlural]) return NO;

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
    else if (![self.pluralTestUnique isEqualToPluralTestUniqueArray:otherCaptureUser.pluralTestUnique]) return NO;

    if (!self.objectTestRequiredUnique && !otherCaptureUser.objectTestRequiredUnique) /* Keep going... */;
    else if (!self.objectTestRequiredUnique && [otherCaptureUser.objectTestRequiredUnique isEqualToObjectTestRequiredUnique:[JRObjectTestRequiredUnique objectTestRequiredUnique]]) /* Keep going... */;
    else if (!otherCaptureUser.objectTestRequiredUnique && [self.objectTestRequiredUnique isEqualToObjectTestRequiredUnique:[JRObjectTestRequiredUnique objectTestRequiredUnique]]) /* Keep going... */;
    else if (![self.objectTestRequiredUnique isEqualToObjectTestRequiredUnique:otherCaptureUser.objectTestRequiredUnique]) return NO;

    if (!self.pluralTestAlphabetic && !otherCaptureUser.pluralTestAlphabetic) /* Keep going... */;
    else if (!self.pluralTestAlphabetic && ![otherCaptureUser.pluralTestAlphabetic count]) /* Keep going... */;
    else if (!otherCaptureUser.pluralTestAlphabetic && ![self.pluralTestAlphabetic count]) /* Keep going... */;
    else if (![self.pluralTestAlphabetic isEqualToPluralTestAlphabeticArray:otherCaptureUser.pluralTestAlphabetic]) return NO;

    if (!self.simpleStringPluralOne && !otherCaptureUser.simpleStringPluralOne) /* Keep going... */;
    else if (!self.simpleStringPluralOne && ![otherCaptureUser.simpleStringPluralOne count]) /* Keep going... */;
    else if (!otherCaptureUser.simpleStringPluralOne && ![self.simpleStringPluralOne count]) /* Keep going... */;
    else if (![self.simpleStringPluralOne isEqualToArray:otherCaptureUser.simpleStringPluralOne]) return NO;

    if (!self.simpleStringPluralTwo && !otherCaptureUser.simpleStringPluralTwo) /* Keep going... */;
    else if (!self.simpleStringPluralTwo && ![otherCaptureUser.simpleStringPluralTwo count]) /* Keep going... */;
    else if (!otherCaptureUser.simpleStringPluralTwo && ![self.simpleStringPluralTwo count]) /* Keep going... */;
    else if (![self.simpleStringPluralTwo isEqualToArray:otherCaptureUser.simpleStringPluralTwo]) return NO;

    if (!self.pinapL1Plural && !otherCaptureUser.pinapL1Plural) /* Keep going... */;
    else if (!self.pinapL1Plural && ![otherCaptureUser.pinapL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.pinapL1Plural && ![self.pinapL1Plural count]) /* Keep going... */;
    else if (![self.pinapL1Plural isEqualToPinapL1PluralArray:otherCaptureUser.pinapL1Plural]) return NO;

    if (!self.pinoL1Object && !otherCaptureUser.pinoL1Object) /* Keep going... */;
    else if (!self.pinoL1Object && [otherCaptureUser.pinoL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.pinoL1Object && [self.pinoL1Object isEqualToPinoL1Object:[JRPinoL1Object pinoL1Object]]) /* Keep going... */;
    else if (![self.pinoL1Object isEqualToPinoL1Object:otherCaptureUser.pinoL1Object]) return NO;

    if (!self.onipL1Plural && !otherCaptureUser.onipL1Plural) /* Keep going... */;
    else if (!self.onipL1Plural && ![otherCaptureUser.onipL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.onipL1Plural && ![self.onipL1Plural count]) /* Keep going... */;
    else if (![self.onipL1Plural isEqualToOnipL1PluralArray:otherCaptureUser.onipL1Plural]) return NO;

    if (!self.oinoL1Object && !otherCaptureUser.oinoL1Object) /* Keep going... */;
    else if (!self.oinoL1Object && [otherCaptureUser.oinoL1Object isEqualToOinoL1Object:[JROinoL1Object oinoL1Object]]) /* Keep going... */;
    else if (!otherCaptureUser.oinoL1Object && [self.oinoL1Object isEqualToOinoL1Object:[JROinoL1Object oinoL1Object]]) /* Keep going... */;
    else if (![self.oinoL1Object isEqualToOinoL1Object:otherCaptureUser.oinoL1Object]) return NO;

    if (!self.pinapinapL1Plural && !otherCaptureUser.pinapinapL1Plural) /* Keep going... */;
    else if (!self.pinapinapL1Plural && ![otherCaptureUser.pinapinapL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.pinapinapL1Plural && ![self.pinapinapL1Plural count]) /* Keep going... */;
    else if (![self.pinapinapL1Plural isEqualToPinapinapL1PluralArray:otherCaptureUser.pinapinapL1Plural]) return NO;

    if (!self.pinonipL1Plural && !otherCaptureUser.pinonipL1Plural) /* Keep going... */;
    else if (!self.pinonipL1Plural && ![otherCaptureUser.pinonipL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.pinonipL1Plural && ![self.pinonipL1Plural count]) /* Keep going... */;
    else if (![self.pinonipL1Plural isEqualToPinonipL1PluralArray:otherCaptureUser.pinonipL1Plural]) return NO;

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
    else if (![self.onipinapL1Plural isEqualToOnipinapL1PluralArray:otherCaptureUser.onipinapL1Plural]) return NO;

    if (!self.oinonipL1Plural && !otherCaptureUser.oinonipL1Plural) /* Keep going... */;
    else if (!self.oinonipL1Plural && ![otherCaptureUser.oinonipL1Plural count]) /* Keep going... */;
    else if (!otherCaptureUser.oinonipL1Plural && ![self.oinonipL1Plural count]) /* Keep going... */;
    else if (![self.oinonipL1Plural isEqualToOinonipL1PluralArray:otherCaptureUser.oinonipL1Plural]) return NO;

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
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRUuid" forKey:@"uuid"];
    [dictionary setObject:@"JRDateTime" forKey:@"created"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastUpdated"];
    [dictionary setObject:@"NSString" forKey:@"email"];
    [dictionary setObject:@"JRBoolean" forKey:@"basicBoolean"];
    [dictionary setObject:@"NSString" forKey:@"basicString"];
    [dictionary setObject:@"JRInteger" forKey:@"basicInteger"];
    [dictionary setObject:@"NSNumber" forKey:@"basicDecimal"];
    [dictionary setObject:@"JRDate" forKey:@"basicDate"];
    [dictionary setObject:@"JRDateTime" forKey:@"basicDateTime"];
    [dictionary setObject:@"JRIpAddress" forKey:@"basicIpAddress"];
    [dictionary setObject:@"JRPassword" forKey:@"basicPassword"];
    [dictionary setObject:@"JRJsonObject" forKey:@"jsonNumber"];
    [dictionary setObject:@"JRJsonObject" forKey:@"jsonString"];
    [dictionary setObject:@"JRJsonObject" forKey:@"jsonArray"];
    [dictionary setObject:@"JRJsonObject" forKey:@"jsonDictionary"];
    [dictionary setObject:@"NSString" forKey:@"stringTestJson"];
    [dictionary setObject:@"NSString" forKey:@"stringTestEmpty"];
    [dictionary setObject:@"NSString" forKey:@"stringTestNull"];
    [dictionary setObject:@"NSString" forKey:@"stringTestInvalid"];
    [dictionary setObject:@"NSString" forKey:@"stringTestNSNull"];
    [dictionary setObject:@"NSString" forKey:@"stringTestAlphanumeric"];
    [dictionary setObject:@"NSString" forKey:@"stringTestUnicodeLetters"];
    [dictionary setObject:@"NSString" forKey:@"stringTestUnicodePrintable"];
    [dictionary setObject:@"NSString" forKey:@"stringTestEmailAddress"];
    [dictionary setObject:@"NSString" forKey:@"stringTestLength"];
    [dictionary setObject:@"NSString" forKey:@"stringTestCaseSensitive"];
    [dictionary setObject:@"NSString" forKey:@"stringTestFeatures"];
    [dictionary setObject:@"NSArray" forKey:@"basicPlural"];
    [dictionary setObject:@"JRBasicObject" forKey:@"basicObject"];
    [dictionary setObject:@"JRObjectTestRequired" forKey:@"objectTestRequired"];
    [dictionary setObject:@"NSArray" forKey:@"pluralTestUnique"];
    [dictionary setObject:@"JRObjectTestRequiredUnique" forKey:@"objectTestRequiredUnique"];
    [dictionary setObject:@"NSArray" forKey:@"pluralTestAlphabetic"];
    [dictionary setObject:@"JRStringArray" forKey:@"simpleStringPluralOne"];
    [dictionary setObject:@"JRStringArray" forKey:@"simpleStringPluralTwo"];
    [dictionary setObject:@"NSArray" forKey:@"pinapL1Plural"];
    [dictionary setObject:@"JRPinoL1Object" forKey:@"pinoL1Object"];
    [dictionary setObject:@"NSArray" forKey:@"onipL1Plural"];
    [dictionary setObject:@"JROinoL1Object" forKey:@"oinoL1Object"];
    [dictionary setObject:@"NSArray" forKey:@"pinapinapL1Plural"];
    [dictionary setObject:@"NSArray" forKey:@"pinonipL1Plural"];
    [dictionary setObject:@"JRPinapinoL1Object" forKey:@"pinapinoL1Object"];
    [dictionary setObject:@"JRPinoinoL1Object" forKey:@"pinoinoL1Object"];
    [dictionary setObject:@"NSArray" forKey:@"onipinapL1Plural"];
    [dictionary setObject:@"NSArray" forKey:@"oinonipL1Plural"];
    [dictionary setObject:@"JROnipinoL1Object" forKey:@"onipinoL1Object"];
    [dictionary setObject:@"JROinoinoL1Object" forKey:@"oinoinoL1Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_uuid release];
    [_created release];
    [_lastUpdated release];
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
