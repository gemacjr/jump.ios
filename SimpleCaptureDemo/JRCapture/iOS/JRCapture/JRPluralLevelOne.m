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


#import "JRPluralLevelOne.h"

@interface NSArray (PluralLevelTwoToFromDictionary)
- (NSArray*)arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoObjects;
- (NSArray*)arrayOfPluralLevelTwoObjectsFromPluralLevelTwoDictionaries;
@end

@implementation NSArray (PluralLevelTwoToFromDictionary)
- (NSArray*)arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelTwo class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelTwo*)object dictionaryFromPluralLevelTwoObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelTwoObjectsFromPluralLevelTwoDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPluralLevelTwo pluralLevelTwoObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRPluralLevelOne
{
    NSInteger _pluralLevelOneId;
    NSString *_level;
    NSString *_name;
    NSArray *_pluralLevelTwo;
}
@dynamic pluralLevelOneId;
@dynamic level;
@dynamic name;
@dynamic pluralLevelTwo;

- (NSInteger)pluralLevelOneId
{
    return _pluralLevelOneId;
}

- (void)setPluralLevelOneId:(NSInteger)newPluralLevelOneId
{
    [self.dirtyPropertySet addObject:@"pluralLevelOneId"];

    _pluralLevelOneId = newPluralLevelOneId;
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

- (NSArray *)pluralLevelTwo
{
    return _pluralLevelTwo;
}

- (void)setPluralLevelTwo:(NSArray *)newPluralLevelTwo
{
    [self.dirtyPropertySet addObject:@"pluralLevelTwo"];

    _pluralLevelTwo = [newPluralLevelTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pluralLevelOne";
    }
    return self;
}

+ (id)pluralLevelOne
{
    return [[[JRPluralLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPluralLevelOne *pluralLevelOneCopy =
                [[JRPluralLevelOne allocWithZone:zone] init];

    pluralLevelOneCopy.pluralLevelOneId = self.pluralLevelOneId;
    pluralLevelOneCopy.level = self.level;
    pluralLevelOneCopy.name = self.name;
    pluralLevelOneCopy.pluralLevelTwo = self.pluralLevelTwo;

    return pluralLevelOneCopy;
}

+ (id)pluralLevelOneObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPluralLevelOne *pluralLevelOne =
        [JRPluralLevelOne pluralLevelOne];

    pluralLevelOne.pluralLevelOneId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    pluralLevelOne.level = [dictionary objectForKey:@"level"];
    pluralLevelOne.name = [dictionary objectForKey:@"name"];
    pluralLevelOne.pluralLevelTwo = [(NSArray*)[dictionary objectForKey:@"pluralLevelTwo"] arrayOfPluralLevelTwoObjectsFromPluralLevelTwoDictionaries];

    return pluralLevelOne;
}

- (NSDictionary*)dictionaryFromPluralLevelOneObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.pluralLevelOneId)
        [dict setObject:[NSNumber numberWithInt:self.pluralLevelOneId] forKey:@"id"];

    if (self.level)
        [dict setObject:self.level forKey:@"level"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    if (self.pluralLevelTwo)
        [dict setObject:[self.pluralLevelTwo arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoObjects] forKey:@"pluralLevelTwo"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"pluralLevelTwo"])
        self.pluralLevelTwo = [(NSArray*)[dictionary objectForKey:@"pluralLevelTwo"] arrayOfPluralLevelTwoObjectsFromPluralLevelTwoDictionaries];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.pluralLevelOneId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.level = [dictionary objectForKey:@"level"];
    self.name = [dictionary objectForKey:@"name"];
    self.pluralLevelTwo = [(NSArray*)[dictionary objectForKey:@"pluralLevelTwo"] arrayOfPluralLevelTwoObjectsFromPluralLevelTwoDictionaries];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:self.level forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelTwo"])
        [dict setObject:[self.pluralLevelTwo arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoObjects] forKey:@"pluralLevelTwo"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:self.pluralLevelOneId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.level forKey:@"level"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[self.pluralLevelTwo arrayOfPluralLevelTwoDictionariesFromPluralLevelTwoObjects] forKey:@"pluralLevelTwo"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:self.pluralLevelOneId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pluralLevelTwo release];

    [super dealloc];
}
@end
