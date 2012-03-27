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


#import "JRHeroes.h"

@implementation JRHeroes
{
    NSInteger _heroesId;
    NSString *_hero;
}
@dynamic heroesId;
@dynamic hero;

- (NSInteger)heroesId
{
    return _heroesId;
}

- (void)setHeroesId:(NSInteger)newHeroesId
{
    [self.dirtyPropertySet addObject:@"heroesId"];

    _heroesId = newHeroesId;
}

- (NSString *)hero
{
    return _hero;
}

- (void)setHero:(NSString *)newHero
{
    [self.dirtyPropertySet addObject:@"hero"];

    _hero = [newHero copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/heroes";
    }
    return self;
}

+ (id)heroes
{
    return [[[JRHeroes alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRHeroes *heroesCopy =
                [[JRHeroes allocWithZone:zone] init];

    heroesCopy.heroesId = self.heroesId;
    heroesCopy.hero = self.hero;

    return heroesCopy;
}

+ (id)heroesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRHeroes *heroes =
        [JRHeroes heroes];

    heroes.heroesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    heroes.hero = [dictionary objectForKey:@"hero"];

    return heroes;
}

- (NSDictionary*)dictionaryFromHeroesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.heroesId)
        [dict setObject:[NSNumber numberWithInt:self.heroesId] forKey:@"id"];

    if (self.hero)
        [dict setObject:self.hero forKey:@"hero"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"hero"])
        self.hero = [dictionary objectForKey:@"hero"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.heroesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.hero = [dictionary objectForKey:@"hero"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"hero"])
        [dict setObject:self.hero forKey:@"hero"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.heroesId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:self
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.hero forKey:@"hero"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.heroesId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

- (void)dealloc
{
    [_hero release];

    [super dealloc];
}
@end
