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
#import "JROnipinapL2PluralElement.h"

@interface JROnipinapL3Object (OnipinapL3ObjectInternalMethods)
+ (id)onipinapL3ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOnipinapL3Object:(JROnipinapL3Object *)otherOnipinapL3Object;
@end

@interface JROnipinapL2PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JROnipinapL2PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JROnipinapL3Object *_onipinapL3Object;
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

- (JROnipinapL3Object *)onipinapL3Object
{
    return _onipinapL3Object;
}

- (void)setOnipinapL3Object:(JROnipinapL3Object *)newOnipinapL3Object
{
    [self.dirtyPropertySet addObject:@"onipinapL3Object"];

    [_onipinapL3Object autorelease];
    _onipinapL3Object = [newOnipinapL3Object retain];

    [_onipinapL3Object setAllPropertiesToDirty];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;

        _onipinapL3Object = [[JROnipinapL3Object alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)onipinapL2PluralElement
{
    return [[[JROnipinapL2PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipinapL2PluralElement *onipinapL2PluralElementCopy = (JROnipinapL2PluralElement *)[super copyWithZone:zone];

    onipinapL2PluralElementCopy.string1 = self.string1;
    onipinapL2PluralElementCopy.string2 = self.string2;
    onipinapL2PluralElementCopy.onipinapL3Object = self.onipinapL3Object;

    return onipinapL2PluralElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];
    [dictionary setObject:(self.onipinapL3Object ? [self.onipinapL3Object toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"onipinapL3Object"];

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

+ (id)onipinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JROnipinapL2PluralElement *onipinapL2PluralElement = [JROnipinapL2PluralElement onipinapL2PluralElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        onipinapL2PluralElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        onipinapL2PluralElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        onipinapL2PluralElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinapL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        onipinapL2PluralElement.canBeUpdatedOrReplaced = YES;
    }

    onipinapL2PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    onipinapL2PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    onipinapL2PluralElement.onipinapL3Object =
        [dictionary objectForKey:@"onipinapL3Object"] != [NSNull null] ? 
        [JROnipinapL3Object onipinapL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinapL3Object"] withPath:onipinapL2PluralElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [onipinapL2PluralElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [onipinapL2PluralElement.dirtyPropertySet removeAllObjects];
    
    return onipinapL2PluralElement;
}

+ (id)onipinapL2PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JROnipinapL2PluralElement onipinapL2PluralElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinapL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"onipinapL3Object"] == [NSNull null])
        self.onipinapL3Object = nil;
    else if ([dictionary objectForKey:@"onipinapL3Object"] && !self.onipinapL3Object)
        self.onipinapL3Object = [JROnipinapL3Object onipinapL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinapL3Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"onipinapL3Object"])
        [self.onipinapL3Object updateFromDictionary:[dictionary objectForKey:@"onipinapL3Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"onipinapL2Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"onipinapL3Object"] || [dictionary objectForKey:@"onipinapL3Object"] == [NSNull null])
        self.onipinapL3Object = nil;
    else if (!self.onipinapL3Object)
        self.onipinapL3Object = [JROnipinapL3Object onipinapL3ObjectObjectFromDictionary:[dictionary objectForKey:@"onipinapL3Object"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.onipinapL3Object replaceFromDictionary:[dictionary objectForKey:@"onipinapL3Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"string1", @"string2", @"onipinapL3Object", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet setByAddingObjectsFromSet:[self updatablePropertySet]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"onipinapL2PluralElement"];

    if (self.onipinapL3Object)
        [snapshotDictionary setObject:[self.onipinapL3Object snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"onipinapL3Object"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"onipinapL2PluralElement"])
        [self.dirtyPropertySet setByAddingObjectsFromSet:[snapshotDictionary objectForKey:@"onipinapL2PluralElement"]];

    if ([snapshotDictionary objectForKey:@"onipinapL3Object"])
        [self.onipinapL3Object restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"onipinapL3Object"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if ([self.dirtyPropertySet containsObject:@"onipinapL3Object"])
        [dictionary setObject:(self.onipinapL3Object ?
                              [self.onipinapL3Object toUpdateDictionary] :
                              [[JROnipinapL3Object onipinapL3Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"onipinapL3Object"];
    else if ([self.onipinapL3Object needsUpdate])
        [dictionary setObject:[self.onipinapL3Object toUpdateDictionary]
                       forKey:@"onipinapL3Object"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    [dictionary setObject:(self.onipinapL3Object ?
                          [self.onipinapL3Object toReplaceDictionary] :
                          [[JROnipinapL3Object onipinapL3Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"onipinapL3Object"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.onipinapL3Object needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOnipinapL2PluralElement:(JROnipinapL2PluralElement *)otherOnipinapL2PluralElement
{
    if (!self.string1 && !otherOnipinapL2PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherOnipinapL2PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherOnipinapL2PluralElement.string1]) return NO;

    if (!self.string2 && !otherOnipinapL2PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherOnipinapL2PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherOnipinapL2PluralElement.string2]) return NO;

    if (!self.onipinapL3Object && !otherOnipinapL2PluralElement.onipinapL3Object) /* Keep going... */;
    else if (!self.onipinapL3Object && [otherOnipinapL2PluralElement.onipinapL3Object isEqualToOnipinapL3Object:[JROnipinapL3Object onipinapL3Object]]) /* Keep going... */;
    else if (!otherOnipinapL2PluralElement.onipinapL3Object && [self.onipinapL3Object isEqualToOnipinapL3Object:[JROnipinapL3Object onipinapL3Object]]) /* Keep going... */;
    else if (![self.onipinapL3Object isEqualToOnipinapL3Object:otherOnipinapL2PluralElement.onipinapL3Object]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];
    [dictionary setObject:@"JROnipinapL3Object" forKey:@"onipinapL3Object"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_onipinapL3Object release];

    [super dealloc];
}
@end
