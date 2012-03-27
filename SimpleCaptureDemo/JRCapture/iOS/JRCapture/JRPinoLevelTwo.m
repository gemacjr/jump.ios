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
- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeObjects;
- (NSArray*)arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries;
@end

@implementation NSArray (PinoLevelThreeToFromDictionary)
- (NSArray*)arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPinoLevelThree*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPinoLevelThree pinoLevelThreeObjectFromDictionary:(NSDictionary*)dictionary]];

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
{
    JRPinoLevelTwo *pinoLevelTwoCopy =
                [[JRPinoLevelTwo allocWithZone:zone] init];

    pinoLevelTwoCopy.level = self.level;
    pinoLevelTwoCopy.name = self.name;
    pinoLevelTwoCopy.pinoLevelThree = self.pinoLevelThree;

    return pinoLevelTwoCopy;
}

+ (id)pinoLevelTwoObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPinoLevelTwo *pinoLevelTwo =
        [JRPinoLevelTwo pinoLevelTwo];

    pinoLevelTwo.level = [dictionary objectForKey:@"level"];
    pinoLevelTwo.name = [dictionary objectForKey:@"name"];
    pinoLevelTwo.pinoLevelThree = [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries];

    return pinoLevelTwo;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.level)
        [dict setObject:self.level forKey:@"level"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    if (self.pinoLevelThree)
        [dict setObject:[self.pinoLevelThree arrayOfPinoLevelThreeDictionariesFromPinoLevelThreeObjects] forKey:@"pinoLevelThree"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"pinoLevelThree"])
        self.pinoLevelThree = [(NSArray*)[dictionary objectForKey:@"pinoLevelThree"] arrayOfPinoLevelThreeObjectsFromPinoLevelThreeDictionaries];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelThree release];

    [super dealloc];
}
@end
