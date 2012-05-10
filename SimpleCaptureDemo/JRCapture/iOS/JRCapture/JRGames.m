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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRGames.h"

@interface JRGames ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRGames
{
    JRObjectId *_gamesId;
    JRBoolean *_isFavorite;
    NSString *_name;
    JRSimpleArray *_opponents;
    JRInteger *_rating;
}
@dynamic gamesId;
@dynamic isFavorite;
@dynamic name;
@dynamic opponents;
@dynamic rating;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)gamesId
{
    return _gamesId;
}

- (void)setGamesId:(JRObjectId *)newGamesId
{
    [self.dirtyPropertySet addObject:@"gamesId"];
    _gamesId = [newGamesId copy];
}

- (JRBoolean *)isFavorite
{
    return _isFavorite;
}

- (void)setIsFavorite:(JRBoolean *)newIsFavorite
{
    [self.dirtyPropertySet addObject:@"isFavorite"];
    _isFavorite = [newIsFavorite copy];
}

- (BOOL)getIsFavoriteBoolValue
{
    return [_isFavorite boolValue];
}

- (void)setIsFavoriteWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"isFavorite"];
    _isFavorite = [NSNumber numberWithBool:boolVal];
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
    [self.dirtyArraySet addObject:@"opponents"];
    _opponents = [newOpponents copyArrayOfStringPluralElementsWithType:@"name"];
}

- (JRInteger *)rating
{
    return _rating;
}

- (void)setRating:(JRInteger *)newRating
{
    [self.dirtyPropertySet addObject:@"rating"];
    _rating = [newRating copy];
}

- (NSInteger)getRatingIntegerValue
{
    return [_rating integerValue];
}

- (void)setRatingWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"rating"];
    _rating = [NSNumber numberWithInteger:integerVal];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.canBeUpdatedOrReplaced = NO;
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

    gamesCopy.captureObjectPath = self.captureObjectPath;

    gamesCopy.gamesId = self.gamesId;
    gamesCopy.isFavorite = self.isFavorite;
    gamesCopy.name = self.name;
    gamesCopy.opponents = self.opponents;
    gamesCopy.rating = self.rating;

    gamesCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    [gamesCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [gamesCopy.dirtyArraySet setSet:self.dirtyPropertySet];

    return gamesCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.gamesId ? [NSNumber numberWithInteger:[self.gamesId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.isFavorite ? [NSNumber numberWithBool:[self.isFavorite boolValue]] : [NSNull null])
             forKey:@"isFavorite"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.opponents ? [self.opponents arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"opponents"];
    [dict setObject:(self.rating ? [NSNumber numberWithInteger:[self.rating integerValue]] : [NSNull null])
             forKey:@"rating"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)gamesObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRGames *games = [JRGames games];
    games.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"games", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    games.gamesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    games.isFavorite =
        [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue]] : nil;

    games.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    games.opponents =
        [dictionary objectForKey:@"opponents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"opponents"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"name" 
                                                                        andPath:[NSString stringWithFormat:@"%@/opponents", games.captureObjectPath]] : nil;

    games.rating =
        [dictionary objectForKey:@"rating"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"rating"] integerValue]] : nil;

    [games.dirtyPropertySet removeAllObjects];
    [games.dirtyArraySet removeAllObjects];
    
    return games;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"games", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.gamesId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"isFavorite"])
        self.isFavorite = [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue]] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"rating"])
        self.rating = [dictionary objectForKey:@"rating"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"rating"] integerValue]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"games", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.gamesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.isFavorite =
        [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue]] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.opponents =
        [dictionary objectForKey:@"opponents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"opponents"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"name" 
                                                                        andPath:[NSString stringWithFormat:@"%@/opponents", self.captureObjectPath]] : nil;

    self.rating =
        [dictionary objectForKey:@"rating"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"rating"] integerValue]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"isFavorite"])
        [dict setObject:(self.isFavorite ? [NSNumber numberWithBool:[self.isFavorite boolValue]] : [NSNull null]) forKey:@"isFavorite"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"rating"])
        [dict setObject:(self.rating ? [NSNumber numberWithInteger:[self.rating integerValue]] : [NSNull null]) forKey:@"rating"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.isFavorite ? [NSNumber numberWithBool:[self.isFavorite boolValue]] : [NSNull null]) forKey:@"isFavorite"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.opponents ? [self.opponents arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"opponents"];
    [dict setObject:(self.rating ? [NSNumber numberWithInteger:[self.rating integerValue]] : [NSNull null]) forKey:@"rating"];

    return dict;
}

- (void)replaceOpponentsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.opponents ofType:@"name" named:@"opponents"
                          forDelegate:delegate withContext:context];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"gamesId"];
    [dict setObject:@"JRBoolean" forKey:@"isFavorite"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JRSimpleArray" forKey:@"opponents"];
    [dict setObject:@"JRInteger" forKey:@"rating"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_gamesId release];
    [_isFavorite release];
    [_name release];
    [_opponents release];
    [_rating release];

    [super dealloc];
}
@end
