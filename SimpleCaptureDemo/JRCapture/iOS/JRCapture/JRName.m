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


#import "JRName.h"

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

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];

    if (!newFamilyName)
        _familyName = [NSNull null];
    else
        _familyName = [newFamilyName copy];
}

- (NSString *)formatted
{
    return _formatted;
}

- (void)setFormatted:(NSString *)newFormatted
{
    [self.dirtyPropertySet addObject:@"formatted"];

    if (!newFormatted)
        _formatted = [NSNull null];
    else
        _formatted = [newFormatted copy];
}

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];

    if (!newGivenName)
        _givenName = [NSNull null];
    else
        _givenName = [newGivenName copy];
}

- (NSString *)honorificPrefix
{
    return _honorificPrefix;
}

- (void)setHonorificPrefix:(NSString *)newHonorificPrefix
{
    [self.dirtyPropertySet addObject:@"honorificPrefix"];

    if (!newHonorificPrefix)
        _honorificPrefix = [NSNull null];
    else
        _honorificPrefix = [newHonorificPrefix copy];
}

- (NSString *)honorificSuffix
{
    return _honorificSuffix;
}

- (void)setHonorificSuffix:(NSString *)newHonorificSuffix
{
    [self.dirtyPropertySet addObject:@"honorificSuffix"];

    if (!newHonorificSuffix)
        _honorificSuffix = [NSNull null];
    else
        _honorificSuffix = [newHonorificSuffix copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];

    if (!newMiddleName)
        _middleName = [NSNull null];
    else
        _middleName = [newMiddleName copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/name";
    }
    return self;
}

+ (id)name
{
    return [[[JRName alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRName *nameCopy =
                [[JRName allocWithZone:zone] init];

    nameCopy.familyName = self.familyName;
    nameCopy.formatted = self.formatted;
    nameCopy.givenName = self.givenName;
    nameCopy.honorificPrefix = self.honorificPrefix;
    nameCopy.honorificSuffix = self.honorificSuffix;
    nameCopy.middleName = self.middleName;

    return nameCopy;
}

+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary
{
    JRName *name =
        [JRName name];

    name.familyName = [dictionary objectForKey:@"familyName"];
    name.formatted = [dictionary objectForKey:@"formatted"];
    name.givenName = [dictionary objectForKey:@"givenName"];
    name.honorificPrefix = [dictionary objectForKey:@"honorificPrefix"];
    name.honorificSuffix = [dictionary objectForKey:@"honorificSuffix"];
    name.middleName = [dictionary objectForKey:@"middleName"];

    return name;
}

- (NSDictionary*)dictionaryFromNameObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.familyName && self.familyName != [NSNull null])
        [dict setObject:self.familyName forKey:@"familyName"];
    else
        [dict setObject:[NSNull null] forKey:@"familyName"];

    if (self.formatted && self.formatted != [NSNull null])
        [dict setObject:self.formatted forKey:@"formatted"];
    else
        [dict setObject:[NSNull null] forKey:@"formatted"];

    if (self.givenName && self.givenName != [NSNull null])
        [dict setObject:self.givenName forKey:@"givenName"];
    else
        [dict setObject:[NSNull null] forKey:@"givenName"];

    if (self.honorificPrefix && self.honorificPrefix != [NSNull null])
        [dict setObject:self.honorificPrefix forKey:@"honorificPrefix"];
    else
        [dict setObject:[NSNull null] forKey:@"honorificPrefix"];

    if (self.honorificSuffix && self.honorificSuffix != [NSNull null])
        [dict setObject:self.honorificSuffix forKey:@"honorificSuffix"];
    else
        [dict setObject:[NSNull null] forKey:@"honorificSuffix"];

    if (self.middleName && self.middleName != [NSNull null])
        [dict setObject:self.middleName forKey:@"middleName"];
    else
        [dict setObject:[NSNull null] forKey:@"middleName"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"familyName"])
        _familyName = [dictionary objectForKey:@"familyName"];

    if ([dictionary objectForKey:@"formatted"])
        _formatted = [dictionary objectForKey:@"formatted"];

    if ([dictionary objectForKey:@"givenName"])
        _givenName = [dictionary objectForKey:@"givenName"];

    if ([dictionary objectForKey:@"honorificPrefix"])
        _honorificPrefix = [dictionary objectForKey:@"honorificPrefix"];

    if ([dictionary objectForKey:@"honorificSuffix"])
        _honorificSuffix = [dictionary objectForKey:@"honorificSuffix"];

    if ([dictionary objectForKey:@"middleName"])
        _middleName = [dictionary objectForKey:@"middleName"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _familyName = [dictionary objectForKey:@"familyName"];
    _formatted = [dictionary objectForKey:@"formatted"];
    _givenName = [dictionary objectForKey:@"givenName"];
    _honorificPrefix = [dictionary objectForKey:@"honorificPrefix"];
    _honorificSuffix = [dictionary objectForKey:@"honorificSuffix"];
    _middleName = [dictionary objectForKey:@"middleName"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dict setObject:self.familyName forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"formatted"])
        [dict setObject:self.formatted forKey:@"formatted"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dict setObject:self.givenName forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"honorificPrefix"])
        [dict setObject:self.honorificPrefix forKey:@"honorificPrefix"];

    if ([self.dirtyPropertySet containsObject:@"honorificSuffix"])
        [dict setObject:self.honorificSuffix forKey:@"honorificSuffix"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dict setObject:self.middleName forKey:@"middleName"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:0
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.familyName forKey:@"familyName"];
    [dict setObject:self.formatted forKey:@"formatted"];
    [dict setObject:self.givenName forKey:@"givenName"];
    [dict setObject:self.honorificPrefix forKey:@"honorificPrefix"];
    [dict setObject:self.honorificSuffix forKey:@"honorificSuffix"];
    [dict setObject:self.middleName forKey:@"middleName"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:0
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
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
