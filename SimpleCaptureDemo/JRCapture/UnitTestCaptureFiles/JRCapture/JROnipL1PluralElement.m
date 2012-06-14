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


#import "JROnipL1PluralElement.h"

@interface JROnipL1PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipL1PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JROnipL2Object *_onipL2Object;
}
@dynamic string1;
@dynamic string2;
@dynamic onipL2Object;
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

- (JROnipL2Object *)onipL2Object
{
    return _onipL2Object;
}

- (void)setOnipL2Object:(JROnipL2Object *)newOnipL2Object
{
    [self.dirtyPropertySet addObject:@"onipL2Object"];

    [_onipL2Object autorelease];
    _onipL2Object = [newOnipL2Object retain];
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

+ (id)onipL1PluralElement
{
    return [[[JROnipL1PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipL1PluralElement *onipL1PluralElementCopy = (JROnipL1PluralElement *)[super copy];

    onipL1PluralElementCopy.string1 = self.string1;
    onipL1PluralElementCopy.string2 = self.string2;
    onipL1PluralElementCopy.onipL2Object = self.onipL2Object;

    return onipL1PluralElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.onipL2Object ? [self.onipL2Object toDictionary] : [NSNull null])
             forKey:@"onipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JROnipL1PluralElement *onipL1PluralElement = [JROnipL1PluralElement onipL1PluralElement];

    onipL1PluralElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    onipL1PluralElement.canBeUpdatedOrReplaced = YES;

    onipL1PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    onipL1PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    onipL1PluralElement.onipL2Object =
        [dictionary objectForKey:@"onipL2Object"] != [NSNull null] ? 
        [JROnipL2Object onipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:onipL1PluralElement.captureObjectPath] : nil;

    [onipL1PluralElement.dirtyPropertySet removeAllObjects];
    [onipL1PluralElement.dirtyArraySet removeAllObjects];
    
    return onipL1PluralElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"onipL2Object"] == [NSNull null])
        self.onipL2Object = nil;
    else if ([dictionary objectForKey:@"onipL2Object"] && !self.onipL2Object)
        self.onipL2Object = [JROnipL2Object onipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"onipL2Object"])
        [self.onipL2Object updateFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"onipL2Object"] || [dictionary objectForKey:@"onipL2Object"] == [NSNull null])
        self.onipL2Object = nil;
    else if (!self.onipL2Object)
        self.onipL2Object = [JROnipL2Object onipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath];
    else
        [self.onipL2Object replaceFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"onipL2Object"])
        [dict setObject:(self.onipL2Object ?
                              [self.onipL2Object toReplaceDictionaryIncludingArrays:NO] :
                              [[JROnipL2Object onipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"onipL2Object"];
    else if ([self.onipL2Object needsUpdate])
        [dict setObject:[self.onipL2Object toUpdateDictionary]
                 forKey:@"onipL2Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];
    [dict setObject:(self.onipL2Object ?
                          [self.onipL2Object toReplaceDictionaryIncludingArrays:YES] :
                          [[JROnipL2Object onipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"onipL2Object"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.onipL2Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOnipL1PluralElement:(JROnipL1PluralElement *)otherOnipL1PluralElement
{
    if (!self.string1 && !otherOnipL1PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherOnipL1PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherOnipL1PluralElement.string1]) return NO;

    if (!self.string2 && !otherOnipL1PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherOnipL1PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherOnipL1PluralElement.string2]) return NO;

    if (!self.onipL2Object && !otherOnipL1PluralElement.onipL2Object) /* Keep going... */;
    else if (!self.onipL2Object && [otherOnipL1PluralElement.onipL2Object isEqualToOnipL2Object:[JROnipL2Object onipL2Object]]) /* Keep going... */;
    else if (!otherOnipL1PluralElement.onipL2Object && [self.onipL2Object isEqualToOnipL2Object:[JROnipL2Object onipL2Object]]) /* Keep going... */;
    else if (![self.onipL2Object isEqualToOnipL2Object:otherOnipL1PluralElement.onipL2Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"JROnipL2Object" forKey:@"onipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_onipL2Object release];

    [super dealloc];
}
@end
