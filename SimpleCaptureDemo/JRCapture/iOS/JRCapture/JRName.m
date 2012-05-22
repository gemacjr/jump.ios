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
@dynamic familyName;
@dynamic formatted;
@dynamic givenName;
@dynamic honorificPrefix;
@dynamic honorificSuffix;
@dynamic middleName;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];
    _familyName = [newFamilyName copy];
}

- (NSString *)formatted
{
    return _formatted;
}

- (void)setFormatted:(NSString *)newFormatted
{
    [self.dirtyPropertySet addObject:@"formatted"];
    _formatted = [newFormatted copy];
}

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];
    _givenName = [newGivenName copy];
}

- (NSString *)honorificPrefix
{
    return _honorificPrefix;
}

- (void)setHonorificPrefix:(NSString *)newHonorificPrefix
{
    [self.dirtyPropertySet addObject:@"honorificPrefix"];
    _honorificPrefix = [newHonorificPrefix copy];
}

- (NSString *)honorificSuffix
{
    return _honorificSuffix;
}

- (void)setHonorificSuffix:(NSString *)newHonorificSuffix
{
    [self.dirtyPropertySet addObject:@"honorificSuffix"];
    _honorificSuffix = [newHonorificSuffix copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];
    _middleName = [newMiddleName copy];
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

+ (id)name
{
    return [[[JRName alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRName *nameCopy =
                [[JRName allocWithZone:zone] init];

    nameCopy.captureObjectPath = self.captureObjectPath;

    nameCopy.familyName = self.familyName;
    nameCopy.formatted = self.formatted;
    nameCopy.givenName = self.givenName;
    nameCopy.honorificPrefix = self.honorificPrefix;
    nameCopy.honorificSuffix = self.honorificSuffix;
    nameCopy.middleName = self.middleName;
    // TODO: Necessary??
    nameCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [nameCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [nameCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return nameCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.familyName ? self.familyName : [NSNull null])
             forKey:@"familyName"];
    [dict setObject:(self.formatted ? self.formatted : [NSNull null])
             forKey:@"formatted"];
    [dict setObject:(self.givenName ? self.givenName : [NSNull null])
             forKey:@"givenName"];
    [dict setObject:(self.honorificPrefix ? self.honorificPrefix : [NSNull null])
             forKey:@"honorificPrefix"];
    [dict setObject:(self.honorificSuffix ? self.honorificSuffix : [NSNull null])
             forKey:@"honorificSuffix"];
    [dict setObject:(self.middleName ? self.middleName : [NSNull null])
             forKey:@"middleName"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRName *name = [JRName name];

    name.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"name"];
// TODO: Is this safe to assume?
    name.canBeUpdatedOrReplaced = YES;

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

    [name.dirtyPropertySet removeAllObjects];
    [name.dirtyArraySet removeAllObjects];
    
    return name;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

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
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

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
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dict setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"formatted"])
        [dict setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dict setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"honorificPrefix"])
        [dict setObject:(self.honorificPrefix ? self.honorificPrefix : [NSNull null]) forKey:@"honorificPrefix"];

    if ([self.dirtyPropertySet containsObject:@"honorificSuffix"])
        [dict setObject:(self.honorificSuffix ? self.honorificSuffix : [NSNull null]) forKey:@"honorificSuffix"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dict setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];
    [dict setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];
    [dict setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];
    [dict setObject:(self.honorificPrefix ? self.honorificPrefix : [NSNull null]) forKey:@"honorificPrefix"];
    [dict setObject:(self.honorificSuffix ? self.honorificSuffix : [NSNull null]) forKey:@"honorificSuffix"];
    [dict setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    return dict;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"familyName"];
    [dict setObject:@"NSString" forKey:@"formatted"];
    [dict setObject:@"NSString" forKey:@"givenName"];
    [dict setObject:@"NSString" forKey:@"honorificPrefix"];
    [dict setObject:@"NSString" forKey:@"honorificSuffix"];
    [dict setObject:@"NSString" forKey:@"middleName"];

    return [NSDictionary dictionaryWithDictionary:dict];
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
