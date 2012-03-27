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


#import "JRObjectLevelThree.h"

@implementation JRObjectLevelThree
{
    NSString *_level;
    NSString *_name;

}
@dynamic level;
@dynamic name;

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
        self.captureObjectPath = @"/objectLevelOne/objectLevelTwo/objectLevelThree";
    }
    return self;
}

+ (id)objectLevelThree
{
    return [[[JRObjectLevelThree alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRObjectLevelThree *objectLevelThreeCopy =
                [[JRObjectLevelThree allocWithZone:zone] init];

    objectLevelThreeCopy.level = self.level;
    objectLevelThreeCopy.name = self.name;

    return objectLevelThreeCopy;
}

+ (id)objectLevelThreeObjectFromDictionary:(NSDictionary*)dictionary
{
    JRObjectLevelThree *objectLevelThree =
        [JRObjectLevelThree objectLevelThree];

    objectLevelThree.level = [dictionary objectForKey:@"level"];
    objectLevelThree.name = [dictionary objectForKey:@"name"];

    return objectLevelThree;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.level)
        [dict setObject:self.level forKey:@"level"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
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
