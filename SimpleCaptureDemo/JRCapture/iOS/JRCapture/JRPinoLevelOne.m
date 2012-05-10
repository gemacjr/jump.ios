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


#import "JRPinoLevelOne.h"

@interface JRPinoLevelOne ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoLevelOne
{
    NSString *_level;
    NSString *_name;
    JRPinoLevelTwo *_pinoLevelTwo;
}
@dynamic level;
@dynamic name;
@dynamic pinoLevelTwo;
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

- (JRPinoLevelTwo *)pinoLevelTwo
{
    return _pinoLevelTwo;
}

- (void)setPinoLevelTwo:(JRPinoLevelTwo *)newPinoLevelTwo
{
    [self.dirtyPropertySet addObject:@"pinoLevelTwo"];
    _pinoLevelTwo = [newPinoLevelTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne";
        self.canBeUpdatedOrReplaced = YES;
    }
    return self;
}

+ (id)pinoLevelOne
{
    return [[[JRPinoLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPinoLevelOne *pinoLevelOneCopy =
                [[JRPinoLevelOne allocWithZone:zone] init];

    pinoLevelOneCopy.captureObjectPath = self.captureObjectPath;

    pinoLevelOneCopy.level = self.level;
    pinoLevelOneCopy.name = self.name;
    pinoLevelOneCopy.pinoLevelTwo = self.pinoLevelTwo;

    pinoLevelOneCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    [pinoLevelOneCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [pinoLevelOneCopy.dirtyArraySet setSet:self.dirtyPropertySet];

    return pinoLevelOneCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.pinoLevelTwo ? [self.pinoLevelTwo toDictionary] : [NSNull null])
             forKey:@"pinoLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinoLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinoLevelOne *pinoLevelOne = [JRPinoLevelOne pinoLevelOne];

//    pinoLevelOne.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinoLevelOne"];

    pinoLevelOne.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pinoLevelOne.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pinoLevelOne.pinoLevelTwo =
        [dictionary objectForKey:@"pinoLevelTwo"] != [NSNull null] ? 
        [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelTwo"] withPath:pinoLevelOne.captureObjectPath] : nil;

    [pinoLevelOne.dirtyPropertySet removeAllObjects];
    [pinoLevelOne.dirtyArraySet removeAllObjects];
    
    return pinoLevelOne;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
//    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinoLevelOne"];

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"pinoLevelTwo"] == [NSNull null])
        self.pinoLevelTwo = nil;
    else if ([dictionary objectForKey:@"pinoLevelTwo"])
        [self.pinoLevelTwo updateFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
//    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"pinoLevelOne"];

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    if (![dictionary objectForKey:@"pinoLevelTwo"] || [dictionary objectForKey:@"pinoLevelTwo"] == [NSNull null])
        self.pinoLevelTwo = nil;
    else
        [self.pinoLevelTwo replaceFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"pinoLevelTwo"])
        [dict setObject:(self.pinoLevelTwo ? [self.pinoLevelTwo toUpdateDictionary] : [NSNull null]) forKey:@"pinoLevelTwo"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.pinoLevelTwo ? [self.pinoLevelTwo toReplaceDictionary] : [NSNull null]) forKey:@"pinoLevelTwo"];

    return dict;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];
    [dict setObject:@"JRPinoLevelTwo" forKey:@"pinoLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelTwo release];

    [super dealloc];
}
@end
