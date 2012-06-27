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
#import "JRPinoLevelTwo.h"

@interface JRPinoLevelThreeElement (PinoLevelThreeElementInternalMethods)
+ (id)pinoLevelThreeElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (BOOL)isEqualToPinoLevelThreeElement:(JRPinoLevelThreeElement *)otherPinoLevelThreeElement;
@end

@interface NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeElements;
- (NSArray*)arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeElements;
@end

@implementation NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinoLevelThreeArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinoLevelThreeArray addObject:[JRPinoLevelThreeElement pinoLevelThreeElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinoLevelThreeArray;
}

- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThreeElement class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThreeElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThreeElement class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThreeElement*)object toReplaceDictionaryIncludingArrays:YES]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PinoLevelTwo_ArrayComparison)
- (BOOL)isEqualToPinoLevelThreeArray:(NSArray *)otherArray;
@end

@implementation NSArray (PinoLevelTwo_ArrayComparison)

- (BOOL)isEqualToPinoLevelThreeArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPinoLevelThreeElement *)[self objectAtIndex:i]) isEqualToPinoLevelThreeElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRPinoLevelTwo ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoLevelTwo
{
    NSString *_level;
    NSString *_name;
    NSArray *_pinoLevelThree;
}
@synthesize canBeUpdatedOrReplaced;

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

- (NSArray *)pinoLevelThree
{
    return _pinoLevelThree;
}

- (void)setPinoLevelThree:(NSArray *)newPinoLevelThree
{
    [_pinoLevelThree autorelease];
    _pinoLevelThree = [newPinoLevelThree copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne/pinoLevelTwo";
        self.canBeUpdatedOrReplaced = YES;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"level", @"name", nil]];
    }
    return self;
}

+ (id)pinoLevelTwo
{
    return [[[JRPinoLevelTwo alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinoLevelTwo *pinoLevelTwoCopy = (JRPinoLevelTwo *)[super copyWithZone:zone];

    pinoLevelTwoCopy.level = self.level;
    pinoLevelTwoCopy.name = self.name;
    pinoLevelTwoCopy.pinoLevelThree = self.pinoLevelThree;

    return pinoLevelTwoCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.pinoLevelThree ? [self.pinoLevelThree arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeElements] : [NSNull null])
             forKey:@"pinoLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinoLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinoLevelTwo *pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwo];


    pinoLevelTwo.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pinoLevelTwo.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pinoLevelTwo.pinoLevelThree =
        [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:pinoLevelTwo.captureObjectPath] : nil;

    [pinoLevelTwo.dirtyPropertySet removeAllObjects];
    
    return pinoLevelTwo;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

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

    self.canBeUpdatedOrReplaced = YES;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.pinoLevelThree =
        [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeElementsFromPinoLevelThreeDictionariesWithPath:self.captureObjectPath] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    return dict;
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if (includingArrays)
        [dict setObject:(self.pinoLevelThree ?
                          [self.pinoLevelThree arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeElements] :
                          [NSArray array])
                 forKey:@"pinoLevelThree"];

    return dict;
}

- (void)replacePinoLevelThreeArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinoLevelThree named:@"pinoLevelThree" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinoLevelTwo:(JRPinoLevelTwo *)otherPinoLevelTwo
{
    if (!self.level && !otherPinoLevelTwo.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherPinoLevelTwo.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherPinoLevelTwo.level]) return NO;

    if (!self.name && !otherPinoLevelTwo.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherPinoLevelTwo.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherPinoLevelTwo.name]) return NO;

    if (!self.pinoLevelThree && !otherPinoLevelTwo.pinoLevelThree) /* Keep going... */;
    else if (!self.pinoLevelThree && ![otherPinoLevelTwo.pinoLevelThree count]) /* Keep going... */;
    else if (!otherPinoLevelTwo.pinoLevelThree && ![self.pinoLevelThree count]) /* Keep going... */;
    else if (![self.pinoLevelThree isEqualToPinoLevelThreeArray:otherPinoLevelTwo.pinoLevelThree]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"NSArray" forKey:@"pinoLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelThree release];

    [super dealloc];
}
@end
