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
#import "JRName.h"

@interface JRName ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRName
{
    NSString *_familyName;
    NSString *_formatted;
    NSString *_givenName;
    NSString *_honorificPrefix;
    NSString *_honorificSuffix;
    NSString *_middleName;
}
@synthesize canBeUpdatedOrReplaced;

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];

    [_familyName autorelease];
    _familyName = [newFamilyName copy];
}

- (NSString *)formatted
{
    return _formatted;
}

- (void)setFormatted:(NSString *)newFormatted
{
    [self.dirtyPropertySet addObject:@"formatted"];

    [_formatted autorelease];
    _formatted = [newFormatted copy];
}

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];

    [_givenName autorelease];
    _givenName = [newGivenName copy];
}

- (NSString *)honorificPrefix
{
    return _honorificPrefix;
}

- (void)setHonorificPrefix:(NSString *)newHonorificPrefix
{
    [self.dirtyPropertySet addObject:@"honorificPrefix"];

    [_honorificPrefix autorelease];
    _honorificPrefix = [newHonorificPrefix copy];
}

- (NSString *)honorificSuffix
{
    return _honorificSuffix;
}

- (void)setHonorificSuffix:(NSString *)newHonorificSuffix
{
    [self.dirtyPropertySet addObject:@"honorificSuffix"];

    [_honorificSuffix autorelease];
    _honorificSuffix = [newHonorificSuffix copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];

    [_middleName autorelease];
    _middleName = [newMiddleName copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"familyName", @"formatted", @"givenName", @"honorificPrefix", @"honorificSuffix", @"middleName", nil]];
    }
    return self;
}

