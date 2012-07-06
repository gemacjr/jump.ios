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
#import "JRObjectTestRequiredUnique.h"

@interface JRObjectTestRequiredUnique ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRObjectTestRequiredUnique
{
    NSString *_requiredString;
    NSString *_uniqueString;
    NSString *_requiredUniqueString;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)requiredString
{
    return _requiredString;
}

- (void)setRequiredString:(NSString *)newRequiredString
{
    [self.dirtyPropertySet addObject:@"requiredString"];

    [_requiredString autorelease];
    _requiredString = [newRequiredString copy];
}

- (NSString *)uniqueString
{
    return _uniqueString;
}

- (void)setUniqueString:(NSString *)newUniqueString
{
    [self.dirtyPropertySet addObject:@"uniqueString"];

    [_uniqueString autorelease];
    _uniqueString = [newUniqueString copy];
}

- (NSString *)requiredUniqueString
{
    return _requiredUniqueString;
}

- (void)setRequiredUniqueString:(NSString *)newRequiredUniqueString
{
    [self.dirtyPropertySet addObject:@"requiredUniqueString"];

    [_requiredUniqueString autorelease];
    _requiredUniqueString = [newRequiredUniqueString copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/objectTestRequiredUnique";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

- (id)initWithRequiredString:(NSString *)newRequiredString andRequiredUniqueString:(NSString *)newRequiredUniqueString
{
    if (!newRequiredString || !newRequiredUniqueString)
    {
        [self release];
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath = @"/objectTestRequiredUnique";
        self.canBeUpdatedOnCapture = YES;

        _requiredString = [newRequiredString copy];
        _requiredUniqueString = [newRequiredUniqueString copy];
    
        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)objectTestRequiredUnique
{
    return [[[JRObjectTestRequiredUnique alloc] init] autorelease];
}

+ (id)objectTestRequiredUniqueWithRequiredString:(NSString *)requiredString andRequiredUniqueString:(NSString *)requiredUniqueString
{
    return [[[JRObjectTestRequiredUnique alloc] initWithRequiredString:requiredString andRequiredUniqueString:requiredUniqueString] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRObjectTestRequiredUnique *objectTestRequiredUniqueCopy = (JRObjectTestRequiredUnique *)[super copyWithZone:zone];

    objectTestRequiredUniqueCopy.requiredString = self.requiredString;
    objectTestRequiredUniqueCopy.uniqueString = self.uniqueString;
    objectTestRequiredUniqueCopy.requiredUniqueString = self.requiredUniqueString;

    return objectTestRequiredUniqueCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.requiredString ? self.requiredString : [NSNull null])
                   forKey:@"requiredString"];
    [dictionary setObject:(self.uniqueString ? self.uniqueString : [NSNull null])
                   forKey:@"uniqueString"];
    [dictionary setObject:(self.requiredUniqueString ? self.requiredUniqueString : [NSNull null])
                   forKey:@"requiredUniqueString"];

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

+ (id)objectTestRequiredUniqueObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRObjectTestRequiredUnique *objectTestRequiredUnique = [JRObjectTestRequiredUnique objectTestRequiredUnique];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        objectTestRequiredUnique.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    objectTestRequiredUnique.requiredString =
        [dictionary objectForKey:@"requiredString"] != [NSNull null] ? 
        [dictionary objectForKey:@"requiredString"] : nil;

    objectTestRequiredUnique.uniqueString =
        [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"uniqueString"] : nil;

    objectTestRequiredUnique.requiredUniqueString =
        [dictionary objectForKey:@"requiredUniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"requiredUniqueString"] : nil;

    if (fromDecoder)
        [objectTestRequiredUnique.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [objectTestRequiredUnique.dirtyPropertySet removeAllObjects];
    
    return objectTestRequiredUnique;
}

+ (id)objectTestRequiredUniqueObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRObjectTestRequiredUnique objectTestRequiredUniqueObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;

    if ([dictionary objectForKey:@"requiredString"])
        self.requiredString = [dictionary objectForKey:@"requiredString"] != [NSNull null] ? 
            [dictionary objectForKey:@"requiredString"] : nil;

    if ([dictionary objectForKey:@"uniqueString"])
        self.uniqueString = [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
            [dictionary objectForKey:@"uniqueString"] : nil;

    if ([dictionary objectForKey:@"requiredUniqueString"])
        self.requiredUniqueString = [dictionary objectForKey:@"requiredUniqueString"] != [NSNull null] ? 
            [dictionary objectForKey:@"requiredUniqueString"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOnCapture = YES;

    self.requiredString =
        [dictionary objectForKey:@"requiredString"] != [NSNull null] ? 
        [dictionary objectForKey:@"requiredString"] : nil;

    self.uniqueString =
        [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"uniqueString"] : nil;

    self.requiredUniqueString =
        [dictionary objectForKey:@"requiredUniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"requiredUniqueString"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"requiredString", @"uniqueString", @"requiredUniqueString", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet setByAddingObjectsFromSet:[self updatablePropertySet]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[[self.dirtyPropertySet copy] autorelease] forKey:@"objectTestRequiredUnique"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"objectTestRequiredUnique"])
        [self.dirtyPropertySet setByAddingObjectsFromSet:[snapshotDictionary objectForKey:@"objectTestRequiredUnique"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"requiredString"])
        [dictionary setObject:(self.requiredString ? self.requiredString : [NSNull null]) forKey:@"requiredString"];

    if ([self.dirtyPropertySet containsObject:@"uniqueString"])
        [dictionary setObject:(self.uniqueString ? self.uniqueString : [NSNull null]) forKey:@"uniqueString"];

    if ([self.dirtyPropertySet containsObject:@"requiredUniqueString"])
        [dictionary setObject:(self.requiredUniqueString ? self.requiredUniqueString : [NSNull null]) forKey:@"requiredUniqueString"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.requiredString ? self.requiredString : [NSNull null]) forKey:@"requiredString"];
    [dictionary setObject:(self.uniqueString ? self.uniqueString : [NSNull null]) forKey:@"uniqueString"];
    [dictionary setObject:(self.requiredUniqueString ? self.requiredUniqueString : [NSNull null]) forKey:@"requiredUniqueString"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToObjectTestRequiredUnique:(JRObjectTestRequiredUnique *)otherObjectTestRequiredUnique
{
    if (!self.requiredString && !otherObjectTestRequiredUnique.requiredString) /* Keep going... */;
    else if ((self.requiredString == nil) ^ (otherObjectTestRequiredUnique.requiredString == nil)) return NO; // xor
    else if (![self.requiredString isEqualToString:otherObjectTestRequiredUnique.requiredString]) return NO;

    if (!self.uniqueString && !otherObjectTestRequiredUnique.uniqueString) /* Keep going... */;
    else if ((self.uniqueString == nil) ^ (otherObjectTestRequiredUnique.uniqueString == nil)) return NO; // xor
    else if (![self.uniqueString isEqualToString:otherObjectTestRequiredUnique.uniqueString]) return NO;

    if (!self.requiredUniqueString && !otherObjectTestRequiredUnique.requiredUniqueString) /* Keep going... */;
    else if ((self.requiredUniqueString == nil) ^ (otherObjectTestRequiredUnique.requiredUniqueString == nil)) return NO; // xor
    else if (![self.requiredUniqueString isEqualToString:otherObjectTestRequiredUnique.requiredUniqueString]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"requiredString"];
    [dictionary setObject:@"NSString" forKey:@"uniqueString"];
    [dictionary setObject:@"NSString" forKey:@"requiredUniqueString"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_requiredString release];
    [_uniqueString release];
    [_requiredUniqueString release];

    [super dealloc];
}
@end
