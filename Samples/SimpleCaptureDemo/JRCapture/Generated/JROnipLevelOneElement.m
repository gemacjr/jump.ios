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
#import "JROnipLevelOneElement.h"

@interface JROnipLevelTwo (JROnipLevelTwo_InternalMethods)
+ (id)onipLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipLevelTwo:(JROnipLevelTwo *)otherOnipLevelTwo;
@end

@interface JROnipLevelOneElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JROnipLevelOneElement
{
    JRObjectId *_onipLevelOneElementId;
    NSString *_level;
    NSString *_name;
    JROnipLevelTwo *_onipLevelTwo;
}
@synthesize canBeUpdatedOnCapture;

- (JRObjectId *)onipLevelOneElementId
{
    return _onipLevelOneElementId;
}

- (void)setOnipLevelOneElementId:(JRObjectId *)newOnipLevelOneElementId
{
    [self.dirtyPropertySet addObject:@"onipLevelOneElementId"];

    [_onipLevelOneElementId autorelease];
    _onipLevelOneElementId = [newOnipLevelOneElementId copy];
}

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    [_level autorelease];
    _level = [newLevel copy];
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

- (JROnipLevelTwo *)onipLevelTwo
{
    return _onipLevelTwo;
}

- (void)setOnipLevelTwo:(JROnipLevelTwo *)newOnipLevelTwo
{
    [self.dirtyPropertySet addObject:@"onipLevelTwo"];

    [_onipLevelTwo autorelease];
    _onipLevelTwo = [newOnipLevelTwo retain];

    [_onipLevelTwo setAllPropertiesToDirty];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _onipLevelTwo = [[JROnipLevelTwo alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)onipLevelOneElement
{
    return [[[JROnipLevelOneElement alloc] init] autorelease];
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.onipLevelOneElementId ? [NSNumber numberWithInteger:[self.onipLevelOneElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.level ? self.level : [NSNull null])
                   forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.onipLevelTwo ? [self.onipLevelTwo toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipLevelTwo"];

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

+ (id)onipLevelOneElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JROnipLevelOneElement *onipLevelOneElement = [JROnipLevelOneElement onipLevelOneElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        onipLevelOneElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        onipLevelOneElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        onipLevelOneElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        onipLevelOneElement.canBeUpdatedOnCapture = YES;
    }

    onipLevelOneElement.onipLevelOneElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    onipLevelOneElement.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    onipLevelOneElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    onipLevelOneElement.onipLevelTwo =
        [dictionary objectForKey:@"onipLevelTwo"] != [NSNull null] ? 
        [JROnipLevelTwo onipLevelTwoObjectFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:onipLevelOneElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [onipLevelOneElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [onipLevelOneElement.dirtyPropertySet removeAllObjects];
    
    return onipLevelOneElement;
}

+ (id)onipLevelOneElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JROnipLevelOneElement onipLevelOneElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.onipLevelOneElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    if (![dictionary objectForKey:@"onipLevelTwo"] || [dictionary objectForKey:@"onipLevelTwo"] == [NSNull null])
        self.onipLevelTwo = nil;
    else if (!self.onipLevelTwo)
        self.onipLevelTwo = [JROnipLevelTwo onipLevelTwoObjectFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.onipLevelTwo replaceFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"onipLevelOneElementId", @"level", @"name", @"onipLevelTwo", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"onipLevelOneElement"];

    if (self.onipLevelTwo)
        [snapshotDictionary setObject:[self.onipLevelTwo snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"onipLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"onipLevelOneElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"onipLevelOneElement"] allObjects]];

    if ([snapshotDictionary objectForKey:@"onipLevelTwo"])
        [self.onipLevelTwo restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"onipLevelTwo"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"onipLevelTwo"])
        [dictionary setObject:(self.onipLevelTwo ?
                              [self.onipLevelTwo toUpdateDictionary] :
                              [[JROnipLevelTwo onipLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"onipLevelTwo"];
    else if ([self.onipLevelTwo needsUpdate])
        [dictionary setObject:[self.onipLevelTwo toUpdateDictionary]
                       forKey:@"onipLevelTwo"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [dictionary setObject:(self.onipLevelTwo ?
                          [self.onipLevelTwo toReplaceDictionary] :
                          [[JROnipLevelTwo onipLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"onipLevelTwo"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.onipLevelTwo needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOnipLevelOneElement:(JROnipLevelOneElement *)otherOnipLevelOneElement
{
    if (!self.level && !otherOnipLevelOneElement.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherOnipLevelOneElement.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherOnipLevelOneElement.level]) return NO;

    if (!self.name && !otherOnipLevelOneElement.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherOnipLevelOneElement.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherOnipLevelOneElement.name]) return NO;

    if (!self.onipLevelTwo && !otherOnipLevelOneElement.onipLevelTwo) /* Keep going... */;
    else if (!self.onipLevelTwo && [otherOnipLevelOneElement.onipLevelTwo isEqualToOnipLevelTwo:[JROnipLevelTwo onipLevelTwo]]) /* Keep going... */;
    else if (!otherOnipLevelOneElement.onipLevelTwo && [self.onipLevelTwo isEqualToOnipLevelTwo:[JROnipLevelTwo onipLevelTwo]]) /* Keep going... */;
    else if (![self.onipLevelTwo isEqualToOnipLevelTwo:otherOnipLevelOneElement.onipLevelTwo]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"onipLevelOneElementId"];
    [dictionary setObject:@"NSString" forKey:@"level"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"JROnipLevelTwo" forKey:@"onipLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_onipLevelOneElementId release];
    [_level release];
    [_name release];
    [_onipLevelTwo release];

    [super dealloc];
}
@end
