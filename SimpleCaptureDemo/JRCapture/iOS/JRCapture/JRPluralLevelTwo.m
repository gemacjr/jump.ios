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


#import "JRPluralLevelTwo.h"

@interface NSArray (PluralLevelThreeToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects;
- (NSArray*)arrayOfPluralLevelThreeUpdateDictionariesFromPluralLevelThreeObjects;
- (NSArray*)arrayOfPluralLevelThreeReplaceDictionariesFromPluralLevelThreeObjects;
@end

@implementation NSArray (PluralLevelThreeToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPluralLevelThreeArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralLevelThreeArray addObject:[JRPluralLevelThree pluralLevelThreeObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPluralLevelThreeArray;
}

- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThree*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelThreeUpdateDictionariesFromPluralLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThree*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelThreeReplaceDictionariesFromPluralLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThree*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRPluralLevelTwo
{
    JRObjectId *_pluralLevelTwoId;
    NSString *_level;
    NSString *_name;
    JRArray *_pluralLevelThree;
}
@dynamic pluralLevelTwoId;
@dynamic level;
@dynamic name;
@dynamic pluralLevelThree;

- (JRObjectId *)pluralLevelTwoId
{
    return _pluralLevelTwoId;
}

- (void)setPluralLevelTwoId:(JRObjectId *)newPluralLevelTwoId
{
    [self.dirtyPropertySet addObject:@"pluralLevelTwoId"];
    _pluralLevelTwoId = [newPluralLevelTwoId copy];
}

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];
    _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];
    _name = [newName copy];
}

- (JRArray *)pluralLevelThree
{
    return _pluralLevelThree;
}

- (void)setPluralLevelThree:(JRArray *)newPluralLevelThree
{
    [self.dirtyPropertySet addObject:@"pluralLevelThree"];
    _pluralLevelThree = [newPluralLevelThree copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pluralLevelOne/pluralLevelTwo";
    }
    return self;
}

+ (id)pluralLevelTwo
{
    return [[[JRPluralLevelTwo alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPluralLevelTwo *pluralLevelTwoCopy =
                [[JRPluralLevelTwo allocWithZone:zone] init];

    pluralLevelTwoCopy.pluralLevelTwoId = self.pluralLevelTwoId;
    pluralLevelTwoCopy.level = self.level;
    pluralLevelTwoCopy.name = self.name;
    pluralLevelTwoCopy.pluralLevelThree = self.pluralLevelThree;

    [pluralLevelTwoCopy.dirtyPropertySet removeAllObjects];
    [pluralLevelTwoCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return pluralLevelTwoCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.pluralLevelTwoId ? [NSNumber numberWithInteger:[self.pluralLevelTwoId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.pluralLevelThree ? [self.pluralLevelThree arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects] : [NSNull null])
             forKey:@"pluralLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pluralLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPluralLevelTwo *pluralLevelTwo = [JRPluralLevelTwo pluralLevelTwo];
    pluralLevelTwo.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelTwo", [pluralLevelTwo.pluralLevelTwoId integerValue]];

    pluralLevelTwo.pluralLevelTwoId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    pluralLevelTwo.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pluralLevelTwo.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pluralLevelTwo.pluralLevelThree =
        [dictionary objectForKey:@"pluralLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionariesWithPath:pluralLevelTwo.captureObjectPath] : nil;

    [pluralLevelTwo.dirtyPropertySet removeAllObjects];
    
    return pluralLevelTwo;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelTwo", [self.pluralLevelTwoId integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.pluralLevelTwoId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"pluralLevelThree"])
        self.pluralLevelThree = [dictionary objectForKey:@"pluralLevelThree"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionariesWithPath:self.captureObjectPath] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralLevelTwo", [self.pluralLevelTwoId integerValue]];

    self.pluralLevelTwoId =
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
        [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionariesWithPath:self.captureObjectPath] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelThree"])
        [dict setObject:(self.pluralLevelThree ? [self.pluralLevelThree arrayOfPluralLevelThreeUpdateDictionariesFromPluralLevelThreeObjects] : [NSNull null]) forKey:@"pluralLevelThree"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:[self.pluralLevelTwoId integerValue]
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.pluralLevelThree ? [self.pluralLevelThree arrayOfPluralLevelThreeReplaceDictionariesFromPluralLevelThreeObjects] : [NSNull null]) forKey:@"pluralLevelThree"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:[self.pluralLevelTwoId integerValue]
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"pluralLevelTwoId"];
    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JRArray" forKey:@"pluralLevelThree"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_pluralLevelTwoId release];
    [_level release];
    [_name release];
    [_pluralLevelThree release];

    [super dealloc];
}
@end