+ (id)name
{
    return [[[JRName alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRName *nameCopy = (JRName *)[super copyWithZone:zone];

    nameCopy.familyName = self.familyName;
    nameCopy.formatted = self.formatted;
    nameCopy.givenName = self.givenName;
    nameCopy.honorificPrefix = self.honorificPrefix;
    nameCopy.honorificSuffix = self.honorificSuffix;
    nameCopy.middleName = self.middleName;

    return nameCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.familyName ? self.familyName : [NSNull null])
                   forKey:@"familyName"];
    [dictionary setObject:(self.formatted ? self.formatted : [NSNull null])
                   forKey:@"formatted"];
    [dictionary setObject:(self.givenName ? self.givenName : [NSNull null])
                   forKey:@"givenName"];
    [dictionary setObject:(self.honorificPrefix ? self.honorificPrefix : [NSNull null])
                   forKey:@"honorificPrefix"];
    [dictionary setObject:(self.honorificSuffix ? self.honorificSuffix : [NSNull null])
                   forKey:@"honorificSuffix"];
    [dictionary setObject:(self.middleName ? self.middleName : [NSNull null])
                   forKey:@"middleName"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertySet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] 
                       forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRName *name = [JRName name];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        name.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        name.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        name.captureObjectPath      = [NSString stringWithFormat:@"%@/%@", capturePath, @"name"];
        // TODO: Is this safe to assume?
        name.canBeUpdatedOrReplaced = YES;
    }

    name.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    name.formatted =
        [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
        [dictionary objectForKey:@"formatted"] : nil;

    name.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    name.honorificPrefix =
        [dictionary objectForKey:@"honorificPrefix"] != [NSNull null] ? 
        [dictionary objectForKey:@"honorificPrefix"] : nil;

    name.honorificSuffix =
        [dictionary objectForKey:@"honorificSuffix"] != [NSNull null] ? 
        [dictionary objectForKey:@"honorificSuffix"] : nil;

    name.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    if (fromDecoder)
        [name.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [name.dirtyPropertySet removeAllObjects];
    
    return name;
}

+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRName nameObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"name"];

    if ([dictionary objectForKey:@"familyName"])
        self.familyName = [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
            [dictionary objectForKey:@"familyName"] : nil;

    if ([dictionary objectForKey:@"formatted"])
        self.formatted = [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
            [dictionary objectForKey:@"formatted"] : nil;

    if ([dictionary objectForKey:@"givenName"])
        self.givenName = [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
            [dictionary objectForKey:@"givenName"] : nil;

    if ([dictionary objectForKey:@"honorificPrefix"])
        self.honorificPrefix = [dictionary objectForKey:@"honorificPrefix"] != [NSNull null] ? 
            [dictionary objectForKey:@"honorificPrefix"] : nil;

    if ([dictionary objectForKey:@"honorificSuffix"])
        self.honorificSuffix = [dictionary objectForKey:@"honorificSuffix"] != [NSNull null] ? 
            [dictionary objectForKey:@"honorificSuffix"] : nil;

    if ([dictionary objectForKey:@"middleName"])
        self.middleName = [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
            [dictionary objectForKey:@"middleName"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"name"];

    self.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    self.formatted =
        [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
        [dictionary objectForKey:@"formatted"] : nil;

    self.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    self.honorificPrefix =
        [dictionary objectForKey:@"honorificPrefix"] != [NSNull null] ? 
        [dictionary objectForKey:@"honorificPrefix"] : nil;

    self.honorificSuffix =
        [dictionary objectForKey:@"honorificSuffix"] != [NSNull null] ? 
        [dictionary objectForKey:@"honorificSuffix"] : nil;

    self.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dictionary setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"formatted"])
        [dictionary setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dictionary setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"honorificPrefix"])
        [dictionary setObject:(self.honorificPrefix ? self.honorificPrefix : [NSNull null]) forKey:@"honorificPrefix"];

    if ([self.dirtyPropertySet containsObject:@"honorificSuffix"])
        [dictionary setObject:(self.honorificSuffix ? self.honorificSuffix : [NSNull null]) forKey:@"honorificSuffix"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dictionary setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];
    [dictionary setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];
    [dictionary setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];
    [dictionary setObject:(self.honorificPrefix ? self.honorificPrefix : [NSNull null]) forKey:@"honorificPrefix"];
    [dictionary setObject:(self.honorificSuffix ? self.honorificSuffix : [NSNull null]) forKey:@"honorificSuffix"];
    [dictionary setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToName:(JRName *)otherName
{
    if (!self.familyName && !otherName.familyName) /* Keep going... */;
    else if ((self.familyName == nil) ^ (otherName.familyName == nil)) return NO; // xor
    else if (![self.familyName isEqualToString:otherName.familyName]) return NO;

    if (!self.formatted && !otherName.formatted) /* Keep going... */;
    else if ((self.formatted == nil) ^ (otherName.formatted == nil)) return NO; // xor
    else if (![self.formatted isEqualToString:otherName.formatted]) return NO;

    if (!self.givenName && !otherName.givenName) /* Keep going... */;
    else if ((self.givenName == nil) ^ (otherName.givenName == nil)) return NO; // xor
    else if (![self.givenName isEqualToString:otherName.givenName]) return NO;

    if (!self.honorificPrefix && !otherName.honorificPrefix) /* Keep going... */;
    else if ((self.honorificPrefix == nil) ^ (otherName.honorificPrefix == nil)) return NO; // xor
    else if (![self.honorificPrefix isEqualToString:otherName.honorificPrefix]) return NO;

    if (!self.honorificSuffix && !otherName.honorificSuffix) /* Keep going... */;
    else if ((self.honorificSuffix == nil) ^ (otherName.honorificSuffix == nil)) return NO; // xor
    else if (![self.honorificSuffix isEqualToString:otherName.honorificSuffix]) return NO;

    if (!self.middleName && !otherName.middleName) /* Keep going... */;
    else if ((self.middleName == nil) ^ (otherName.middleName == nil)) return NO; // xor
    else if (![self.middleName isEqualToString:otherName.middleName]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"familyName"];
    [dictionary setObject:@"NSString" forKey:@"formatted"];
    [dictionary setObject:@"NSString" forKey:@"givenName"];
    [dictionary setObject:@"NSString" forKey:@"honorificPrefix"];
    [dictionary setObject:@"NSString" forKey:@"honorificSuffix"];
    [dictionary setObject:@"NSString" forKey:@"middleName"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_familyName release];
    [_formatted release];
    [_givenName release];
    [_honorificPrefix release];
    [_honorificSuffix release];
    [_middleName release];

    [super dealloc];
}
@end
