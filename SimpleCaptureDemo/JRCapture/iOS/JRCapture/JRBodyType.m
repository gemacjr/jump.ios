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


#import "JRBodyType.h"

@interface JRBodyType ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRBodyType
{
    NSString *_build;
    NSString *_color;
    NSString *_eyeColor;
    NSString *_hairColor;
    NSNumber *_height;
}
@dynamic build;
@dynamic color;
@dynamic eyeColor;
@dynamic hairColor;
@dynamic height;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)build
{
    return _build;
}

- (void)setBuild:(NSString *)newBuild
{
    [self.dirtyPropertySet addObject:@"build"];
    _build = [newBuild copy];
}

- (NSString *)color
{
    return _color;
}

- (void)setColor:(NSString *)newColor
{
    [self.dirtyPropertySet addObject:@"color"];
    _color = [newColor copy];
}

- (NSString *)eyeColor
{
    return _eyeColor;
}

- (void)setEyeColor:(NSString *)newEyeColor
{
    [self.dirtyPropertySet addObject:@"eyeColor"];
    _eyeColor = [newEyeColor copy];
}

- (NSString *)hairColor
{
    return _hairColor;
}

- (void)setHairColor:(NSString *)newHairColor
{
    [self.dirtyPropertySet addObject:@"hairColor"];
    _hairColor = [newHairColor copy];
}

- (NSNumber *)height
{
    return _height;
}

- (void)setHeight:(NSNumber *)newHeight
{
    [self.dirtyPropertySet addObject:@"height"];
    _height = [newHeight copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)bodyType
{
    return [[[JRBodyType alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRBodyType *bodyTypeCopy =
                [[JRBodyType allocWithZone:zone] init];

    bodyTypeCopy.captureObjectPath = self.captureObjectPath;

    bodyTypeCopy.build = self.build;
    bodyTypeCopy.color = self.color;
    bodyTypeCopy.eyeColor = self.eyeColor;
    bodyTypeCopy.hairColor = self.hairColor;
    bodyTypeCopy.height = self.height;

    bodyTypeCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    [bodyTypeCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [bodyTypeCopy.dirtyArraySet setSet:self.dirtyPropertySet];

    return bodyTypeCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.build ? self.build : [NSNull null])
             forKey:@"build"];
    [dict setObject:(self.color ? self.color : [NSNull null])
             forKey:@"color"];
    [dict setObject:(self.eyeColor ? self.eyeColor : [NSNull null])
             forKey:@"eyeColor"];
    [dict setObject:(self.hairColor ? self.hairColor : [NSNull null])
             forKey:@"hairColor"];
    [dict setObject:(self.height ? self.height : [NSNull null])
             forKey:@"height"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRBodyType *bodyType = [JRBodyType bodyType];

    bodyType.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"bodyType"];
// TODO: Is this safe to assume?
    bodyType.canBeUpdatedOrReplaced = YES;

    bodyType.build =
        [dictionary objectForKey:@"build"] != [NSNull null] ? 
        [dictionary objectForKey:@"build"] : nil;

    bodyType.color =
        [dictionary objectForKey:@"color"] != [NSNull null] ? 
        [dictionary objectForKey:@"color"] : nil;

    bodyType.eyeColor =
        [dictionary objectForKey:@"eyeColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"eyeColor"] : nil;

    bodyType.hairColor =
        [dictionary objectForKey:@"hairColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"hairColor"] : nil;

    bodyType.height =
        [dictionary objectForKey:@"height"] != [NSNull null] ? 
        [dictionary objectForKey:@"height"] : nil;

    [bodyType.dirtyPropertySet removeAllObjects];
    [bodyType.dirtyArraySet removeAllObjects];
    
    return bodyType;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"bodyType"];

    if ([dictionary objectForKey:@"build"])
        self.build = [dictionary objectForKey:@"build"] != [NSNull null] ? 
            [dictionary objectForKey:@"build"] : nil;

    if ([dictionary objectForKey:@"color"])
        self.color = [dictionary objectForKey:@"color"] != [NSNull null] ? 
            [dictionary objectForKey:@"color"] : nil;

    if ([dictionary objectForKey:@"eyeColor"])
        self.eyeColor = [dictionary objectForKey:@"eyeColor"] != [NSNull null] ? 
            [dictionary objectForKey:@"eyeColor"] : nil;

    if ([dictionary objectForKey:@"hairColor"])
        self.hairColor = [dictionary objectForKey:@"hairColor"] != [NSNull null] ? 
            [dictionary objectForKey:@"hairColor"] : nil;

    if ([dictionary objectForKey:@"height"])
        self.height = [dictionary objectForKey:@"height"] != [NSNull null] ? 
            [dictionary objectForKey:@"height"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"bodyType"];

    self.build =
        [dictionary objectForKey:@"build"] != [NSNull null] ? 
        [dictionary objectForKey:@"build"] : nil;

    self.color =
        [dictionary objectForKey:@"color"] != [NSNull null] ? 
        [dictionary objectForKey:@"color"] : nil;

    self.eyeColor =
        [dictionary objectForKey:@"eyeColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"eyeColor"] : nil;

    self.hairColor =
        [dictionary objectForKey:@"hairColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"hairColor"] : nil;

    self.height =
        [dictionary objectForKey:@"height"] != [NSNull null] ? 
        [dictionary objectForKey:@"height"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"build"])
        [dict setObject:(self.build ? self.build : [NSNull null]) forKey:@"build"];

    if ([self.dirtyPropertySet containsObject:@"color"])
        [dict setObject:(self.color ? self.color : [NSNull null]) forKey:@"color"];

    if ([self.dirtyPropertySet containsObject:@"eyeColor"])
        [dict setObject:(self.eyeColor ? self.eyeColor : [NSNull null]) forKey:@"eyeColor"];

    if ([self.dirtyPropertySet containsObject:@"hairColor"])
        [dict setObject:(self.hairColor ? self.hairColor : [NSNull null]) forKey:@"hairColor"];

    if ([self.dirtyPropertySet containsObject:@"height"])
        [dict setObject:(self.height ? self.height : [NSNull null]) forKey:@"height"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.build ? self.build : [NSNull null]) forKey:@"build"];
    [dict setObject:(self.color ? self.color : [NSNull null]) forKey:@"color"];
    [dict setObject:(self.eyeColor ? self.eyeColor : [NSNull null]) forKey:@"eyeColor"];
    [dict setObject:(self.hairColor ? self.hairColor : [NSNull null]) forKey:@"hairColor"];
    [dict setObject:(self.height ? self.height : [NSNull null]) forKey:@"height"];

    return dict;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"build"];
    [dict setObject:@"NSString" forKey:@"color"];
    [dict setObject:@"NSString" forKey:@"eyeColor"];
    [dict setObject:@"NSString" forKey:@"hairColor"];
    [dict setObject:@"NSNumber" forKey:@"height"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_build release];
    [_color release];
    [_eyeColor release];
    [_hairColor release];
    [_height release];

    [super dealloc];
}
@end
