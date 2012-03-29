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


#import "JRPluralLevelTwo.h"

@interface NSArray (PluralLevelThreeToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects;
- (NSArray*)arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries;
@end

@implementation NSArray (PluralLevelThreeToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThree*)object dictionaryFromPluralLevelThreeObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPluralLevelThree pluralLevelThreeObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRPluralLevelTwo
{
    NSInteger _pluralLevelTwoId;
    NSString *_level;
    NSString *_name;
    NSArray *_pluralLevelThree;
}
@dynamic pluralLevelTwoId;
@dynamic level;
@dynamic name;
@dynamic pluralLevelThree;

- (NSInteger)pluralLevelTwoId
{
    return _pluralLevelTwoId;
}

- (void)setPluralLevelTwoId:(NSInteger)newPluralLevelTwoId
{
    [self.dirtyPropertySet addObject:@"pluralLevelTwoId"];

    _pluralLevelTwoId = newPluralLevelTwoId;
}

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    if (!newLevel)
        _level = [NSNull null];
    else
        _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    if (!newName)
        _name = [NSNull null];
    else
        _name = [newName copy];
}

- (NSArray *)pluralLevelThree
{
    return _pluralLevelThree;
}

- (void)setPluralLevelThree:(NSArray *)newPluralLevelThree
{
    [self.dirtyPropertySet addObject:@"pluralLevelThree"];

    if (!newPluralLevelThree)
        _pluralLevelThree = [NSNull null];
    else
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
{
    JRPluralLevelTwo *pluralLevelTwoCopy =
                [[JRPluralLevelTwo allocWithZone:zone] init];

    pluralLevelTwoCopy.pluralLevelTwoId = self.pluralLevelTwoId;
    pluralLevelTwoCopy.level = self.level;
    pluralLevelTwoCopy.name = self.name;
    pluralLevelTwoCopy.pluralLevelThree = self.pluralLevelThree;

    return pluralLevelTwoCopy;
}

+ (id)pluralLevelTwoObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPluralLevelTwo *pluralLevelTwo =
        [JRPluralLevelTwo pluralLevelTwo];

    pluralLevelTwo.pluralLevelTwoId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    pluralLevelTwo.level = [dictionary objectForKey:@"level"];
    pluralLevelTwo.name = [dictionary objectForKey:@"name"];
    pluralLevelTwo.pluralLevelThree = [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries];

    return pluralLevelTwo;
}

- (NSDictionary*)dictionaryFromPluralLevelTwoObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.pluralLevelTwoId)
        [dict setObject:[NSNumber numberWithInt:self.pluralLevelTwoId] forKey:@"id"];

    if (self.level && self.level != [NSNull null])
        [dict setObject:self.level forKey:@"level"];
    else
        [dict setObject:[NSNull null] forKey:@"level"];

    if (self.name && self.name != [NSNull null])
        [dict setObject:self.name forKey:@"name"];
    else
        [dict setObject:[NSNull null] forKey:@"name"];

    if (self.pluralLevelThree && self.pluralLevelThree != [NSNull null])
        [dict setObject:[self.pluralLevelThree arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects] forKey:@"pluralLevelThree"];
    else
        [dict setObject:[NSNull null] forKey:@"pluralLevelThree"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _pluralLevelTwoId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"level"])
        _level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"pluralLevelThree"])
        _pluralLevelThree = [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _pluralLevelTwoId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _level = [dictionary objectForKey:@"level"];
    _name = [dictionary objectForKey:@"name"];
    _pluralLevelThree = [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelTwoId"])
        [dict setObject:[NSNumber numberWithInt:self.pluralLevelTwoId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:self.level forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelThree"])
        [dict setObject:[self.pluralLevelThree arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects] forKey:@"pluralLevelThree"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:0
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.pluralLevelTwoId] forKey:@"id"];
    [dict setObject:self.level forKey:@"level"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[self.pluralLevelThree arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects] forKey:@"pluralLevelThree"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
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
    [_pluralLevelThree release];

    [super dealloc];
}
@end
