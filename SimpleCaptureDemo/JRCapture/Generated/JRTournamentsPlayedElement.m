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
#import "JRTournamentsPlayedElement.h"

@interface JRTournamentsPlayedElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRTournamentsPlayedElement
{
    JRObjectId *_tournamentsPlayedElementId;
    JRDecimal *_moneyWon;
    JRInteger *_placed;
    JRDateTime *_tournamentDate;
    JRBoolean *_wonMoney;
}
@synthesize canBeUpdatedOnCapture;

- (JRObjectId *)tournamentsPlayedElementId
{
    return _tournamentsPlayedElementId;
}

- (void)setTournamentsPlayedElementId:(JRObjectId *)newTournamentsPlayedElementId
{
    [self.dirtyPropertySet addObject:@"tournamentsPlayedElementId"];

    [_tournamentsPlayedElementId autorelease];
    _tournamentsPlayedElementId = [newTournamentsPlayedElementId copy];
}

- (JRDecimal *)moneyWon
{
    return _moneyWon;
}

- (void)setMoneyWon:(JRDecimal *)newMoneyWon
{
    [self.dirtyPropertySet addObject:@"moneyWon"];

    [_moneyWon autorelease];
    _moneyWon = [newMoneyWon copy];
}

- (JRInteger *)placed
{
    return _placed;
}

- (void)setPlaced:(JRInteger *)newPlaced
{
    [self.dirtyPropertySet addObject:@"placed"];

    [_placed autorelease];
    _placed = [newPlaced copy];
}

- (NSInteger)getPlacedIntegerValue
{
    return [_placed integerValue];
}

- (void)setPlacedWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"placed"];

    [_placed autorelease];
    _placed = [[NSNumber numberWithInteger:integerVal] retain];
}

- (JRDateTime *)tournamentDate
{
    return _tournamentDate;
}

- (void)setTournamentDate:(JRDateTime *)newTournamentDate
{
    [self.dirtyPropertySet addObject:@"tournamentDate"];

    [_tournamentDate autorelease];
    _tournamentDate = [newTournamentDate copy];
}

- (JRBoolean *)wonMoney
{
    return _wonMoney;
}

- (void)setWonMoney:(JRBoolean *)newWonMoney
{
    [self.dirtyPropertySet addObject:@"wonMoney"];

    [_wonMoney autorelease];
    _wonMoney = [newWonMoney copy];
}

- (BOOL)getWonMoneyBoolValue
{
    return [_wonMoney boolValue];
}

- (void)setWonMoneyWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"wonMoney"];

    [_wonMoney autorelease];
    _wonMoney = [[NSNumber numberWithBool:boolVal] retain];
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

+ (id)tournamentsPlayedElement
{
    return [[[JRTournamentsPlayedElement alloc] init] autorelease];
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.tournamentsPlayedElementId ? [NSNumber numberWithInteger:[self.tournamentsPlayedElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.moneyWon ? self.moneyWon : [NSNull null])
                   forKey:@"moneyWon"];
    [dictionary setObject:(self.placed ? [NSNumber numberWithInteger:[self.placed integerValue]] : [NSNull null])
                   forKey:@"placed"];
    [dictionary setObject:(self.tournamentDate ? [self.tournamentDate stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"tournamentDate"];
    [dictionary setObject:(self.wonMoney ? [NSNumber numberWithBool:[self.wonMoney boolValue]] : [NSNull null])
                   forKey:@"wonMoney"];

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

+ (id)tournamentsPlayedElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRTournamentsPlayedElement *tournamentsPlayedElement = [JRTournamentsPlayedElement tournamentsPlayedElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        tournamentsPlayedElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        tournamentsPlayedElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        tournamentsPlayedElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"tournamentsPlayed", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        tournamentsPlayedElement.canBeUpdatedOnCapture = YES;
    }

    tournamentsPlayedElement.tournamentsPlayedElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    tournamentsPlayedElement.moneyWon =
        [dictionary objectForKey:@"moneyWon"] != [NSNull null] ? 
        [dictionary objectForKey:@"moneyWon"] : nil;

    tournamentsPlayedElement.placed =
        [dictionary objectForKey:@"placed"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"placed"] integerValue]] : nil;

    tournamentsPlayedElement.tournamentDate =
        [dictionary objectForKey:@"tournamentDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"tournamentDate"]] : nil;

    tournamentsPlayedElement.wonMoney =
        [dictionary objectForKey:@"wonMoney"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"wonMoney"] boolValue]] : nil;

    if (fromDecoder)
        [tournamentsPlayedElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [tournamentsPlayedElement.dirtyPropertySet removeAllObjects];
    
    return tournamentsPlayedElement;
}

