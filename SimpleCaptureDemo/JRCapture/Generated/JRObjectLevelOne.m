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
#import "JRObjectLevelOne.h"

@interface JRObjectLevelTwo (ObjectLevelTwoInternalMethods)
+ (id)objectLevelTwoObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToObjectLevelTwo:(JRObjectLevelTwo *)otherObjectLevelTwo;
@end

@interface JRObjectLevelOne ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRObjectLevelOne
{
    NSString *_level;
    NSString *_name;
    JRObjectLevelTwo *_objectLevelTwo;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    [_level autorelease];
    _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    [_name autorelease];
    _name = [newName copy];
}

- (JRObjectLevelTwo *)objectLevelTwo
{
    return _objectLevelTwo;
}

- (void)setObjectLevelTwo:(JRObjectLevelTwo *)newObjectLevelTwo
{
    [self.dirtyPropertySet addObject:@"objectLevelTwo"];

    [_objectLevelTwo autorelease];
    _objectLevelTwo = [newObjectLevelTwo retain];

    [_objectLevelTwo setAllPropertiesToDirty];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/objectLevelOne";
        self.canBeUpdatedOnCapture = YES;

        _objectLevelTwo = [[JRObjectLevelTwo alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)objectLevelOne
{
    return [[[JRObjectLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRObjectLevelOne *objectLevelOneCopy = (JRObjectLevelOne *)[super copyWithZone:zone];

    objectLevelOneCopy.level = self.level;
    objectLevelOneCopy.name = self.name;
    objectLevelOneCopy.objectLevelTwo = self.objectLevelTwo;

    return objectLevelOneCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null])
                   forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.objectLevelTwo ? [self.objectLevelTwo toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"objectLevelTwo"];

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

+ (id)objectLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRObjectLevelOne *objectLevelOne = [JRObjectLevelOne objectLevelOne];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        objectLevelOne.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    objectLevelOne.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    objectLevelOne.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    objectLevelOne.objectLevelTwo =
        [dictionary objectForKey:@"objectLevelTwo"] != [NSNull null] ? 
        [JRObjectLevelTwo objectLevelTwoObjectFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:objectLevelOne.captureObjectPath fromDecoder:fromDecoder] : nil;

    if (fromDecoder)
        [objectLevelOne.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [objectLevelOne.dirtyPropertySet removeAllObjects];
    
    return objectLevelOne;
}

+ (id)objectLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRObjectLevelOne objectLevelOneObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;

    if ([dictionary objectForKey:@"objectLevelTwo"] == [NSNull null])
        self.objectLevelTwo = nil;
    else if ([dictionary objectForKey:@"objectLevelTwo"] && !self.objectLevelTwo)
        self.objectLevelTwo = [JRObjectLevelTwo objectLevelTwoObjectFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"objectLevelTwo"])
        [self.objectLevelTwo updateFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    if (![dictionary objectForKey:@"objectLevelTwo"] || [dictionary objectForKey:@"objectLevelTwo"] == [NSNull null])
        self.objectLevelTwo = nil;
    else if (!self.objectLevelTwo)
        self.objectLevelTwo = [JRObjectLevelTwo objectLevelTwoObjectFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.objectLevelTwo replaceFromDictionary:[dictionary objectForKey:@"objectLevelTwo"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"level", @"name", @"objectLevelTwo", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet setByAddingObjectsFromSet:[self updatablePropertySet]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"objectLevelOne"];

    if (self.objectLevelTwo)
        [snapshotDictionary setObject:[self.objectLevelTwo snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"objectLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"objectLevelOne"])
        [self.dirtyPropertySet setByAddingObjectsFromSet:[snapshotDictionary objectForKey:@"objectLevelOne"]];

    if ([snapshotDictionary objectForKey:@"objectLevelTwo"])
        [self.objectLevelTwo restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"objectLevelTwo"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"objectLevelTwo"])
        [dictionary setObject:(self.objectLevelTwo ?
                              [self.objectLevelTwo toUpdateDictionary] :
                              [[JRObjectLevelTwo objectLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"objectLevelTwo"];
    else if ([self.objectLevelTwo needsUpdate])
        [dictionary setObject:[self.objectLevelTwo toUpdateDictionary]
                       forKey:@"objectLevelTwo"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [dictionary setObject:(self.objectLevelTwo ?
                          [self.objectLevelTwo toReplaceDictionary] :
                          [[JRObjectLevelTwo objectLevelTwo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"objectLevelTwo"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.objectLevelTwo needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToObjectLevelOne:(JRObjectLevelOne *)otherObjectLevelOne
{
    if (!self.level && !otherObjectLevelOne.level) /* Keep going... */;
    else if ((self.level == nil) ^ (otherObjectLevelOne.level == nil)) return NO; // xor
    else if (![self.level isEqualToString:otherObjectLevelOne.level]) return NO;

    if (!self.name && !otherObjectLevelOne.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherObjectLevelOne.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherObjectLevelOne.name]) return NO;

    if (!self.objectLevelTwo && !otherObjectLevelOne.objectLevelTwo) /* Keep going... */;
    else if (!self.objectLevelTwo && [otherObjectLevelOne.objectLevelTwo isEqualToObjectLevelTwo:[JRObjectLevelTwo objectLevelTwo]]) /* Keep going... */;
    else if (!otherObjectLevelOne.objectLevelTwo && [self.objectLevelTwo isEqualToObjectLevelTwo:[JRObjectLevelTwo objectLevelTwo]]) /* Keep going... */;
    else if (![self.objectLevelTwo isEqualToObjectLevelTwo:otherObjectLevelOne.objectLevelTwo]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"level"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"JRObjectLevelTwo" forKey:@"objectLevelTwo"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_objectLevelTwo release];

    [super dealloc];
}
@end
