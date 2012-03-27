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

@interface NSArray (OpponentsToFromDictionary)
- (NSArray*)arrayOfOpponentsDictionariesFromOpponentsObjects;
- (NSArray*)arrayOfOpponentsObjectsFromOpponentsDictionaries;
@end

@implementation NSArray (OpponentsToFromDictionary)
- (NSArray*)arrayOfOpponentsDictionariesFromOpponentsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROpponents class]])
            [filteredDictionaryArray addObject:[(JROpponents*)object dictionaryFromOpponentsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOpponentsObjectsFromOpponentsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JROpponents opponentsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

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

    _opponents = [newOpponents copy];
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
{
    JRGames *gamesCopy =
                [[JRGames allocWithZone:zone] init];

    gamesCopy.gamesId = self.gamesId;
    gamesCopy.isFavorite = self.isFavorite;
    gamesCopy.name = self.name;
    gamesCopy.opponents = self.opponents;
    gamesCopy.rating = self.rating;

    return gamesCopy;
}

+ (id)gamesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRGames *games =
        [JRGames games];

    games.gamesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    games.isFavorite = [(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue];
    games.name = [dictionary objectForKey:@"name"];
    games.opponents = [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfOpponentsObjectsFromOpponentsDictionaries];
    games.rating = [(NSNumber*)[dictionary objectForKey:@"rating"] intValue];

    return games;
}

- (NSDictionary*)dictionaryFromGamesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.gamesId)
        [dict setObject:[NSNumber numberWithInt:self.gamesId] forKey:@"id"];

    if (self.isFavorite)
        [dict setObject:[NSNumber numberWithBool:self.isFavorite] forKey:@"isFavorite"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    if (self.opponents)
        [dict setObject:[self.opponents arrayOfOpponentsDictionariesFromOpponentsObjects] forKey:@"opponents"];

    if (self.rating)
        [dict setObject:[NSNumber numberWithInt:self.rating] forKey:@"rating"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"isFavorite"])
        self.isFavorite = [(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"opponents"])
        self.opponents = [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfOpponentsObjectsFromOpponentsDictionaries];

    if ([dictionary objectForKey:@"rating"])
        self.rating = [(NSNumber*)[dictionary objectForKey:@"rating"] intValue];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.gamesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.isFavorite = [(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue];
    self.name = [dictionary objectForKey:@"name"];
    self.opponents = [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfOpponentsObjectsFromOpponentsDictionaries];
    self.rating = [(NSNumber*)[dictionary objectForKey:@"rating"] intValue];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"isFavorite"])
        [dict setObject:[NSNumber numberWithBool:self.isFavorite] forKey:@"isFavorite"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"opponents"])
        [dict setObject:[self.opponents arrayOfOpponentsDictionariesFromOpponentsObjects] forKey:@"opponents"];

    if ([self.dirtyPropertySet containsObject:@"rating"])
        [dict setObject:[NSNumber numberWithInt:self.rating] forKey:@"rating"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.gamesId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithBool:self.isFavorite] forKey:@"isFavorite"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[self.opponents arrayOfOpponentsDictionariesFromOpponentsObjects] forKey:@"opponents"];
    [dict setObject:[NSNumber numberWithInt:self.rating] forKey:@"rating"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.gamesId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];
}

- (void)dealloc
{
    [_name release];
    [_opponents release];

    [super dealloc];
}
@end
