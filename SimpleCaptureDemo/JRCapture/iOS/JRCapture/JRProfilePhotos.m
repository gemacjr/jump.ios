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


#import "JRProfilePhotos.h"

@interface JRProfilePhotos ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRProfilePhotos
{
    JRObjectId *_profilePhotosId;
    JRBoolean *_primary;
    NSString *_type;
    NSString *_value;
}
@dynamic profilePhotosId;
@dynamic primary;
@dynamic type;
@dynamic value;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)profilePhotosId
{
    return _profilePhotosId;
}

- (void)setProfilePhotosId:(JRObjectId *)newProfilePhotosId
{
    [self.dirtyPropertySet addObject:@"profilePhotosId"];
    _profilePhotosId = [newProfilePhotosId copy];
}

- (JRBoolean *)primary
{
    return _primary;
}

- (void)setPrimary:(JRBoolean *)newPrimary
{
    [self.dirtyPropertySet addObject:@"primary"];
    _primary = [newPrimary copy];
}

- (BOOL)getPrimaryBoolValue
{
    return [_primary boolValue];
}

- (void)setPrimaryWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"primary"];
    _primary = [NSNumber numberWithBool:boolVal];
}

- (NSString *)type
{
    return _type;
}

- (void)setType:(NSString *)newType
{
    [self.dirtyPropertySet addObject:@"type"];
    _type = [newType copy];
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];
    _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)profilePhotos
{
    return [[[JRProfilePhotos alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRProfilePhotos *profilePhotosCopy =
                [[JRProfilePhotos allocWithZone:zone] init];

    profilePhotosCopy.captureObjectPath = self.captureObjectPath;

    profilePhotosCopy.profilePhotosId = self.profilePhotosId;
    profilePhotosCopy.primary = self.primary;
    profilePhotosCopy.type = self.type;
    profilePhotosCopy.value = self.value;

    profilePhotosCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    [profilePhotosCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [profilePhotosCopy.dirtyArraySet setSet:self.dirtyPropertySet];

    return profilePhotosCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.profilePhotosId ? [NSNumber numberWithInteger:[self.profilePhotosId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null])
             forKey:@"primary"];
    [dict setObject:(self.type ? self.type : [NSNull null])
             forKey:@"type"];
    [dict setObject:(self.value ? self.value : [NSNull null])
             forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)profilePhotosObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRProfilePhotos *profilePhotos = [JRProfilePhotos profilePhotos];
    profilePhotos.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profilePhotos", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    profilePhotos.profilePhotosId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    profilePhotos.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    profilePhotos.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    profilePhotos.value =
        [dictionary objectForKey:@"value"] != [NSNull null] ? 
        [dictionary objectForKey:@"value"] : nil;

    [profilePhotos.dirtyPropertySet removeAllObjects];
    [profilePhotos.dirtyArraySet removeAllObjects];
    
    return profilePhotos;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profilePhotos", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.profilePhotosId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"primary"])
        self.primary = [dictionary objectForKey:@"primary"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"] != [NSNull null] ? 
            [dictionary objectForKey:@"type"] : nil;

    if ([dictionary objectForKey:@"value"])
        self.value = [dictionary objectForKey:@"value"] != [NSNull null] ? 
            [dictionary objectForKey:@"value"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profilePhotos", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.profilePhotosId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    self.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    self.value =
        [dictionary objectForKey:@"value"] != [NSNull null] ? 
        [dictionary objectForKey:@"value"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dict setObject:(self.value ? self.value : [NSNull null]) forKey:@"value"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];
    [dict setObject:(self.value ? self.value : [NSNull null]) forKey:@"value"];

    return dict;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"profilePhotosId"];
    [dict setObject:@"JRBoolean" forKey:@"primary"];
    [dict setObject:@"NSString" forKey:@"type"];
    [dict setObject:@"NSString" forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_profilePhotosId release];
    [_primary release];
    [_type release];
    [_value release];

    [super dealloc];
}
@end
