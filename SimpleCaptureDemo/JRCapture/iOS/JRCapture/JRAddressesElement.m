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


#import "JRAddressesElement.h"

@interface JRAddressesElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRAddressesElement
{
    JRObjectId *_addressesElementId;
    NSString *_country;
    NSString *_extendedAddress;
    NSString *_formatted;
    NSNumber *_latitude;
    NSString *_locality;
    NSNumber *_longitude;
    NSString *_poBox;
    NSString *_postalCode;
    JRBoolean *_primary;
    NSString *_region;
    NSString *_streetAddress;
    NSString *_type;
}
@dynamic addressesElementId;
@dynamic country;
@dynamic extendedAddress;
@dynamic formatted;
@dynamic latitude;
@dynamic locality;
@dynamic longitude;
@dynamic poBox;
@dynamic postalCode;
@dynamic primary;
@dynamic region;
@dynamic streetAddress;
@dynamic type;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)addressesElementId
{
    return _addressesElementId;
}

- (void)setAddressesElementId:(JRObjectId *)newAddressesElementId
{
    [self.dirtyPropertySet addObject:@"addressesElementId"];
    _addressesElementId = [newAddressesElementId copy];
}

- (NSString *)country
{
    return _country;
}

- (void)setCountry:(NSString *)newCountry
{
    [self.dirtyPropertySet addObject:@"country"];
    _country = [newCountry copy];
}

- (NSString *)extendedAddress
{
    return _extendedAddress;
}

