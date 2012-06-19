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


#import "JROinonipL1PluralElement.h"

@interface JROinonipL1PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROinonipL1PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JROinonipL2Object *_oinonipL2Object;
}
@dynamic string1;
@dynamic string2;
@dynamic oinonipL2Object;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)string1
{
    return _string1;
}

- (void)setString1:(NSString *)newString1
{
    [self.dirtyPropertySet addObject:@"string1"];

    [_string1 autorelease];
    _string1 = [newString1 copy];
}

- (NSString *)string2
{
    return _string2;
}

- (void)setString2:(NSString *)newString2
{
    [self.dirtyPropertySet addObject:@"string2"];

    [_string2 autorelease];
    _string2 = [newString2 copy];
}

- (JROinonipL2Object *)oinonipL2Object
{
    return _oinonipL2Object;
}

- (void)setOinonipL2Object:(JROinonipL2Object *)newOinonipL2Object
{
    [self.dirtyPropertySet addObject:@"oinonipL2Object"];

    [_oinonipL2Object autorelease];
    _oinonipL2Object = [newOinonipL2Object retain];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;

        _oinonipL2Object = [[JROinonipL2Object alloc] init];

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", @"oinonipL2Object", nil]];
    }
    return self;
}

+ (id)oinonipL1PluralElement
{
    return [[[JROinonipL1PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROinonipL1PluralElement *oinonipL1PluralElementCopy = (JROinonipL1PluralElement *)[super copy];

    oinonipL1PluralElementCopy.string1 = self.string1;
    oinonipL1PluralElementCopy.string2 = self.string2;
    oinonipL1PluralElementCopy.oinonipL2Object = self.oinonipL2Object;

    return oinonipL1PluralElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.oinonipL2Object ? [self.oinonipL2Object toDictionary] : [NSNull null])
             forKey:@"oinonipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)oinonipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROinonipL1PluralElement *oinonipL1PluralElement = [JROinonipL1PluralElement oinonipL1PluralElement];

    oinonipL1PluralElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"oinonipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    oinonipL1PluralElement.canBeUpdatedOrReplaced = YES;

    oinonipL1PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    oinonipL1PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    oinonipL1PluralElement.oinonipL2Object =
        [dictionary objectForKey:@"oinonipL2Object"] != [NSNull null] ? 
        [JROinonipL2Object oinonipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinonipL2Object"] withPath:oinonipL1PluralElement.captureObjectPath] : nil;

    [oinonipL1PluralElement.dirtyPropertySet removeAllObjects];
    [oinonipL1PluralElement.dirtyArraySet removeAllObjects];
    
    return oinonipL1PluralElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"oinonipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"oinonipL2Object"] == [NSNull null])
        self.oinonipL2Object = nil;
    else if ([dictionary objectForKey:@"oinonipL2Object"] && !self.oinonipL2Object)
        self.oinonipL2Object = [JROinonipL2Object oinonipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinonipL2Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"oinonipL2Object"])
        [self.oinonipL2Object updateFromDictionary:[dictionary objectForKey:@"oinonipL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"oinonipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"oinonipL2Object"] || [dictionary objectForKey:@"oinonipL2Object"] == [NSNull null])
        self.oinonipL2Object = nil;
    else if (!self.oinonipL2Object)
        self.oinonipL2Object = [JROinonipL2Object oinonipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"oinonipL2Object"] withPath:self.captureObjectPath];
    else
        [self.oinonipL2Object replaceFromDictionary:[dictionary objectForKey:@"oinonipL2Object"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"oinonipL2Object"])
        [dict setObject:(self.oinonipL2Object ?
                              [self.oinonipL2Object toReplaceDictionaryIncludingArrays:NO] :
                              [[JROinonipL2Object oinonipL2Object] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */
                 forKey:@"oinonipL2Object"];
    else if ([self.oinonipL2Object needsUpdate])
        [dict setObject:[self.oinonipL2Object toUpdateDictionary]
                 forKey:@"oinonipL2Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [dict setObject:(self.oinonipL2Object ?
                          [self.oinonipL2Object toReplaceDictionaryIncludingArrays:YES] :
                          [[JROinonipL2Object oinonipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"oinonipL2Object"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.oinonipL2Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOinonipL1PluralElement:(JROinonipL1PluralElement *)otherOinonipL1PluralElement
{
    if (!self.string1 && !otherOinonipL1PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherOinonipL1PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherOinonipL1PluralElement.string1]) return NO;

    if (!self.string2 && !otherOinonipL1PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherOinonipL1PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherOinonipL1PluralElement.string2]) return NO;

    if (!self.oinonipL2Object && !otherOinonipL1PluralElement.oinonipL2Object) /* Keep going... */;
    else if (!self.oinonipL2Object && [otherOinonipL1PluralElement.oinonipL2Object isEqualToOinonipL2Object:[JROinonipL2Object oinonipL2Object]]) /* Keep going... */;
    else if (!otherOinonipL1PluralElement.oinonipL2Object && [self.oinonipL2Object isEqualToOinonipL2Object:[JROinonipL2Object oinonipL2Object]]) /* Keep going... */;
    else if (![self.oinonipL2Object isEqualToOinonipL2Object:otherOinonipL1PluralElement.oinonipL2Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"JROinonipL2Object" forKey:@"oinonipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_oinonipL2Object release];

    [super dealloc];
}
@end
