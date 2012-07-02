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
#import "JRPinoLevelOne.h"

@interface JRPinoLevelTwo (PinoLevelTwoInternalMethods)
+ (id)pinoLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinoLevelTwo:(JRPinoLevelTwo *)otherPinoLevelTwo;
@end

@interface JRPinoLevelOne ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoLevelOne
{
    NSString *_level;
    NSString *_name;
    JRPinoLevelTwo *_pinoLevelTwo;
}
@synthesize canBeUpdatedOrReplaced;

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

- (JRPinoLevelTwo *)pinoLevelTwo
{
    return _pinoLevelTwo;
}

- (void)setPinoLevelTwo:(JRPinoLevelTwo *)newPinoLevelTwo
{
    [self.dirtyPropertySet addObject:@"pinoLevelTwo"];

    [_pinoLevelTwo autorelease];
    _pinoLevelTwo = [newPinoLevelTwo retain];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne";
        self.canBeUpdatedOrReplaced = YES;

        _pinoLevelTwo = [[JRPinoLevelTwo alloc] init];

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"level", @"name", @"pinoLevelTwo", nil]];
    }
    return self;
}

+ (id)pinoLevelOne
{
    return [[[JRPinoLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinoLevelOne *pinoLevelOneCopy = (JRPinoLevelOne *)[super copyWithZone:zone];

    pinoLevelOneCopy.level = self.level;
    pinoLevelOneCopy.name = self.name;
    pinoLevelOneCopy.pinoLevelTwo = self.pinoLevelTwo;

    return pinoLevelOneCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null])
                   forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.pinoLevelTwo ? [self.pinoLevelTwo toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinoLevelTwo"];

    if (forEncoder)
    {
        [dictionary setObject:[self.dirtyPropertySet allObjects] forKey:@"dirtyPropertySet"];
        [dictionary setObject:self.captureObjectPath forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pinoLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinoLevelOne *pinoLevelOne = [JRPinoLevelOne pinoLevelOne];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinoLevelOne.captureObjectPath      = [dictionary objectForKey:@"captureObjectPath"];
    }

    pinoLevelOne.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pinoLevelOne.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    pinoLevelOne.pinoLevelTwo =
        [dictionary objectForKey:@"pinoLevelTwo"] != [NSNull null] ? 
        [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:pinoLevelOne.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pinoLevelOne.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinoLevelOne.dirtyPropertySet removeAllObjects];
    
    return pinoLevelOne;
}

+ (id)pinoLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinoLevelOne pinoLevelOneObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"pinoLevelTwo"] == [NSNull null])
        self.pinoLevelTwo = nil;
    else if ([dictionary objectForKey:@"pinoLevelTwo"] && !self.pinoLevelTwo)
        self.pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"pinoLevelTwo"])
        [self.pinoLevelTwo updateFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    if (![dictionary objectForKey:@"pinoLevelTwo"] || [dictionary objectForKey:@"pinoLevelTwo"] == [NSNull null])
        self.pinoLevelTwo = nil;
    else if (!self.pinoLevelTwo)
        self.pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.pinoLevelTwo replaceFromDictionary:[dictionary objectForKey:@"pinoLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"pinoLevelTwo"])
        [dictionary setObject:(self.pinoLevelTwo ?
                              [self.pinoLevelTwo toReplaceDictionaryIncludingArrays:NO] :
                              [[JRPinoLevelTwo pinoLevelTwo] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */
                       forKey:@"pinoLevelTwo"];
    else if ([self.pinoLevelTwo needsUpdate])
        [dictionary setObject:[self.pinoLevelTwo toUpdateDictionary]
                       forKey:@"pinoLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [dictionary setObject:(self.pinoLevelTwo ?
                          [self.pinoLevelTwo toReplaceDictionaryIncludingArrays:YES] :
                          [[JRPinoLevelTwo pinoLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                     forKey:@"pinoLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.pinoLevelTwo needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToPinoLevelOne:(JRPinoLevelOne *)otherPinoLevelOne
{
    if (!self.level && !otherPinoLevelOne.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherPinoLevelOne.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherPinoLevelOne.level]) return NO;

    if (!self.name && !otherPinoLevelOne.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherPinoLevelOne.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherPinoLevelOne.name]) return NO;

    if (!self.pinoLevelTwo && !otherPinoLevelOne.pinoLevelTwo) /* Keep going... */;
    else if (!self.pinoLevelTwo && [otherPinoLevelOne.pinoLevelTwo isEqualToPinoLevelTwo:[JRPinoLevelTwo pinoLevelTwo]]) /* Keep going... */;
    else if (!otherPinoLevelOne.pinoLevelTwo && [self.pinoLevelTwo isEqualToPinoLevelTwo:[JRPinoLevelTwo pinoLevelTwo]]) /* Keep going... */;
    else if (![self.pinoLevelTwo isEqualToPinoLevelTwo:otherPinoLevelOne.pinoLevelTwo]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"level"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"JRPinoLevelTwo" forKey:@"pinoLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelTwo release];

    [super dealloc];
}
@end
