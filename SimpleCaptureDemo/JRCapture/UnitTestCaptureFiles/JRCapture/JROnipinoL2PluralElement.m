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


#import "JROnipinoL2PluralElement.h"

@interface JROnipinoL2PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipinoL2PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JROnipinoL3Object *_onipinoL3Object;
}
@dynamic string1;
@dynamic string2;
@dynamic onipinoL3Object;
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

- (JROnipinoL3Object *)onipinoL3Object
{
    return _onipinoL3Object;
}

- (void)setOnipinoL3Object:(JROnipinoL3Object *)newOnipinoL3Object
{
    [self.dirtyPropertySet addObject:@"onipinoL3Object"];
    _onipinoL3Object = [newOnipinoL3Object copy];
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

+ (id)onipinoL2PluralElement
{
    return [[[JROnipinoL2PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JROnipinoL2PluralElement *onipinoL2PluralElementCopy =
                [[JROnipinoL2PluralElement allocWithZone:zone] init];

    onipinoL2PluralElementCopy.captureObjectPath = self.captureObjectPath;

    onipinoL2PluralElementCopy.string1 = self.string1;
    onipinoL2PluralElementCopy.string2 = self.string2;
    onipinoL2PluralElementCopy.onipinoL3Object = self.onipinoL3Object;
    // TODO: Necessary??
    onipinoL2PluralElementCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [onipinoL2PluralElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [onipinoL2PluralElementCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return onipinoL2PluralElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.onipinoL3Object ? [self.onipinoL3Object toDictionary] : [NSNull null])
             forKey:@"onipinoL3Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)onipinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROnipinoL2PluralElement *onipinoL2PluralElement = [JROnipinoL2PluralElement onipinoL2PluralElement];

    onipinoL2PluralElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinoL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    onipinoL2PluralElement.canBeUpdatedOrReplaced = YES;

    onipinoL2PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    onipinoL2PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    onipinoL2PluralElement.onipinoL3Object =
        [dictionary objectForKey:@"onipinoL3Object"] != [NSNull null] ? 
        [JROnipinoL3Object onipinoL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:onipinoL2PluralElement.captureObjectPath] : nil;

    [onipinoL2PluralElement.dirtyPropertySet removeAllObjects];
    [onipinoL2PluralElement.dirtyArraySet removeAllObjects];
    
    return onipinoL2PluralElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinoL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"onipinoL3Object"] == [NSNull null])
        self.onipinoL3Object = nil;
    else if ([dictionary objectForKey:@"onipinoL3Object"] && !self.onipinoL3Object)
        self.onipinoL3Object = [JROnipinoL3Object onipinoL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"onipinoL3Object"])
        [self.onipinoL3Object updateFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinoL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"onipinoL3Object"] || [dictionary objectForKey:@"onipinoL3Object"] == [NSNull null])
        self.onipinoL3Object = nil;
    else if (!self.onipinoL3Object)
        self.onipinoL3Object = [JROnipinoL3Object onipinoL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath];
    else
        [self.onipinoL3Object replaceFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"onipinoL3Object"] || [self.onipinoL3Object needsUpdate])
        [dict setObject:(self.onipinoL3Object ?
                              [self.onipinoL3Object toUpdateDictionary] :
                              [[JROnipinoL3Object onipinoL3Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"onipinoL3Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];
    [dict setObject:(self.onipinoL3Object ?
                          [self.onipinoL3Object toReplaceDictionary] :
                          [[JROnipinoL3Object onipinoL3Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"onipinoL3Object"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.onipinoL3Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOnipinoL2PluralElement:(JROnipinoL2PluralElement *)otherOnipinoL2PluralElement
{
    if ((self.string1 == nil) ^ (otherOnipinoL2PluralElement.string1 == nil)) // xor
        return NO;

    if (![self.string1 isEqualToString:otherOnipinoL2PluralElement.string1])
        return NO;

    if ((self.string2 == nil) ^ (otherOnipinoL2PluralElement.string2 == nil)) // xor
        return NO;

    if (![self.string2 isEqualToString:otherOnipinoL2PluralElement.string2])
        return NO;

    if ((self.onipinoL3Object == nil) ^ (otherOnipinoL2PluralElement.onipinoL3Object == nil)) // xor
        return NO;

    if (![self.onipinoL3Object isEqualToOnipinoL3Object:otherOnipinoL2PluralElement.onipinoL3Object])
        return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"JROnipinoL3Object" forKey:@"onipinoL3Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_onipinoL3Object release];

    [super dealloc];
}
@end
