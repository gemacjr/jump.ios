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
#import "JRBestHand.h"

@interface JRBestHand ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRBestHand
{
    JRDate *_datePlayed;
    NSString *_hand;
    NSString *_handBeat;
    JRDecimal *_moneyWon;
}
@synthesize canBeUpdatedOnCapture;

- (JRDate *)datePlayed
{
    return _datePlayed;
}

- (void)setDatePlayed:(JRDate *)newDatePlayed
{
    [self.dirtyPropertySet addObject:@"datePlayed"];

    [_datePlayed autorelease];
    _datePlayed = [newDatePlayed copy];
}

- (NSString *)hand
{
    return _hand;
}

- (void)setHand:(NSString *)newHand
{
    [self.dirtyPropertySet addObject:@"hand"];

    [_hand autorelease];
    _hand = [newHand copy];
}

- (NSString *)handBeat
{
    return _handBeat;
}

- (void)setHandBeat:(NSString *)newHandBeat
{
    [self.dirtyPropertySet addObject:@"handBeat"];

    [_handBeat autorelease];
    _handBeat = [newHandBeat copy];
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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/bestHand";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)bestHand
{
    return [[[JRBestHand alloc] init] autorelease];
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.datePlayed ? [self.datePlayed stringFromISO8601Date] : [NSNull null])
                   forKey:@"datePlayed"];
    [dictionary setObject:(self.hand ? self.hand : [NSNull null])
                   forKey:@"hand"];
    [dictionary setObject:(self.handBeat ? self.handBeat : [NSNull null])
                   forKey:@"handBeat"];
    [dictionary setObject:(self.moneyWon ? self.moneyWon : [NSNull null])
                   forKey:@"moneyWon"];

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

+ (id)bestHandObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRBestHand *bestHand = [JRBestHand bestHand];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        bestHand.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    bestHand.datePlayed =
        [dictionary objectForKey:@"datePlayed"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"datePlayed"]] : nil;

    bestHand.hand =
        [dictionary objectForKey:@"hand"] != [NSNull null] ? 
        [dictionary objectForKey:@"hand"] : nil;

    bestHand.handBeat =
        [dictionary objectForKey:@"handBeat"] != [NSNull null] ? 
        [dictionary objectForKey:@"handBeat"] : nil;

    bestHand.moneyWon =
        [dictionary objectForKey:@"moneyWon"] != [NSNull null] ? 
        [dictionary objectForKey:@"moneyWon"] : nil;

    if (fromDecoder)
        [bestHand.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [bestHand.dirtyPropertySet removeAllObjects];
    
    return bestHand;
}

+ (id)bestHandObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRBestHand bestHandObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;

    self.datePlayed =
        [dictionary objectForKey:@"datePlayed"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"datePlayed"]] : nil;

    self.hand =
        [dictionary objectForKey:@"hand"] != [NSNull null] ? 
        [dictionary objectForKey:@"hand"] : nil;

    self.handBeat =
        [dictionary objectForKey:@"handBeat"] != [NSNull null] ? 
        [dictionary objectForKey:@"handBeat"] : nil;

    self.moneyWon =
        [dictionary objectForKey:@"moneyWon"] != [NSNull null] ? 
        [dictionary objectForKey:@"moneyWon"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"datePlayed", @"hand", @"handBeat", @"moneyWon", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"bestHand"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"bestHand"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"bestHand"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"datePlayed"])
        [dictionary setObject:(self.datePlayed ? [self.datePlayed stringFromISO8601Date] : [NSNull null]) forKey:@"datePlayed"];

    if ([self.dirtyPropertySet containsObject:@"hand"])
        [dictionary setObject:(self.hand ? self.hand : [NSNull null]) forKey:@"hand"];

    if ([self.dirtyPropertySet containsObject:@"handBeat"])
        [dictionary setObject:(self.handBeat ? self.handBeat : [NSNull null]) forKey:@"handBeat"];

    if ([self.dirtyPropertySet containsObject:@"moneyWon"])
        [dictionary setObject:(self.moneyWon ? self.moneyWon : [NSNull null]) forKey:@"moneyWon"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.datePlayed ? [self.datePlayed stringFromISO8601Date] : [NSNull null]) forKey:@"datePlayed"];
    [dictionary setObject:(self.hand ? self.hand : [NSNull null]) forKey:@"hand"];
    [dictionary setObject:(self.handBeat ? self.handBeat : [NSNull null]) forKey:@"handBeat"];
    [dictionary setObject:(self.moneyWon ? self.moneyWon : [NSNull null]) forKey:@"moneyWon"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToBestHand:(JRBestHand *)otherBestHand
{
    if (!self.datePlayed && !otherBestHand.datePlayed) /* Keep going... */;
    else if ((self.datePlayed == nil) ^ (otherBestHand.datePlayed == nil)) return NO; // xor
    else if (![self.datePlayed isEqualToDate:otherBestHand.datePlayed]) return NO;

    if (!self.hand && !otherBestHand.hand) /* Keep going... */;
    else if ((self.hand == nil) ^ (otherBestHand.hand == nil)) return NO; // xor
    else if (![self.hand isEqualToString:otherBestHand.hand]) return NO;

    if (!self.handBeat && !otherBestHand.handBeat) /* Keep going... */;
    else if ((self.handBeat == nil) ^ (otherBestHand.handBeat == nil)) return NO; // xor
    else if (![self.handBeat isEqualToString:otherBestHand.handBeat]) return NO;

    if (!self.moneyWon && !otherBestHand.moneyWon) /* Keep going... */;
    else if ((self.moneyWon == nil) ^ (otherBestHand.moneyWon == nil)) return NO; // xor
    else if (![self.moneyWon isEqualToNumber:otherBestHand.moneyWon]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRDate" forKey:@"datePlayed"];
    [dictionary setObject:@"NSString" forKey:@"hand"];
    [dictionary setObject:@"NSString" forKey:@"handBeat"];
    [dictionary setObject:@"JRDecimal" forKey:@"moneyWon"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_datePlayed release];
    [_hand release];
    [_handBeat release];
    [_moneyWon release];

    [super dealloc];
}
@end
