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

@interface JROnipLevelTwo (OnipLevelTwoInternalMethods)
+ (id)onipLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (BOOL)isEqualToOnipLevelTwo:(JROnipLevelTwo *)otherOnipLevelTwo;
@end

@interface JROnipLevelOneElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipLevelOneElement
{
    JRObjectId *_onipLevelOneElementId;
    NSString *_level;
    NSString *_name;
    JROnipLevelTwo *_onipLevelTwo;
}
@synthesize canBeUpdatedOrReplaced;

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
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;

        _onipLevelTwo = [[JROnipLevelTwo alloc] init];

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"onipLevelOneElementId", @"level", @"name", @"onipLevelTwo", nil]];
    }
    return self;
}

+ (id)onipLevelOneElement
{
    return [[[JROnipLevelOneElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipLevelOneElement *onipLevelOneElementCopy = (JROnipLevelOneElement *)[super copyWithZone:zone];

    onipLevelOneElementCopy.onipLevelOneElementId = self.onipLevelOneElementId;
    onipLevelOneElementCopy.level = self.level;
    onipLevelOneElementCopy.name = self.name;
    onipLevelOneElementCopy.onipLevelTwo = self.onipLevelTwo;

    return onipLevelOneElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.onipLevelOneElementId ? [NSNumber numberWithInteger:[self.onipLevelOneElementId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.onipLevelTwo ? [self.onipLevelTwo toDictionary] : [NSNull null])
             forKey:@"onipLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)onipLevelOneElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROnipLevelOneElement *onipLevelOneElement = [JROnipLevelOneElement onipLevelOneElement];

    onipLevelOneElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    onipLevelOneElement.canBeUpdatedOrReplaced = YES;

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
        [JROnipLevelTwo onipLevelTwoObjectFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:onipLevelOneElement.captureObjectPath] : nil;

    [onipLevelOneElement.dirtyPropertySet removeAllObjects];
    
    return onipLevelOneElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.onipLevelOneElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"onipLevelTwo"] == [NSNull null])
        self.onipLevelTwo = nil;
    else if ([dictionary objectForKey:@"onipLevelTwo"] && !self.onipLevelTwo)
        self.onipLevelTwo = [JROnipLevelTwo onipLevelTwoObjectFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"onipLevelTwo"])
        [self.onipLevelTwo updateFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
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
        self.onipLevelTwo = [JROnipLevelTwo onipLevelTwoObjectFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:self.captureObjectPath];
    else
        [self.onipLevelTwo replaceFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"onipLevelTwo"])
        [dict setObject:(self.onipLevelTwo ?
                              [self.onipLevelTwo toReplaceDictionaryIncludingArrays:NO] :
                              [[JROnipLevelTwo onipLevelTwo] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */
                 forKey:@"onipLevelTwo"];
    else if ([self.onipLevelTwo needsUpdate])
        [dict setObject:[self.onipLevelTwo toUpdateDictionary]
                 forKey:@"onipLevelTwo"];

    return dict;
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [dict setObject:(self.onipLevelTwo ?
                          [self.onipLevelTwo toReplaceDictionaryIncludingArrays:YES] :
                          [[JROnipLevelTwo onipLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"onipLevelTwo"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.onipLevelTwo needsUpdate])
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
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"onipLevelOneElementId"];
    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JROnipLevelTwo" forKey:@"onipLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
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
