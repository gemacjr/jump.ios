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


#import "JRGames.h"

@implementation JRGames
{
    NSInteger _gamesId;
    BOOL _isFavorite;
    NSString *_name;
    NSArray *_opponents;
    NSInteger _rating;
}
@dynamic gamesId;
@dynamic isFavorite;
@dynamic name;
@dynamic opponents;
@dynamic rating;

- (NSInteger)gamesId
{
    return _gamesId;
}

- (void)setGamesId:(NSInteger)newGamesId
{
    [self.dirtyPropertySet addObject:@"gamesId"];
    _gamesId = newGamesId;
}

- (BOOL)isFavorite
{
    return _isFavorite;
}

- (void)setIsFavorite:(BOOL)newIsFavorite
{
    [self.dirtyPropertySet addObject:@"isFavorite"];
    _isFavorite = newIsFavorite;
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

- (NSArray *)opponents
{
    return _opponents;
}

- (void)setOpponents:(NSArray *)newOpponents
{
    [self.dirtyPropertySet addObject:@"opponents"];
    _opponents = [newOpponents copyArrayOfStringPluralElementsWithType:@"name"];
}

- (NSInteger)rating
{
    return _rating;
}

- (void)setRating:(NSInteger)newRating
{
    [self.dirtyPropertySet addObject:@"rating"];
    _rating = newRating;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/games";
    }
    return self;
}

+ (id)games
{
    return [[[JRGames alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRGames *gamesCopy =
                [[JRGames allocWithZone:zone] init];

    gamesCopy.gamesId = self.gamesId;
    gamesCopy.isFavorite = self.isFavorite;
    gamesCopy.name = self.name;
    gamesCopy.opponents = self.opponents;
    gamesCopy.rating = self.rating;

    [gamesCopy.dirtyPropertySet removeAllObjects];
    [gamesCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return gamesCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.gamesId]
             forKey:@"id"];
    [dict setObject:[NSNumber numberWithBool:self.isFavorite]
             forKey:@"isFavorite"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.opponents ? [self.opponents arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"opponents"];
    [dict setObject:[NSNumber numberWithInt:self.rating]
             forKey:@"rating"];

    return dict;
}

+ (id)gamesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRGames *games = [JRGames games];

    games.gamesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    games.isFavorite =
        [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue] : 0;

    games.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    games.opponents =
        [dictionary objectForKey:@"opponents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"name"] : nil;

    games.rating =
        [dictionary objectForKey:@"rating"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"rating"] intValue] : 0;

    [games.dirtyPropertySet removeAllObjects];
    
    return games;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _gamesId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    if ([dictionary objectForKey:@"isFavorite"])
        _isFavorite = [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue] : 0;

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"opponents"])
        _opponents = [dictionary objectForKey:@"opponents"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"name"] : nil;

    if ([dictionary objectForKey:@"rating"])
        _rating = [dictionary objectForKey:@"rating"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"rating"] intValue] : 0;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary
{
    _gamesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    _isFavorite =
        [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue] : 0;

    _name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    _opponents =
        [dictionary objectForKey:@"opponents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"name"] : nil;

    _rating =
        [dictionary objectForKey:@"rating"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"rating"] intValue] : 0;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"isFavorite"])
        [dict setObject:(self.isFavorite ? [NSNumber numberWithBool:self.isFavorite] : [NSNull null]) forKey:@"isFavorite"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"opponents"])
        [dict setObject:(self.opponents ? self.opponents : [NSNull null]) forKey:@"opponents"];

    if ([self.dirtyPropertySet containsObject:@"rating"])
        [dict setObject:(self.rating ? [NSNumber numberWithInt:self.rating] : [NSNull null]) forKey:@"rating"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:_gamesId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.isFavorite ? [NSNumber numberWithBool:self.isFavorite] : [NSNull null]) forKey:@"isFavorite"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.opponents ? self.opponents : [NSNull null]) forKey:@"opponents"];
    [dict setObject:(self.rating ? [NSNumber numberWithInt:self.rating] : [NSNull null]) forKey:@"rating"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:_gamesId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_name release];
    [_opponents release];

    [super dealloc];
}
@end
