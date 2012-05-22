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


#import "JROnipLevelOneElement.h"

@interface JROnipLevelOneElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipLevelOneElement
{
    JRObjectId *_onipLevelOneId;
    NSString *_level;
    NSString *_name;
    JROnipLevelTwo *_onipLevelTwo;
}
@dynamic onipLevelOneId;
@dynamic level;
@dynamic name;
@dynamic onipLevelTwo;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)onipLevelOneId
{
    return _onipLevelOneId;
}

- (void)setOnipLevelOneId:(JRObjectId *)newOnipLevelOneId
{
    [self.dirtyPropertySet addObject:@"onipLevelOneId"];
    _onipLevelOneId = [newOnipLevelOneId copy];
}

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];
    _level = [newLevel copy];
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

- (JROnipLevelTwo *)onipLevelTwo
{
    return _onipLevelTwo;
}

- (void)setOnipLevelTwo:(JROnipLevelTwo *)newOnipLevelTwo
{
    [self.dirtyPropertySet addObject:@"onipLevelTwo"];
    _onipLevelTwo = [newOnipLevelTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)onipLevelOne
{
    return [[[JROnipLevelOneElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JROnipLevelOneElement *onipLevelOneCopy =
                [[JROnipLevelOneElement allocWithZone:zone] init];

    onipLevelOneCopy.captureObjectPath = self.captureObjectPath;

    onipLevelOneCopy.onipLevelOneId = self.onipLevelOneId;
    onipLevelOneCopy.level = self.level;
    onipLevelOneCopy.name = self.name;
    onipLevelOneCopy.onipLevelTwo = self.onipLevelTwo;
    // TODO: Necessary??
    onipLevelOneCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [onipLevelOneCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [onipLevelOneCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return onipLevelOneCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.onipLevelOneId ? [NSNumber numberWithInteger:[self.onipLevelOneId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.onipLevelTwo ? [self.onipLevelTwo toDictionary] : [NSNull null])
             forKey:@"onipLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)onipLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROnipLevelOneElement *onipLevelOne = [JROnipLevelOneElement onipLevelOne];

    onipLevelOne.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    onipLevelOne.canBeUpdatedOrReplaced = YES;

    onipLevelOne.onipLevelOneId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    onipLevelOne.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    onipLevelOne.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    onipLevelOne.onipLevelTwo =
        [dictionary objectForKey:@"onipLevelTwo"] != [NSNull null] ? 
        [JROnipLevelTwo onipLevelTwoObjectFromDictionary:[dictionary objectForKey:@"onipLevelTwo"] withPath:onipLevelOne.captureObjectPath] : nil;

    [onipLevelOne.dirtyPropertySet removeAllObjects];
    [onipLevelOne.dirtyArraySet removeAllObjects];
    
    return onipLevelOne;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.onipLevelOneId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
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
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipLevelOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.onipLevelOneId =
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
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
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
                              [self.onipLevelTwo toUpdateDictionary] :
                              [[JROnipLevelTwo onipLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"onipLevelTwo"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.onipLevelTwo ?
                          [self.onipLevelTwo toReplaceDictionary] :
                          [[JROnipLevelTwo onipLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"onipLevelTwo"];

    return dict;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"onipLevelOneId"];
    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JROnipLevelTwo" forKey:@"onipLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_onipLevelOneId release];
    [_level release];
    [_name release];
    [_onipLevelTwo release];

    [super dealloc];
}
@end
