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


#import "JROinoinoL1Object.h"

@interface JROinoinoL1Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROinoinoL1Object
{
    NSString *_string1;
    NSString *_string2;
    JROinoinoL2Object *_oinoinoL2Object;
}
@dynamic string1;
@dynamic string2;
@dynamic oinoinoL2Object;
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

- (JROinoinoL2Object *)oinoinoL2Object
{
    return _oinoinoL2Object;
}

- (void)setOinoinoL2Object:(JROinoinoL2Object *)newOinoinoL2Object
{
    [self.dirtyPropertySet addObject:@"oinoinoL2Object"];
    _oinoinoL2Object = [newOinoinoL2Object copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/oinoinoL1Object";
        self.canBeUpdatedOrReplaced = YES;
    }
    return self;
}

+ (id)oinoinoL1Object
{
    return [[[JROinoinoL1Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JROinoinoL1Object *oinoinoL1ObjectCopy =
                [[JROinoinoL1Object allocWithZone:zone] init];

    oinoinoL1ObjectCopy.captureObjectPath = self.captureObjectPath;

    oinoinoL1ObjectCopy.string1 = self.string1;
    oinoinoL1ObjectCopy.string2 = self.string2;
    oinoinoL1ObjectCopy.oinoinoL2Object = self.oinoinoL2Object;
    // TODO: Necessary??
    oinoinoL1ObjectCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [oinoinoL1ObjectCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [oinoinoL1ObjectCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return oinoinoL1ObjectCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.oinoinoL2Object ? [self.oinoinoL2Object toDictionary] : [NSNull null])
             forKey:@"oinoinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)oinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROinoinoL1Object *oinoinoL1Object = [JROinoinoL1Object oinoinoL1Object];


    oinoinoL1Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    oinoinoL1Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    oinoinoL1Object.oinoinoL2Object =
        [dictionary objectForKey:@"oinoinoL2Object"] != [NSNull null] ? 
        [JROinoinoL2Object oinoinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL2Object"] withPath:oinoinoL1Object.captureObjectPath] : nil;

    [oinoinoL1Object.dirtyPropertySet removeAllObjects];
    [oinoinoL1Object.dirtyArraySet removeAllObjects];
    
    return oinoinoL1Object;
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

    if ([dictionary objectForKey:@"oinoinoL2Object"] == [NSNull null])
        self.oinoinoL2Object = nil;
    else if ([dictionary objectForKey:@"oinoinoL2Object"] && !self.oinoinoL2Object)
        self.oinoinoL2Object = [JROinoinoL2Object oinoinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL2Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"oinoinoL2Object"])
        [self.oinoinoL2Object updateFromDictionary:[dictionary objectForKey:@"oinoinoL2Object"] withPath:self.captureObjectPath];

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

    if (![dictionary objectForKey:@"oinoinoL2Object"] || [dictionary objectForKey:@"oinoinoL2Object"] == [NSNull null])
        self.oinoinoL2Object = nil;
    else if (!self.oinoinoL2Object)
        self.oinoinoL2Object = [JROinoinoL2Object oinoinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinoinoL2Object"] withPath:self.captureObjectPath];
    else
        [self.oinoinoL2Object replaceFromDictionary:[dictionary objectForKey:@"oinoinoL2Object"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"oinoinoL2Object"] || [self.oinoinoL2Object needsUpdate])
        [dict setObject:(self.oinoinoL2Object ?
                              [self.oinoinoL2Object toUpdateDictionary] :
                              [[JROinoinoL2Object oinoinoL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"oinoinoL2Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];
    [dict setObject:(self.oinoinoL2Object ?
                          [self.oinoinoL2Object toReplaceDictionary] :
                          [[JROinoinoL2Object oinoinoL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"oinoinoL2Object"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.oinoinoL2Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOinoinoL1Object:(JROinoinoL1Object *)otherOinoinoL1Object
{
    if (!self.string1 && !otherOinoinoL1Object.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherOinoinoL1Object.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherOinoinoL1Object.string1]) return NO;

    if (!self.string2 && !otherOinoinoL1Object.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherOinoinoL1Object.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherOinoinoL1Object.string2]) return NO;

    if (!self.oinoinoL2Object && !otherOinoinoL1Object.oinoinoL2Object) /* Keep going... */;
    else if (!self.oinoinoL2Object && [otherOinoinoL1Object.oinoinoL2Object isEqualToOinoinoL2Object:[JROinoinoL2Object oinoinoL2Object]]) /* Keep going... */;
    else if (!otherOinoinoL1Object.oinoinoL2Object && [self.oinoinoL2Object isEqualToOinoinoL2Object:[JROinoinoL2Object oinoinoL2Object]]) /* Keep going... */;
    else if (![self.oinoinoL2Object isEqualToOinoinoL2Object:otherOinoinoL1Object.oinoinoL2Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"JROinoinoL2Object" forKey:@"oinoinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_oinoinoL2Object release];

    [super dealloc];
}
@end
