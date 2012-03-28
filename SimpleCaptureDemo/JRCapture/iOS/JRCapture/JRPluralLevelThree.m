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

- (NSInteger)pluralLevelThreeId
{
    return _pluralLevelThreeId;
}

- (void)setPluralLevelThreeId:(NSInteger)newPluralLevelThreeId
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

- (NSDictionary*)dictionaryFromPluralLevelThreeObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.pluralLevelThreeId)
        [dict setObject:[NSNumber numberWithInt:self.pluralLevelThreeId] forKey:@"id"];

    if (self.level && self.level != [NSNull null])
        [dict setObject:self.level forKey:@"level"];
    else
        [dict setObject:[NSNull null] forKey:@"level"];

    if (self.name && self.name != [NSNull null])
        [dict setObject:self.name forKey:@"name"];
    else
        [dict setObject:[NSNull null] forKey:@"name"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _pluralLevelThreeId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"level"])
        _level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _pluralLevelThreeId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _level = [dictionary objectForKey:@"level"];
    _name = [dictionary objectForKey:@"name"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelThreeId"])
        [dict setObject:[NSNumber numberWithInt:self.pluralLevelThreeId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:self.level forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

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

    [dict setObject:[NSNumber numberWithInt:self.pluralLevelThreeId] forKey:@"id"];
    [dict setObject:self.level forKey:@"level"];
    [dict setObject:self.name forKey:@"name"];

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

    [super dealloc];
}
@end