+ (id)tournamentsPlayedElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRTournamentsPlayedElement tournamentsPlayedElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"tournamentsPlayed", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.tournamentsPlayedElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.moneyWon =
        [dictionary objectForKey:@"moneyWon"] != [NSNull null] ? 
        [dictionary objectForKey:@"moneyWon"] : nil;

    self.placed =
        [dictionary objectForKey:@"placed"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"placed"] integerValue]] : nil;

    self.tournamentDate =
        [dictionary objectForKey:@"tournamentDate"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"tournamentDate"]] : nil;

    self.wonMoney =
        [dictionary objectForKey:@"wonMoney"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"wonMoney"] boolValue]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"tournamentsPlayedElementId", @"moneyWon", @"placed", @"tournamentDate", @"wonMoney", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"tournamentsPlayedElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"tournamentsPlayedElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"tournamentsPlayedElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"moneyWon"])
        [dictionary setObject:(self.moneyWon ? self.moneyWon : [NSNull null]) forKey:@"moneyWon"];

    if ([self.dirtyPropertySet containsObject:@"placed"])
        [dictionary setObject:(self.placed ? [NSNumber numberWithInteger:[self.placed integerValue]] : [NSNull null]) forKey:@"placed"];

    if ([self.dirtyPropertySet containsObject:@"tournamentDate"])
        [dictionary setObject:(self.tournamentDate ? [self.tournamentDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"tournamentDate"];

    if ([self.dirtyPropertySet containsObject:@"wonMoney"])
        [dictionary setObject:(self.wonMoney ? [NSNumber numberWithBool:[self.wonMoney boolValue]] : [NSNull null]) forKey:@"wonMoney"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.moneyWon ? self.moneyWon : [NSNull null]) forKey:@"moneyWon"];
    [dictionary setObject:(self.placed ? [NSNumber numberWithInteger:[self.placed integerValue]] : [NSNull null]) forKey:@"placed"];
    [dictionary setObject:(self.tournamentDate ? [self.tournamentDate stringFromISO8601DateTime] : [NSNull null]) forKey:@"tournamentDate"];
    [dictionary setObject:(self.wonMoney ? [NSNumber numberWithBool:[self.wonMoney boolValue]] : [NSNull null]) forKey:@"wonMoney"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToTournamentsPlayedElement:(JRTournamentsPlayedElement *)otherTournamentsPlayedElement
{
    if (!self.moneyWon && !otherTournamentsPlayedElement.moneyWon) /* Keep going... */;
    else if ((self.moneyWon == nil) ^ (otherTournamentsPlayedElement.moneyWon == nil)) return NO; // xor
    else if (![self.moneyWon isEqualToNumber:otherTournamentsPlayedElement.moneyWon]) return NO;

    if (!self.placed && !otherTournamentsPlayedElement.placed) /* Keep going... */;
    else if ((self.placed == nil) ^ (otherTournamentsPlayedElement.placed == nil)) return NO; // xor
    else if (![self.placed isEqualToNumber:otherTournamentsPlayedElement.placed]) return NO;

    if (!self.tournamentDate && !otherTournamentsPlayedElement.tournamentDate) /* Keep going... */;
    else if ((self.tournamentDate == nil) ^ (otherTournamentsPlayedElement.tournamentDate == nil)) return NO; // xor
    else if (![self.tournamentDate isEqualToDate:otherTournamentsPlayedElement.tournamentDate]) return NO;

    if (!self.wonMoney && !otherTournamentsPlayedElement.wonMoney) /* Keep going... */;
    else if ((self.wonMoney == nil) ^ (otherTournamentsPlayedElement.wonMoney == nil)) return NO; // xor
    else if (![self.wonMoney isEqualToNumber:otherTournamentsPlayedElement.wonMoney]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"tournamentsPlayedElementId"];
    [dictionary setObject:@"JRDecimal" forKey:@"moneyWon"];
    [dictionary setObject:@"JRInteger" forKey:@"placed"];
    [dictionary setObject:@"JRDateTime" forKey:@"tournamentDate"];
    [dictionary setObject:@"JRBoolean" forKey:@"wonMoney"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_tournamentsPlayedElementId release];
    [_moneyWon release];
    [_placed release];
    [_tournamentDate release];
    [_wonMoney release];

    [super dealloc];
}
@end
