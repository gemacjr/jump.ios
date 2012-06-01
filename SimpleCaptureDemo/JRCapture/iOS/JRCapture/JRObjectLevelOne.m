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


#import "JRObjectLevelOne.h"

@interface JRObjectLevelOne ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRObjectLevelOne
{
    NSString *_level;
    NSString *_name;
    JRObjectLevelTwo *_objectLevelTwo;
}
@dynamic level;
@dynamic name;
@dynamic objectLevelTwo;
@synthesize canBeUpdatedOrReplaced;

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

- (JRObjectLevelTwo *)objectLevelTwo
{
    return _objectLevelTwo;
}

- (void)setObjectLevelTwo:(JRObjectLevelTwo *)newObjectLevelTwo
{
    [self.dirtyPropertySet addObject:@"objectLevelTwo"];
    _objectLevelTwo = [newObjectLevelTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/objectLevelOne";
        self.canBeUpdatedOrReplaced = YES;
    }
    return self;
}

+ (id)objectLevelOne
{
    return [[[JRObjectLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRObjectLevelOne *objectLevelOneCopy =
                [[JRObjectLevelOne allocWithZone:zone] init];

    objectLevelOneCopy.captureObjectPath = self.captureObjectPath;

    objectLevelOneCopy.level = self.level;
    objectLevelOneCopy.name = self.name;
    objectLevelOneCopy.objectLevelTwo = self.objectLevelTwo;
    // TODO: Necessary??
    objectLevelOneCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [objectLevelOneCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [objectLevelOneCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return objectLevelOneCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.objectLevelTwo ? [self.objectLevelTwo toDictionary] : [NSNull null])
             forKey:@"objectLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)objectLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRObjectLevelOne *objectLevelOne = [JRObjectLevelOne objectLevelOne];


    objectLevelOne.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    objectLevelOne.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    objectLevelOne.objectLevelTwo =
        [dictionary objectForKey:@"objectLevelTwo"] != [NSNull null] ? 
        [JRObjectLevelTwo objectLevelTwoObjectFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:objectLevelOne.captureObjectPath] : nil;

    [objectLevelOne.dirtyPropertySet removeAllObjects];
    [objectLevelOne.dirtyArraySet removeAllObjects];
    
    return objectLevelOne;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"objectLevelTwo"] == [NSNull null])
        self.objectLevelTwo = nil;
    else if ([dictionary objectForKey:@"objectLevelTwo"] && !self.objectLevelTwo)
        self.objectLevelTwo = [JRObjectLevelTwo objectLevelTwoObjectFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"objectLevelTwo"])
        [self.objectLevelTwo updateFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    if (![dictionary objectForKey:@"objectLevelTwo"] || [dictionary objectForKey:@"objectLevelTwo"] == [NSNull null])
        self.objectLevelTwo = nil;
    else if (!self.objectLevelTwo)
        self.objectLevelTwo = [JRObjectLevelTwo objectLevelTwoObjectFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath];
    else
        [self.objectLevelTwo replaceFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"objectLevelTwo"] || [self.objectLevelTwo needsUpdate])
        [dict setObject:(self.objectLevelTwo ?
                              [self.objectLevelTwo toUpdateDictionary] :
                              [[JRObjectLevelTwo objectLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"objectLevelTwo"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.objectLevelTwo ?
                          [self.objectLevelTwo toReplaceDictionary] :
                          [[JRObjectLevelTwo objectLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"objectLevelTwo"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.objectLevelTwo needsUpdate])
        return YES;

    return NO;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JRObjectLevelTwo" forKey:@"objectLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_objectLevelTwo release];

    [super dealloc];
}
@end
