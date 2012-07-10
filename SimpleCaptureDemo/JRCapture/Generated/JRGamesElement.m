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


#import "JRCaptureObject+Internal.h"
#import "JRGamesElement.h"

@interface JRGamesElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRGamesElement
{
    JRObjectId *_gamesElementId;
    JRBoolean *_isFavorite;
    NSString *_name;
    JRStringArray *_opponents;
    JRInteger *_rating;
}
@synthesize canBeUpdatedOnCapture;

- (JRObjectId *)gamesElementId
{
    return _gamesElementId;
}

- (void)setGamesElementId:(JRObjectId *)newGamesElementId
{
    [self.dirtyPropertySet addObject:@"gamesElementId"];

    [_gamesElementId autorelease];
    _gamesElementId = [newGamesElementId copy];
}

- (JRBoolean *)isFavorite
{
    return _isFavorite;
}

- (void)setIsFavorite:(JRBoolean *)newIsFavorite
{
    [self.dirtyPropertySet addObject:@"isFavorite"];

    [_isFavorite autorelease];
    _isFavorite = [newIsFavorite copy];
}

- (BOOL)getIsFavoriteBoolValue
{
    return [_isFavorite boolValue];
}

- (void)setIsFavoriteWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"isFavorite"];

    [_isFavorite autorelease];
    _isFavorite = [[NSNumber numberWithBool:boolVal] retain];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    [_name autorelease];
    _name = [newName copy];
}

- (JRStringArray *)opponents
{
    return _opponents;
}

- (void)setOpponents:(JRStringArray *)newOpponents
{
    [_opponents autorelease];
    _opponents = [newOpponents copy];
}

- (JRInteger *)rating
{
    return _rating;
}

- (void)setRating:(JRInteger *)newRating
{
    [self.dirtyPropertySet addObject:@"rating"];

    [_rating autorelease];
    _rating = [newRating copy];
}

- (NSInteger)getRatingIntegerValue
{
    return [_rating integerValue];
}

- (void)setRatingWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"rating"];

    [_rating autorelease];
    _rating = [[NSNumber numberWithInteger:integerVal] retain];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)gamesElement
{
    return [[[JRGamesElement alloc] init] autorelease];
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.gamesElementId ? [NSNumber numberWithInteger:[self.gamesElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.isFavorite ? [NSNumber numberWithBool:[self.isFavorite boolValue]] : [NSNull null])
                   forKey:@"isFavorite"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.opponents ? self.opponents : [NSNull null])
                   forKey:@"opponents"];
    [dictionary setObject:(self.rating ? [NSNumber numberWithInteger:[self.rating integerValue]] : [NSNull null])
                   forKey:@"rating"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOnCapture] 
                       forKey:@"canBeUpdatedOnCapture"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)gamesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRGamesElement *gamesElement = [JRGamesElement gamesElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        gamesElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        gamesElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        gamesElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"games", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        gamesElement.canBeUpdatedOnCapture = YES;
    }

    gamesElement.gamesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    gamesElement.isFavorite =
        [dictionary objectForKey:@"isFavorite"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"isFavorite"] boolValue]] : nil;

    gamesElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    gamesElement.opponents =
        [dictionary objectForKey:@"opponents"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfStringsFromStringPluralDictionariesWithType:@"name"] : nil;

    gamesElement.rating =
        [dictionary objectForKey:@"rating"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"rating"] integerValue]] : nil;

    if (fromDecoder)
        [gamesElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [gamesElement.dirtyPropertySet removeAllObjects];
    
    return gamesElement;
}

+ (id)gamesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRGamesElement gamesElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"games", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.gamesElementId =
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
        [(NSArray*)[dictionary objectForKey:@"opponents"] arrayOfStringsFromStringPluralDictionariesWithType:@"name"] : nil;

    self.rating =
        [dictionary objectForKey:@"rating"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"rating"] integerValue]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"gamesElementId", @"isFavorite", @"name", @"rating", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"gamesElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"gamesElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"gamesElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"isFavorite"])
        [dictionary setObject:(self.isFavorite ? [NSNumber numberWithBool:[self.isFavorite boolValue]] : [NSNull null]) forKey:@"isFavorite"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"rating"])
        [dictionary setObject:(self.rating ? [NSNumber numberWithInteger:[self.rating integerValue]] : [NSNull null]) forKey:@"rating"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.isFavorite ? [NSNumber numberWithBool:[self.isFavorite boolValue]] : [NSNull null]) forKey:@"isFavorite"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [dictionary setObject:(self.opponents ?
                          self.opponents :
                          [NSArray array])
                   forKey:@"opponents"];
    [dictionary setObject:(self.rating ? [NSNumber numberWithInteger:[self.rating integerValue]] : [NSNull null]) forKey:@"rating"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replaceOpponentsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.opponents named:@"opponents" isArrayOfStrings:YES
                       withType:@"name" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToGamesElement:(JRGamesElement *)otherGamesElement
{
    if (!self.isFavorite && !otherGamesElement.isFavorite) /* Keep going... */;
    else if ((self.isFavorite == nil) ^ (otherGamesElement.isFavorite == nil)) return NO; // xor
    else if (![self.isFavorite isEqualToNumber:otherGamesElement.isFavorite]) return NO;

    if (!self.name && !otherGamesElement.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherGamesElement.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherGamesElement.name]) return NO;

    if (!self.opponents && !otherGamesElement.opponents) /* Keep going... */;
    else if (!self.opponents && ![otherGamesElement.opponents count]) /* Keep going... */;
    else if (!otherGamesElement.opponents && ![self.opponents count]) /* Keep going... */;
    else if (![self.opponents isEqualToArray:otherGamesElement.opponents]) return NO;

    if (!self.rating && !otherGamesElement.rating) /* Keep going... */;
    else if ((self.rating == nil) ^ (otherGamesElement.rating == nil)) return NO; // xor
    else if (![self.rating isEqualToNumber:otherGamesElement.rating]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"gamesElementId"];
    [dictionary setObject:@"JRBoolean" forKey:@"isFavorite"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"JRStringArray" forKey:@"opponents"];
    [dictionary setObject:@"JRInteger" forKey:@"rating"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_gamesElementId release];
    [_isFavorite release];
    [_name release];
    [_opponents release];
    [_rating release];

    [super dealloc];
}
@end
