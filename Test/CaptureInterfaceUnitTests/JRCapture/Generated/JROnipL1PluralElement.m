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
#import "JROnipL1PluralElement.h"

@interface JROnipL2Object (JROnipL2Object_InternalMethods)
+ (id)onipL2ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipL2Object:(JROnipL2Object *)otherOnipL2Object;
@end

@interface JROnipL1PluralElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JROnipL1PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JROnipL2Object *_onipL2Object;
}
@synthesize canBeUpdatedOnCapture;

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

    [_onipL2Object setAllPropertiesToDirty];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _onipL2Object = [[JROnipL2Object alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)onipL1PluralElement
{
    return [[[JROnipL1PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipL1PluralElement *onipL1PluralElementCopy = (JROnipL1PluralElement *)[super copyWithZone:zone];

    onipL1PluralElementCopy.string1 = self.string1;
    onipL1PluralElementCopy.string2 = self.string2;
    onipL1PluralElementCopy.onipL2Object = self.onipL2Object;

    return onipL1PluralElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.onipL2Object ? [self.onipL2Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipL2Object"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOnCapture] 
                       forKey:@"canBeUpdatedOnCapture"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JROnipL1PluralElement *onipL1PluralElement = [JROnipL1PluralElement onipL1PluralElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        onipL1PluralElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        onipL1PluralElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        onipL1PluralElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        onipL1PluralElement.canBeUpdatedOnCapture = YES;
    }

    onipL1PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    onipL1PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    onipL1PluralElement.onipL2Object =
        [dictionary objectForKey:@"onipL2Object"] != [NSNull null] ? 
        [JROnipL2Object onipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:onipL1PluralElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [onipL1PluralElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [onipL1PluralElement.dirtyPropertySet removeAllObjects];
    
    return onipL1PluralElement;
}

+ (id)onipL1PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JROnipL1PluralElement onipL1PluralElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
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
        self.onipL2Object = [JROnipL2Object onipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"onipL2Object"])
        [self.onipL2Object updateFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;
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
        self.onipL2Object = [JROnipL2Object onipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.onipL2Object replaceFromDictionary:[dictionary objectForKey:@"onipL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"string1", @"string2", @"onipL2Object", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"onipL1PluralElement"];

    if (self.onipL2Object)
        [snapshotDictionary setObject:[self.onipL2Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"onipL2Object"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"onipL1PluralElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"onipL1PluralElement"] allObjects]];

    if ([snapshotDictionary objectForKey:@"onipL2Object"])
        [self.onipL2Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"onipL2Object"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if ([self.dirtyPropertySet containsObject:@"onipL2Object"])
        [dictionary setObject:(self.onipL2Object ?
                              [self.onipL2Object toUpdateDictionary] :
                              [[JROnipL2Object onipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"onipL2Object"];
    else if ([self.onipL2Object needsUpdate])
        [dictionary setObject:[self.onipL2Object toUpdateDictionary]
                       forKey:@"onipL2Object"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [dictionary setObject:(self.onipL2Object ?
                          [self.onipL2Object toReplaceDictionary] :
                          [[JROnipL2Object onipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"onipL2Object"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.onipL2Object needsUpdate])
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
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"JROnipL2Object" forKey:@"onipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_onipL2Object release];

    [super dealloc];
}
@end
