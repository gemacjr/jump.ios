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


#import "JRPluralLevelThree.h"

@implementation JRPluralLevelThree
{
    NSInteger _pluralLevelThreeId;
    NSString *_level;
    NSString *_name;

}
@dynamic pluralLevelThreeId;
@dynamic level;
@dynamic name;

- (NSInteger )pluralLevelThreeId
{
    return _pluralLevelThreeId;
}

- (void)setPluralLevelThreeId:(NSInteger )newPluralLevelThreeId
{
    [self.dirtyPropertySet addObject:@"pluralLevelThreeId"];

    _pluralLevelThreeId = newPluralLevelThreeId;

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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pluralLevelOne/pluralLevelTwo/pluralLevelThree";
    }
    return self;
}

+ (id)pluralLevelThree
{
    return [[[JRPluralLevelThree alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPluralLevelThree *pluralLevelThreeCopy =
                [[JRPluralLevelThree allocWithZone:zone] init];

    pluralLevelThreeCopy.pluralLevelThreeId = self.pluralLevelThreeId;
    pluralLevelThreeCopy.level = self.level;
    pluralLevelThreeCopy.name = self.name;

    return pluralLevelThreeCopy;
}

+ (id)pluralLevelThreeObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPluralLevelThree *pluralLevelThree =
        [JRPluralLevelThree pluralLevelThree];

    pluralLevelThree.pluralLevelThreeId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    pluralLevelThree.level = [dictionary objectForKey:@"level"];
    pluralLevelThree.name = [dictionary objectForKey:@"name"];

    return pluralLevelThree;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.pluralLevelThreeId)
        [dict setObject:[NSNumber numberWithInt:self.pluralLevelThreeId] forKey:@"id"];

    if (self.level)
        [dict setObject:self.level forKey:@"level"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"pluralLevelThreeId"])
        self.pluralLevelThreeId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];
}

- (void)dealloc
{
    [_level release];
    [_name release];

    [super dealloc];
}
@end
