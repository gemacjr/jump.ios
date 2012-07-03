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
#import "JROnipinoL2PluralElement.h"

@interface JROnipinoL3Object (OnipinoL3ObjectInternalMethods)
+ (id)onipinoL3ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipinoL3Object:(JROnipinoL3Object *)otherOnipinoL3Object;
@end

@interface JROnipinoL2PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipinoL2PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JROnipinoL3Object *_onipinoL3Object;
}
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

- (JROnipinoL3Object *)onipinoL3Object
{
    return _onipinoL3Object;
}

- (void)setOnipinoL3Object:(JROnipinoL3Object *)newOnipinoL3Object
{
    [self.dirtyPropertySet addObject:@"onipinoL3Object"];

    [_onipinoL3Object autorelease];
    _onipinoL3Object = [newOnipinoL3Object retain];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;

        _onipinoL3Object = [[JROnipinoL3Object alloc] init];

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", @"onipinoL3Object", nil]];
    }
    return self;
}

+ (id)onipinoL2PluralElement
{
    return [[[JROnipinoL2PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipinoL2PluralElement *onipinoL2PluralElementCopy = (JROnipinoL2PluralElement *)[super copyWithZone:zone];

    onipinoL2PluralElementCopy.string1 = self.string1;
    onipinoL2PluralElementCopy.string2 = self.string2;
    onipinoL2PluralElementCopy.onipinoL3Object = self.onipinoL3Object;

    return onipinoL2PluralElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.onipinoL3Object ? [self.onipinoL3Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipinoL3Object"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] 
                       forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)onipinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JROnipinoL2PluralElement *onipinoL2PluralElement = [JROnipinoL2PluralElement onipinoL2PluralElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        onipinoL2PluralElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        onipinoL2PluralElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        onipinoL2PluralElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinoL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        // TODO: Is this safe to assume?
        onipinoL2PluralElement.canBeUpdatedOrReplaced = YES;
    }

    onipinoL2PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    onipinoL2PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    onipinoL2PluralElement.onipinoL3Object =
        [dictionary objectForKey:@"onipinoL3Object"] != [NSNull null] ? 
        [JROnipinoL3Object onipinoL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:onipinoL2PluralElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [onipinoL2PluralElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [onipinoL2PluralElement.dirtyPropertySet removeAllObjects];
    
    return onipinoL2PluralElement;
}

+ (id)onipinoL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JROnipinoL2PluralElement onipinoL2PluralElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

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
        self.onipinoL3Object = [JROnipinoL3Object onipinoL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"onipinoL3Object"])
        [self.onipinoL3Object updateFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

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
        self.onipinoL3Object = [JROnipinoL3Object onipinoL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.onipinoL3Object replaceFromDictionary:[dictionary objectForKey:@"onipinoL3Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if ([self.dirtyPropertySet containsObject:@"onipinoL3Object"])
        [dictionary setObject:(self.onipinoL3Object ?
                              [self.onipinoL3Object toReplaceDictionaryIncludingArrays:NO] :
                              [[JROnipinoL3Object onipinoL3Object] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */
                       forKey:@"onipinoL3Object"];
    else if ([self.onipinoL3Object needsUpdate])
        [dictionary setObject:[self.onipinoL3Object toUpdateDictionary]
                       forKey:@"onipinoL3Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [dictionary setObject:(self.onipinoL3Object ?
                          [self.onipinoL3Object toReplaceDictionaryIncludingArrays:YES] :
                          [[JROnipinoL3Object onipinoL3Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                     forKey:@"onipinoL3Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
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
    if (!self.string1 && !otherOnipinoL2PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherOnipinoL2PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherOnipinoL2PluralElement.string1]) return NO;

    if (!self.string2 && !otherOnipinoL2PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherOnipinoL2PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherOnipinoL2PluralElement.string2]) return NO;

    if (!self.onipinoL3Object && !otherOnipinoL2PluralElement.onipinoL3Object) /* Keep going... */;
    else if (!self.onipinoL3Object && [otherOnipinoL2PluralElement.onipinoL3Object isEqualToOnipinoL3Object:[JROnipinoL3Object onipinoL3Object]]) /* Keep going... */;
    else if (!otherOnipinoL2PluralElement.onipinoL3Object && [self.onipinoL3Object isEqualToOnipinoL3Object:[JROnipinoL3Object onipinoL3Object]]) /* Keep going... */;
    else if (![self.onipinoL3Object isEqualToOnipinoL3Object:otherOnipinoL2PluralElement.onipinoL3Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"JROnipinoL3Object" forKey:@"onipinoL3Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_onipinoL3Object release];

    [super dealloc];
}
@end
