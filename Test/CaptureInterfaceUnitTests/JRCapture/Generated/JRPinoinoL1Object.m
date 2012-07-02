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
#import "JRPinoinoL1Object.h"

@interface JRPinoinoL2Object (PinoinoL2ObjectInternalMethods)
+ (id)pinoinoL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPinoinoL2Object:(JRPinoinoL2Object *)otherPinoinoL2Object;
@end

@interface JRPinoinoL1Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoinoL1Object
{
    NSString *_string1;
    NSString *_string2;
    JRPinoinoL2Object *_pinoinoL2Object;
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

- (JRPinoinoL2Object *)pinoinoL2Object
{
    return _pinoinoL2Object;
}

- (void)setPinoinoL2Object:(JRPinoinoL2Object *)newPinoinoL2Object
{
    [self.dirtyPropertySet addObject:@"pinoinoL2Object"];

    [_pinoinoL2Object autorelease];
    _pinoinoL2Object = [newPinoinoL2Object retain];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoinoL1Object";
        self.canBeUpdatedOrReplaced = YES;

        _pinoinoL2Object = [[JRPinoinoL2Object alloc] init];

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", @"pinoinoL2Object", nil]];
    }
    return self;
}

+ (id)pinoinoL1Object
{
    return [[[JRPinoinoL1Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinoinoL1Object *pinoinoL1ObjectCopy = (JRPinoinoL1Object *)[super copyWithZone:zone];

    pinoinoL1ObjectCopy.string1 = self.string1;
    pinoinoL1ObjectCopy.string2 = self.string2;
    pinoinoL1ObjectCopy.pinoinoL2Object = self.pinoinoL2Object;

    return pinoinoL1ObjectCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.pinoinoL2Object ? [self.pinoinoL2Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"pinoinoL2Object"];

    if (forEncoder)
    {
        [dictionary setObject:[self.dirtyPropertySet allObjects] forKey:@"dirtyPropertySet"];
        [dictionary setObject:self.captureObjectPath forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinoinoL1Object *pinoinoL1Object = [JRPinoinoL1Object pinoinoL1Object];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinoinoL1Object.captureObjectPath      = [dictionary objectForKey:@"captureObjectPath"];
    }

    pinoinoL1Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinoinoL1Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinoinoL1Object.pinoinoL2Object =
        [dictionary objectForKey:@"pinoinoL2Object"] != [NSNull null] ? 
        [JRPinoinoL2Object pinoinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL2Object"] withPath:pinoinoL1Object.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [pinoinoL1Object.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinoinoL1Object.dirtyPropertySet removeAllObjects];
    
    return pinoinoL1Object;
}

+ (id)pinoinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinoinoL1Object pinoinoL1ObjectObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"pinoinoL2Object"] == [NSNull null])
        self.pinoinoL2Object = nil;
    else if ([dictionary objectForKey:@"pinoinoL2Object"] && !self.pinoinoL2Object)
        self.pinoinoL2Object = [JRPinoinoL2Object pinoinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL2Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"pinoinoL2Object"])
        [self.pinoinoL2Object updateFromDictionary:[dictionary objectForKey:@"pinoinoL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"pinoinoL2Object"] || [dictionary objectForKey:@"pinoinoL2Object"] == [NSNull null])
        self.pinoinoL2Object = nil;
    else if (!self.pinoinoL2Object)
        self.pinoinoL2Object = [JRPinoinoL2Object pinoinoL2ObjectObjectFromDictionary:[dictionary objectForKey:@"pinoinoL2Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.pinoinoL2Object replaceFromDictionary:[dictionary objectForKey:@"pinoinoL2Object"] withPath:self.captureObjectPath];

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

    if ([self.dirtyPropertySet containsObject:@"pinoinoL2Object"])
        [dictionary setObject:(self.pinoinoL2Object ?
                              [self.pinoinoL2Object toReplaceDictionaryIncludingArrays:NO] :
                              [[JRPinoinoL2Object pinoinoL2Object] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */
                       forKey:@"pinoinoL2Object"];
    else if ([self.pinoinoL2Object needsUpdate])
        [dictionary setObject:[self.pinoinoL2Object toUpdateDictionary]
                       forKey:@"pinoinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [dictionary setObject:(self.pinoinoL2Object ?
                          [self.pinoinoL2Object toReplaceDictionaryIncludingArrays:YES] :
                          [[JRPinoinoL2Object pinoinoL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                     forKey:@"pinoinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.pinoinoL2Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToPinoinoL1Object:(JRPinoinoL1Object *)otherPinoinoL1Object
{
    if (!self.string1 && !otherPinoinoL1Object.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPinoinoL1Object.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPinoinoL1Object.string1]) return NO;

    if (!self.string2 && !otherPinoinoL1Object.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPinoinoL1Object.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPinoinoL1Object.string2]) return NO;

    if (!self.pinoinoL2Object && !otherPinoinoL1Object.pinoinoL2Object) /* Keep going... */;
    else if (!self.pinoinoL2Object && [otherPinoinoL1Object.pinoinoL2Object isEqualToPinoinoL2Object:[JRPinoinoL2Object pinoinoL2Object]]) /* Keep going... */;
    else if (!otherPinoinoL1Object.pinoinoL2Object && [self.pinoinoL2Object isEqualToPinoinoL2Object:[JRPinoinoL2Object pinoinoL2Object]]) /* Keep going... */;
    else if (![self.pinoinoL2Object isEqualToPinoinoL2Object:otherPinoinoL1Object.pinoinoL2Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"JRPinoinoL2Object" forKey:@"pinoinoL2Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinoinoL2Object release];

    [super dealloc];
}
@end
