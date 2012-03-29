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


#import "JRPinoLevelTwo.h"

@interface NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries;
- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeObjects;
- (NSArray*)arrayOfPinoLevelThreeUpdateDictionariesFromPinoLevelThreeObjects;
- (NSArray*)arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeObjects;
@end

@implementation NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries
{
    NSMutableArray *filteredPinoLevelThreeArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinoLevelThreeArray addObject:[JRPinoLevelThree pinoLevelThreeObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredPinoLevelThreeArray;
}

- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThree*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoLevelThreeUpdateDictionariesFromPinoLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThree*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThree*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRPinoLevelTwo
{
    NSString *_level;
    NSString *_name;
    NSArray *_pinoLevelThree;
}
@dynamic level;
@dynamic name;
@dynamic pinoLevelThree;

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

- (NSArray *)pinoLevelThree
{
    return _pinoLevelThree;
}

- (void)setPinoLevelThree:(NSArray *)newPinoLevelThree
{
    [self.dirtyPropertySet addObject:@"pinoLevelThree"];
    _pinoLevelThree = [newPinoLevelThree copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne/pinoLevelTwo";
    }
    return self;
}

+ (id)pinoLevelTwo
{
    return [[[JRPinoLevelTwo alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPinoLevelTwo *pinoLevelTwoCopy =
                [[JRPinoLevelTwo allocWithZone:zone] init];

    pinoLevelTwoCopy.level = self.level;
    pinoLevelTwoCopy.name = self.name;
    pinoLevelTwoCopy.pinoLevelThree = self.pinoLevelThree;

    [pinoLevelTwoCopy.dirtyPropertySet removeAllObjects];
    [pinoLevelTwoCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

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
    [dict setObject:(self.pinoLevelThree ? [self.pinoLevelThree arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeObjects] : [NSNull null])
             forKey:@"pinoLevelThree"];

    return dict;
}

+ (id)pinoLevelTwoObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPinoLevelTwo *pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwo];

    pinoLevelTwo.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pinoLevelTwo.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pinoLevelTwo.pinoLevelThree =
        [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries] : nil;

    [pinoLevelTwo.dirtyPropertySet removeAllObjects];
    
    return pinoLevelTwo;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"level"])
        _level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"pinoLevelThree"])
        _pinoLevelThree = [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary
{
    _level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    _name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    _pinoLevelThree =
        [dictionary objectForKey:@"pinoLevelThree"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"pinoLevelThree"])
        [dict setObject:(self.pinoLevelThree ? [self.pinoLevelThree arrayOfPinoLevelThreeUpdateDictionariesFromPinoLevelThreeObjects] : [NSNull null]) forKey:@"pinoLevelThree"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:0
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
    [dict setObject:(self.pinoLevelThree ? [self.pinoLevelThree arrayOfPinoLevelThreeReplaceDictionariesFromPinoLevelThreeObjects] : [NSNull null]) forKey:@"pinoLevelThree"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:0
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelThree release];

    [super dealloc];
}
@end
