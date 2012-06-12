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


#import "JRObjectTestRequiredUnique.h"

@interface JRObjectTestRequiredUnique ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRObjectTestRequiredUnique
{
    NSString *_requiredString;
    NSString *_uniqueString;
    NSString *_requiredUniqueString;
}
@dynamic requiredString;
@dynamic uniqueString;
@dynamic requiredUniqueString;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)requiredString
{
    return _requiredString;
}

- (void)setRequiredString:(NSString *)newRequiredString
{
    [self.dirtyPropertySet addObject:@"requiredString"];
    _requiredString = [newRequiredString copy];
}

- (NSString *)uniqueString
{
    return _uniqueString;
}

- (void)setUniqueString:(NSString *)newUniqueString
{
    [self.dirtyPropertySet addObject:@"uniqueString"];
    _uniqueString = [newUniqueString copy];
}

- (NSString *)requiredUniqueString
{
    return _requiredUniqueString;
}

- (void)setRequiredUniqueString:(NSString *)newRequiredUniqueString
{
    [self.dirtyPropertySet addObject:@"requiredUniqueString"];
    _requiredUniqueString = [newRequiredUniqueString copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/objectTestRequiredUnique";
        self.canBeUpdatedOrReplaced = YES;
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
        self.canBeUpdatedOrReplaced = YES;
        _requiredString = [newRequiredString copy];
        _requiredUniqueString = [newRequiredUniqueString copy];
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
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRObjectTestRequiredUnique *objectTestRequiredUniqueCopy =
                [[JRObjectTestRequiredUnique allocWithZone:zone] initWithRequiredString:self.requiredString andRequiredUniqueString:self.requiredUniqueString];

    objectTestRequiredUniqueCopy.captureObjectPath = self.captureObjectPath;

    objectTestRequiredUniqueCopy.uniqueString = self.uniqueString;
    // TODO: Necessary??
    objectTestRequiredUniqueCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [objectTestRequiredUniqueCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [objectTestRequiredUniqueCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return objectTestRequiredUniqueCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.requiredString ? self.requiredString : [NSNull null])
             forKey:@"requiredString"];
    [dict setObject:(self.uniqueString ? self.uniqueString : [NSNull null])
             forKey:@"uniqueString"];
    [dict setObject:(self.requiredUniqueString ? self.requiredUniqueString : [NSNull null])
             forKey:@"requiredUniqueString"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)objectTestRequiredUniqueObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRObjectTestRequiredUnique *objectTestRequiredUnique = [JRObjectTestRequiredUnique objectTestRequiredUnique];


    objectTestRequiredUnique.requiredString =
        [dictionary objectForKey:@"requiredString"] != [NSNull null] ? 
        [dictionary objectForKey:@"requiredString"] : nil;

    objectTestRequiredUnique.uniqueString =
        [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"uniqueString"] : nil;

    objectTestRequiredUnique.requiredUniqueString =
        [dictionary objectForKey:@"requiredUniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"requiredUniqueString"] : nil;

    [objectTestRequiredUnique.dirtyPropertySet removeAllObjects];
    [objectTestRequiredUnique.dirtyArraySet removeAllObjects];
    
    return objectTestRequiredUnique;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

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
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

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
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"requiredString"])
        [dict setObject:(self.requiredString ? self.requiredString : [NSNull null]) forKey:@"requiredString"];

    if ([self.dirtyPropertySet containsObject:@"uniqueString"])
        [dict setObject:(self.uniqueString ? self.uniqueString : [NSNull null]) forKey:@"uniqueString"];

    if ([self.dirtyPropertySet containsObject:@"requiredUniqueString"])
        [dict setObject:(self.requiredUniqueString ? self.requiredUniqueString : [NSNull null]) forKey:@"requiredUniqueString"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.requiredString ? self.requiredString : [NSNull null]) forKey:@"requiredString"];
    [dict setObject:(self.uniqueString ? self.uniqueString : [NSNull null]) forKey:@"uniqueString"];
    [dict setObject:(self.requiredUniqueString ? self.requiredUniqueString : [NSNull null]) forKey:@"requiredUniqueString"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToObjectTestRequiredUnique:(JRObjectTestRequiredUnique *)otherObjectTestRequiredUnique
{
    if ((self.requiredString == nil) ^ (otherObjectTestRequiredUnique.requiredString == nil)) // xor
        return NO;

    if (![self.requiredString isEqualToString:otherObjectTestRequiredUnique.requiredString])
        return NO;

    if ((self.uniqueString == nil) ^ (otherObjectTestRequiredUnique.uniqueString == nil)) // xor
        return NO;

    if (![self.uniqueString isEqualToString:otherObjectTestRequiredUnique.uniqueString])
        return NO;

    if ((self.requiredUniqueString == nil) ^ (otherObjectTestRequiredUnique.requiredUniqueString == nil)) // xor
        return NO;

    if (![self.requiredUniqueString isEqualToString:otherObjectTestRequiredUnique.requiredUniqueString])
        return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"requiredString"];
    [dict setObject:@"NSString" forKey:@"uniqueString"];
    [dict setObject:@"NSString" forKey:@"requiredUniqueString"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_requiredString release];
    [_uniqueString release];
    [_requiredUniqueString release];

    [super dealloc];
}
@end
