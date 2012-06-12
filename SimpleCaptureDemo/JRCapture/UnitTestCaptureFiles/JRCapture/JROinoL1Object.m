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


#import "JROinoL1Object.h"

@interface JROinoL1Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROinoL1Object
{
    NSString *_string1;
    NSString *_string2;
    JROinoL2Object *_oinoL2Object;
}
@dynamic string1;
@dynamic string2;
@dynamic oinoL2Object;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)string1
{
    return _string1;
}

- (void)setString1:(NSString *)newString1
{
    [self.dirtyPropertySet addObject:@"string1"];
    _string1 = [newString1 copy];
}

- (NSString *)string2
{
    return _string2;
}

- (void)setString2:(NSString *)newString2
{
    [self.dirtyPropertySet addObject:@"string2"];
    _string2 = [newString2 copy];
}

- (JROinoL2Object *)oinoL2Object
{
    return _oinoL2Object;
}

- (void)setOinoL2Object:(JROinoL2Object *)newOinoL2Object
{
    [self.dirtyPropertySet addObject:@"oinoL2Object"];
    _oinoL2Object = [newOinoL2Object copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/oinoL1Object";
        self.canBeUpdatedOrReplaced = YES;
    }
    return self;
}

+ (id)oinoL1Object
{
    return [[[JROinoL1Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JROinoL1Object *oinoL1ObjectCopy =
                [[JROinoL1Object allocWithZone:zone] init];

    oinoL1ObjectCopy.captureObjectPath = self.captureObjectPath;

    oinoL1ObjectCopy.string1 = self.string1;
    oinoL1ObjectCopy.string2 = self.string2;
    oinoL1ObjectCopy.oinoL2Object = self.oinoL2Object;
    // TODO: Necessary??
    oinoL1ObjectCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [oinoL1ObjectCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [oinoL1ObjectCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return oinoL1ObjectCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.oinoL2Object ? [self.oinoL2Object toDictionary] : [NSNull null])
             forKey:@"oinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)oinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROinoL1Object *oinoL1Object = [JROinoL1Object oinoL1Object];


    oinoL1Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    oinoL1Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    oinoL1Object.oinoL2Object =
        [dictionary objectForKey:@"oinoL2Object"] != [NSNull null] ? 
        [JROinoL2Object oinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL2Object"] withPath:oinoL1Object.captureObjectPath] : nil;

    [oinoL1Object.dirtyPropertySet removeAllObjects];
    [oinoL1Object.dirtyArraySet removeAllObjects];
    
    return oinoL1Object;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"oinoL2Object"] == [NSNull null])
        self.oinoL2Object = nil;
    else if ([dictionary objectForKey:@"oinoL2Object"] && !self.oinoL2Object)
        self.oinoL2Object = [JROinoL2Object oinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL2Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"oinoL2Object"])
        [self.oinoL2Object updateFromDictionary:[dictionary objectForKey:@"oinoL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"oinoL2Object"] || [dictionary objectForKey:@"oinoL2Object"] == [NSNull null])
        self.oinoL2Object = nil;
    else if (!self.oinoL2Object)
        self.oinoL2Object = [JROinoL2Object oinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoL2Object"] withPath:self.captureObjectPath];
    else
        [self.oinoL2Object replaceFromDictionary:[dictionary objectForKey:@"oinoL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if ([self.dirtyPropertySet containsObject:@"oinoL2Object"] || [self.oinoL2Object needsUpdate])
        [dict setObject:(self.oinoL2Object ?
                              [self.oinoL2Object toUpdateDictionary] :
                              [[JROinoL2Object oinoL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"oinoL2Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];
    [dict setObject:(self.oinoL2Object ?
                          [self.oinoL2Object toReplaceDictionary] :
                          [[JROinoL2Object oinoL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"oinoL2Object"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.oinoL2Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOinoL1Object:(JROinoL1Object *)otherOinoL1Object
{
    if ((self.string1 == nil) ^ (otherOinoL1Object.string1 == nil)) // xor
        return NO;

    if (![self.string1 isEqualToString:otherOinoL1Object.string1])
        return NO;

    if ((self.string2 == nil) ^ (otherOinoL1Object.string2 == nil)) // xor
        return NO;

    if (![self.string2 isEqualToString:otherOinoL1Object.string2])
        return NO;

    if (!self.oinoL2Object && !otherOinoL1Object.oinoL2Object) /* Keep going... */;
    else if (!self.oinoL2Object && [otherOinoL1Object.oinoL2Object isEqualToOinoL2Object:[JROinoL2Object oinoL2Object]]) /* Keep going... */;
    else if (!otherOinoL1Object.oinoL2Object && [self.oinoL2Object isEqualToOinoL2Object:[JROinoL2Object oinoL2Object]]) /* Keep going... */;
    else if (![self.oinoL2Object isEqualToOinoL2Object:otherOinoL1Object.oinoL2Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"JROinoL2Object" forKey:@"oinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_oinoL2Object release];

    [super dealloc];
}
@end