- (void)setExtendedAddress:(NSString *)newExtendedAddress
{
    [self.dirtyPropertySet addObject:@"extendedAddress"];
    _extendedAddress = [newExtendedAddress copy];
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

- (NSNumber *)latitude
{
    return _latitude;
}

- (void)setLatitude:(NSNumber *)newLatitude
{
    [self.dirtyPropertySet addObject:@"latitude"];
    _latitude = [newLatitude copy];
}

- (NSString *)locality
{
    return _locality;
}

- (void)setLocality:(NSString *)newLocality
{
    [self.dirtyPropertySet addObject:@"locality"];
    _locality = [newLocality copy];
}

- (NSNumber *)longitude
{
    return _longitude;
}

- (void)setLongitude:(NSNumber *)newLongitude
{
    [self.dirtyPropertySet addObject:@"longitude"];
    _longitude = [newLongitude copy];
}

- (NSString *)poBox
{
    return _poBox;
}

- (void)setPoBox:(NSString *)newPoBox
{
    [self.dirtyPropertySet addObject:@"poBox"];
    _poBox = [newPoBox copy];
}

- (NSString *)postalCode
{
    return _postalCode;
}

- (void)setPostalCode:(NSString *)newPostalCode
{
    [self.dirtyPropertySet addObject:@"postalCode"];
    _postalCode = [newPostalCode copy];
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

- (NSString *)region
{
    return _region;
}

- (void)setRegion:(NSString *)newRegion
{
    [self.dirtyPropertySet addObject:@"region"];
    _region = [newRegion copy];
}

- (NSString *)streetAddress
{
    return _streetAddress;
}

- (void)setStreetAddress:(NSString *)newStreetAddress
{
    [self.dirtyPropertySet addObject:@"streetAddress"];
    _streetAddress = [newStreetAddress copy];
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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)addressesElement
{
    return [[[JRAddressesElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRAddressesElement *addressesElementCopy =
                [[JRAddressesElement allocWithZone:zone] init];

    addressesElementCopy.captureObjectPath = self.captureObjectPath;

    addressesElementCopy.addressesElementId = self.addressesElementId;
    addressesElementCopy.country = self.country;
    addressesElementCopy.extendedAddress = self.extendedAddress;
    addressesElementCopy.formatted = self.formatted;
    addressesElementCopy.latitude = self.latitude;
    addressesElementCopy.locality = self.locality;
    addressesElementCopy.longitude = self.longitude;
    addressesElementCopy.poBox = self.poBox;
    addressesElementCopy.postalCode = self.postalCode;
    addressesElementCopy.primary = self.primary;
    addressesElementCopy.region = self.region;
    addressesElementCopy.streetAddress = self.streetAddress;
    addressesElementCopy.type = self.type;
    // TODO: Necessary??
    addressesElementCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [addressesElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [addressesElementCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return addressesElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.addressesElementId ? [NSNumber numberWithInteger:[self.addressesElementId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.country ? self.country : [NSNull null])
             forKey:@"country"];
    [dict setObject:(self.extendedAddress ? self.extendedAddress : [NSNull null])
             forKey:@"extendedAddress"];
    [dict setObject:(self.formatted ? self.formatted : [NSNull null])
             forKey:@"formatted"];
    [dict setObject:(self.latitude ? self.latitude : [NSNull null])
             forKey:@"latitude"];
    [dict setObject:(self.locality ? self.locality : [NSNull null])
             forKey:@"locality"];
    [dict setObject:(self.longitude ? self.longitude : [NSNull null])
             forKey:@"longitude"];
    [dict setObject:(self.poBox ? self.poBox : [NSNull null])
             forKey:@"poBox"];
    [dict setObject:(self.postalCode ? self.postalCode : [NSNull null])
             forKey:@"postalCode"];
    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null])
             forKey:@"primary"];
    [dict setObject:(self.region ? self.region : [NSNull null])
             forKey:@"region"];
    [dict setObject:(self.streetAddress ? self.streetAddress : [NSNull null])
             forKey:@"streetAddress"];
    [dict setObject:(self.type ? self.type : [NSNull null])
             forKey:@"type"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)addressesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRAddressesElement *addressesElement = [JRAddressesElement addressesElement];

    addressesElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"addresses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    addressesElement.canBeUpdatedOrReplaced = YES;

    addressesElement.addressesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    addressesElement.country =
        [dictionary objectForKey:@"country"] != [NSNull null] ? 
        [dictionary objectForKey:@"country"] : nil;

    addressesElement.extendedAddress =
        [dictionary objectForKey:@"extendedAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"extendedAddress"] : nil;

    addressesElement.formatted =
        [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
        [dictionary objectForKey:@"formatted"] : nil;

    addressesElement.latitude =
        [dictionary objectForKey:@"latitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"latitude"] : nil;

    addressesElement.locality =
        [dictionary objectForKey:@"locality"] != [NSNull null] ? 
        [dictionary objectForKey:@"locality"] : nil;

    addressesElement.longitude =
        [dictionary objectForKey:@"longitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"longitude"] : nil;

    addressesElement.poBox =
        [dictionary objectForKey:@"poBox"] != [NSNull null] ? 
        [dictionary objectForKey:@"poBox"] : nil;

    addressesElement.postalCode =
        [dictionary objectForKey:@"postalCode"] != [NSNull null] ? 
        [dictionary objectForKey:@"postalCode"] : nil;

    addressesElement.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    addressesElement.region =
        [dictionary objectForKey:@"region"] != [NSNull null] ? 
        [dictionary objectForKey:@"region"] : nil;

    addressesElement.streetAddress =
        [dictionary objectForKey:@"streetAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"streetAddress"] : nil;

    addressesElement.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    [addressesElement.dirtyPropertySet removeAllObjects];
    [addressesElement.dirtyArraySet removeAllObjects];
    
    return addressesElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"addresses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.addressesElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"country"])
        self.country = [dictionary objectForKey:@"country"] != [NSNull null] ? 
            [dictionary objectForKey:@"country"] : nil;

    if ([dictionary objectForKey:@"extendedAddress"])
        self.extendedAddress = [dictionary objectForKey:@"extendedAddress"] != [NSNull null] ? 
            [dictionary objectForKey:@"extendedAddress"] : nil;

    if ([dictionary objectForKey:@"formatted"])
        self.formatted = [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
            [dictionary objectForKey:@"formatted"] : nil;

    if ([dictionary objectForKey:@"latitude"])
        self.latitude = [dictionary objectForKey:@"latitude"] != [NSNull null] ? 
            [dictionary objectForKey:@"latitude"] : nil;

    if ([dictionary objectForKey:@"locality"])
        self.locality = [dictionary objectForKey:@"locality"] != [NSNull null] ? 
            [dictionary objectForKey:@"locality"] : nil;

    if ([dictionary objectForKey:@"longitude"])
        self.longitude = [dictionary objectForKey:@"longitude"] != [NSNull null] ? 
            [dictionary objectForKey:@"longitude"] : nil;

    if ([dictionary objectForKey:@"poBox"])
        self.poBox = [dictionary objectForKey:@"poBox"] != [NSNull null] ? 
            [dictionary objectForKey:@"poBox"] : nil;

    if ([dictionary objectForKey:@"postalCode"])
        self.postalCode = [dictionary objectForKey:@"postalCode"] != [NSNull null] ? 
            [dictionary objectForKey:@"postalCode"] : nil;

    if ([dictionary objectForKey:@"primary"])
        self.primary = [dictionary objectForKey:@"primary"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    if ([dictionary objectForKey:@"region"])
        self.region = [dictionary objectForKey:@"region"] != [NSNull null] ? 
            [dictionary objectForKey:@"region"] : nil;

    if ([dictionary objectForKey:@"streetAddress"])
        self.streetAddress = [dictionary objectForKey:@"streetAddress"] != [NSNull null] ? 
            [dictionary objectForKey:@"streetAddress"] : nil;

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"] != [NSNull null] ? 
            [dictionary objectForKey:@"type"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"addresses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.addressesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.country =
        [dictionary objectForKey:@"country"] != [NSNull null] ? 
        [dictionary objectForKey:@"country"] : nil;

    self.extendedAddress =
        [dictionary objectForKey:@"extendedAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"extendedAddress"] : nil;

    self.formatted =
        [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
        [dictionary objectForKey:@"formatted"] : nil;

    self.latitude =
        [dictionary objectForKey:@"latitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"latitude"] : nil;

    self.locality =
        [dictionary objectForKey:@"locality"] != [NSNull null] ? 
        [dictionary objectForKey:@"locality"] : nil;

    self.longitude =
        [dictionary objectForKey:@"longitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"longitude"] : nil;

    self.poBox =
        [dictionary objectForKey:@"poBox"] != [NSNull null] ? 
        [dictionary objectForKey:@"poBox"] : nil;

    self.postalCode =
        [dictionary objectForKey:@"postalCode"] != [NSNull null] ? 
        [dictionary objectForKey:@"postalCode"] : nil;

    self.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    self.region =
        [dictionary objectForKey:@"region"] != [NSNull null] ? 
        [dictionary objectForKey:@"region"] : nil;

    self.streetAddress =
        [dictionary objectForKey:@"streetAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"streetAddress"] : nil;

    self.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"country"])
        [dict setObject:(self.country ? self.country : [NSNull null]) forKey:@"country"];

    if ([self.dirtyPropertySet containsObject:@"extendedAddress"])
        [dict setObject:(self.extendedAddress ? self.extendedAddress : [NSNull null]) forKey:@"extendedAddress"];

    if ([self.dirtyPropertySet containsObject:@"formatted"])
        [dict setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];

    if ([self.dirtyPropertySet containsObject:@"latitude"])
        [dict setObject:(self.latitude ? self.latitude : [NSNull null]) forKey:@"latitude"];

    if ([self.dirtyPropertySet containsObject:@"locality"])
        [dict setObject:(self.locality ? self.locality : [NSNull null]) forKey:@"locality"];

    if ([self.dirtyPropertySet containsObject:@"longitude"])
        [dict setObject:(self.longitude ? self.longitude : [NSNull null]) forKey:@"longitude"];

    if ([self.dirtyPropertySet containsObject:@"poBox"])
        [dict setObject:(self.poBox ? self.poBox : [NSNull null]) forKey:@"poBox"];

    if ([self.dirtyPropertySet containsObject:@"postalCode"])
        [dict setObject:(self.postalCode ? self.postalCode : [NSNull null]) forKey:@"postalCode"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"region"])
        [dict setObject:(self.region ? self.region : [NSNull null]) forKey:@"region"];

    if ([self.dirtyPropertySet containsObject:@"streetAddress"])
        [dict setObject:(self.streetAddress ? self.streetAddress : [NSNull null]) forKey:@"streetAddress"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.country ? self.country : [NSNull null]) forKey:@"country"];
    [dict setObject:(self.extendedAddress ? self.extendedAddress : [NSNull null]) forKey:@"extendedAddress"];
    [dict setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];
    [dict setObject:(self.latitude ? self.latitude : [NSNull null]) forKey:@"latitude"];
    [dict setObject:(self.locality ? self.locality : [NSNull null]) forKey:@"locality"];
    [dict setObject:(self.longitude ? self.longitude : [NSNull null]) forKey:@"longitude"];
    [dict setObject:(self.poBox ? self.poBox : [NSNull null]) forKey:@"poBox"];
    [dict setObject:(self.postalCode ? self.postalCode : [NSNull null]) forKey:@"postalCode"];
    [dict setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dict setObject:(self.region ? self.region : [NSNull null]) forKey:@"region"];
    [dict setObject:(self.streetAddress ? self.streetAddress : [NSNull null]) forKey:@"streetAddress"];
    [dict setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"addressesElementId"];
    [dict setObject:@"NSString" forKey:@"country"];
    [dict setObject:@"NSString" forKey:@"extendedAddress"];
    [dict setObject:@"NSString" forKey:@"formatted"];
    [dict setObject:@"NSNumber" forKey:@"latitude"];
    [dict setObject:@"NSString" forKey:@"locality"];
    [dict setObject:@"NSNumber" forKey:@"longitude"];
    [dict setObject:@"NSString" forKey:@"poBox"];
    [dict setObject:@"NSString" forKey:@"postalCode"];
    [dict setObject:@"JRBoolean" forKey:@"primary"];
    [dict setObject:@"NSString" forKey:@"region"];
    [dict setObject:@"NSString" forKey:@"streetAddress"];
    [dict setObject:@"NSString" forKey:@"type"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_addressesElementId release];
    [_country release];
    [_extendedAddress release];
    [_formatted release];
    [_latitude release];
    [_locality release];
    [_longitude release];
    [_poBox release];
    [_postalCode release];
    [_primary release];
    [_region release];
    [_streetAddress release];
    [_type release];

    [super dealloc];
}
@end
